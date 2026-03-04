#!/bin/zsh
set -euo pipefail

# === Function to check if required tools are installed ===
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "[!] Error: $1 is not installed. Please install it and try again."
        exit 1
    }
}

echo "[*] Checking dependencies..."
for tool in subfinder assetfinder amass dnsx httpx; do
    check_command "$tool"
done

domain="${1:?Usage: $0 <target.com>}"

if [[ -d "$domain" ]]; then
    echo "[!] Directory $domain already exists. Files may be overwritten."
fi

mkdir -p "$domain"
cd "$domain"

echo "[+] Starting subdomain enumeration for: $domain"

subfinder -d "$domain" -silent -all -o subfinder.txt || echo "[!] subfinder failed."
assetfinder --subs-only "$domain" > assetfinder.txt || echo "[!] assetfinder failed."
amass enum -passive -d "$domain" -o amass.txt || echo "[!] amass passive failed."

cat subfinder.txt assetfinder.txt amass.txt 2>/dev/null | sort -u > all_subs.txt

dnsx -silent -a -resp -l all_subs.txt -o live_subs.txt || echo "[!] dnsx failed."
httpx -silent -l live_subs.txt -o httpx.txt || echo "[!] httpx failed."

echo "[✅] Enumeration completed."
echo "[📁] Results stored in: $(pwd)"
echo "[📊] Total unique subdomains: $(wc -l < all_subs.txt)"
