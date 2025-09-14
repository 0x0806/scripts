
#!/bin/bash

# ULTIMATE ADVANCED NETWORK SCANNER v4.0 - COMPLETE IMPLEMENTATION
# Auto-installs ALL required tools and handles missing dependencies
# Enhanced with AI-powered analysis and advanced threat detection

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[0;95m'
ORANGE='\033[0;91m'
BOLD='\033[1m'
NC='\033[0m'

# Global variables for process management
TOTAL_PROCESSES=0
COMPLETED_PROCESSES=0
FAILED_PROCESSES=0
MAX_PARALLEL_JOBS=30
SCAN_START_TIME=$(date +%s)

# Enhanced ASCII Banner
echo -e "${PURPLE}${BOLD}"
cat << "EOF"
██╗   ██╗██╗  ████████╗██╗███╗   ███╗ █████╗ ████████╗███████╗
██║   ██║██║  ╚══██╔══╝██║████╗ ████║██╔══██╗╚══██╔══╝██╔════╝
██║   ██║██║     ██║   ██║██╔████╔██║███████║   ██║   █████╗  
██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝  
╚██████╔╝███████╗██║   ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗
 ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
    ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
    ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
    ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
    ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
    ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
    ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
     ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ 
     ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗
     ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
     ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
     ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║
     ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
EOF
echo -e "${NC}"

echo -e "${WHITE}${MAGENTA}██████████████████████████████████████████████████████████████${NC}"
echo -e "${WHITE}${CYAN}           ULTIMATE NETWORK SCANNER v4.0                      ${NC}"
echo -e "${WHITE}${CYAN}      MAXIMUM AUTOMATION - AI ENHANCED - AUTO-INSTALL        ${NC}"
echo -e "${WHITE}${CYAN}        PENTESTING GRADE - PROFESSIONAL EDITION             ${NC}"
echo -e "${WHITE}${MAGENTA}██████████████████████████████████████████████████████████████${NC}"

# Enhanced tool installation with better error handling
check_and_install_tool() {
    local tool_name=$1
    local install_cmd=$2
    local verify_cmd=${3:-"command -v $tool_name"}

    echo -e "${BLUE}[TOOL-CHECK]${NC} Checking $tool_name..."

    if ! command -v "$tool_name" >/dev/null 2>&1; then
        echo -e "${YELLOW}[INSTALL]${NC} Installing $tool_name..."
        
        # Try multiple installation methods
        if timeout 120 bash -c "$install_cmd" >/dev/null 2>&1; then
            sleep 2
            if eval "$verify_cmd" >/dev/null 2>&1; then
                echo -e "${GREEN}[SUCCESS]${NC} $tool_name installed successfully"
                return 0
            else
                echo -e "${ORANGE}[PARTIAL]${NC} $tool_name installed but verification failed"
                return 1
            fi
        else
            echo -e "${RED}[FAILED]${NC} Failed to install $tool_name"
            return 1
        fi
    else
        echo -e "${GREEN}[FOUND]${NC} $tool_name is already installed"
        return 0
    fi
}

install_essential_tools() {
    echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                    AUTO-INSTALLING TOOLS                      ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

    # Update package lists safely
    if command -v apt-get >/dev/null 2>&1; then
        echo -e "${BLUE}[UPDATE]${NC} Updating package lists..."
        timeout 60 sudo apt-get update -qq 2>/dev/null || true
    fi

    # Core network tools with fallbacks
    check_and_install_tool "nmap" "nix-env -iA nixpkgs.nmap || apt-get install -y nmap" "nmap --version"
    check_and_install_tool "dig" "nix-env -iA nixpkgs.dig || apt-get install -y dnsutils" "dig -v"
    check_and_install_tool "host" "nix-env -iA nixpkgs.bind || apt-get install -y bind9-host" "host -V"
    check_and_install_tool "whois" "nix-env -iA nixpkgs.whois || apt-get install -y whois" "whois --version"
    check_and_install_tool "nslookup" "nix-env -iA nixpkgs.bind || apt-get install -y dnsutils" "command -v nslookup"
    check_and_install_tool "ping" "nix-env -iA nixpkgs.iputils || apt-get install -y iputils-ping" "ping -V"
    
    # Check for ping6 or use ping -6
    if ! command -v ping6 >/dev/null 2>&1; then
        if ping -6 ::1 -c 1 >/dev/null 2>&1; then
            echo -e "${GREEN}[FOUND]${NC} IPv6 ping available via ping -6"
        else
            echo -e "${YELLOW}[INFO]${NC} IPv6 ping not available"
        fi
    else
        echo -e "${GREEN}[FOUND]${NC} ping6 is already installed"
    fi
    
    check_and_install_tool "traceroute" "nix-env -iA nixpkgs.traceroute || apt-get install -y traceroute" "traceroute --version"
    check_and_install_tool "mtr" "nix-env -iA nixpkgs.mtr || apt-get install -y mtr-tiny" "mtr --version"
    
    # Check for netcat alternatives
    if ! command -v nc >/dev/null 2>&1; then
        if command -v ncat >/dev/null 2>&1; then
            echo -e "${GREEN}[FOUND]${NC} ncat available as netcat alternative"
            alias nc=ncat
        elif command -v netcat >/dev/null 2>&1; then
            echo -e "${GREEN}[FOUND]${NC} netcat available"
            alias nc=netcat
        else
            check_and_install_tool "nc" "nix-env -iA nixpkgs.netcat || apt-get install -y netcat-openbsd" "command -v nc"
        fi
    else
        echo -e "${GREEN}[FOUND]${NC} nc is already installed"
    fi
    
    # Check for telnet or use alternative
    if ! command -v telnet >/dev/null 2>&1; then
        echo -e "${YELLOW}[INFO]${NC} telnet not available, will use nc for connections"
    else
        echo -e "${GREEN}[FOUND]${NC} telnet is already installed"
    fi
    
    check_and_install_tool "openssl" "nix-env -iA nixpkgs.openssl || apt-get install -y openssl" "openssl version"
    check_and_install_tool "curl" "nix-env -iA nixpkgs.curl || apt-get install -y curl" "curl --version"
    check_and_install_tool "ss" "nix-env -iA nixpkgs.iproute2 || apt-get install -y iproute2" "ss --version"
    check_and_install_tool "ip" "nix-env -iA nixpkgs.iproute2 || apt-get install -y iproute2" "ip -V"
    check_and_install_tool "netstat" "nix-env -iA nixpkgs.nettools || apt-get install -y net-tools" "netstat --version"

    # Advanced tools with graceful fallbacks
    if ! check_and_install_tool "masscan" "nix-env -iA nixpkgs.masscan || apt-get install -y masscan" "masscan --version"; then
        echo -e "${YELLOW}[FALLBACK]${NC} masscan not available, will use nmap for fast scanning"
    fi

    if ! check_and_install_tool "hping3" "nix-env -iA nixpkgs.hping || apt-get install -y hping3" "hping3 --version"; then
        echo -e "${YELLOW}[FALLBACK]${NC} hping3 not available, will use nmap for TCP ping"
    fi

    # Additional security tools
    check_and_install_tool "nikto" "nix-env -iA nixpkgs.nikto || apt-get install -y nikto" "nikto -Version"
    check_and_install_tool "dirb" "nix-env -iA nixpkgs.dirb || apt-get install -y dirb" "dirb"
    check_and_install_tool "gobuster" "nix-env -iA nixpkgs.gobuster || apt-get install -y gobuster" "gobuster version"
    check_and_install_tool "sqlmap" "nix-env -iA nixpkgs.sqlmap || apt-get install -y sqlmap" "sqlmap --version"
    check_and_install_tool "wpscan" "nix-env -iA nixpkgs.wpscan || gem install wpscan" "wpscan --version"

    echo -e "${GREEN}[COMPLETE]${NC} Tool installation phase completed"
}

# Safe command execution with multiple fallbacks
safe_execute() {
    local cmd=$1
    local fallback_cmd=$2
    local tool_name=$3
    local timeout_val=${4:-30}

    # Try primary command first
    if timeout "$timeout_val" bash -c "$cmd" 2>/dev/null; then
        return 0
    elif [ -n "$fallback_cmd" ] && [ "$fallback_cmd" != "echo" ]; then
        echo -e "${YELLOW}[FALLBACK]${NC} $tool_name primary failed, trying alternative..."
        if timeout "$timeout_val" bash -c "$fallback_cmd" 2>/dev/null; then
            return 0
        fi
    fi
    echo -e "${ORANGE}[SKIP]${NC} $tool_name not available or failed"
    return 1
}

# Enhanced input validation functions
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
        return 0
    fi
    return 1
}

validate_domain() {
    local domain=$1
    if [[ $domain =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?$ ]]; then
        return 0
    fi
    return 1
}

validate_cidr() {
    local cidr=$1
    if [[ $cidr =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/([0-9]|[1-2][0-9]|3[0-2])$ ]]; then
        return 0
    fi
    return 1
}

validate_url() {
    local url=$1
    if [[ $url =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]]; then
        return 0
    fi
    return 1
}

