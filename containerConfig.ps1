#################################################################################################################################
#  Name        : Configure-WinRM.ps1                                                                                            #
#                                                                                                                               #
#  Description : Configures the WinRM on a local machine                                                                        #
#                                                                                                                               #
#  Arguments   : HostName, specifies the FQDN of machine or domain                                                           #
#################################################################################################################################

param
(
    [Parameter(Mandatory = $true)]
    [string] $HostName

    [string] $GitHubUsername
)

$DockerConfig = 'C:\ProgramData\Docker\runDockerDaemon.cmd'

#Set RDP and Docker Firewall Rules:

if (!(Get-NetFirewallRule | where {$_.Name -eq "Docker"})) {
    New-NetFirewallRule -Name "Docker" -DisplayName "Docker" -Protocol tcp -LocalPort 2376 -Action Allow -Enabled True
}

if (!(Get-NetFirewallRule | where {$_.Name -eq "SSH"})) {
    New-NetFirewallRule -Name "SSH" -DisplayName "SSH" -Protocol tcp -LocalPort 22 -Action Allow -Enabled True
}

# Install OpenSSH
# see also https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH
Expand-Archive OpenSSH-Win64.zip "C:\Program Files" -Force
Push-Location "C:\Program Files\OpenSSH-Win64"
.\ssh-keygen.exe -A
copy "C:\Program Files\OpenSSH-Win64\x64\ssh-lsa.dll" C:\Windows\system32\
cmd /c setup-ssh-lsa.cmd
.\sshd.exe install
Start-Service sshd
Set-Service sshd -StartupType Automatic
Pop-Location

# Insert public SSH keys of given GitHub user
if ($GitHubUsername -ne "") {
  if (!(Test-Path "$env:USERPROFILE\.ssh")) {
    mkdir "$env:USERPROFILE\.ssh"
  }
  wget https://api.github.com/users/$GitHubUsername/keys -UseBasicParsing | ConvertFrom-Json | foreach { $_.key } | Out-File $env:USERPROFILE\.ssh\authorized_keys -encoding ASCII -append
}

#Restart Docker Service
#Restart-Service Docker

.\ConfigureWinRM.ps1 $HostName
