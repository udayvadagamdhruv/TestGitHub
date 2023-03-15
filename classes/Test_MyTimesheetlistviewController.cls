@istest
public class Test_MyTimesheetlistviewController{
    // Start Test Coverage Code 
      static testMethod void Test_MyTimesheetlistviewController()
      {
         /*   Profile p=[Select Id from Profile where Name=: 'System Administrator'];
          
          User u=[Select Id,Name from User where IsActive=: True and ProfileId=: p.Id LIMIT 1];
          
          System.runAs(u)
          {
          
           
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
          		
          //    System.assertEquals('Test Job 314',testJob1.id);   
              
               PageReference myVfPage = Page.MyTimesheetlistview;
                  Test.setCurrentPage(myVfPage);
                  ApexPAges.StandardController sc = new ApexPages.StandardController(testClient);
              
              
              MyTimesheetlistviewController ctrl = new MyTimesheetlistviewController(sc);
              ctrl.NewMethod();
              ctrl.getTsEnty();
              ctrl.beginning();
              ctrl.previous();
              ctrl.next();
              ctrl.end();
              ctrl.getnxt();
              ctrl.getprev();
                 
              
          } */
    } 
 // End of test Method

}