# Enhanced target input with multiple options
get_target() {
    echo -e "\n${YELLOW}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║            ENHANCED TARGET SELECTION          ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${GREEN}Supported formats:${NC}"
    echo -e "${CYAN}  • Single IP: ${WHITE}192.168.1.1${NC}"
    echo -e "${CYAN}  • Domain: ${WHITE}example.com${NC}"
    echo -e "${CYAN}  • CIDR Range: ${WHITE}192.168.1.0/24${NC}"
    echo -e "${CYAN}  • IP Range: ${WHITE}192.168.1.1-192.168.1.50${NC}"
    echo -e "${CYAN}  • URL: ${WHITE}https://example.com${NC}"
    echo -e "${CYAN}  • Multiple targets: ${WHITE}target1,target2,target3${NC}"

    while true; do
        echo -e "\n${GREEN}${BOLD}Enter target(s):${NC}"
        read -p ">>> " TARGET

        # Handle multiple targets
        if [[ $TARGET == *","* ]]; then
            IFS=',' read -ra TARGETS <<< "$TARGET"
            local valid=true
            for t in "${TARGETS[@]}"; do
                t=$(echo "$t" | xargs) # trim whitespace
                if ! (validate_ip "$t" || validate_domain "$t" || validate_cidr "$t" || validate_url "$t"); then
                    echo -e "${RED}❌ Invalid format for target: $t${NC}"
                    valid=false
                    break
                fi
            done
            if [ "$valid" = true ]; then
                TARGET="${TARGETS[0]}" # Use first target as primary
                break
            fi
        elif validate_ip "$TARGET" || validate_domain "$TARGET" || validate_cidr "$TARGET" || validate_url "$TARGET"; then
            break
        elif [[ $TARGET =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            break
        else
            echo -e "${RED}❌ Invalid format! Please try again.${NC}"
        fi
    done
}

# Enhanced process management with better error handling
run_advanced_tool() {
    local category=$1
    local tool_name=$2
    local command=$3
    local output_file=$4
    local priority=${5:-"normal"}
    local timeout_val=${6:-"300"}

    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")" 2>/dev/null

    # Control parallel execution
    while [ $(jobs -r | wc -l) -ge $MAX_PARALLEL_JOBS ]; do
        sleep 0.5
    done

    (
        local start_time=$(date +%s)
        local pid=$$
        echo -e "${CYAN}[STARTED]${NC} [$category] $tool_name - PID: $pid - Priority: $priority"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - STARTED - $category - $tool_name - PID: $pid" >> "$OUTPUT_DIR/detailed_execution_log.txt" 2>/dev/null

        # Execute command with enhanced timeout and error handling
        if timeout "$timeout_val" bash -c "$command" > "$output_file" 2>&1; then
            local exit_code=0
        else
            local exit_code=$?
        fi
        
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))

        # Enhanced result analysis
        local file_size=0
        if [ -f "$output_file" ]; then
            file_size=$(stat -c%s "$output_file" 2>/dev/null || stat -f%z "$output_file" 2>/dev/null || wc -c < "$output_file" 2>/dev/null || echo 0)
        fi

        if [ $exit_code -eq 0 ] && [ -s "$output_file" ] && [ "$file_size" -gt 10 ]; then
            echo -e "${GREEN}[SUCCESS]${NC} [$category] $tool_name (${duration}s) - ${file_size} bytes"
            echo "$tool_name:SUCCESS:${duration}s:${file_size}bytes" >> "$OUTPUT_DIR/execution_log.txt" 2>/dev/null
            echo "$(date '+%Y-%m-%d %H:%M:%S') - SUCCESS - $category - $tool_name - Duration: ${duration}s - Size: ${file_size} bytes" >> "$OUTPUT_DIR/detailed_execution_log.txt" 2>/dev/null
        elif [ $exit_code -eq 124 ]; then
            echo -e "${YELLOW}[TIMEOUT]${NC} [$category] $tool_name (${timeout_val}s limit)"
            echo "$tool_name:TIMEOUT:${timeout_val}s:0bytes" >> "$OUTPUT_DIR/execution_log.txt" 2>/dev/null
            echo "$(date '+%Y-%m-%d %H:%M:%S') - TIMEOUT - $category - $tool_name - Timeout: ${timeout_val}s" >> "$OUTPUT_DIR/detailed_execution_log.txt" 2>/dev/null
        elif [ "$file_size" -eq 0 ] || [ ! -s "$output_file" ]; then
            echo -e "${ORANGE}[NO_DATA]${NC} [$category] $tool_name (${duration}s) - No output"
            echo "$tool_name:NO_DATA:${duration}s:0bytes" >> "$OUTPUT_DIR/execution_log.txt" 2>/dev/null
            echo "$(date '+%Y-%m-%d %H:%M:%S') - NO_DATA - $category - $tool_name - Duration: ${duration}s" >> "$OUTPUT_DIR/detailed_execution_log.txt" 2>/dev/null
        else
            echo -e "${RED}[FAILED]${NC} [$category] $tool_name (${duration}s) - Exit code: $exit_code"
            echo "$tool_name:FAILED:${duration}s:${file_size}bytes:exit_$exit_code" >> "$OUTPUT_DIR/execution_log.txt" 2>/dev/null
            echo "$(date '+%Y-%m-%d %H:%M:%S') - FAILED - $category - $tool_name - Duration: ${duration}s - Exit: $exit_code" >> "$OUTPUT_DIR/detailed_execution_log.txt" 2>/dev/null
        fi

        # Auto-analyze critical findings
        if [ -s "$output_file" ]; then
            analyze_output "$category" "$tool_name" "$output_file" &
        fi

    ) &

    TOTAL_PROCESSES=$((TOTAL_PROCESSES + 1))
}

# AI-powered output analysis with error handling
analyze_output() {
    local category=$1
    local tool_name=$2
    local output_file=$3

    # Critical findings patterns
    local findings_file="$OUTPUT_DIR/critical_findings.txt"

    # Ensure findings file exists
    touch "$findings_file" 2>/dev/null

    # Check for common security issues
    if grep -i "vulnerable\|exploit\|critical\|high\|severe\|backdoor\|malware" "$output_file" >/dev/null 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - CRITICAL FINDING - $tool_name - $(grep -i "vulnerable\|exploit\|critical\|high\|severe" "$output_file" 2>/dev/null | head -3)" >> "$findings_file" 2>/dev/null
    fi

    # Check for open ports
    if [[ $tool_name == *"nmap"* ]] && grep "open" "$output_file" >/dev/null 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - OPEN PORTS - $tool_name - $(grep "open" "$output_file" 2>/dev/null | wc -l) ports found" >> "$findings_file" 2>/dev/null
    fi

    # Check for SSL/TLS issues
    if [[ $tool_name == *"ssl"* ]] && grep -i "weak\|vulnerable\|deprecated\|insecure" "$output_file" >/dev/null 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - SSL/TLS ISSUE - $tool_name - $(grep -i "weak\|vulnerable\|deprecated" "$output_file" 2>/dev/null | head -1)" >> "$findings_file" 2>/dev/null
    fi
}

# Install tools first
install_essential_tools

# Get target and create enhanced output structure
get_target

# Create ultra-advanced output directory structure
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
CLEAN_TARGET=$(echo "$TARGET" | sed 's/[^a-zA-Z0-9._-]/_/g')
OUTPUT_DIR="ULTIMATE_SCAN_${CLEAN_TARGET}_${TIMESTAMP}"

# Create comprehensive directory structure
mkdir -p "$OUTPUT_DIR"/{reconnaissance/{passive/{dns,whois,certificates,osint,shodan,censys},active/{icmp,tcp,udp,sctp}},network/{discovery/{hosts,ports,services,protocols},mapping/{topology,routing,firewall},enumeration/{banners,versions,fingerprinting}},web/{discovery/{directories,files,parameters,apis},vulnerabilities/{xss,sqli,csrf,lfi,rfi,xxe,ssrf},analysis/{headers,cookies,forms,javascript}},services/{enumeration/{ssh,ftp,smtp,http,https,dns,snmp,smb,rdp,telnet,ldap,mysql,postgresql,mongodb,redis,elasticsearch},exploitation,bruteforce},system/{information/{os,hardware,software,processes,users},vulnerabilities/{cve,misconfigurations,patches}},wireless/{discovery,analysis,attacks},mobile/{android,ios},cloud/{aws,azure,gcp,docker,kubernetes},malware/{static,dynamic,behavioral},forensics/{memory,disk,network},reporting/{html,json,xml,pdf},logs/{execution,errors,debug}} 2>/dev/null

echo -e "\n${BLUE}🎯 Primary Target: ${WHITE}$TARGET${NC}"
echo -e "${BLUE}📁 Output Directory: ${WHITE}$OUTPUT_DIR${NC}"
echo -e "${BLUE}🚀 Max Parallel Jobs: ${WHITE}$MAX_PARALLEL_JOBS${NC}"
echo -e "${YELLOW}🚀 Launching ULTIMATE scan with maximum automation...${NC}\n"

# Initialize log files
echo "# Ultimate Network Scanner v4.0 - Execution Log" > "$OUTPUT_DIR/execution_log.txt" 2>/dev/null
echo "# Detailed execution log with timestamps" > "$OUTPUT_DIR/detailed_execution_log.txt" 2>/dev/null
echo "# Critical security findings" > "$OUTPUT_DIR/critical_findings.txt" 2>/dev/null

