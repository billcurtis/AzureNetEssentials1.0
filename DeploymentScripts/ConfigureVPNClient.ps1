
# Version 1.0  Provision VPN Client

# Sleep as extension has a habit of starting a little too quick.
Start-Sleep -Seconds 30

#Disable Firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

#Enable RDP 
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

#Enable RDP
$RDPRegPath = 'HKLM:\System\CurrentControlSet\Control\Terminal Server'
set-ItemProperty -Path $RDPRegPath -name "fDenyTSConnections" -Value 0

Invoke-Command -ScriptBlock {

    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Confirm:$false -Force

    <# Install Chocolatey
Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) 

# Install OpenVPN
choco install openvpn --params "'/SELECT_SHORTCUTS=1 /SELECT_ASSOCIATIONS=1'" -y
#>

    # Download OpenVPN
    New-Item -ItemType Directory -Path C:\temp -Force
    $openVPNuri = 'https://swupdate.openvpn.org/community/releases/OpenVPN-2.5.9-I601-amd64.msi'
    Invoke-RestMethod -Method Get -Uri $openVPNuri -OutFile 'C:\temp\OpenVPN.msi'
    Set-Location -Path C:\Temp
    $expression = "msiexec /i OpenVPN.msi /qb"
    Invoke-Expression $expression



    # Create Lab Cert Files
    New-Item 'C:\Users\All Users\VPNCertificates' -ItemType Directory -Force 
    $p2sClientCertPath = (New-Item 'C:\Users\All Users\Desktop\VPNCertificates\P2SClientCertificate.txt' -ItemType File -Force).FullName
    $p2sClientPrivateKeyPath = (New-Item 'C:\Users\All Users\Desktop\VPNCertificates\P2SClientPrivateKey.txt' -ItemType File -Force).FullName
    $rootCertPath = (New-Item 'C:\Users\All Users\Desktop\VPNCertificates\RootCert.txt' -ItemType File -Force).FullName

    # Populate Content of Cert Files
    Set-Content -Value ((Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/billcurtis/AzureNetEssentials1.0/master/DeploymentScripts/Artifacts/P2SClientCertificate.txt' -UseBasicParsing).Content) -LiteralPath $p2sClientCertPath -Force
    Set-Content -Value ((Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/billcurtis/AzureNetEssentials1.0/master/DeploymentScripts/Artifacts/P2SClientPrivateKey.txt' -UseBasicParsing).Content) -LiteralPath $p2sClientPrivateKeyPath -Force
    Set-Content -Value ((Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/billcurtis/AzureNetEssentials1.0/master/DeploymentScripts/Artifacts/RootCert.txt' -UseBasicParsing).Content) -LiteralPath $rootCertPath -Force

}