@isTest
public class Test_JobsListViewHome{ 
    static testMethod void Test_JobsListViewHome()
        
       {
       /* Profile p=[Select Id from Profile where Name=: 'System Administrator'];
          
          User u=[Select Id,Name from User where IsActive=: True and ProfileId=: p.Id LIMIT 1];
          
          System.runAs(u)
          {
            
          
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 810');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 810',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 810',Schedule_Template__c=testST.Id);
                insert testScheduleTask1;

          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 810');
                insert testSpec;
                
          Job__c testJob1=new Job__c(Job_Auto_Number__c='810',Name='Test Job 810',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c = 'Active');
         
                 insert testJob1;
         Job__c testJob2=new Job__c(Job_Auto_Number__c='819',Name='Test Job 810111',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c = 'Active');
 
         insert testJob2;
         Job__c testJob3=new Job__c(Job_Auto_Number__c='854',Name='Test Job 81440111',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c = 'Active');
 
         insert testJob3;
  
  
          System.assertEquals('Test Job 810',testJob1.Name);
                 
          Job_Task__c testJT1=new Job_Task__c(Name='Test Job Task 8100',Job__c=testJob1.Id,Marked_Done__c=True, Days__c=1,Revised_Due_Date__c=system.today());
             insert testJT1;        
         
         Job_Task__c testJT2=new Job_Task__c(Name='Test Job Task 812310',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=1,Revised_Due_Date__c=system.today());
            insert testJT2;
         Job_Task__c testJT3=new Job_Task__c(Name='Test Job Task 8123311',Job__c=testJob2.Id,Marked_Done__c=False,Days__c=1,Revised_Due_Date__c=system.today());
            insert testJT3;
         Job_Task__c testJT4=new Job_Task__c(Name='Test Job Task 8132311',Job__c=testJob2.Id,Marked_Done__c=False,Days__c=1,Revised_Due_Date__c=system.today());
            insert testJT4;
            
            string userName = UserInfo.getUserName();
            
            
         Job_Team__c  objTeam = new Job_Team__c(Job__c=testJob1.Id,Task__c='Test Job Task 812310',Role__c= 'tset',Staff__c=u.Name);
         insert objTeam;
         
         
         
        // Job_Team__c  objTeam1 = new Job_Team__c(Job__c=testJob1.Id,Task__c=testJT3.id,Role__c= 'tset',Staff__c=u.Name);
       //  insert objTeam1;
         //System.assertEquals()
       
       JobsListViewHome js = new JobsListViewHome();
               js.getjobStatuslist();
                js.test1();
       js.userName = UserInfo.getUserName();//'shashi reddy';
       //js.SortDirection = 'ASC';
       //js.getjobStatuslist();
       js.getSortDirection();
       js.setSortDirection('jobName');
       jobsWrapper wrp = new jobsWrapper();
              
       
       
       //wpr.objjobTasks = testJT3;
        
       }*/
       
  }
        
        

}