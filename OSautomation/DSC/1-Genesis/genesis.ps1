
Configuration Genesis
{
    ### AD Credentials from AWS SSM Parameters ###
    $domain   = "{ssm:domainName}"

    ### The PSCredential object in AWS SSM uses the username as the secret/param id so it can look up the values, the password in the object is not important in this case
    $credential = New-Object PSCredential("domaincreds", (ConvertTo-SecureString "DoesntMatter" -AsPlainText -Force))



    ### Import the necessary modules
    Import-DscResource -Module PsDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDsc -ModuleVersion 8.5.0

    Node localhost
    {
        ### Set system locale
        SystemLocale SetLocale {
            IsSingleInstance = 'Yes'
            SystemLocale     = 'en-GB'
        }

        # Wait for the Domain to be available so we can join it.
        WaitForAll DC
        {
        ResourceName      = '[xADDomain]PrimaryDC'
        NodeName          = $domain
        RetryIntervalSec  = 15
        RetryCount        = 60
        }
        
        
        ### Join the domain with the name taken from the Name tag and set the description of the VM to match the Purpose tag
        Computer RenameAndJoin {
            DependsOn = "[WaitForAll]DC"
            Name = '{tag:Name}'
            DomainName = $domain
            JoinOU = 'OU=Servers,OU=Corporate,DC=Gamesys,DC=Corp'
            Description = '{tag:Purpose}'
            Credential = $credential
        }
        PendingReboot RebootAfterDomainJoin
        {
            Name = 'DomainJoin'
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



Genesis -ConfigurationData $cd
