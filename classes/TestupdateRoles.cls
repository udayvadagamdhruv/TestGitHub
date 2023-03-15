@isTest
Public class TestupdateRoles{
 static TestMethod void TestupdateRoles(){
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
             
        insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 50',Media_Types__c=testMedia.Id);
             
        insert testST;
                 
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 50');
        insert testSpec;
               
        Job__c testJob1=new Job__c(Name='Test Job 10',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
        insert testJob1;
                 
       System.assertEquals('Test Job 10',testJob1.Name);     
       
       Schedule_Task__c testScheduleTask=new Schedule_Task__c (Name='Schedule Task 10',Schedule_Template__c=testST.Id,roles__c='Manager');
         
       insert testScheduleTask;
       
       ScheduleTaskRole__c testScheduleTaskRole=new ScheduleTaskRole__c (Schedule_Task__c =testScheduleTask.Id,Name='Design Manager');
       insert testScheduleTaskRole;
       ScheduleTaskRole__c testScheduleTaskRole1=new ScheduleTaskRole__c (Schedule_Task__c =testScheduleTask.Id,Name='Design Manager demo');
       insert testScheduleTaskRole1;
       
      testScheduleTaskRole = [SELECT id,name FROM ScheduleTaskRole__c  WHERE Id =:testScheduleTaskRole.Id];
       testScheduleTaskRole.name='test';
       update testScheduleTaskRole;
       
       delete testScheduleTaskRole1;
             
  }           
}