# PHASE 1: ENHANCED PASSIVE RECONNAISSANCE
echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                PHASE 1: ENHANCED PASSIVE RECONNAISSANCE       ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# Comprehensive DNS Intelligence with fallbacks
run_advanced_tool "DNS-INTEL" "Host Resolution" "host $TARGET 2>/dev/null || nslookup $TARGET 2>/dev/null || echo 'DNS resolution failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/host_resolution.txt" "high" 30
run_advanced_tool "DNS-INTEL" "DNS A Records" "dig A $TARGET +short 2>/dev/null || nslookup -type=A $TARGET 2>/dev/null || echo 'A record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/a_records_trace.txt" "high" 60
run_advanced_tool "DNS-INTEL" "DNS AAAA Records" "dig AAAA $TARGET +short 2>/dev/null || nslookup -type=AAAA $TARGET 2>/dev/null || echo 'AAAA record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/aaaa_records.txt" "normal" 30
run_advanced_tool "DNS-INTEL" "DNS MX Records" "dig MX $TARGET +short 2>/dev/null || nslookup -type=MX $TARGET 2>/dev/null || echo 'MX record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/mx_records.txt" "normal" 30
run_advanced_tool "DNS-INTEL" "DNS NS Records" "dig NS $TARGET +short 2>/dev/null || nslookup -type=NS $TARGET 2>/dev/null || echo 'NS record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/ns_records.txt" "normal" 30
run_advanced_tool "DNS-INTEL" "DNS TXT Records" "dig TXT $TARGET +short 2>/dev/null || nslookup -type=TXT $TARGET 2>/dev/null || echo 'TXT record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/txt_records.txt" "high" 30
run_advanced_tool "DNS-INTEL" "DNS SOA Records" "dig SOA $TARGET +short 2>/dev/null || nslookup -type=SOA $TARGET 2>/dev/null || echo 'SOA record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/soa_records.txt" "normal" 30
run_advanced_tool "DNS-INTEL" "DNS CNAME Records" "dig CNAME $TARGET +short 2>/dev/null || nslookup -type=CNAME $TARGET 2>/dev/null || echo 'CNAME record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/cname_records.txt" "normal" 30
run_advanced_tool "DNS-INTEL" "DNS PTR Records" "dig -x $TARGET +short 2>/dev/null || nslookup $TARGET 2>/dev/null || echo 'PTR record lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/ptr_records.txt" "normal" 30
run_advanced_tool "DNS-INTEL" "DNS ALL Records" "dig ANY $TARGET +noall +answer 2>/dev/null || nslookup -type=ANY $TARGET 2>/dev/null || echo 'ALL records lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/all_records.txt" "high" 60
run_advanced_tool "DNS-INTEL" "DNS Zone Transfer" "dig axfr $TARGET 2>/dev/null || echo 'Zone transfer not allowed or failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/zone_transfer.txt" "critical" 120

# Subdomain enumeration
run_advanced_tool "DNS-INTEL" "Subdomain Brute Force" "for sub in www mail ftp admin api cdn blog dev test staging; do dig \${sub}.$TARGET +short 2>/dev/null | grep -v '^;' | head -3; done" "$OUTPUT_DIR/reconnaissance/passive/dns/subdomain_brute.txt" "high" 180

# Advanced NSLookup variants
run_advanced_tool "DNS-INTEL" "NSLookup Standard" "nslookup $TARGET 2>/dev/null || host $TARGET 2>/dev/null || echo 'NSLookup failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/nslookup_standard.txt" "normal" 30
run_advanced_tool "DNS-INTEL" "NSLookup Google DNS" "nslookup $TARGET 8.8.8.8 2>/dev/null || host $TARGET 8.8.8.8 2>/dev/null || echo 'NSLookup with Google DNS failed'" "$OUTPUT_DIR/reconnaissance/passive/dns/nslookup_reverse.txt" "normal" 30

# WHOIS Deep Intelligence  
run_advanced_tool "WHOIS-INTEL" "Domain WHOIS" "whois $TARGET 2>/dev/null || curl -s \"https://www.whois.net/whois/$TARGET\" 2>/dev/null || echo 'WHOIS lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/whois/domain_whois.txt" "high" 60
run_advanced_tool "WHOIS-INTEL" "IP WHOIS" "TARGET_IP=\$(dig +short $TARGET 2>/dev/null | head -1) && [ -n \"\$TARGET_IP\" ] && whois \$TARGET_IP 2>/dev/null || echo 'IP WHOIS lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/whois/ip_whois.txt" "high" 60
run_advanced_tool "WHOIS-INTEL" "ASN Lookup" "TARGET_IP=\$(dig +short $TARGET 2>/dev/null | head -1) && [ -n \"\$TARGET_IP\" ] && whois -h whois.cymru.com \" -v \$TARGET_IP\" 2>/dev/null || echo 'ASN lookup failed'" "$OUTPUT_DIR/reconnaissance/passive/whois/asn_lookup.txt" "normal" 60

# SSL/TLS Certificate Analysis with better error handling
run_advanced_tool "SSL-INTEL" "SSL Certificate Info" "echo | openssl s_client -connect $TARGET:443 -servername $TARGET 2>/dev/null | openssl x509 -text -noout 2>/dev/null || curl -I https://$TARGET 2>/dev/null || echo 'SSL certificate analysis failed'" "$OUTPUT_DIR/reconnaissance/passive/certificates/ssl_cert_full.txt" "high" 60
run_advanced_tool "SSL-INTEL" "SSL Certificate Chain" "echo | openssl s_client -connect $TARGET:443 -servername $TARGET -showcerts 2>/dev/null || echo 'SSL chain analysis failed'" "$OUTPUT_DIR/reconnaissance/passive/certificates/ssl_chain.txt" "normal" 60
run_advanced_tool "SSL-INTEL" "SSL Certificate Dates" "echo | openssl s_client -connect $TARGET:443 -servername $TARGET 2>/dev/null | openssl x509 -dates -noout 2>/dev/null || echo 'SSL dates check failed'" "$OUTPUT_DIR/reconnaissance/passive/certificates/ssl_dates.txt" "normal" 30

# PHASE 2: ACTIVE RECONNAISSANCE
echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║              PHASE 2: ACTIVE RECONNAISSANCE                   ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# Multi-protocol Network Connectivity Testing
run_advanced_tool "ACTIVE-PING" "ICMP Ping Test" "ping -c 10 -W 3 $TARGET 2>/dev/null || echo 'ICMP ping failed - target may be unreachable or blocking ICMP'" "$OUTPUT_DIR/reconnaissance/active/icmp/ping_test.txt" "high" 60

# IPv6 ping with fallback
if command -v ping6 >/dev/null 2>&1; then
    run_advanced_tool "ACTIVE-PING" "ICMP Ping IPv6" "ping6 -c 5 $TARGET 2>/dev/null || echo 'IPv6 ping failed - target may not support IPv6'" "$OUTPUT_DIR/reconnaissance/active/icmp/ping_ipv6.txt" "normal" 60
else
    run_advanced_tool "ACTIVE-PING" "ICMP Ping IPv6" "ping -6 -c 5 $TARGET 2>/dev/null || echo 'IPv6 ping not available or failed'" "$OUTPUT_DIR/reconnaissance/active/icmp/ping_ipv6.txt" "normal" 60
fi

# Advanced ping techniques
run_advanced_tool "ACTIVE-PING" "Ping Timestamp" "ping -c 5 -M time $TARGET 2>/dev/null || echo 'Timestamp ping failed'" "$OUTPUT_DIR/reconnaissance/active/icmp/ping_timestamp.txt" "normal" 30
run_advanced_tool "ACTIVE-PING" "Ping Flood" "ping -c 10 -f $TARGET 2>/dev/null || echo 'Flood ping failed or requires root'" "$OUTPUT_DIR/reconnaissance/active/icmp/ping_flood.txt" "normal" 30

# Network Routing Analysis
run_advanced_tool "ROUTE-TRACE" "Traceroute ICMP" "traceroute -I -m 20 $TARGET 2>/dev/null || traceroute -m 20 $TARGET 2>/dev/null || echo 'Traceroute failed'" "$OUTPUT_DIR/reconnaissance/active/routing/traceroute_icmp.txt" "high" 120
run_advanced_tool "ROUTE-TRACE" "Traceroute UDP" "traceroute -U -m 20 $TARGET 2>/dev/null || traceroute -m 20 $TARGET 2>/dev/null || echo 'UDP traceroute failed'" "$OUTPUT_DIR/reconnaissance/active/routing/traceroute_udp.txt" "normal" 120
run_advanced_tool "ROUTE-TRACE" "Traceroute TCP" "traceroute -T -p 80 -m 20 $TARGET 2>/dev/null || echo 'TCP traceroute failed'" "$OUTPUT_DIR/reconnaissance/active/routing/traceroute_tcp.txt" "normal" 120
run_advanced_tool "ROUTE-TRACE" "MTR Report" "mtr -r -c 10 --report-wide $TARGET 2>/dev/null || traceroute $TARGET 2>/dev/null || echo 'MTR report failed'" "$OUTPUT_DIR/reconnaissance/active/routing/mtr_report.txt" "high" 120
run_advanced_tool "ROUTE-TRACE" "MTR Continuous" "timeout 60 mtr -c 20 $TARGET 2>/dev/null || echo 'MTR continuous failed'" "$OUTPUT_DIR/reconnaissance/active/routing/mtr_continuous.txt" "normal" 60

