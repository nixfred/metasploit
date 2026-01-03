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

# =============================================================================
# LESSON LOADING FUNCTIONS
# =============================================================================

def load_all_lessons():
    """Load all lesson JSON files and return as list"""
    lessons = []
    for f in os.listdir(LESSONS_DIR):
        if f.endswith('.json'):
            with open(os.path.join(LESSONS_DIR, f)) as fp:
                lessons.append(json.load(fp))
    return lessons

def get_episodes_ordered():
    """Return lessons sorted by episode_number (for story mode)

    Lessons with episode_number come first (sorted 1-8),
    lessons without episode_number come after (original behavior).
    """
    lessons = load_all_lessons()
    with_episode = [l for l in lessons if l.get('episode_number')]
    without_episode = [l for l in lessons if not l.get('episode_number')]
    return sorted(with_episode, key=lambda x: x['episode_number']) + without_episode

def get_lesson_by_episode(episode_number):
    """Get a specific lesson by its episode number"""
    for lesson in load_all_lessons():
        if lesson.get('episode_number') == episode_number:
            return lesson
    return None

def get_lesson_by_id(lesson_id):
    """Get a specific lesson by its ID"""
    lesson_file = os.path.join(LESSONS_DIR, f"{lesson_id}.json")
    if os.path.exists(lesson_file):
        with open(lesson_file) as f:
            return json.load(f)
    return None

# =============================================================================
# DOCKER FUNCTIONS
# =============================================================================

