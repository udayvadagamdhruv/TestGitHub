// This class is used to Delete Tag associated with Job
public with sharing class DeleteTagExtension 
{
  // Global variables
  /*
       public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     } 
  
      public Id JobId;
      private final Tag__c objTag; 
   // End Global variables
   
   // Start Constructor   
    public DeleteTagExtension(ApexPages.StandardController controller) 
    {
       this.objTag=(Tag__c)controller.getrecord();
       JobId = [Select Id, Job__c from Tag__c where Id =:objTag.Id limit 1].Job__c;
    }
    // End Constructor
    
    // Method called on to delete Tag record
     public PageReference checkDelete()
     {
        try
        {
            if(Tag__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objTag); 
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
        
        PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
        }
        else
        {
             p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
        }
        
        
      //  PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
        p.setRedirect(true);
        return p;
     }
     // End Delete Method
     
      // Start Test Coverage 
       
    static testMethod void Test_DeleteTagExtension()
      {
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 371');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 371',Media_Types__c=testMedia.Id);
             
                 insert testST;
     
            Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 371');
                insert testSpec;
    
            Job__c testJob1=new Job__c(Name='Test Job 371',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
               Tag__c testTag=new Tag__c(Name='Test Tag 371',Job__c=testJob1.Id);
               insert testTag;
               
               System.assertEquals('Test Tag 371',testTag.Name);
               
             // Instantiate the standard controller with the Tag
            ApexPages.StandardController con=new ApexPages.StandardController(testTag);
        
            // Instantiate the extention instance with the standardcontroller
            DeleteTagExtension ext=new DeleteTagExtension(con);
        
            // Invoke the primary method on the extension
            ApexPages.PageReference result=ext.checkDelete();
            
            // To cover Catch block
            result=ext.checkDelete();
      }
    // End Test Coverage*/
}// End of Class