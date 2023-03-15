@isTest
Public class TestinsertJobSpec{

    /*    static testMethod void TestinsertJobSpec()
          {
              Job_Number_Setting__c customSetting305 = new  Job_Number_Setting__c(Name= 'yy');

                insert customSetting305;
            
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 305');
              insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 305',Media_Types__c=testMedia.Id);
              insert testST;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 305');
              insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 305',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
              insert testJob1;
                 
              System.assertEquals('Test Job 305',testJob1.Name);   
                 
              Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 306',Job__c=testJob1.Id);
         
               
              ApexPages.currentPage().getParameters().put('jobId',testJob1.Id); 
              
              // Instantiate the standard controller with the Job    
                   ApexPages.StandardController con=new ApexPages.StandardController(testJobSpec);
        
              // Instantiate the extention instance with the standard controller 
                   extension_JobSpec ext=new extension_JobSpec(con);
        
              // Invoke the primary method on the extension 
                   ApexPages.PageReference result=ext.saveme();    
                   result=ext.cancelme(); 
                    
                      
              Job_Spec__c testJobSpec1=new Job_Spec__c(Name='Job Spec 306',Job__c=testJob1.Id);
              
                // Instantiate the standard controller with the Job  Spec  
              ApexPages.StandardController con1=new ApexPages.StandardController(testJobSpec1);
              
              // Instantiate the extention instance with the standard controller 
              
              extension_JobSpec ext1=new extension_JobSpec(con1);
              
              // Invoke the primary method on the extension 
              
              try
               {      
                ApexPages.PageReference result3=ext1.saveme();    
               }
              catch(System.DMLException e)
               {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
         
          }

*/

}