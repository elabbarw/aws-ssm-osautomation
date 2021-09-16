Configuration DomainController
{
    ### AD Credentials from AWS SSM Parameters ###
    $domain = "{ssmtag:domainname}"
    $username = "{ssmtag:domainusername}"
    $password = "{ssmtag:domainpassword}" | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object PSCredential($username, $password)

    ### Import the necessary modules
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName ActiveDirectoryDsc -ModuleVersion 6.0.1

    Node localhost
    {
        WindowsFeature 'InstallADDomainServicesFeature'
        {
            Ensure = 'Present'
            Name   = 'AD-Domain-Services'
        }

        WindowsFeature 'RSATADPowerShell'
        {
            Ensure    = 'Present'
            Name      = 'RSAT-AD-PowerShell'

            DependsOn = '[WindowsFeature]InstallADDomainServicesFeature'
        }

        WaitForADDomain 'WaitForestAvailability'
        {
            DomainName = $domain
            Credential = $credential

            DependsOn  = '[WindowsFeature]RSATADPowerShell'
        }

        ADDomainController 'DomainControllerUsingExistingDNSServer'
        {
            DomainName                    = $domain
            Credential                    = $credential
            SafeModeAdministratorPassword = $credential
            InstallDns                    = $false

            DependsOn                     = '[WaitForADDomain]WaitForestAvailability'
        }
    }

    }

    $cd = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}


DomainController -ConfigurationData $cd

    