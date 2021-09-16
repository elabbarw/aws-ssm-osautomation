Configuration PrintServer
{
    ### Import the necessary modules
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node localhost
    {
       WindowsFeature 'InstallPrint'
       {
           Name = 'Print-Server'
           Ensure = 'Present'
           IncludeAllSubFeature = $true
       } 

    }


}
PrintServer