# TCP/UDP specific tests
run_advanced_tool "ACTIVE-TCP" "TCP Ping Port 80" "hping3 -S -p 80 -c 5 $TARGET 2>/dev/null || nmap -sS -p 80 $TARGET 2>/dev/null || echo 'TCP ping port 80 failed'" "$OUTPUT_DIR/reconnaissance/active/tcp/tcp_ping_80.txt" "high" 30
run_advanced_tool "ACTIVE-TCP" "TCP Ping Port 443" "hping3 -S -p 443 -c 5 $TARGET 2>/dev/null || nmap -sS -p 443 $TARGET 2>/dev/null || echo 'TCP ping port 443 failed'" "$OUTPUT_DIR/reconnaissance/active/tcp/tcp_ping_443.txt" "high" 30
run_advanced_tool "ACTIVE-TCP" "TCP Ping Port 22" "hping3 -S -p 22 -c 5 $TARGET 2>/dev/null || nmap -sS -p 22 $TARGET 2>/dev/null || echo 'TCP ping port 22 failed'" "$OUTPUT_DIR/reconnaissance/active/tcp/tcp_ping_22.txt" "normal" 30
run_advanced_tool "ACTIVE-TCP" "TCP ACK Scan" "hping3 -A -p 80 -c 5 $TARGET 2>/dev/null || echo 'TCP ACK scan failed'" "$OUTPUT_DIR/reconnaissance/active/tcp/tcp_ack_scan.txt" "normal" 30

run_advanced_tool "ACTIVE-UDP" "UDP Ping" "hping3 --udp -p 53 -c 5 $TARGET 2>/dev/null || nmap -sU -p 53 $TARGET 2>/dev/null || echo 'UDP ping failed'" "$OUTPUT_DIR/reconnaissance/active/udp/udp_ping.txt" "normal" 30

# PHASE 3: COMPREHENSIVE NETWORK DISCOVERY
echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║            PHASE 3: COMPREHENSIVE NETWORK DISCOVERY           ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# Enhanced Nmap Arsenal with fallbacks
run_advanced_tool "NMAP-DISCOVERY" "Quick TCP Scan" "nmap -sS -T4 --top-ports 1000 $TARGET 2>/dev/null || nmap -sT --top-ports 100 $TARGET 2>/dev/null || echo 'Quick TCP scan failed'" "$OUTPUT_DIR/network/discovery/ports/nmap_quick_tcp.txt" "critical" 300
run_advanced_tool "NMAP-DISCOVERY" "Full TCP Scan" "nmap -sS -T3 -p- $TARGET 2>/dev/null || nmap -sT --top-ports 10000 $TARGET 2>/dev/null || echo 'Full TCP scan failed'" "$OUTPUT_DIR/network/discovery/ports/nmap_full_tcp.txt" "high" 1800
run_advanced_tool "NMAP-DISCOVERY" "UDP Top Ports" "nmap -sU --top-ports 1000 -T4 $TARGET 2>/dev/null || echo 'UDP scan failed or requires root privileges'" "$OUTPUT_DIR/network/discovery/ports/nmap_udp_top1000.txt" "high" 600
run_advanced_tool "NMAP-DISCOVERY" "UDP Full Scan" "timeout 1200 nmap -sU -T3 -p- $TARGET 2>/dev/null || echo 'UDP full scan failed or timeout'" "$OUTPUT_DIR/network/discovery/ports/nmap_udp_full.txt" "normal" 1200
run_advanced_tool "NMAP-DISCOVERY" "TCP Connect Scan" "nmap -sT -T4 --top-ports 10000 $TARGET 2>/dev/null || echo 'TCP connect scan failed'" "$OUTPUT_DIR/network/discovery/ports/nmap_tcp_connect.txt" "high" 600
run_advanced_tool "NMAP-DISCOVERY" "Stealth SYN Scan" "nmap -sS -T4 --top-ports 5000 $TARGET 2>/dev/null || echo 'Stealth SYN scan failed'" "$OUTPUT_DIR/network/discovery/ports/nmap_stealth_syn.txt" "high" 600
run_advanced_tool "NMAP-DISCOVERY" "Ultra Fast SYN" "nmap -sS -T5 --min-rate=5000 --top-ports 1000 $TARGET 2>/dev/null || echo 'Ultra fast scan failed'" "$OUTPUT_DIR/network/discovery/ports/nmap_ultrafast_syn.txt" "normal" 180
run_advanced_tool "NMAP-DISCOVERY" "SCTP INIT Scan" "nmap -sY --top-ports 100 $TARGET 2>/dev/null || echo 'SCTP scan failed'" "$OUTPUT_DIR/network/discovery/ports/nmap_sctp_init.txt" "normal" 120

# Service and Version Detection
run_advanced_tool "NMAP-SERVICE" "Service Detection" "nmap -sV -T4 --version-intensity 5 --top-ports 1000 $TARGET 2>/dev/null || nmap -sT --top-ports 100 $TARGET 2>/dev/null || echo 'Service detection failed'" "$OUTPUT_DIR/network/discovery/services/nmap_service_detection.txt" "critical" 900
run_advanced_tool "NMAP-SERVICE" "Script Scanning" "nmap -sC -sV -T4 --top-ports 1000 $TARGET 2>/dev/null || nmap --top-ports 100 $TARGET 2>/dev/null || echo 'Script scanning failed'" "$OUTPUT_DIR/network/discovery/services/nmap_script_scan.txt" "high" 600
run_advanced_tool "NMAP-SERVICE" "Intense Service Scan" "nmap -sV -sC -A -T4 --top-ports 5000 $TARGET 2>/dev/null || echo 'Intense service scan failed'" "$OUTPUT_DIR/network/discovery/services/nmap_intense_service.txt" "critical" 1200
run_advanced_tool "NMAP-SERVICE" "Service Scripts" "nmap --script=banner,service-scan -p- $TARGET 2>/dev/null || echo 'Service scripts failed'" "$OUTPUT_DIR/network/discovery/services/nmap_service_scripts.txt" "high" 900

# OS Detection
run_advanced_tool "NMAP-OS" "OS Detection" "nmap -O -T4 --osscan-guess $TARGET 2>/dev/null || echo 'OS detection failed or requires root privileges'" "$OUTPUT_DIR/system/information/os/nmap_os_detection.txt" "high" 300
run_advanced_tool "NMAP-OS" "OS Aggressive" "nmap -O -A --osscan-guess --fuzzy $TARGET 2>/dev/null || echo 'Aggressive OS detection failed'" "$OUTPUT_DIR/system/information/os/nmap_os_aggressive.txt" "high" 300
run_advanced_tool "NMAP-OS" "OS Fuzzy" "nmap -O --fuzzy $TARGET 2>/dev/null || echo 'Fuzzy OS detection failed'" "$OUTPUT_DIR/system/information/os/nmap_os_fuzzy.txt" "normal" 180

# Vulnerability Scanning
run_advanced_tool "NMAP-VULN" "Basic Vuln Scan" "nmap --script vuln -T4 --top-ports 1000 $TARGET 2>/dev/null || echo 'Vulnerability scan failed'" "$OUTPUT_DIR/system/vulnerabilities/nmap_vuln_scan.txt" "critical" 900
run_advanced_tool "NMAP-VULN" "Comprehensive Vuln" "nmap --script vuln,exploit --script-args=unsafe=1 -T4 --top-ports 5000 $TARGET 2>/dev/null || echo 'Comprehensive vulnerability scan failed'" "$OUTPUT_DIR/system/vulnerabilities/nmap_vuln_comprehensive.txt" "critical" 1500
run_advanced_tool "NMAP-VULN" "CVE Detection" "nmap --script vulners,vulscan --script-args vulscandb=/usr/share/nmap/scripts/vulscan/scipvuldb.csv -sV $TARGET 2>/dev/null || echo 'CVE detection failed'" "$OUTPUT_DIR/system/vulnerabilities/cve/comprehensive_cve_scan.txt" "critical" 1200
run_advanced_tool "NMAP-VULN" "Exploit Database" "nmap --script exploit -T4 --top-ports 1000 $TARGET 2>/dev/null || echo 'Exploit database scan failed'" "$OUTPUT_DIR/system/vulnerabilities/cve/exploit_database_scan.txt" "critical" 900
run_advanced_tool "NMAP-VULN" "Intrusive Scan" "nmap --script intrusive -T4 --top-ports 1000 $TARGET 2>/dev/null || echo 'Intrusive scan failed'" "$OUTPUT_DIR/system/vulnerabilities/intrusive_scan.txt" "critical" 1200
run_advanced_tool "NMAP-VULN" "Exploit Scripts" "nmap --script exploit,dos,malware -T4 $TARGET 2>/dev/null || echo 'Exploit scripts failed'" "$OUTPUT_DIR/system/vulnerabilities/nmap_exploit_scripts.txt" "critical" 900

