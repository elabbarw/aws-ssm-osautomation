Configuration DomainController
{
    ### AD Credentials from AWS SSM Parameters ###
    $domain   = "{ssm:domainName}"
    ### The PSCredential object in AWS SSM uses the username as the secret/param id so it can look up the values, the password in the object is not important in this case
    $credential = New-Object PSCredential("domaincreds", (ConvertTo-SecureString "DoesntMatter" -AsPlainText -Force))

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

    