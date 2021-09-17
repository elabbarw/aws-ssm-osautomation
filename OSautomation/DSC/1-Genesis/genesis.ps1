
Configuration Genesis
{
    ### AD Credentials from AWS SSM Parameters ###
    $domain   = "{ssm:domainName}"
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
        
        ### Join the domain with the name taken from the Name tag and set the description of the VM to match the Purpose tag
        Computer RenameAndJoin {
            Name = '{tag:Name}'
            DomainName = $domain
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