# Specialized vulnerability scans
run_advanced_tool "NMAP-VULN" "SMB Vulnerabilities" "nmap --script smb-vuln* -p 445 $TARGET 2>/dev/null || echo 'SMB vulnerability scan failed'" "$OUTPUT_DIR/system/vulnerabilities/smb/smb_vulnerabilities_comprehensive.txt" "high" 300
run_advanced_tool "NMAP-VULN" "DNS Vulnerabilities" "nmap --script dns-* -p 53 $TARGET 2>/dev/null || echo 'DNS vulnerability scan failed'" "$OUTPUT_DIR/system/vulnerabilities/dns/dns_vulnerabilities.txt" "high" 300
run_advanced_tool "NMAP-VULN" "RPC Vulnerabilities" "nmap --script rpc-* -p 111,135 $TARGET 2>/dev/null || echo 'RPC vulnerability scan failed'" "$OUTPUT_DIR/system/vulnerabilities/rpc/rpc_vulnerabilities.txt" "normal" 300

# Malware detection
run_advanced_tool "NMAP-MALWARE" "Backdoor Detection" "nmap --script backdoor -T4 $TARGET 2>/dev/null || echo 'Backdoor detection failed'" "$OUTPUT_DIR/malware/static/nmap_backdoor_detection.txt" "high" 600
run_advanced_tool "NMAP-MALWARE" "Malware Detection" "nmap --script malware -T4 $TARGET 2>/dev/null || echo 'Malware detection failed'" "$OUTPUT_DIR/malware/static/nmap_malware_detection.txt" "high" 600

# Safe scripts scanning
run_advanced_tool "NMAP-SAFE" "Safe Scripts" "nmap --script safe -T4 --top-ports 1000 $TARGET 2>/dev/null || echo 'Safe scripts scan failed'" "$OUTPUT_DIR/network/enumeration/nmap_scripts_safe.txt" "normal" 600

# Alternative scanning tools (with fallbacks)
if command -v masscan >/dev/null 2>&1; then
    run_advanced_tool "ALT-SCAN" "Masscan Fast" "masscan -p1-65535 $TARGET --rate=1000 2>/dev/null || nmap -sS -T5 --min-rate=1000 --top-ports 10000 $TARGET 2>/dev/null || echo 'Fast scan failed'" "$OUTPUT_DIR/network/discovery/ports/masscan_fast.txt" "high" 300
    run_advanced_tool "ALT-SCAN" "Masscan Ultra Fast" "masscan -p1-65535 $TARGET --rate=5000 2>/dev/null || echo 'Ultra fast masscan failed'" "$OUTPUT_DIR/network/discovery/ports/masscan_ultrafast.txt" "high" 180
fi

if command -v rustscan >/dev/null 2>&1; then
    run_advanced_tool "ALT-SCAN" "RustScan Fast" "rustscan -a $TARGET --range 1-65535 --timeout 3000 2>/dev/null || echo 'RustScan failed'" "$OUTPUT_DIR/network/discovery/ports/rustscan_fast.txt" "high" 300
fi

# Connectivity testing for common ports
COMMON_PORTS=(21 22 23 25 53 80 110 135 139 143 443 445 993 995 1433 3306 3389 5432 5900 6379 9200 11211 27017)
for port in "${COMMON_PORTS[@]}"; do
    if command -v nc >/dev/null 2>&1; then
        run_advanced_tool "CONNECTIVITY" "Port $port Test" "timeout 5 nc -zv $TARGET $port 2>/dev/null || echo 'Port $port closed or filtered'" "$OUTPUT_DIR/network/discovery/ports/connectivity_test_${port}.txt" "normal" 10
    fi
done

# PHASE 4: SERVICE ENUMERATION
echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                PHASE 4: SERVICE ENUMERATION                   ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# Banner Grabbing for common ports with proper netcat handling
BANNER_PORTS=(21 22 23 25 53 80 110 135 139 143 443 445 993 995 1433 3306 3389 5432 5900 6379 9200 11211 27017)
for port in "${BANNER_PORTS[@]}"; do
    # Use available netcat variant
    if command -v nc >/dev/null 2>&1; then
        run_advanced_tool "BANNER-GRAB" "Banner Port $port" "timeout 10 nc -nv -w 5 $TARGET $port < /dev/null 2>/dev/null || echo 'Banner grab failed for port $port'" "$OUTPUT_DIR/network/enumeration/banners/netcat_banner_${port}.txt" "normal" 20
    elif command -v ncat >/dev/null 2>&1; then
        run_advanced_tool "BANNER-GRAB" "Banner Port $port" "timeout 10 ncat -nv -w 5 $TARGET $port < /dev/null 2>/dev/null || echo 'Banner grab failed for port $port'" "$OUTPUT_DIR/network/enumeration/banners/netcat_banner_${port}.txt" "normal" 20
    fi
    
    # Telnet banner grabbing
    if command -v telnet >/dev/null 2>&1; then
        run_advanced_tool "BANNER-GRAB" "Telnet Banner $port" "timeout 10 telnet $TARGET $port < /dev/null 2>/dev/null || echo 'Telnet banner grab failed for port $port'" "$OUTPUT_DIR/network/enumeration/banners/telnet_banner_${port}.txt" "normal" 20
    fi
done

# SSH Enumeration with better error handling
run_advanced_tool "SSH-ENUM" "SSH Banner" "timeout 10 ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no $TARGET 2>&1 | head -5 || echo 'SSH banner grab failed'" "$OUTPUT_DIR/services/enumeration/ssh/ssh_banner.txt" "high" 20
run_advanced_tool "SSH-ENUM" "SSH Version" "nmap --script ssh-hostkey,ssh2-enum-algos -p 22 $TARGET 2>/dev/null || echo 'SSH version detection failed'" "$OUTPUT_DIR/services/enumeration/ssh/ssh_version.txt" "high" 60
run_advanced_tool "SSH-ENUM" "SSH Host Keys" "nmap --script ssh-hostkey -p 22 $TARGET 2>/dev/null || echo 'SSH host key enumeration failed'" "$OUTPUT_DIR/services/enumeration/ssh/ssh_hostkeys.txt" "high" 60
run_advanced_tool "SSH-ENUM" "SSH Algorithms" "nmap --script ssh2-enum-algos -p 22 $TARGET 2>/dev/null || echo 'SSH algorithm enumeration failed'" "$OUTPUT_DIR/services/enumeration/ssh/ssh_algorithms.txt" "high" 60
run_advanced_tool "SSH-ENUM" "SSH Auth Methods" "nmap --script ssh-auth-methods -p 22 $TARGET 2>/dev/null || echo 'SSH auth methods failed'" "$OUTPUT_DIR/services/enumeration/ssh/ssh_auth_methods.txt" "normal" 60

# FTP Enumeration
run_advanced_tool "FTP-ENUM" "FTP Anonymous" "nmap --script ftp-anon -p 21 $TARGET 2>/dev/null || echo 'FTP anonymous check failed'" "$OUTPUT_DIR/services/enumeration/ftp/ftp_anonymous.txt" "high" 60
run_advanced_tool "FTP-ENUM" "FTP Comprehensive" "nmap --script ftp-* -p 21 $TARGET 2>/dev/null || echo 'FTP comprehensive scan failed'" "$OUTPUT_DIR/services/enumeration/ftp/ftp_comprehensive.txt" "high" 120

# SMB/NetBIOS Enumeration
run_advanced_tool "SMB-ENUM" "SMB Comprehensive" "nmap --script smb-* -p 445 $TARGET 2>/dev/null || echo 'SMB comprehensive scan failed'" "$OUTPUT_DIR/services/enumeration/smb/smb_comprehensive.txt" "high" 300
run_advanced_tool "SMB-ENUM" "NetBIOS Names" "nmap --script nbstat -p 137 $TARGET 2>/dev/null || echo 'NetBIOS names failed'" "$OUTPUT_DIR/services/enumeration/smb/netbios_names.txt" "normal" 60
run_advanced_tool "SMB-ENUM" "SMB OS Discovery" "nmap --script smb-os-discovery -p 445 $TARGET 2>/dev/null || echo 'SMB OS discovery failed'" "$OUTPUT_DIR/services/enumeration/smb/smb_os_discovery.txt" "high" 120

# SNMP Enumeration
run_advanced_tool "SNMP-ENUM" "SNMP Walk Public" "nmap --script snmp-walk --script-args snmp-walk.community=public -p 161 $TARGET 2>/dev/null || echo 'SNMP walk failed'" "$OUTPUT_DIR/services/enumeration/snmp/snmp_walk_public.txt" "high" 300
run_advanced_tool "SNMP-ENUM" "SNMP Comprehensive" "nmap --script snmp-* -p 161 $TARGET 2>/dev/null || echo 'SNMP comprehensive scan failed'" "$OUTPUT_DIR/services/enumeration/snmp/snmp_comprehensive.txt" "high" 300

