@isTest
public class Test_EditJobSpec
{

/*     static testMethod void Test_EditJobSpec()
     {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 625');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 625',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Specification Template 625');
                insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 625',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                 insert testJob1;
                 
          Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 625',Job__c=testJob1.Id);
          
                  insert testJobSpec;
         
          System.assertEquals('Job Spec 625',testJobSpec.Name);
    
            // Instantiate the standard controller with the Job Spec
          ApexPages.StandardController con=new ApexPages.StandardController(testJobSpec);
        
            // Instantiate the extention instance with the standardcontroller
          EditJobSpecExtension ext1=new EditJobSpecExtension(con);
        
           // Invoke the primary method on the extension 
          ApexPages.PageReference result=ext1.saveme();    
          result=ext1.cancelme();   
        
            // To cover catch block in save method
          delete testJobSpec;
          result=ext1.saveme();  
         
       /*  DeleteJobSpecExtension ext12=new DeleteJobSpecExtension(con);
         ext12.objJobSpec = testJobSpec;
         ext12.checkDelete();
         }*/
    // End of Test Coverage

}