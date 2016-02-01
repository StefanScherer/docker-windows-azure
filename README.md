# docker-windows-azure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FStefanScherer%2Fdocker-windows-azure%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FStefanScherer%2Fdocker-windows-azure%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template will deploy and configure a Windows Server 2016 TP4 core VM instance with Windows Server Containers and Docker Engine. These items are performed by the template:

* Deploy the TP4 Windows Server Container Image
* Run the Docker Engine
* Open Ports for SSH, RDP, WinRM (HTTPS) and Docker (HTTP unsecure).
* Install OpenSSH
  * Adds the SSH public key of a given GitHub user for password-less login
* Install additional Docker tools:
  * Docker Compose 1.5.2
  * Docker Machine 0.5.6

Windows Server 2016 TP4 and Windows Server Container are in an early preview release and are not production ready and or supported.

The Docker Engine is started without TLS certificates. Do not run this production.

> Microsoft Azure does not support Hyper-V containers. To complete Hyper-V Container exercises, you need an on-prem container host.

## azure-cli

Additional to the "Deploy to Azure" button abvoe you can deploy the VM with the `azure` cli as well:

```
azure config mode arm
azure group deployment create Group docker-tp4 \
  --template-uri https://raw.githubusercontent.com/StefanScherer/docker-windows-azure/master/azuredeploy.json \
  -p '{
    "adminUsername": {"value": "docker"},
    "adminPassword": {"value": "Super$ecretPass123"},
    "dnsNameForPublicIP": {"value": "docker-tp4"},
    "VMName": {"value": "docker-tp4"},
    "location": {"value": "North Europe"}
    }'
```

To retrieve the IP address or the FQDN use these commands

```bash
azure vm show Group docker-tp4 | grep "Public IP address" | cut -d : -f 3
1.2.3.4

azure vm show Group docker-tp4 | grep FQDN | cut -d : -f 3 | head -1
docker-tp4.northeurope.cloudapp.azure.com
```

## Connect to Docker Engine

To connect to the Windows Docker Engine from a notebook you just have to set the DOCKER_HOST environment variable.

At the moment the connection is unsecured which I want to change in near future in this repo.

### bash
```bash
unset DOCKER_MACHINE_NAME
unset DOCKER_TLS_VERIFY
unset DOCKER_CERT_PATH
export DOCKER_HOST=tcp://$(azure vm show Group docker-tp4 | grep "Public IP address" | cut -d : -f 3):2375
```

### PowerShell
```powershell
rm env:DOCKER_MACHINE_NAME
rm env:DOCKER_TLS_VERIFY
rm env:DOCKER_CERT_PATH
$env:DOCKER_HOST="tcp://$(azure vm show Group docker-tp4 | grep "Public IP address" | cut -d : -f 3):2375"
```

The thee `unset` commands are useful if you use `docker-machine` to connect to different VM's with TLS. This turns off TLS so you can then run `docker` commands like

```bash
docker images
```
![docker-run-cmd](images/docker-images.png)

or start your first Windows container eg. from your Mac

```bash
docker run -it windowsservercore cmd
```
![docker-run-cmd](images/docker-run-cmd.png)

## Credits

This work is based on the Azure quickstart templates
* https://github.com/Azure/azure-quickstart-templates/tree/master/windows-server-containers-preview
* https://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-winrm-windows