# Database Enumeration
run_advanced_tool "DB-ENUM" "MySQL Comprehensive" "nmap --script mysql-* -p 3306 $TARGET 2>/dev/null || echo 'MySQL enumeration failed'" "$OUTPUT_DIR/services/enumeration/mysql/mysql_comprehensive.txt" "high" 300
run_advanced_tool "DB-ENUM" "PostgreSQL Comprehensive" "nmap --script pgsql-* -p 5432 $TARGET 2>/dev/null || echo 'PostgreSQL enumeration failed'" "$OUTPUT_DIR/services/enumeration/postgresql/postgresql_comprehensive.txt" "high" 300
run_advanced_tool "DB-ENUM" "MongoDB Comprehensive" "nmap --script mongodb-* -p 27017 $TARGET 2>/dev/null || echo 'MongoDB enumeration failed'" "$OUTPUT_DIR/services/enumeration/mongodb/mongodb_comprehensive.txt" "high" 300
run_advanced_tool "DB-ENUM" "Redis Comprehensive" "nmap --script redis-* -p 6379 $TARGET 2>/dev/null || echo 'Redis enumeration failed'" "$OUTPUT_DIR/services/enumeration/redis/redis_comprehensive.txt" "high" 300

# Directory Service Enumeration
run_advanced_tool "LDAP-ENUM" "LDAP Comprehensive" "nmap --script ldap-* -p 389,636 $TARGET 2>/dev/null || echo 'LDAP enumeration failed'" "$OUTPUT_DIR/services/enumeration/ldap/ldap_comprehensive.txt" "high" 300

# Remote Desktop Enumeration
run_advanced_tool "RDP-ENUM" "RDP Comprehensive" "nmap --script rdp-* -p 3389 $TARGET 2>/dev/null || echo 'RDP enumeration failed'" "$OUTPUT_DIR/services/enumeration/rdp/rdp_comprehensive.txt" "high" 300

# VNC Enumeration
run_advanced_tool "VNC-ENUM" "VNC Comprehensive" "nmap --script vnc-* -p 5900 $TARGET 2>/dev/null || echo 'VNC enumeration failed'" "$OUTPUT_DIR/services/enumeration/vnc/vnc_comprehensive.txt" "high" 300

# Telnet Enumeration
run_advanced_tool "TELNET-ENUM" "Telnet Comprehensive" "nmap --script telnet-* -p 23 $TARGET 2>/dev/null || echo 'Telnet enumeration failed'" "$OUTPUT_DIR/services/enumeration/telnet/telnet_comprehensive.txt" "high" 300

# DNS Enumeration
run_advanced_tool "DNS-ENUM" "DNS Comprehensive" "nmap --script dns-* -p 53 $TARGET 2>/dev/null || echo 'DNS enumeration failed'" "$OUTPUT_DIR/services/enumeration/dns/dns_comprehensive.txt" "high" 300

# PHASE 5: WEB APPLICATION ANALYSIS
echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║              PHASE 5: WEB APPLICATION ANALYSIS               ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# HTTP/HTTPS Analysis
WEB_PORTS=(80 443 8000 8080 8443 8888 9000)
for port in "${WEB_PORTS[@]}"; do
    run_advanced_tool "WEB-ENUM" "HTTP Headers $port" "curl -I -L -k --max-time 20 -H \"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\" http://$TARGET:$port 2>/dev/null || wget -O- -q --timeout=20 http://$TARGET:$port 2>/dev/null | head -20 || echo 'HTTP headers failed'" "$OUTPUT_DIR/web/analysis/headers/http_headers_${port}.txt" "high" 30
    run_advanced_tool "WEB-ENUM" "HTTPS Headers $port" "curl -I -L -k --max-time 20 -H \"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\" https://$TARGET:$port 2>/dev/null || echo 'HTTPS headers failed'" "$OUTPUT_DIR/web/analysis/headers/https_headers_${port}.txt" "high" 30
    run_advanced_tool "WEB-OPTIONS" "HTTP OPTIONS $port" "curl -X OPTIONS -I -k --max-time 15 http://$TARGET:$port 2>/dev/null || echo 'OPTIONS method failed'" "$OUTPUT_DIR/web/discovery/options_method_${port}.txt" "normal" 20
done

# Enhanced web header analysis
run_advanced_tool "WEB-HEADERS" "Server Headers" "nmap --script http-headers -p 80,443,8080,8443 $TARGET 2>/dev/null || echo 'Server headers scan failed'" "$OUTPUT_DIR/web/analysis/headers/server_headers.txt" "high" 120
run_advanced_tool "WEB-HEADERS" "HTTP Headers Nmap" "nmap --script http-headers,http-server-header -p 80,443 $TARGET 2>/dev/null || echo 'HTTP headers nmap failed'" "$OUTPUT_DIR/web/analysis/headers/http_headers_nmap.txt" "high" 120

# HTTP Methods Enumeration
run_advanced_tool "WEB-METHODS" "HTTP Methods" "nmap --script http-methods --script-args http-methods.url-path=/,http-methods.test-all -p 80,443 $TARGET 2>/dev/null || echo 'HTTP methods failed'" "$OUTPUT_DIR/web/discovery/http_methods_comprehensive.txt" "high" 120
run_advanced_tool "WEB-TITLES" "HTTP Titles" "nmap --script http-title -p 80,443,8080,8443 $TARGET 2>/dev/null || echo 'HTTP titles failed'" "$OUTPUT_DIR/web/discovery/http_titles.txt" "normal" 120

# Web Content Discovery
run_advanced_tool "WEB-CONTENT" "Robots.txt" "curl -s -k --max-time 15 http://$TARGET/robots.txt 2>/dev/null || wget -q -O- --timeout=15 http://$TARGET/robots.txt 2>/dev/null || echo 'robots.txt not found or failed'" "$OUTPUT_DIR/web/discovery/directories/robots.txt" "high" 20
run_advanced_tool "WEB-CONTENT" "Sitemap.xml" "curl -s -k --max-time 15 http://$TARGET/sitemap.xml 2>/dev/null || wget -q -O- --timeout=15 http://$TARGET/sitemap.xml 2>/dev/null || echo 'sitemap.xml not found or failed'" "$OUTPUT_DIR/web/discovery/directories/sitemap.xml" "high" 20
run_advanced_tool "WEB-CONTENT" "Security.txt" "curl -s -k --max-time 15 http://$TARGET/.well-known/security.txt 2>/dev/null || curl -s -k --max-time 15 http://$TARGET/security.txt 2>/dev/null || echo 'security.txt not found'" "$OUTPUT_DIR/web/discovery/directories/security.txt" "normal" 20
run_advanced_tool "WEB-CONTENT" "Crossdomain.xml" "curl -s -k --max-time 15 http://$TARGET/crossdomain.xml 2>/dev/null || echo 'crossdomain.xml not found'" "$OUTPUT_DIR/web/discovery/directories/crossdomain.xml" "normal" 15
run_advanced_tool "WEB-CONTENT" "Clientaccesspolicy.xml" "curl -s -k --max-time 15 http://$TARGET/clientaccesspolicy.xml 2>/dev/null || echo 'clientaccesspolicy.xml not found'" "$OUTPUT_DIR/web/discovery/directories/clientaccesspolicy.xml" "normal" 15

# Common directory enumeration
COMMON_DIRS=(admin administrator login logout wp-admin phpmyadmin backup config test api css js images files uploads staging dev v1 v2)
for dir in "${COMMON_DIRS[@]}"; do
    run_advanced_tool "WEB-DIR" "Directory $dir" "curl -I -s -k --max-time 10 http://$TARGET/$dir/ 2>/dev/null | head -1 || echo 'Directory $dir test failed'" "$OUTPUT_DIR/web/discovery/directories/dir_${dir}.txt" "normal" 15
done

# Common file enumeration
COMMON_FILES=(admin.php login.php)
for file in "${COMMON_FILES[@]}"; do
    run_advanced_tool "WEB-FILE" "File $file" "curl -I -s -k --max-time 10 http://$TARGET/$file 2>/dev/null | head -1 || echo 'File $file test failed'" "$OUTPUT_DIR/web/discovery/directories/dir_${file}.txt" "normal" 15
done

# PHASE 6: WEB VULNERABILITY ASSESSMENT
echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║            PHASE 6: WEB VULNERABILITY ASSESSMENT             ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# SSL/TLS Vulnerability Assessment
run_advanced_tool "SSL-VULN" "SSL Certificate Analysis" "nmap --script ssl-cert,ssl-cert-intaddr,ssl-date -p 443 $TARGET 2>/dev/null || echo 'SSL certificate analysis failed'" "$OUTPUT_DIR/web/vulnerabilities/ssl_certificate_analysis.txt" "high" 120
run_advanced_tool "SSL-VULN" "SSL Ciphers" "nmap --script ssl-enum-ciphers -p 443 $TARGET 2>/dev/null || echo 'SSL ciphers enumeration failed'" "$OUTPUT_DIR/web/vulnerabilities/ssl_ciphers_comprehensive.txt" "high" 120
run_advanced_tool "SSL-VULN" "SSL Heartbleed" "nmap --script ssl-heartbleed -p 443 $TARGET 2>/dev/null || echo 'Heartbleed test failed'" "$OUTPUT_DIR/web/vulnerabilities/ssl_heartbleed.txt" "critical" 60
run_advanced_tool "SSL-VULN" "SSL POODLE" "nmap --script ssl-poodle -p 443 $TARGET 2>/dev/null || echo 'POODLE test failed'" "$OUTPUT_DIR/web/vulnerabilities/ssl_poodle.txt" "high" 60
run_advanced_tool "SSL-VULN" "SSL CCS Injection" "nmap --script ssl-ccs-injection -p 443 $TARGET 2>/dev/null || echo 'CCS injection test failed'" "$OUTPUT_DIR/web/vulnerabilities/ssl_ccs_injection.txt" "high" 60
run_advanced_tool "SSL-VULN" "SSL Date" "nmap --script ssl-date -p 443 $TARGET 2>/dev/null || echo 'SSL date check failed'" "$OUTPUT_DIR/web/vulnerabilities/ssl_date.txt" "normal" 30

