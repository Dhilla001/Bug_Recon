# Deep Bug_Recon
This is a tool for automating deep recon process for bug hunting (My personal methodology)

The kali tools used in here:       
      -subfinder      
      -assetfinder      
      -amass      
      -dnsx *find all live SDs(SubDomains) including non webservice SDs such as FTP, mail, etc.      
      -httpx *find all live SDs with webservice(http/https)      

A seperate folder will be created with the name of the target, containing the enumerated files.

Usage:      
      First install all the required tools(One time):    
      
      chmod +x tools.sh      
      ./tools.sh      
      chmod +x subenum.sh    
      
after this, run the subenum.sh with the target wildcard     

      ./subenum.sh target.com      

