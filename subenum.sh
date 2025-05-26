#!/bin/bash

# === Function to check if required tools are installed ===
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "[!] Error: $1 is not installed. Please install it and try again."
        exit 1
    }
}

# === Check if required tools are available ===
echo "[*] Checking dependencies..."
for tool in subfinder assetfinder amass dnsx httpx; do
    check_command "$tool"
done

# === Check if SecLists wordlist exists ===
SECLISTS_WORDLIST="/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
if [ ! -f "$SECLISTS_WORDLIST" ]; then
    echo "[!] Required wordlist not found: $SECLISTS_WORDLIST"
    echo "    → Make sure SecLists is installed: https://github.com/danielmiessler/SecLists"
    echo "    → Or update the script with a correct wordlist path."
    exit 1
fi

# === Check for domain input ===
if [ -z "$1" ]; then
    echo "[!] Usage: $0 <target.com>"
    exit 1
fi

domain=$1
output_dir="$domain"
mkdir -p "$output_dir" || { echo "[!] Failed to create output directory."; exit 1; }
cd "$output_dir" || exit 1

echo "[+] Starting subdomain enumeration for: $domain"

# === Start enumeration ===

echo "[*] Running subfinder..."
subfinder -d "$domain" -silent -all -o subfinder.txt || echo "[!] subfinder failed."

echo "[*] Running assetfinder..."
assetfinder --subs-only "$domain" > assetfinder.txt || echo "[!] assetfinder failed."

echo "[*] Running amass (passive)..."
amass enum -passive -d "$domain" -o amass.txt || echo "[!] amass passive failed."

echo "[*] Running amass (active brute-force)..."
amass enum -active -brute -w "$SECLISTS_WORDLIST" -d "$domain" -o amass_brute.txt || echo "[!] amass brute failed."

echo "[*] Merging and deduplicating subdomains..."
cat subfinder.txt assetfinder.txt amass.txt amass_brute.txt 2>/dev/null | sort -u > all_subs.txt || {
    echo "[!] Failed to create all_subs.txt"
    exit 1
}

echo "[*] Running dnsx..."
dnsx -silent -a -resp -l all_subs.txt -o live_subs.txt || echo "[!] dnsx failed."

echo "[*] Running httpx..."
httpx -silent -l live_subs.txt -o httpx.txt || echo "[!] httpx failed."

echo "[✅] Enumeration completed. Output saved in: $output_dir/"
