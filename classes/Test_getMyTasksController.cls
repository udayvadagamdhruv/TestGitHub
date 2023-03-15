@isTest
public class Test_getMyTasksController { 
    static testMethod void Test_getMyTasksController (){
      /*  Profile p=[Select Id from Profile where Name=: 'System Administrator'];
          
          User u=[Select Id,Name,Email from User where IsActive=: True and ProfileId=: p.Id LIMIT 1];
          
          System.runAs(u)
          {

            Job_Number_Setting__c customSetting810 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting810;
          
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 810');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 810',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 810',Schedule_Template__c=testST.Id);
                insert testScheduleTask1;

          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 810');
                insert testSpec;
                
          Job__c testJob1=new Job__c( Job_Auto_Number__c = '111',Status__c = 'Active',Name='Test Job 111',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                 insert testJob1;
          
          System.assertEquals('Test Job 111',testJob1.Name);
                 
          Job_Task__c testJT1=new Job_Task__c(Name='Test Job Task 8100',Job__c=testJob1.Id,Marked_Done__c=False, Days__c=1,Revised_Due_Date__c=System.today()+1);
             insert testJT1; 
             
          Job_Task__c testJT3=new Job_Task__c(Name='Test Job Task 8107',Job__c=testJob1.Id,Marked_Done__c=True, Days__c=1,Revised_Due_Date__c=System.today()+1);
             insert testJT3;
             
          Job_Task__c testJT4=new Job_Task__c(Name='Test Job Task 8101',Job__c=testJob1.Id,Marked_Done__c=False, Days__c=1,Revised_Due_Date__c=System.today()+1);
             insert testJT4;       
         
         Job_Task__c testJT2=new Job_Task__c(Name='Test Job Task 8110',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=1,Revised_Due_Date__c=System.today()+1);
            insert testJT2;
            
         Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT1.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR1;  
         
         Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT2.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR2;  
          
         Job_Task_Role__c testJTR3=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT3.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR3;
          Job_Task_Role__c testJTR4=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT4.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR4;   
              
            
         System.assertEquals('Test Designer',testJTR1.Name);   
         
         
        // Instantiate the extention instance with the custom controller 
          getMyTasksController ext=new getMyTasksController();
          ext.getSortDirection();
          ext.setSortDirection('ASC');
          ext.strJTID=testJT1.id;
          ext.getlstJTR();
          ext.getViewData();
              ext.TsEntry();
              ext.beginning();
              ext.previous();
              ext.next();
              ext.end();
              ext.getnxt();
              ext.getprev();
          //ext.sortDirection='ASC';
           string str;
          list<Job_Task_Role__c> lst;
          //taskWrapper twrap = new taskWrapper();
          // Invoke the primary method on the extension
          
          ApexPages.Pagereference result1=ext.assignMarkedDone1();
          ext.strJTID=testJT2.id;
          ApexPages.Pagereference result2=ext.assignMarkedDone1();
          }*/
    }
}