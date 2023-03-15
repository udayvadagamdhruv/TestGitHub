@isTest
Public Class TestDisplayTsEntriesunderjobtabext{
 // Start Test Coverage Code 
      static testMethod void TestDisplayTsEntriesunderjobtabext()
      {/*
           DisplayTimesheetEntriesunderjobtabext ext=new DisplayTimesheetEntriesunderjobtabext();
           
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 313');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 313',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 314',Media_Types__c=testMedia.Id);
               insert testST1;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 313');
               insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 314');
               insert testSpec1;
           
           Job__c testJob1=new Job__c(Name='Test Job 314',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           Timesheet_Entries__c testClient=new Timesheet_Entries__c (Job__c=testJob1.id);
           insert testClient;  
          
           
           
           System.assertEquals('Test Job 314',testJob1.Name);  
           
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
            
           // Instantiate the extention instance with the Custom Controller
           
           DisplayTimesheetEntriesunderjobtabext ext1=new DisplayTimesheetEntriesunderjobtabext();
          //ext1.OffsetSize = 2;
          //ext1.LimitSize = 1;
           ext1.ciid= testClient.Id;
           ext1.CreateTsEntry();
           ext1.save(); // Invoke the Save and Cancel method on the extension
           ext1.cancelme();
           ext1.del();
           ext1.getSumhrs();
          ext1.FirstPage();
          ext1.next();
          ext1.previous();
          ext1.LastPage();
          ext1.getnxt();
          ext1.getprev();*/
    } 
 // End of test Method


}