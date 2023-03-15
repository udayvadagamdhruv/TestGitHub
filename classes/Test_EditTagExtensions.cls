@isTest
Public Class Test_EditTagExtensions{
 /*
 static testMethod void Test_EditTagExtensions()
     {
               Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

               insert customSetting001;
               
              Media_Type__c testMedia = new Media_Type__c(Name='Test Media 622');
              insert testMedia;
             
              Schedule_Template__c testST = new Schedule_Template__c(Name='Test Schedule Template 622',Media_Types__c=testMedia.Id);
              insert testST;
                 
              Specification_Template__c testSpec = new Specification_Template__c(Name='Testing Spcification Template 622');
              insert testSpec;
                
              Job__c testJob1 = new Job__c(Name='Test Job 622',Flag__c = True, Job_Auto_Number__c='Job 622', Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
                {
                   insert testJob1;
                }
               catch(System.DMLException e)
                {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' ,e.getDmlStatusCode(0));
                }
              System.assertEquals('Test Job 622',testJob1.Name); 
               
              Tag__c testTag = new Tag__c(Name='Test Tag 622',Job__c=testJob1.Id);
                  insert testTag;
              
        // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.StandardController(testTag);
        
        // Instantiate the extention instance with the standardcontroller
           EditTagExtensions ext=new EditTagExtensions(con);
        
        // Invoke the primary method on the extension 
           ApexPages.PageReference result=ext.saveme();
           ApexPages.PageReference result1=ext.cancelme();
         
           // To cover catch block  
           delete testTag;
           result=ext.saveme();
    }*/
    
    }