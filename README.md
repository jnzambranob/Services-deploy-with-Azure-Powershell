# Services deployment with Azure Powershell
Base architecture deployment with Azure Powershell
Version: 0.1

### How to use?
This PowerShell script allows you to deploy the following resources:

- Resource Group
- App Service Plan
- App Service
- Azure Function (With its own App service plan and storage account)

The user can set the parameter "-ambient" with the commands **"dev"** or **"prod"** depending of the desired deployment settings.

~~Also, the script implements a function to generate unique names based in the date and time of the host system; this is used to prevent duplicated names in the resources with mandatory unique name.~~
The script implements a function to verify if a resource or a resource group exist (to avoid the creation of duplicated resources)

### Requirememts
- Powershell or PSCore installed (tested with PSCore 7.3.4)
- Az Powershell installed (check [THIS](https://github.com/jnzambranob/Bootcamp-tools-installer.git))

### Instructions
**1.** Clone this repo or download the script file: [Script Link](https://raw.githubusercontent.com/jnzambranob/Services-deploy-with-Azure-Powershell/main/servdeploy_vres.ps1)(Right-click in the link and choose "Save link as")
**2.** Allow the PowerShell script execution running this command in a PowerShell terminal:
```powershell
Set-ExecutionPolicy -ExecutionPolicy ByPass -Scope CurrentUser
```
  >This is mandatory and has to be done because the script execution is disabled by default for security reasons.

**3.** To avoid security leaks, the Azure session is not hard-coded in the script and the Azure session auth should be managed by the user **before** running this script. An easy way to start an Azure session in an attended system is running the comamnd:
```powershell
Connect-AzAccount
```
Also, the user can run the auxiliar script that uses the command mentioned before with the command:
```powershell
.\servdeploy.ps1 -ambient dev
```
This version didn't have the parameter **-connected** and could be used if the script is **not** running in an unnattended host (*as a Pipeline*)

**4.** Run the script directly from PowerShell using the mandatory parameters **-ambient** (**dev** or **prod**) and **-connected** (**yes** is the only parameter acepted). Here is an **example** of the command:
```powershell
.\servdeploy_noauth.ps1 -ambient dev -connected yes
```

>Remember to open the script from the folder where the file is located. This script not could be executed from the file explorer, because it needs additional parameters for running.

### Known Issues
- The script uses only functions for resource declaration and deployment. There is not use of resource properties modding functions.
