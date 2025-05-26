# Deep Bug_Recon
This is a tool for automating deep recon process for bug hunting (My personal methodology)

Note: This tool assumes that the required kali tools(preinstalled) are working perfect.
      -subfinder
      -assetfinder
      -amass
      -dnsx *find all live SDs(SubDomains) including non webservice SDs such as FTP, mail, etc.
      -httpx *find all live SDs with webservice(http/https)
      -SecLists (wordlist, not available preinstalled in kali, install it from "https://github.com/danielmiessler/SecLists")

Usage: chmod +x subenum.sh
       ./subenum.sh target.com
