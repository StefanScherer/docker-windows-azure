#  Arguments : HostName, specifies the FQDN of machine or domain
param
(
    [string] $HostName = $(throw "HostName is required."),
)

$Logfile = "C:\containerConfig.log"

function LogWrite {
   Param ([string]$logstring)
   $now = Get-Date -format s
   Add-Content $Logfile -value "$now $logstring"
   Write-Host $logstring
}

LogWrite "containerConfig.ps1"
LogWrite "HostName = $($HostName)"
LogWrite "USERPROFILE = $($env:USERPROFILE)"
LogWrite "pwd = $($pwd)"

$DockerConfig = 'C:\ProgramData\Docker\runDockerDaemon.cmd'

#Set RDP and Docker Firewall Rules:

if (!(Get-NetFirewallRule | where {$_.Name -eq "Docker"})) {
    New-NetFirewallRule -Name "Docker" -DisplayName "Docker" -Protocol tcp -LocalPort 2375 -Action Allow -Enabled True
}

if (!(Get-NetFirewallRule | where {$_.Name -eq "SSH"})) {
    New-NetFirewallRule -Name "SSH" -DisplayName "SSH" -Protocol tcp -LocalPort 22 -Action Allow -Enabled True
}

# Install OpenSSH
# see also https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/12_22_2015/OpenSSH-Win64.zip -Out OpenSSH-Win64.zip -UseBasicParsing
Expand-Archive OpenSSH-Win64.zip "C:\Program Files" -Force
Push-Location "C:\Program Files\OpenSSH-Win64"
.\ssh-keygen.exe -A
copy "C:\Program Files\OpenSSH-Win64\x64\ssh-lsa.dll" C:\Windows\system32\
cmd /c setup-ssh-lsa.cmd
.\sshd.exe install
Start-Service sshd
Set-Service sshd -StartupType Automatic
Pop-Location

#Modify Docker Daemon Configuration
if (!($file = Get-Item -Path $DockerConfig)) {
    Write-Verbose "Docker Daemon Command File Missing" -Verbose
}
else {
    $file = Get-Content $DockerConfig
    $file = $file -replace '^docker daemon -D -b "Virtual Switch"$','docker daemon -D -b "Virtual Switch" -H 0.0.0.0:2375'
    Set-Content -Path $DockerConfig -Value $file
}

#Restart Docker Service
Restart-Service Docker

# Install Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
# install docker tools
choco install -y docker-machine -version 0.5.6
choco install -y docker-compose -version 1.5.2

.\ConfigureWinRM.ps1 $HostName

# OpenSSH server needs a restart for ssh key based logins
Restart-Computer
