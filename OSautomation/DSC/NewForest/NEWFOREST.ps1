Configuration NewForest
{
    ### AD Credentials from AWS SSM Parameters ###
    $domain   = "{ssm:domainName}"
    $credential = New-Object PSCredential("domaincreds", (ConvertTo-SecureString "DoesntMatter" -AsPlainText -Force))



    ### Import the necessary modules
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName ActiveDirectoryDsc -ModuleVersion 6.0.1
    Import-DscResource -ModuleName ComputerManagementDsc
    node "localhost"
    {
        WindowsFeature "ADDS"
        {
            Name   = "AD-Domain-Services"
            Ensure = "Present"
        }

        WindowsFeature "RSAT"
        {
            Name   = "RSAT-AD-PowerShell"
            Ensure = "Present"
        }

        ADDomain $domain
        {
            DomainName                    = $domain
            Credential                    = $credential
            SafemodeAdministratorPassword = $credential
            ForestMode                    = "WinThreshold"
        }

        PendingReboot RebootAfterForest
        {
            Name = "ForestCreation"
        }
    }
}


    $cd = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}


NewForest -ConfigurationData $cd

    