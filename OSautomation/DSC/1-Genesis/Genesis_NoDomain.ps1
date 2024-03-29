
Configuration Genesis_NoDomain
{
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
        Computer Rename {
            Name = '{tag:Name}'
            Description = '{tag:Purpose}'
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



Genesis_NoDomain -ConfigurationData $cd
