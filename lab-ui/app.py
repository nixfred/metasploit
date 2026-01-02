#!/usr/bin/env python3
"""
Pentest Learning Lab - Web Interface
Manages Docker containers and serves guided lessons with embedded Kali terminal
"""

from flask import Flask, render_template, jsonify, request
import subprocess
import json
import os

app = Flask(__name__)

# Path to lessons
LESSONS_DIR = os.path.join(os.path.dirname(__file__), 'lessons')

def run_docker(cmd):
    """Run a docker-compose command and return result"""
    try:
        # Include Docker credential helper in PATH
        env = os.environ.copy()
        env['PATH'] = env.get('PATH', '') + ':/Applications/Docker.app/Contents/Resources/bin'

        result = subprocess.run(
            f"cd {os.path.dirname(os.path.dirname(__file__))} && docker-compose {cmd}",
            shell=True, capture_output=True, text=True, timeout=120, env=env
        )
        return {"success": result.returncode == 0, "output": result.stdout + result.stderr}
    except Exception as e:
        return {"success": False, "output": str(e)}

def get_container_status(name):
    """Check if a container is running"""
    result = subprocess.run(
        f"docker ps --filter name={name} --format '{{{{.Status}}}}'",
        shell=True, capture_output=True, text=True
    )
    return result.stdout.strip() if result.stdout.strip() else "stopped"

@app.route('/')
def index():
    """Main page - lesson selector"""
    lessons = []
    for f in os.listdir(LESSONS_DIR):
        if f.endswith('.json'):
            with open(os.path.join(LESSONS_DIR, f)) as fp:
                lesson = json.load(fp)
                lessons.append({
                    "id": lesson["id"],
                    "name": lesson["name"],
                    "difficulty": lesson["difficulty"],
                    "container": lesson["container"],
                    "description": lesson.get("short_description", lesson["description"][:100])
                })
    return render_template('index.html', lessons=lessons)

@app.route('/lesson/<lesson_id>')
def lesson(lesson_id):
    """Individual lesson page with embedded terminal"""
    lesson_file = os.path.join(LESSONS_DIR, f"{lesson_id}.json")
    if not os.path.exists(lesson_file):
        return "Lesson not found", 404

    with open(lesson_file) as f:
        lesson_data = json.load(f)

    return render_template('lesson.html', lesson=lesson_data)

@app.route('/api/container/<name>/start', methods=['POST'])
def start_container(name):
    """Start a specific container"""
    result = run_docker(f"up -d {name}")
    return jsonify(result)

@app.route('/api/container/<name>/stop', methods=['POST'])
def stop_container(name):
    """Stop a specific container using docker stop (more reliable than docker-compose stop)"""
    try:
        result = subprocess.run(
            f"docker stop {name}",
            shell=True, capture_output=True, text=True, timeout=30
        )
        return jsonify({"success": result.returncode == 0, "output": result.stdout + result.stderr})
    except Exception as e:
        return jsonify({"success": False, "output": str(e)})

@app.route('/api/container/<name>/status')
def container_status(name):
    """Get container status"""
    status = get_container_status(name)
    return jsonify({"name": name, "status": status, "running": "Up" in status})

@app.route('/api/containers/status')
def all_containers_status():
    """Get status of all containers"""
    containers = ['kali', 'dvwa', 'vsftpd', 'vulnssh', 'vulnmysql', 'tomcat',
                  'samba', 'metasploitable2', 'juiceshop', 'webgoat']
    statuses = {}
    for c in containers:
        status = get_container_status(c)
        statuses[c] = {"status": status, "running": "Up" in status}
    return jsonify(statuses)

@app.route('/api/kali/start', methods=['POST'])
def start_kali():
    """Start the Kali attack box"""
    result = run_docker("up -d kali")
    return jsonify(result)

if __name__ == '__main__':
    print("""
    ╔═══════════════════════════════════════════════════════════╗
    ║  🔓 P3N73S7 L4B                                           ║
    ║  Open http://localhost:5050 in your browser               ║
    ║  Kali terminal at http://localhost:7681                   ║
    ╚═══════════════════════════════════════════════════════════╝
    """)
    app.run(host='0.0.0.0', port=5050, debug=True)