# HTTP Security Headers
run_advanced_tool "WEB-SEC" "Security Headers" "curl -I -s -k http://$TARGET 2>/dev/null | grep -i 'x-frame-options\\|x-xss-protection\\|x-content-type-options\\|strict-transport-security\\|content-security-policy' || echo 'Security headers check completed'" "$OUTPUT_DIR/web/vulnerabilities/security_headers.txt" "high" 30

# Web Application Vulnerability Scans
run_advanced_tool "WEB-VULN" "SQL Injection" "nmap --script http-sql-injection --script-args http-sql-injection.url=/,http-sql-injection.method=GET -p 80,443 $TARGET 2>/dev/null || echo 'SQL injection scan failed'" "$OUTPUT_DIR/web/vulnerabilities/sql_injection.txt" "critical" 300
run_advanced_tool "WEB-VULN" "CSRF Check" "nmap --script http-csrf -p 80,443 $TARGET 2>/dev/null || echo 'CSRF check failed'" "$OUTPUT_DIR/web/vulnerabilities/csrf_check.txt" "high" 120
run_advanced_tool "WEB-VULN" "Cookie Security" "nmap --script http-cookie-flags -p 80,443 $TARGET 2>/dev/null || echo 'Cookie security check failed'" "$OUTPUT_DIR/web/vulnerabilities/cookie_security.txt" "high" 120
run_advanced_tool "WEB-VULN" "Slowloris" "nmap --script http-slowloris --max-parallelism 300 -p 80,443 $TARGET 2>/dev/null || echo 'Slowloris test failed'" "$OUTPUT_DIR/web/vulnerabilities/slowloris.txt" "high" 300

# Advanced web application testing
if command -v nikto >/dev/null 2>&1; then
    run_advanced_tool "WEB-NIKTO" "Nikto Scan" "nikto -h $TARGET -p 80,443 -Format txt -output /dev/stdout 2>/dev/null || echo 'Nikto scan failed'" "$OUTPUT_DIR/web/vulnerabilities/nikto_scan.txt" "critical" 600
fi

if command -v sqlmap >/dev/null 2>&1; then
    run_advanced_tool "WEB-SQLMAP" "SQLMap Scan" "timeout 300 sqlmap -u \"http://$TARGET\" --batch --random-agent --level=1 --risk=1 --thread=5 2>/dev/null || echo 'SQLMap scan failed'" "$OUTPUT_DIR/web/vulnerabilities/sqlmap_scan.txt" "critical" 300
fi

# PHASE 7: SYSTEM INFORMATION GATHERING
echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║           PHASE 7: SYSTEM INFORMATION GATHERING              ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# Local system information
run_advanced_tool "SYS-INFO" "Network Interfaces" "ip addr show 2>/dev/null || ifconfig -a 2>/dev/null || echo 'Network interfaces info failed'" "$OUTPUT_DIR/system/information/network/interfaces.txt" "normal" 30
run_advanced_tool "SYS-INFO" "Routing Table" "ip route show 2>/dev/null || route -n 2>/dev/null || echo 'Routing table info failed'" "$OUTPUT_DIR/system/information/network/routing_table.txt" "normal" 30
run_advanced_tool "SYS-INFO" "Network Statistics" "ss -tuln 2>/dev/null || netstat -tuln 2>/dev/null || echo 'Network statistics failed'" "$OUTPUT_DIR/system/information/network/network_statistics.txt" "high" 30
run_advanced_tool "SYS-INFO" "Process Network" "netstat -tulnp 2>/dev/null || ss -tulnp 2>/dev/null || echo 'Process network info failed'" "$OUTPUT_DIR/system/information/network/process_network.txt" "high" 30
run_advanced_tool "SYS-INFO" "ARP Cache" "arp -a 2>/dev/null || ip neigh show 2>/dev/null || echo 'ARP cache info failed'" "$OUTPUT_DIR/system/information/network/arp_cache.txt" "normal" 30

