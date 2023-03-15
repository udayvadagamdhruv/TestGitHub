@isTest
public class TestTaskRoleStaffSectionExtension{ 
    static testMethod void TestTaskRoleStaffSectionExtensiong()
        {
          /*   Media_Type__c testMedia=new Media_Type__c(Name='Test Media 614');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 614',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
            Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 914',Schedule_Template__c=testST.id,Days__c=3);
                insert testSchedule1;
                
            Schedule_Task__c testSchedule2=new Schedule_Task__C(Name='Test Schedule Task 915',Schedule_Template__c=testST.id,Days__c=3);
                insert testSchedule2;
                
            ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Test Role 001',Schedule_Task__c=testSchedule1.id);
                insert testSTR1;
                
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 614');
                insert testSpec;
                
            Job__c testJob1=new Job__c(Name='Test Job 614',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='Start Date');
         
                 insert testJob1;
                 
             System.assertEquals('Test Job 614',testJob1.Name);
                 
            Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 615',Job__c=testJob1.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 1);
        
                insert testJobTask1;
             list<Job_Task__c> Jobtasklist=new list<Job_Task__c>();
        
             Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 616',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 2);
        
               Jobtasklist.add(testJobTask2);
        
            Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3);
        
                
                Jobtasklist.add(testJobTask3);
            insert Jobtasklist;    
                
            Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Job Task Role 615',Job_Task__c=testJobTask1.Id);
        
                insert testJTR1;
                
             ApexPages.currentPage().getParameters().put('Id', testJobTask1.Id);
         
           // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJobTask1);
        
           // Instantiate the extention instance with the standardcontroller 
               TaskRoleStaffSectionExtension ext=new TaskRoleStaffSectionExtension(con);
        
              ApexPages.PageReference result1=ext.AddStaffs();*/
                    
    }// End of Test method JobTeam Test 
    
}// End of Test Coverage