Configuration NpsServer
{
    ### Import the necessary modules
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node localhost
    {
       WindowsFeature 'InstallNPS'
       {
           Name = 'NPAS'
           Ensure = 'Present'
           IncludeAllSubFeature = $true
       } 

    }


}

NpsServer