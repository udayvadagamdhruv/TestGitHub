// This class is used to Delete Session associated with Job
public with sharing class DeleteSessionExtension 
{/*
  // Global variables
      public Id JobId;
      private final Session__c objSession; 
      public Boolean isError{get;set;}
   // End Global variables
   
   // Start Constructor   
    public DeleteSessionExtension(ApexPages.StandardController controller) 
    {
       isError = False;
       this.objSession=(Session__c)controller.getrecord();
       JobId = [Select Id, Job__c from Session__c where Id =:objSession.Id limit 1].Job__c;
    }
    // End Constructor
    
    // Method called on to delete Session record
     public PageReference checkDelete()
     {
        try
        {
            if(Session__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objSession);  
            }
        }
        catch(System.DMLException e)
        {
            isError = True;
            return null;
        }
        PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=10');
        p.setRedirect(true);
        return p;
     }
     // End Delete Method
     
      // Start Test Coverage 
       
    static testMethod void Test_DeleteTagExtension()
      {
            Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
    
            insert customSetting001; 
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 9998');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 9998',Media_Types__c=testMedia.Id);
             
                 insert testST;
     
            Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 9998');
                insert testSpec;
    
            Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='Job12349',Name='TJ-Developer9998',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
               
               Session__c testSession=new Session__c(Name='TestSession 9998',Job__c=testJob1.Id);
               insert testSession;
               
               System.assertEquals('TestSession 9998',testSession.Name);
               
             // Instantiate the standard controller with the Session
            ApexPages.StandardController con=new ApexPages.StandardController(testSession);
        
            // Instantiate the extention instance with the standardcontroller
            DeleteSessionExtension ext=new DeleteSessionExtension(con);
        
            // Invoke the primary method on the extension
            ApexPages.PageReference result=ext.checkDelete();
            
            // To cover Catch block
            result=ext.checkDelete();
      }*/
    // End Test Coverage
}// End of Class