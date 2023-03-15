@isTest
public class TestdeleteJobSpec
{
/*
          // Test Coverage Code
     static testMethod void TestdeleteJobSpec()
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
    // ENd of Test Method
*/
}