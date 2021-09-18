Configuration NpsServer
{
    ### Import the necessary modules
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node localhost
    {
        WindowsFeature NPASPolicyServerInstall
        {
            Ensure = "Present"
            Name = "NPAS-Policy-Server"
        }

        WindowsFeature NPASHealthInstall
        {
            Ensure = "Present"
            Name = "NPAS-Health"
            DependsOn = "[WindowsFeature]NPASPolicyServerInstall"
        }

        WindowsFeature RSATNPAS
        {
            Ensure = "Present"
            Name = "RSAT-NPAS"
            DependsOn = "[WindowsFeature]NPASPolicyServerInstall"
        }

        WindowsFeature RSATDFSMgmtConInstall
        {
            Ensure = "Present"
            Name = "RSAT-DFS-Mgmt-Con"
            DependsOn = "[WindowsFeature]RSATNPAS"
        }

    }


}

NpsServer