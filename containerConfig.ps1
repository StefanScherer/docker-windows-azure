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
)

$DockerConfig = 'C:\ProgramData\Docker\runDockerDaemon.cmd'

#Set RDP and Docker Firewall Rules:

if (!(Get-NetFirewallRule | where {$_.Name -eq "Docker"})) {
    New-NetFirewallRule -Name "Docker" -DisplayName "Docker" -Protocol tcp -LocalPort 2376 -Action Allow -Enabled True
}

# Install OpenSSL
# see also http://blogsprajeesh.blogspot.de/2015/09/docker-for-windows-on-azure-vm-securing.html
Start-Process .\Win64OpenSSL_Light-1_0_2f.exe -ArgumentList '/silent /verysilent /sp- /suppressmsgboxes' -Wait
$env:OPENSSL_CONF = "C:\OpenSSL-Win64\bin\openssl.cfg"
$opensslExe = "C:\OpenSSL-Win64\bin\openssl.exe"

#$CertLocation = "C:\ProramData\Docker"
#$env:RANDFILE = Join-Path $CertLocation ".rnd"
#& $opensslExe genrsa -aes256 -out ca-key.pem 2048
#& $opensslExe req -new -x509 -days 365 -key ca-key.pem -subj "/C=NL/ST=UT/L=Amersfoort/O=Prajeesh" -sha256 -out ca.pem
#& $opensslExe genrsa -aes256 -out server-key.pem 2048
#& $opensslExe req -subj "/C=NL/ST=UT/L=Amersfoort/O=Prajeesh" -new -key server-key.pem -out server.csr
#"subjectAltName = IP:10.10.10.20,IP:127.0.0.1,DNS.1:*.cloudapp.net,DNS.2:*.*.cloudapp.azure.com" | Out-File extfile.cnf -Encoding ASCII
#& $opensslExe x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
#& $opensslExe genrsa -out client-key.pem 2048
#& $opensslExe req -subj "/CN=client" -new -key client-key.pem -out client.csr
#"extendedKeyUsage = clientAuth" | Out-File extfile.cnf -Encoding ASCII
#& $opensslExe x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile.cnf


#Modify Docker Daemon Configuration
#if (!($file = Get-Item -Path $DockerConfig)) {
#    Write-Verbose "Docker Daemon Command File Missing" -Verbose
#} else {
#    $file = Get-Content $DockerConfig
#    $file = $file -replace '^docker daemon -D -b "Virtual Switch"$','docker daemon -D -b "Virtual Switch" -H 0.0.0.0:2375'
#    Set-Content -Path $DockerConfig -Value $file
#}

#Restart Docker Service
#Restart-Service Docker

.\ConfigureWinRM.ps1 $HostName
