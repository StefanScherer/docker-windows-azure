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
* Open Ports for RDP, WinRM (HTTPS) and Docker (HTTPS).
* Install additional Docker tools:
  * Docker Compose 1.5.2
  * Docker Machine 0.5.6

Windows Server 2016 TP4 and Windows Server Container are in an early preview release and are not production ready and or supported.

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
$ azure vm show Group docker-tp4 | grep "Public IP address" | cut -d : -f 3
1.2.3.4

$ azure vm show Group docker-tp4 | grep FQDN | cut -d : -f 3 | head -1
docker-tp4.northeurope.cloudapp.azure.com
```

## Credits

This work is based on the Azure quickstart templates
* https://github.com/Azure/azure-quickstart-templates/tree/master/windows-server-containers-preview
* https://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-winrm-windows
