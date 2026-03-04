#!/bin/zsh
set -e

echo "[*] Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "[*] Installing Go..."
sudo apt install golang -y

# === Setup Go Path Properly for zsh ===
GOPATH=$(go env GOPATH)
GOBIN="$GOPATH/bin"

echo "[*] Configuring Go environment for zsh..."

if ! grep -q "$GOBIN" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# Go Path" >> ~/.zshrc
    echo "export PATH=\$PATH:$GOBIN" >> ~/.zshrc
fi

export PATH=$PATH:$GOBIN
mkdir -p "$GOBIN"

echo "[*] Installing recon tools..."

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/owasp-amass/amass/v4/...@latest
go install -v github.com/tomnomnom/assetfinder@latest

echo
echo "[✔] Installed tool versions:"
echo -n "subfinder: "; subfinder -version 2>/dev/null || echo "Not found"
echo -n "httpx: "; httpx -version 2>/dev/null || echo "Not found"
echo -n "dnsx: "; dnsx -version 2>/dev/null || echo "Not found"
echo -n "amass: "; amass -version 2>/dev/null || echo "Not found"
echo -n "assetfinder: "; assetfinder -h 2>/dev/null | head -n 1 || echo "Not found"

echo
echo "[✅] Recon environment setup complete!"
echo "[ℹ] Restart your terminal or run: source ~/.zshrc"