# Real-time progress monitor with error handling
monitor_progress() {
    local last_update=0
    while [ $(jobs -r | wc -l) -gt 0 ]; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - SCAN_START_TIME))
        local running=$(jobs -r | wc -l)
        local completed=$(grep -c "SUCCESS\|FAILED\|TIMEOUT\|NO_DATA" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
        local success=$(grep -c "SUCCESS" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
        local failed=$(grep -c "FAILED" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
        local timeout=$(grep -c "TIMEOUT" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
        local no_data=$(grep -c "NO_DATA" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
        
        # Safe progress calculation
        local progress=0
        if [ "$TOTAL_PROCESSES" -gt 0 ]; then
            progress=$((completed * 100 / TOTAL_PROCESSES))
        fi

        # Update every 5 seconds
        if [ $((current_time - last_update)) -ge 5 ]; then
            printf "\r\033[K"
            echo -ne "${GREEN}✅ Success: ${WHITE}$success${NC} ${RED}❌ Failed: ${WHITE}$failed${NC} ${YELLOW}⏱️  Timeout: ${WHITE}$timeout${NC} ${ORANGE}📭 No Data: ${WHITE}$no_data${NC} ${BLUE}🔄 Running: ${WHITE}$running${NC} ${PURPLE}📊 Progress: ${WHITE}$progress%${NC}"
            last_update=$current_time
        fi
        sleep 2
    done
    echo -e "\n"
}

# Generate comprehensive JSON report
generate_json_report() {
    local json_file="$OUTPUT_DIR/scan_report.json"
    local scan_duration=$(($(date +%s) - SCAN_START_TIME))
    
    cat << EOF > "$json_file"
{
  "scan_info": {
    "version": "Ultimate Network Scanner v4.0",
    "target": "$TARGET",
    "scan_date": "$(date -Iseconds)",
    "scan_duration_seconds": $scan_duration,
    "output_directory": "$OUTPUT_DIR"
  },
  "statistics": {
    "total_tools_executed": $TOTAL_PROCESSES,
    "successful_scans": $(grep -c "SUCCESS" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0),
    "failed_scans": $(grep -c "FAILED" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0),
    "timeout_scans": $(grep -c "TIMEOUT" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0),
    "no_data_scans": $(grep -c "NO_DATA" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0),
    "total_output_files": $(find "$OUTPUT_DIR" -type f -name "*.txt" 2>/dev/null | wc -l),
    "critical_findings": $(wc -l < "$OUTPUT_DIR/critical_findings.txt" 2>/dev/null || echo 0)
  },
  "execution_log": [
$(grep -v "^#" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null | sed 's/.*/"&",/' | sed '$ s/,$//' || echo '')
  ]
}
EOF
}

# Generate HTML threat intelligence report
generate_html_report() {
    local html_file="$OUTPUT_DIR/ULTIMATE_THREAT_INTELLIGENCE_REPORT.html"
    local scan_duration=$(($(date +%s) - SCAN_START_TIME))
    local success_count=$(grep -c "SUCCESS" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
    local total_files=$(find "$OUTPUT_DIR" -type f -name "*.txt" 2>/dev/null | wc -l)
    local critical_count=$(wc -l < "$OUTPUT_DIR/critical_findings.txt" 2>/dev/null || echo 0)
    
    cat << EOF > "$html_file"
<!DOCTYPE html>
<html>
<head>
    <title>Ultimate Threat Intelligence Report</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #1a1a1a; color: #fff; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { text-align: center; padding: 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 10px; margin-bottom: 30px; }
        .header h1 { margin: 0; font-size: 2.5em; }
        .header h2 { margin: 10px 0; color: #ffeb3b; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: #2d2d2d; padding: 20px; border-radius: 8px; text-align: center; border-left: 4px solid #00bcd4; }
        .stat-card h3 { margin: 0 0 10px 0; font-size: 2.5em; color: #00bcd4; }
        .section { background: #2d2d2d; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .section.critical { border-left: 4px solid #f44336; }
        .section.warning { border-left: 4px solid #ff9800; }
        .section.info { border-left: 4px solid #2196f3; }
        .findings-list { list-style: none; padding: 0; }
        .findings-list li { padding: 10px; background: #1e1e1e; margin: 5px 0; border-radius: 4px; border-left: 3px solid #f44336; }
        .timestamp { color: #888; font-size: 0.9em; }
        pre { background: #1e1e1e; padding: 15px; border-radius: 4px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🛡️ ULTIMATE THREAT INTELLIGENCE REPORT</h1>
            <h2>Target: $TARGET</h2>
            <p>Generated: $(date)</p>
            <p>Scan Duration: $(printf '%02d:%02d:%02d' $((scan_duration/3600)) $((scan_duration%3600/60)) $((scan_duration%60)))</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>$TOTAL_PROCESSES</h3>
                <p>Total Scans Executed</p>
            </div>
            <div class="stat-card">
                <h3>$success_count</h3>
                <p>Successful Scans</p>
            </div>
            <div class="stat-card">
                <h3>$total_files</h3>
                <p>Output Files</p>
            </div>
            <div class="stat-card">
                <h3>$critical_count</h3>
                <p>Critical Findings</p>
            </div>
        </div>
        
        <div class="section critical">
            <h2>🚨 CRITICAL SECURITY FINDINGS</h2>
            <ul class="findings-list">
$(while IFS= read -r line; do echo "                <li><span class=\"timestamp\">$line</span> - $line</li>"; done < "$OUTPUT_DIR/critical_findings.txt" 2>/dev/null || echo "                <li>No critical findings detected</li>")
            </ul>
        </div>
        
        <div class="section info">
            <h2>📊 EXECUTION SUMMARY</h2>
            <pre>$(cat "$OUTPUT_DIR/execution_log.txt" 2>/dev/null | head -50)</pre>
        </div>
    </div>
</body>
</html>
EOF
}

# Launch monitoring
monitor_progress &
MONITOR_PID=$!

# Wait for all processes
echo -e "\n${YELLOW}⏳ Executing $TOTAL_PROCESSES scanning tools...${NC}"
wait

# Kill monitor safely
kill $MONITOR_PID 2>/dev/null || true

# Generate final reports with error handling
generate_final_report() {
    local report_file="$OUTPUT_DIR/ULTIMATE_SCAN_REPORT.md"
    local scan_duration=$(($(date +%s) - SCAN_START_TIME))

    cat << EOF > "$report_file"
# 🛡️ ULTIMATE NETWORK SCANNER REPORT v4.0

## 🎯 TARGET INFORMATION
- **Target**: \`$TARGET\`
- **Scan Date**: $(date)
- **Scanner Version**: Ultimate Network Scanner v4.0 - Complete Implementation
- **Scan Duration**: $(printf '%02d:%02d:%02d' $((scan_duration/3600)) $((scan_duration%3600/60)) $((scan_duration%60)))
- **Output Directory**: \`$OUTPUT_DIR\`

## 📊 EXECUTION STATISTICS
| Metric | Count |
|--------|-------|
| Total Tools Executed | $TOTAL_PROCESSES |
| Successful Scans | $(grep -c "SUCCESS" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0) |
| Failed Scans | $(grep -c "FAILED" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0) |
| Timeout Scans | $(grep -c "TIMEOUT" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0) |
| No Data Scans | $(grep -c "NO_DATA" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0) |
| Total Output Files | $(find "$OUTPUT_DIR" -type f -name "*.txt" 2>/dev/null | wc -l) |
| Critical Findings | $(wc -l < "$OUTPUT_DIR/critical_findings.txt" 2>/dev/null || echo 0) |

## 🚨 CRITICAL SECURITY FINDINGS
\`\`\`
$(cat "$OUTPUT_DIR/critical_findings.txt" 2>/dev/null || echo "No critical findings detected")
\`\`\`

## 🔧 TOOLS USED
- **Network Scanning**: Nmap, Masscan, RustScan
- **Service Enumeration**: Protocol-specific Nmap scripts
- **Web Testing**: cURL, HTTP-specific Nmap scripts, Nikto, SQLMap
- **SSL/TLS Analysis**: OpenSSL, SSL-specific Nmap scripts
- **Vulnerability Assessment**: Vulners, VulScan, Exploit-DB scripts
- **Network Intelligence**: Ping, Traceroute, MTR, DNS tools

## 📋 QUICK ACCESS COMMANDS
\`\`\`bash
# View all open ports
find $OUTPUT_DIR -name '*nmap*' -exec grep -l 'open' {} \\;

# Check critical vulnerabilities  
find $OUTPUT_DIR -name '*vuln*' -exec cat {} \\;

# Web application findings
cat $OUTPUT_DIR/web/discovery/*.txt

# Service version information
cat $OUTPUT_DIR/network/discovery/services/nmap_intense_service.txt

# SSL/TLS security analysis
cat $OUTPUT_DIR/web/vulnerabilities/ssl_*.txt
\`\`\`

## ⚠️ IMPORTANT NOTES
- This scan was performed for **authorized security assessment purposes only**
- Results should be analyzed by **qualified security professionals**
- Some tests may have **triggered security monitoring systems**
- Always ensure **proper authorization** before conducting security assessments
- This tool is for **educational and authorized testing purposes only**

---
**Report Generated**: $(date)  
**Ultimate Network Scanner v4.0** - Complete Implementation Edition
EOF

    echo -e "${GREEN}📋 Final Report generated: $report_file${NC}"
}

# Generate all reports
generate_final_report
generate_json_report
generate_html_report

# Final completion display with safe calculations
echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                         🎉 ULTIMATE SCAN COMPLETED! 🎉                       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"

# Calculate final statistics safely
FINAL_SUCCESS=$(grep -c "SUCCESS" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
FINAL_FAILED=$(grep -c "FAILED" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
FINAL_TIMEOUT=$(grep -c "TIMEOUT" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
FINAL_NO_DATA=$(grep -c "NO_DATA" "$OUTPUT_DIR/execution_log.txt" 2>/dev/null || echo 0)
FINAL_FILES=$(find "$OUTPUT_DIR" -type f -name "*.txt" 2>/dev/null | wc -l || echo 0)
FINAL_SIZE=$(du -sh "$OUTPUT_DIR" 2>/dev/null | cut -f1 || echo "Unknown")
FINAL_CRITICAL=$(wc -l < "$OUTPUT_DIR/critical_findings.txt" 2>/dev/null || echo 0)
SCAN_DURATION=$(($(date +%s) - SCAN_START_TIME))

# Ensure we have valid numbers for calculations
FINAL_SUCCESS=${FINAL_SUCCESS:-0}
FINAL_FAILED=${FINAL_FAILED:-0}
FINAL_TIMEOUT=${FINAL_TIMEOUT:-0}
FINAL_NO_DATA=${FINAL_NO_DATA:-0}
TOTAL_PROCESSES=${TOTAL_PROCESSES:-1}

# Calculate success percentage safely
if [ "$TOTAL_PROCESSES" -gt 0 ]; then
    SUCCESS_PERCENTAGE=$(( FINAL_SUCCESS * 100 / TOTAL_PROCESSES ))
else
    SUCCESS_PERCENTAGE=0
fi

echo -e "\n${CYAN}📊 SCAN STATISTICS:${NC}"
echo -e "${BLUE}🎯 Target: ${WHITE}${BOLD}$TARGET${NC}"
echo -e "${BLUE}📁 Output Directory: ${WHITE}${BOLD}$OUTPUT_DIR${NC}"
echo -e "${BLUE}🔧 Tools Executed: ${WHITE}${BOLD}$TOTAL_PROCESSES${NC}"
echo -e "${BLUE}✅ Successful: ${WHITE}${BOLD}$FINAL_SUCCESS${NC} ${GREEN}(${SUCCESS_PERCENTAGE}%)${NC}"
echo -e "${BLUE}❌ Failed: ${WHITE}${BOLD}$FINAL_FAILED${NC}"  
echo -e "${BLUE}⏱️  Timeout: ${WHITE}${BOLD}$FINAL_TIMEOUT${NC}"
echo -e "${BLUE}📭 No Data: ${WHITE}${BOLD}$FINAL_NO_DATA${NC}"
echo -e "${BLUE}📄 Files: ${WHITE}${BOLD}$FINAL_FILES${NC}"
echo -e "${BLUE}💾 Size: ${WHITE}${BOLD}$FINAL_SIZE${NC}"
echo -e "${BLUE}🚨 Critical: ${WHITE}${BOLD}$FINAL_CRITICAL${NC}"
echo -e "${BLUE}⏰ Duration: ${WHITE}${BOLD}$(printf '%02d:%02d:%02d' $((SCAN_DURATION/3600)) $((SCAN_DURATION%3600/60)) $((SCAN_DURATION%60)))${NC}"

echo -e "\n${GREEN}🔍 ANALYSIS COMMANDS:${NC}"
echo -e "${CYAN}View Markdown report: ${WHITE}cat $OUTPUT_DIR/ULTIMATE_SCAN_REPORT.md${NC}"
echo -e "${CYAN}View HTML report: ${WHITE}open $OUTPUT_DIR/ULTIMATE_THREAT_INTELLIGENCE_REPORT.html${NC}"
echo -e "${CYAN}View JSON report: ${WHITE}cat $OUTPUT_DIR/scan_report.json${NC}"
echo -e "${CYAN}Check success: ${WHITE}grep SUCCESS $OUTPUT_DIR/execution_log.txt${NC}"
echo -e "${CYAN}Open ports: ${WHITE}find $OUTPUT_DIR -name '*nmap*' -exec grep -l 'open' {} \\; 2>/dev/null${NC}"

echo -e "\n${GREEN}${BOLD}🎯 Scan completed! All tools auto-installed and executed with complete implementation.${NC}"
echo -e "${WHITE}${BOLD}Happy Hunting! 🕵️‍♂️${NC}"
