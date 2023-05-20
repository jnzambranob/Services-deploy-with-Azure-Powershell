param ($ambient)
function Set-UniqueName{
    
    param (
        [Parameter(Mandatory)]
        [string]$UniqueName
    )

    $date = Get-date; #date for unique name generation;
    $uidate = "{0}{1}{2}-{3}{4}{5}" -f $date.Year,$date.Month,$date.Day,$date.hour,$date.Minute,$date.Second #Unique namegen
    $UniqueNameOut = $UniqueName + "$uidate"
    Write-Output $UniqueNameOut
}

if ($ambient -eq "dev"){ #setting names for DEVELOPMENT enviroment
    write-host "Enviroment: Development"
    $rgname = "RGBootcamp-Dev" #Resource Group name
    $spname = "SPBootcamp-Dev" #Service Plan name
    $appname = Set-UniqueName ASBootcamp-Dev #Appservice Plan name
    $fname =  Set-UniqueName FuncBootcamp-Dev #Function Service name
    $location = "East US" #Location of the resources
}
elseif ($ambient -eq "prod") { #setting names for PRODUCTION enviroment
    write-host "Enviroment: Production"
    $rgname = "RGBootcamp-Prod" #Resource Group name
    $spname = "SPBootcamp-Prod" #Service Plan name
    $appname = Set-UniqueName ASBootcamp-Prod #Appservice Plan name
    $fname =  Set-UniqueName FuncBootcamp-Prod #Function Service name
    $location = "East US" #Location of the resources    
}
else{
    write-host "The parameter for execution is not recognized or missing, check and try again"
    exit
}

Connect-AzAccount | Out-Null;

$Appserplanprop = @{ #Properties of the App service plan /serverfarms
    Location          = $location
    Properties        = @{Createdby="AZPowershell"}
    Sku               = @{name= "F1"
                          tier = "Free"
                          size = "F1"
                          family = "F"
                          capacity = 1
                         }
    ResourceName      = $spname
    ResourceType      = "Microsoft.Web/serverfarms"
    ResourceGroupName = $rgname
    Force             = $true
}
New-AzResourceGroup -Name $rgname -Location $location -Force #Resource Group deployment
New-AzResource @Appserplanprop #App service plan deployment
$sf = Get-AzResource -Name $spname;
$Appserprop = @{ #Properties of the App Service /sites
    Location          = $location
    Properties        = @{Createdby="AZPowershell"
                          serverFarmId=$sf.Id}
    ResourceName      = $appname
    ResourceType      = "microsoft.Web/sites"
    ResourceGroupName = $rgname
    Force             = $true
}
New-AzResource @Appserprop #App service deployment
$Funcprop = @{ #Properties of the App Service /sites
    Location          = $location
    Kind              = "functionapp"
    Properties        = @{Createdby="AZPowershell"}
    ResourceName      = $fname
    ResourceType      = "microsoft.Web/sites"
    ResourceGroupName = $rgname
    Force             = $true
}
New-AzResource @Funcprop #Function deployment