
# Version 1.0  Provision VPN Client

# Sleep as extension has a habit of starting a little too quick.
Start-Sleep -Seconds 30

#Disable Firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False



}