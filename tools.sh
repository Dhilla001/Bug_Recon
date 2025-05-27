#!/bin/bash

# === Update packages ===
echo "[*] Updating system..."
sudo apt update -y && sudo apt upgrade -y

# === Install Go (Golang) ===
echo "[*] Installing Go..."
sudo apt install golang -y

# === Set Go environment ===
echo "[*] Setting Go path..."
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc

# === Create Go bin folder if it doesn't exist ===
mkdir -p "$(go env GOPATH)/bin"

# === Install Subfinder ===
echo "[*] Installing subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# === Install httpx ===
echo "[*] Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# === Install dnsx ===
echo "[*] Installing dnsx..."
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

# === Install Amass ===
echo "[*] Installing amass..."
sudo snap install amass

# === Install assetfinder ===
echo "[*] Installing assetfinder..."
go install -v github.com/tomnomnom/assetfinder@latest

# === Reload shell to reflect changes ===
echo "[*] Reloading shell environment..."
source ~/.bashrc

# === Verify Installations ===
echo
echo "[✔] Installed tool versions:"
echo -n "subfinder: "; subfinder -version 2>/dev/null
echo -n "httpx: "; httpx -version 2>/dev/null
echo -n "dnsx: "; dnsx -version 2>/dev/null
echo -n "amass: "; amass -version 2>/dev/null
echo -n "assetfinder: "; assetfinder -h | head -n 1

echo
echo "[✅] All recon tools installed successfully!"
