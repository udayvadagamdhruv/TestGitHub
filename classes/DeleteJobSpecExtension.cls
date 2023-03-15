// This class is used to Delete Job Spec
public with sharing class DeleteJobSpecExtension 
{

       public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    
     public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
        
      // Global variables 
      public  boolean isError{get;set;}
      public Id JobId;
    public Job_Spec__c objJobSpec{get;set;} 
      // End of Global variables
      
      // Standard Controller Constructor
      public DeleteJobSpecExtension(ApexPages.StandardController controller) 
       {   
           String errors;
           Boolean Error;
           List<Job_Spec__c> sps = new list<Job_Spec__c>();
        isError = false; 
           boolean isL = isLtng;
           boolean is = isMob;
         this.objJobSpec=(Job_Spec__c)controller.getrecord();
          JobId = [Select Id, Job__c from Job_Spec__c where Id =:objJobSpec.Id limit 1].Job__c;
       }
      // End of Standard Controller Constructor 

      // Method called on to delete Job Spec Item 
      public PageReference checkDelete()
      {
         try
         {
             Database.delete(objJobSpec);        
         }
         catch(System.DMLException e)
         {
             isError = true;
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); 
             return null;
         }
         
           PageReference p;
            if(isMob)
            {
               p = new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=CreativeBrief');
                
            }
            
            else if(isLtng)
            {
                 p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');
                 
            }
            else
            {
                  p =new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=3');
                  
            }
                p.setRedirect(true);
                return p; 
       }
      // End of checkDelete Method 
     
     /* // Test Coverage Code
     static testMethod void deleteJobSpec()
      {
             
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 329');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 329',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 329');
               insert testSpec;
                
           Job__c testJob1=new Job__c(Job_Auto_Number__c='329',Flag__c=True,Name='Test Job 329',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               insert testJob1;
       
           System.assertEquals('Test Job 329',testjob1.Name);
                 
           Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 329',Job__c=testJob1.Id);
               insert testJobSpec;
                 
           // Test Duplicate JobSpec for any Job
           Job_Spec__c testJobSpec1=new Job_Spec__c(Name='Job Spec 329',Job__c=testJob1.Id);
            try
             {
                 insert testJobSpec1;
             }
             catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
             }
        
           Job_Spec__c testJobSpec2=new Job_Spec__c(Name='Job Spec 629',Job__c=testJob1.Id);
               insert testJobSpec2; 
               testJobSpec2.Name='Job Spec 329'; 
                try
                {
                     update testJobSpec2;
                }
                catch(System.DMLException e)
                {
                     System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
                } 
               // End Duplicate Job Spec
                 
           // Instantiate the standard controller with the Job 
        ApexPages.currentPage().getParameters().put('Id',testJobSpec.Id);
        ApexPages.StandardController con=new ApexPages.StandardController(testJobSpec);
        
        // Instantiate the extention instance with the standardcontroller 
        DeleteJobSpecExtension ext=new DeleteJobSpecExtension(con);
        
        // Invoke the primary method on the extension 
        ApexPages.PageReference result=ext.checkDelete();
        
        // Below code covers the Catch statement 
        result=ext.checkDelete();       
      }
    // ENd of Test Method*/
}
// End of Apex class