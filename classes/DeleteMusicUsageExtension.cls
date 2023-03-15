// This class is used as Extension to delete Music Usage record
public with sharing class DeleteMusicUsageExtension {
   
     /*   // Global variables
        
            public Id jobId{get;set;}
            public boolean isError {get;set;}
            private final Music_Usage__c objMU;
            
        // End of Global variables
   
    
    // Start constructor
    public DeleteMusicUsageExtension(ApexPages.StandardController con)
    {
        isError = false;
        this.objMU = (Music_Usage__c)con.getRecord();
        jobId = [Select Id,Job__c from Music_Usage__c where Id =: objMU.Id Limit 1].Job__c;
    }
    // End of constructor
    
    
    // This method is called on to delete Music Usage
    public pagereference checkDelete()
    {
        try
        {
            if(Music_Usage__c.sObjectType.getDescribe().isDeletable()){
                Database.Delete(objMU);
            }
        }
        catch(Exception e)
        {
            isError=True;   
            return NULL;
        }   
        // Navigate to Music Usage Tab
        Pagereference p = new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=12');
        p.setRedirect(true);
        return(p);
    }
    // End of method checkDelete
        
    // Start Test Coverage  
     static testMethod void Test_DeleteMusicUsageExtension()
      {
            
            test.startTest(); // Start Test Method
            
            Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting001;
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 3718');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 3718',Media_Types__c=testMedia.Id);
             
                 insert testST;
     
            Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 3718');
                insert testSpec;
    
            Job__c testJob1=new Job__c(Name='Test Job 3718',Flag__c=True, Job_Auto_Number__c='Job 3718',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
               Music_Usage__c testMusic=new Music_Usage__c(Name='Test Music 3718',Job__c=testJob1.Id);
               insert testMusic;
               
               System.assertEquals('Test Music 3718',testMusic.Name);
               
             // Instantiate the standard controller with the Music Usage
            ApexPages.StandardController con=new ApexPages.StandardController(testMusic);
        
            // Instantiate the extention instance with the standardcontroller
            DeleteMusicUsageExtension ext=new DeleteMusicUsageExtension(con);
        
            // Invoke the primary method on the extension
            ApexPages.PageReference result=ext.checkDelete();
            
            // To cover Catch block
            result=ext.checkDelete();
            
            test.stopTest(); // Stop Test Method
      }*/
    // End of Test Coverage
}// End of Class