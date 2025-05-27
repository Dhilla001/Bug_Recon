#!/bin/bash

# === Function to check if required tools are installed ===
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "[!] Error: $1 is not installed. Please install it and try again."
        exit 1
    }
}

# === Check if required tools are installed ===
echo "[*] Checking dependencies..."
for tool in subfinder assetfinder amass dnsx httpx; do
    check_command "$tool"
done

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

# === Run enumeration tools ===

echo "[*] Running subfinder..."
subfinder -d "$domain" -silent -all -o subfinder.txt || echo "[!] subfinder failed."

echo "[*] Running assetfinder..."
assetfinder --subs-only "$domain" > assetfinder.txt || echo "[!] assetfinder failed."

echo "[*] Running amass (passive only)..."
amass enum -passive -d "$domain" -o amass.txt || echo "[!] amass passive failed."

echo "[*] Merging and deduplicating subdomains..."
cat subfinder.txt assetfinder.txt amass.txt 2>/dev/null | sort -u > all_subs.txt || {
    echo "[!] Failed to create all_subs.txt"
    exit 1
}

echo "[*] Running dnsx (check live services)..."
dnsx -silent -a -resp -l all_subs.txt -o live_subs.txt || echo "[!] dnsx failed."

echo "[*] Running httpx (check web services)..."
httpx -silent -l live_subs.txt -o httpx.txt || echo "[!] httpx failed."

echo "[✅] Enumeration completed. Results saved in: $output_dir/"
