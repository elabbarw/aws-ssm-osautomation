Configuration Genesis
{

    ### Import the necessary modules
    Import-DscResource -Module PsDesiredStateConfiguration
    Import-DscResource -Module ComputerManagementDsc

    Node localhost
    {
        $testvalue = "{tagssm:TESTDCPWD}"
        
        ### Join the domain with the name taken from the Name tag and set the description of the VM to match the Purpose tag
        Computer Rename {
            Name = '{tagssm:Name}'
            Description = '{tagssm:Purpose}'
        }
        ### Set system locale
        SystemLocale SetLocale {
            IsSingleInstance = 'Yes'
            SystemLocale     = 'en-GB'
        }



    }


}

Genesis