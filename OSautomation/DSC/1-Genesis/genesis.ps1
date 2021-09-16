Configuration Genesis
{
    ### AD Credentials from AWS SSM Parameters ###
    $domain = "{ssmtag:domainname}"
    $username = "{ssmtag:domainusername}"
    $password = "{ssmtag:domainpassword}"
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    ### Import the necessary modules
    Import-DscResource -Module PsDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDsc -ModuleVersion 8.5.0

    Node localhost
    {
        ### Join the domain with the name taken from the Name tag and set the description of the VM to match the Purpose tag
        Computer RenameAndJoin {
            Name = '{ssmtag:Name}'
            DomainName = $domain
            Description = '{ssmtag:Purpose}'
            Credential = $credential
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
Genesis