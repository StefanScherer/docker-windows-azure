## Windows Server Container Host Preview (Docker Ready)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FStefanScherer%2Fdocker-windows-azure%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FStefanScherer%2Fdocker-windows-azure%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template will deploy and configure a Windows Server 2016 TP4 core VM instance with Windows Server Containers. These items are performed by the template:

- Deploy the TP4 Windows Server Container Image.
- Create inbound network security group rules for HTTP, RDP and Docker.
- Create inbound Windows Firewall rule for Docker (custom script extensions).

Windows Server 2016 TP4 and Windows Server Container are in an early preview release and are not production ready and or supported.

> Microsoft Azure does not support Hyper-V containers. To complete Hyper-V Container exercises, you need an on-prem container host.

## azure-cli

```
azure config mode arm
azure group deployment create Group docker-tp4 --template-uri https://raw.githubusercontent.com/StefanScherer/docker-windows-azure/master/azuredeploy.json -p '{ "adminUsername": {"value": "docker"}, "adminPassword": {"value": "Super$ecretPass123"}, "dnsNameForPublicIP": {"value": "docker-tp4"}, "VMName": {"value": "docker-tp4"}, "location": {"value": "North Europe"}}'
```
