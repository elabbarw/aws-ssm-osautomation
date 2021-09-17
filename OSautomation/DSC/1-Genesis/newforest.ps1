
Configuration Genesis_newForest
{
    ### Import the necessary modules
    Import-DscResource -Module PsDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDsc -ModuleVersion 8.5.0

    Node localhost
    {
        ### Join the domain with the name taken from the Name tag and set the description of the VM to match the Purpose tag
        Computer Rename {
            Name = '{ssmtag:Name}'
            Description = '{ssmtag:Purpose}'
        }
        PendingReboot RebootAfterDomainJoin
        {
            Name = 'DomainJoin'
        }
        ### Set system locale
        SystemLocale SetLocale {
            IsSingleInstance = 'Yes'
            SystemLocale     = 'en-GB'
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



Genesis_newForest -ConfigurationData $cd
