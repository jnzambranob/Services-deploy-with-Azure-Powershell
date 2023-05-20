param ($ambient)
#FUNCTIONS DECLARATIONS
function Find-IfResourceExist{    
    param (
        [Parameter(Mandatory=$true)]$rgname,
        [Parameter(Mandatory=$false)]$resname
    )
    if ( $null -eq $resname ){
        $resourcecheck = Get-AzResourceGroup -ResourceGroupName $rgname
        if ( $null -eq $resourcecheck ){
            Write-Output $false
        }
        else {
            Write-Output $true
             }
    }
    else{
        $resourcecheck = Get-AzResource -ResourceGroupName $rgname -Name $resname
        if ( $null -eq $resourcecheck ){
            Write-Output $false
        }
        else {
            Write-Output $true
             }
    } 
}
#-----------------------
#CONNECTION CONFIRMATION
Connect-AzAccount | Out-Null;
#-----------------------
#ENVIROMENT SETTINGS
#----------------------DEVELOPMENT-----------------------
if ($ambient -eq "dev"){ #setting names for development enviroment
    write-host "Enviroment: Development"
    $rgname = "RGBootcamp-Dev" #Resource Group name
    $spname = "SPBootcamp-Dev" #App Service Plan name
    $appname = "ASBootcamp-Dev" #Appservice name (unique name required)
    $fname =  "FuncBootcamp-Dev" #Function Service name (unique name required)
    $location = "East US" #Location of the resources
    $stoname = "stobootcampdev" #Storage account name (Mandatory for correct configuration of function app)
}
#----------------------PRODUCTION-----------------------
elseif ($ambient -eq "prod") { #setting names for production enviroment
    write-host "Enviroment: Production"
    $rgname = "RGBootcamp-Prod" #Resource Group name
    $spname = "SPBootcamp-Prod" #App Service Plan name
    $appname = "ASBootcamp-Prod" #Appservice name (unique name required)
    $fname =  "FuncBootcamp-Prod" #Function Service name (unique name required)
    $location = "East US" #Location of the resources
    $stoname = "stobootcampprod" #(Mandatory for correct configuration of function app)
}
else{
    write-host "The parameter for execution is not recognized or missing, check and try again"
    exit
}
#-----------------------
#RESOURCES DECLARATION AND DEPLOY
#-----------------------RESOURCE GROUP------------------------
New-AzResourceGroup -Name $rgname -Location $location -Force #Resource Group deployment
#-----------------------RESOURCE: APP SERVICE PLAN------------------------
$Appserplanprop = @{ #Properties of the App service plan /serverfarms
    ResourceGroupName = $rgname
    Name              = $spname
    Location          = $location
    Tier              = "Free"
}
New-AzAppServicePlan @Appserplanprop #App service plan deployment
#-----------------------RESOURCE: APP SERVICE------------------------
$Appserprop = @{ #Properties of the App Service /sites
    ResourceGroupName = $rgname
    Name              = $appname
    Location          = $location
    AppServicePlan    = $spname
}
if((Find-IfResourceExist $rgname $appname) -eq $false){
    Write-Output "Creating resource"
    New-AzWebApp @Appserprop #App service deployment
}
else {
    Write-Output "The resource exist, skipping deployment"
}
#-----------------------RESOURCE: FUNCTION APP------------------------
$Funcprop = @{ #Properties of the App Service /sites
    Location           = $location  #For NewAzFunctionApp
    Name               = $fname     #For NewAzFunctionApp
    ResourceGroupName  = $rgname    #For NewAzFunctionApp
    Runtime            = "powershell"
    StorageAccountName = $stoname
}
if((Find-IfResourceExist $rgname $fname) -eq $false){
    Write-Output "Creating storage account"
    New-AzStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $location -SkuName Standard_LRS
    Write-Output "Creating resource"
    New-AzFunctionApp @Funcprop #General Function deployment (avoid the manual deploy of storage account)
}
else {
    Write-Output "The resource exist, skipping deployment"
}
#------------------------END OF THE SCRIPT----------------------------