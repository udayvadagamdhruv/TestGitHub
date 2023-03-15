@isTest
public class testcalendarCmpController {
    @testSetup static void SetupMethod() {
        
        Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');
        insert customSetting1;
        
        Campaign__c testCamp=new Campaign__c(Name='Camp');
        insert testCamp;
        
        Client__c c=new Client__c(name='test client');
        insert c;
        
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 614');
        insert testMedia;
        
        Holiday__c hh=new Holiday__c(Name='August-15',Date__c=System.today()+10);
        insert hh;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 614',Media_Types__c=testMedia.Id);
        insert testST;
        
        Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 914',Schedule_Template__c=testST.id,Days__c=3);
        insert testSchedule1;
        
        Schedule_Task__c testSchedule2=new Schedule_Task__C(Name='Test Schedule Task 915',Schedule_Template__c=testST.id,Days__c=3);
        insert testSchedule2;
        
        ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Designer',Schedule_Task__c=testSchedule1.id);
        insert testSTR1;
        
        Job__c testJob2=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Status__c='Active',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Schedule_Calc__c='End Date');
        insert testJob2;
        
        Job_Team__c jteam22 = new Job_Team__c(staff__c='manikanta', Role__c='Designer', email__c='test1@test.com', job__c=testJob2.id);  
        insert jteam22;
        
        List<SObject> selectedrecs=new List<SObject>{testJob2};
            
            System.assertEquals('Test Job 615',testJob2.Name);
        
        Job_Task__c testJobTask4=new Job_Task__c(Name='Job Task 617',Schedule_Roles__c='Designer;Project Manager',Job__c=testJob2.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 4,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert testJobTask4;
        
        
        Job_Task__c testJobTask8=new Job_Task__c(Name='Job Task 6188',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3,Task_Order__c = 4,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert testJobTask8;
        
        Job_Task__c testJobTask5=new Job_Task__c(Name='Job Task 619',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False, Task_Order__c = 5,Days__c=3,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert testJobTask5;
        
        Job_Task__c testJobTask6=new Job_Task__c(Name='Job Task 618',Job__c=testJob2.Id,Start_Date__c=System.Today(), Task_Order__c = 6,Days__c=3,Marked_Done__c=false,Revised_Due_Date__c=System.Today(),Email__C='mani@gmail.com,sugu@gmail.com' );
        insert testJobTask6;
        
        Job_Task__c testJobTask7=new Job_Task__c(Name='Job Task 6191',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Task_Order__c = 7,Days__c=3,Revised_Due_Date__c=System.Today()+1,Email__C='mani@gmail.com,sugu@gmail.com');
        insert testJobTask7;
        
        Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask6.Id,Email__c='mani@gmail.com');
        insert testJTR2;
        
        Job_Team__c jteam = new Job_Team__c(staff__c='test', role__c='test', email__c='test@test.com', job__c=testJob2.id);  
        insert jteam;
        
        Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
        insert testStaff1;
        
        Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Project Manager',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
        insert testStaff2;
        
        Staff__c testStaff3=new Staff__c(First_Name__c='Sugunakar',Name='Sugunakar Routhu', Last_Name__c='Routhu',Role__c='Art Director',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
        insert testStaff3;
        
        Client_Contact__c  testcc1=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLasNam1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff176@gmail.com');
        insert testcc1;
        
        Client_Contact__c  testcc2=new Client_Contact__c(Client__c=c.id,First_Name__c='Sugunakar',Last_Name__c='Routhu', Name='Sugunakar Routhu' ,Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff167@gmail.com');
        insert testcc2;
        
    }
    
    
    @isTest static void testjob(){
       //List<String> obj=['Account','Job__c'];
       // calendarCmpController.getObjectFieldLabels('Account');
       test.startTest();
        Campaign__c testcmp=[select Id,Name from Campaign__c where Name='Camp'];
        Client__c testclient=[select Id,Name from Client__c where name='test client'];
        Media_Type__c testmedia=[select Id,Name from Media_Type__c where Name='Test Media 614'];
        Schedule_Template__c testST=[select id,Name,Media_Types__c from Schedule_Template__c where Name='Test Schedule Template 614'];
        Job__c testJob2=[select id,name from Job__c where Name='Test Job 615'];
        string startenddate=string.valueof(System.Today());
        
        calendarCmpController.getLabelsforObject();
        calendarCmpController.getCampaigns();
        calendarCmpController.getClients();
        calendarCmpController.getMediatype();
        calendarCmpController.getscheduletemp(testmedia.id);
        calendarCmpController.fetchJobStatusPicklistval();
        calendarCmpController.getJobs('Active');
        calendarCmpController.getCalJobs('Active',testcmp.Name,testclient.Name,testmedia.Name,testST.Name,testJob2.Name);
        calendarCmpController.updateJob(testJob2.Id,startenddate,startenddate,true);
        test.stopTest();
        
    }
    
     @isTest static void testcmp(){
         test.startTest();
         Campaign__c testcmp=[select Id,Name from Campaign__c where Name='Camp'];
         string startenddate=string.valueof(System.Today());
         calendarCmpController.fetchCampStatusPicklistval();
         calendarCmpController.getCampaignNames('Active');
         calendarCmpController.getuserNames();
         calendarCmpController.getCalCamp('Active',testcmp.Name,'Steve Harris');
         calendarCmpController.updateCamp(testcmp.Id,startenddate,startenddate);
         test.stopTest();
    }
    
    @isTest static void testtsk(){
        test.startTest();
        Campaign__c testcmp=[select Id,Name from Campaign__c where Name='Camp'];
        Client__c testclient=[select Id,Name from Client__c where name='test client'];
        Media_Type__c testmedia=[select Id,Name from Media_Type__c where Name='Test Media 614'];
        Schedule_Template__c testST=[select id,Name,Media_Types__c from Schedule_Template__c where Name='Test Schedule Template 614'];
        Job__c testJob2=[select id,name,Schedule_Calc__c from Job__c where Name='Test Job 615'];
        Job_Task__c testJobTask=[select id,name from Job_Task__c where Name='Job Task 617'];
        string startenddate=string.valueof(System.Today());
        
        calendarCmpController.getStaff();
        calendarCmpController.getRole();
        calendarCmpController.getTasks();
        calendarCmpController.getCalTasks('Active',testcmp.Name,testclient.Name,testmedia.Name,testST.Name,testJob2.Name,testJobTask.Name,'CEO','Steve Harris');
        calendarCmpController.updateTask(testJobTask.Id,startenddate,startenddate,'true');
        calendarCmpController.updateTask(testJobTask.Id,startenddate,startenddate,'false');
        test.stopTest();
    }
}