// This class is used as extension for inseting Music Usage record
// This class is used as extension for page : CreateNewMusicUsage
public with sharing class CreateNewMusicUsage {
/*
    // Global variables
    
    public String jobId{get;set;}
    public String jobName{get;set;}
    private final Music_Usage__c objMU;

    // End of Global variables
    
    // Start constructor
    public CreateNewMusicUsage(ApexPages.StandardController controller) 
    {
        this.objMU = (Music_Usage__c)controller.getRecord(); 
        jobId=ApexPages.CurrentPage().getParameters().get('jobId');
        objMU.Job__c = jobId;
    }
    // End of constructor
    
    // This method is called on to handle Save button
    public pagereference save()
    {
        try
        {
            insert objMU; 
        }
        catch(Exception e)
        {
            return NULL;    
        } 
        Pagereference p=new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=12');
        p.setRedirect(true);
        return(p);
    }
    // End of method Save
    
    // This method is called on to handle Cancel button
    public pagereference cancel()
    {
        Pagereference p=new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=12');
        p.setRedirect(true);
        return p;
    }
    // End of method Cancel
    
    // Start Test method
    static testMethod void Test_CreateNewMusicUsage()
    {
        Job_Number_Setting__c customSetting351 = new  Job_Number_Setting__c(Name= 'yy');
                insert customSetting351;
            
        Media_Type__c testMedia1=new Media_Type__c(Name='Test Media 3519');
                insert testMedia1;
             
        Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 3519',Media_Types__c=testMedia1.Id);
                insert testST1;
                 
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 3519');
                insert testSpec1;
                
        Job__c testJob1=new Job__c(Name='Test Job 3519',Flag__c=True, Job_Auto_Number__c='Job 3519',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
                insert testJob1;
                 
        System.assertEquals('Test Job 3519',testJob1.Name);        
         
        Music_Usage__c testMU1=new Music_Usage__c(
                                    Name='Test MU 3519',
                                    Job__c = testJob1.Id,
                                    Music_Usage_Promo_Length__c = 'Test Promo Length', 
                                    Music_Usage_Track__c = 'Test Track', 
                                    Music_Usage_Track_Info__c = 'Test Track Info',
                                    Music_Usage_Drop__c = 'Test Drop',
                                    Music_Usage_Start_Date__c = System.Today(),
                                    Music_Usage_End_Date__c = System.Today() + 5 );   
                
        
        ApexPages.currentPage().getParameters().put('jobId',testJob1.id);
        
        // Instantiate the standard controller with Music Usage
        ApexPages.StandardController con= new ApexPages.StandardController(testMU1);
        
        // Instantiate the extension instance with the standard controller
       CreateNewMusicUsage ext= new CreateNewMusicUsage(con);
        
        // Invoke the primary methods on extension
        ApexPages.Pagereference result=ext.save();
        
        result = ext.cancel();    
        
        delete testMU1; // To cover catch block inside save method
        
        result = ext.save();
    }*/
    // End of Test method

}// End of class