Configuration NewForest
{
    ### AD Credentials from AWS SSM Parameters ###
    $domain   = "{ssmtag:domainName}"
    $username = "{ssmtag:domainJoinUsername}"
    $password = "{ssmtag:domainJoinPassword}" | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object PSCredential($username, $password)


    ### Import the necessary modules
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName ActiveDirectoryDsc -ModuleVersion 6.0.1

    node 'localhost'
    {
        WindowsFeature 'ADDS'
        {
            Name   = 'AD-Domain-Services'
            Ensure = 'Present'
        }

        WindowsFeature 'RSAT'
        {
            Name   = 'RSAT-AD-PowerShell'
            Ensure = 'Present'
        }

        ADDomain $domain
        {
            DomainName                    = $domain
            Credential                    = $credential
            SafemodeAdministratorPassword = $credential
            ForestMode                    = 'WinThreshold'
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


NewForest -ConfigurationData $cd

    