def run_docker(cmd):
    """Run a docker compose command and return result"""
    try:
        project_dir = os.path.dirname(os.path.dirname(__file__))

        # Use project's docker config (no credential helper - public images only)
        env = os.environ.copy()
        # Add Docker bin and user's bin (for docker-credential-none helper)
        # macOS Docker Desktop path + Linux standard paths
        home = os.path.expanduser('~')
        extra_paths = f"{home}/bin:/Applications/Docker.app/Contents/Resources/bin:/usr/local/bin"
        env['PATH'] = extra_paths + ":" + env.get('PATH', '')
        env['DOCKER_CONFIG'] = os.path.join(project_dir, '.docker')

        # Try docker compose v2 first, fall back to docker-compose v1
        result = subprocess.run(
            f"cd {project_dir} && docker compose {cmd}",
            shell=True, capture_output=True, text=True, timeout=300, env=env
        )
        if result.returncode != 0 and "is not a docker command" in result.stderr:
            # Fall back to docker-compose v1
            result = subprocess.run(
                f"cd {project_dir} && docker-compose {cmd}",
                shell=True, capture_output=True, text=True, timeout=300, env=env
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

# =============================================================================
# PAGE ROUTES
# =============================================================================

@app.route('/')
def index():
    """Main page - lesson selector

    Supports two modes:
    - Training mode (default): Original grid view
    - Story mode (?mode=story): Episode list in narrative order
    """
    mode = request.args.get('mode', 'story')  # Default to story mode

    if mode == 'story':
        # Story mode: episodes in narrative order
        episodes = get_episodes_ordered()
        lessons = [{
            "id": ep["id"],
            "name": ep["name"],
            "difficulty": ep["difficulty"],
            "container": ep["container"],
            "description": ep.get("short_description", ep["description"][:100]),
            "episode_number": ep.get("episode_number"),
            "episode_title": ep.get("episode_title")
        } for ep in episodes]
    else:
        # Training mode: original behavior
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

    return render_template('index.html', lessons=lessons, mode=mode)

@app.route('/episode/<int:episode_number>')
def episode(episode_number):
    """Serve a lesson by episode number (story mode navigation)"""
    lesson_data = get_lesson_by_episode(episode_number)
    if not lesson_data:
        return "Episode not found", 404
    return render_template('lesson.html', lesson=lesson_data, mode='story')

@app.route('/interstitial/<int:episode_number>')
def interstitial(episode_number):
    """Serve the interstitial (story) page before an episode"""
    lesson_data = get_lesson_by_episode(episode_number)
    if not lesson_data:
        return "Episode not found", 404

    interstitial_data = lesson_data.get('interstitial', {})
    return render_template('interstitial.html',
                           episode=lesson_data,
                           interstitial=interstitial_data,
                           episode_number=episode_number)

@app.route('/lesson/<lesson_id>')
def lesson(lesson_id):
    """Individual lesson page with embedded terminal"""
    lesson_file = os.path.join(LESSONS_DIR, f"{lesson_id}.json")
    if not os.path.exists(lesson_file):
        return "Lesson not found", 404

    with open(lesson_file) as f:
        lesson_data = json.load(f)

    return render_template('lesson.html', lesson=lesson_data)

# Target containers (excludes kali which always stays running)
TARGET_CONTAINERS = ['vsftpd', 'dvwa', 'vulnssh', 'tomcat', 'samba',
                     'juiceshop', 'metasploitable2', 'vulnmysql', 'webgoat',
                     'bwapp', 'mutillidae', 'wordpress']

def stop_other_targets(keep_container):
    """Stop all target containers except the one we're starting (and kali)"""
    for target in TARGET_CONTAINERS:
        if target != keep_container:
            try:
                subprocess.run(f"docker stop {target}", shell=True,
                              capture_output=True, timeout=10)
            except:
                pass  # Ignore errors - container might not exist or already stopped

@app.route('/api/container/<name>/start', methods=['POST'])
def start_container(name):
    """Start a specific container, stopping other targets to conserve resources"""
    # Stop other targets first (kali stays running)
    if name in TARGET_CONTAINERS:
        stop_other_targets(name)
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
    containers = ['kali', 'vsftpd', 'dvwa', 'vulnssh', 'tomcat', 'samba',
                  'juiceshop', 'metasploitable2', 'vulnmysql', 'webgoat']
    statuses = {}
    for c in containers:
        status = get_container_status(c)
        statuses[c] = {"status": status, "running": "Up" in status}
    return jsonify(statuses)

@app.route('/api/containers/start-all', methods=['POST'])
def start_all_containers():
    """Start all containers"""
    containers = ['kali', 'vsftpd', 'dvwa', 'vulnssh', 'tomcat', 'samba',
                  'juiceshop', 'metasploitable2', 'vulnmysql', 'webgoat']
    results = {}
    for name in containers:
        result = run_docker(f"up -d {name}")
        results[name] = result
    return jsonify({"success": True, "results": results})

@app.route('/api/kali/start', methods=['POST'])
def start_kali():
    """Start the Kali attack box"""
    result = run_docker("up -d kali")
    return jsonify(result)

@app.route('/api/targets/stop-all', methods=['POST'])
def stop_all_targets():
    """Stop all target containers (not Kali)"""
    targets = ['dvwa', 'vsftpd', 'vulnssh', 'vulnmysql', 'tomcat', 'samba',
               'metasploitable2', 'juiceshop', 'webgoat', 'bwapp', 'mutillidae',
               'wordpress', 'cowrie', 'dozzle']
    stopped = []
    failed = []
    for name in targets:
        try:
            result = subprocess.run(
                f"docker stop {name}",
                shell=True, capture_output=True, text=True, timeout=10
            )
            if result.returncode == 0:
                stopped.append(name)
        except:
            pass  # Container might not exist or already stopped
    return jsonify({"success": True, "stopped": stopped})

# Funnel API endpoints - call tailscale directly (avoid sudo in funnel.sh)
def start_funnel():
    """Start Tailscale Funnel by calling tailscale commands directly"""
    try:
        output = []

        # Reset existing config
        subprocess.run(['tailscale', 'serve', 'reset'],
                      capture_output=True, text=True, timeout=10)

        # Funnel Lab UI (5050 → 443)
        result1 = subprocess.run(
            ['tailscale', 'funnel', '--bg', '--https=443', 'http://localhost:5050'],
            capture_output=True, text=True, timeout=30
        )
        output.append(result1.stdout + result1.stderr)

        # Funnel Kali terminal (7681 → 8443)
        result2 = subprocess.run(
            ['tailscale', 'funnel', '--bg', '--https=8443', 'http://localhost:7681'],
            capture_output=True, text=True, timeout=30
        )
        output.append(result2.stdout + result2.stderr)

        # Check if operator permission is needed
        combined = '\n'.join(output)
        if 'Access denied' in combined or 'permission denied' in combined.lower():
            return {
                "success": False,
                "output": "Tailscale operator not set. Run this once from terminal:\n  sudo tailscale set --operator=$USER\nThen retry."
            }

        return {"success": result2.returncode == 0, "output": combined}
    except Exception as e:
        return {"success": False, "output": str(e)}

def stop_funnel():
    """Stop Tailscale Funnel"""
    try:
        output = []

        result1 = subprocess.run(
            ['tailscale', 'funnel', '--https=443', 'off'],
            capture_output=True, text=True, timeout=10
        )
        output.append(result1.stdout + result1.stderr)

        result2 = subprocess.run(
            ['tailscale', 'funnel', '--https=8443', 'off'],
            capture_output=True, text=True, timeout=10
        )
        output.append(result2.stdout + result2.stderr)

        return {"success": True, "output": '\n'.join(output)}
    except Exception as e:
        return {"success": False, "output": str(e)}

@app.route('/api/funnel/status')
def funnel_status():
    """Get Tailscale Funnel status"""
    try:
        # Check if funnel is active by looking at tailscale serve status
        result = subprocess.run(
            ['tailscale', 'serve', 'status', '--json'],
            capture_output=True, text=True, timeout=10
        )
        if result.returncode == 0:
            status_data = json.loads(result.stdout) if result.stdout.strip() else {}
            # Funnel is active if there are any services AND funnel is enabled
            funnel_result = subprocess.run(
                ['tailscale', 'funnel', 'status'],
                capture_output=True, text=True, timeout=10
            )
            is_active = 'Funnel on' in funnel_result.stdout or ':443' in funnel_result.stdout
            # Get the hostname
            hostname_result = subprocess.run(
                ['tailscale', 'status', '--json'],
                capture_output=True, text=True, timeout=10
            )
            hostname = ""
            if hostname_result.returncode == 0:
                try:
                    ts_data = json.loads(hostname_result.stdout)
                    hostname = ts_data.get('Self', {}).get('DNSName', '').rstrip('.')
                except:
                    pass
            return jsonify({
                "active": is_active,
                "hostname": hostname,
                "output": funnel_result.stdout
            })
        return jsonify({"active": False, "hostname": "", "output": ""})
    except Exception as e:
        return jsonify({"active": False, "hostname": "", "error": str(e)})

@app.route('/api/funnel/start', methods=['POST'])
def funnel_start():
    """Start Tailscale Funnel"""
    result = start_funnel()
    return jsonify(result)

@app.route('/api/funnel/stop', methods=['POST'])
def funnel_stop():
    """Stop Tailscale Funnel"""
    result = stop_funnel()
    return jsonify(result)

if __name__ == '__main__':
    print("""
    ╔═══════════════════════════════════════════════════════════╗
    ║  🔓 P3N73S7 L4B                                           ║
    ║  Open http://localhost:5050 in your browser               ║
    ║  Kali terminal at http://localhost:7681                   ║
    ╚═══════════════════════════════════════════════════════════╝
    """)
    app.run(host='0.0.0.0', port=5050, debug=False)
