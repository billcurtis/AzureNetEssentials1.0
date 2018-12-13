# parameters 
$ServergName1 = "NetEssentConsoleServer-East"
$ServergName2 = "NetEssentConsoleServer-West"
$templateFile1 = '.\CreateConsoleVM1_Template.json'
$templateFile2 = '.\CreateConsoleVM2_Template.json'
$templateparameterFile1 = '.\CreateConsoleServerVM1_Parameters.json'
$templateparameterFile2 = '.\CreateConsoleServerVM2_Parameters.json'

# import the AzureRM modules
Import-Module AzureRM.Resources

#  login
Login-AzureRmAccount

# create the resource from the template - pass names as parameters
New-AzureRmResourceGroup -Location "East US" -Name $ServergName1
New-AzureRmResourceGroup -Location "West US" -Name $ServergName2

New-AzureRmResourceGroupDeployment -Verbose -Force -ResourceGroupName $ServergName1 -TemplateFile $templateFile1 -TemplateParameterFile $templateparameterFile1 
New-AzureRmResourceGroupDeployment -Verbose -Force -ResourceGroupName $ServergName2 -TemplateFile $templateFile2 -TemplateParameterFile $templateparameterFile2