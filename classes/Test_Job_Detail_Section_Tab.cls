@isTest
public class Test_Job_Detail_Section_Tab {
    
    @testSetup static void SetupMethod() {
        
        Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');
        insert customSetting1;
        
        Client__c c=new Client__c(name='test client');
        insert c;
        Vendor__c v=new Vendor__c(name='test Vendor');
        insert v;
        
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
        
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1310');
        insert testSpec1;
        
        Spec_Item__c testSPI1=new Spec_Item__c(Name='Test SPI 1310',Description__c='Test Desc 1310',Specification_Template__c=testSpec1.id,Sort_Order__c=1);
        insert testSPI1;     
        
        Specification_Template__c testSpec2=new Specification_Template__c(Name='Testing Spcification Template 1311');
        insert testSpec2;
        
        Spec_Item__c testSPI2=new Spec_Item__c(Name='Test SPI 1311',Description__c='Test Desc 1310',Specification_Template__c=testSpec2.id);
        insert testSPI2;
        
        
        Job__c testJob1=new Job__c(Name='Test Job 614',Start_Date__c=System.Today(),Status__c='Active',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id,JS_Client__c=c.id,Schedule_Calc__c='Start Date');
        
        insert testJob1;
        
        Job_Spec__c testJobSpec1=new Job_Spec__c(Name='Job Spec-1',Job__c=testJob1.id,Creative_Brief_Template__c='test1',Sort_Order__c=1);        
        insert testJobSpec1;
        
        Job_Spec__c testJobSpec2=new Job_Spec__c(Name='Job Spec-2',Job__c=testJob1.id,Creative_Brief_Template__c='test1',Sort_Order__c=2);        
        insert testJobSpec2;
        
        List<Job_Spec__c> speclist=new list<Job_Spec__c>{testJobSpec1,testJobSpec2};
            
            
        Job_Team__c jteam1 = new Job_Team__c(staff__c='manikanta', Role__c='Designer', email__c='test1@test.com', job__c=testJob1.id);  
        insert jteam1;
        Job_Team__c jteam2 = new Job_Team__c(staff__c='manikanta', Role__c='Project Manager', email__c='test2@test.com', job__c=testJob1.id);  
        insert jteam2;
        
        Job_Team__c jteam3 = new Job_Team__c(staff__c='Sugunakar Routhu', Role__c='Designer', email__c='test3@test.com', job__c=testJob1.id);  
        insert jteam3;
        
        System.assertEquals('Test Job 614',testJob1.Name);
        
        Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 615',Job__c=testJob1.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 1,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert testJobTask1;
        
        list<Job_Task__c> Jobtasklist=new list<Job_Task__c>();
        
        Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 616',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 2,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
        Jobtasklist.add(testJobTask2);
        
        Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
        
        Jobtasklist.add(testJobTask3);
        insert Jobtasklist;    
        
        Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask1.Id);
        insert testJTR1;
        Job_Task_Role__c testJTR22=new Job_Task_Role__c(Name='Project Manager',Job_Task__c=testJobTask2.Id);
        insert testJTR22;
        
        
        Job_Task__c taskViewJobTask1=new Job_Task__c(Name='Job Task View',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=2,Task_Order__c = 1,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert taskViewJobTask1;
        
         Job_Task_Role__c tViewJTR1=new Job_Task_Role__c(Name='Designer',Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR1;
        Job_Task_Role__c tViewJTR2=new Job_Task_Role__c(Name='Project Manager',Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR2;
        
        
        Job__c testJob2=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Status__c='Active',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id,Schedule_Calc__c='End Date');
        
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
        
        Vendor_Contact__c testVC1=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLastName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
        insert testVC1;
        
        
        Vendor_Contact__c  testVC2=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='Sugunakar',Last_Name__c='Routhu', Name='Sugunakar Routhu' ,Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
        insert testVC2;
        
    }
    
    
    @isTest static void testFirst(){
        
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];
        List<Job_Spec__c> speclist=[select Id,Name,Creative_Brief_Template__c,Sort_Order__c from Job_Spec__c];
        String selectedstaff='[{"Active":true,"Email":"manikanta@dhruvsoft.com","Rolename":"Account Mgr","selection":true,"sobjet":{"Id":"a0y36000002IC17AAG","Name":"Kvns Manikanta","Active__c":true,"First_Name__c":"Kvns","Last_Name__c":"Manikanta","Email__c":"manikanta@dhruvsoft.com","Role__c":"Account Mgr","Username__c":"jsdev2manikanta@dhruvsoft.com"},"SobjType":"Staff__c","Sroles":false,"Staffname":"Kvns Manikanta","Username":"jsdev2manikanta@dhruvsoft.com"},{"Active":true,"Email":"amy.geppert@temple.edu","Rolename":"Copywriter","selection":false,"sobjet":{"Id":"a0y36000006OipSAAS","Name":"Amy Geppert","Active__c":true,"First_Name__c":"Amy","Last_Name__c":"Geppert","Email__c":"amy.geppert@temple.edu","Role__c":"Copywriter","Username__c":"js.amy.geppert@temple.edu"},"SobjType":"Staff__c","Sroles":true,"Staffname":"Amy Geppert","Username":"js.amy.geppert@temple.edu"},{"Active":true,"Email":"manikanta@dhruvsoft.com","Rolename":"Copywriter","selection":true,"sobjet":{"Id":"a0y1R00000Hy0ByQAJ","Name":"Dhruv Hyd","Active__c":true,"First_Name__c":"Dhruv","Last_Name__c":"Hyd","Email__c":"manikanta@dhruvsoft.com","Role__c":"Copywriter","Username__c":"manikantad@dhruvsoft.com"},"SobjType":"Staff__c","Sroles":true,"Staffname":"Dhruv Hyd","Username":"manikantad@dhruvsoft.com"},{"Active":true,"Email":"sugunakar@dhruvsoft.com","Rolename":"Copywriter","selection":false,"sobjet":{"Id":"a0y1R00000Hy7TYQAZ","Name":"Sugunakar Routhu","Active__c":true,"First_Name__c":"Sugunakar","Last_Name__c":"Routhu","Email__c":"sugunakar@dhruvsoft.com","Role__c":"Copywriter","Username__c":"sugunakarvr@dhruvsoft.com"},"SobjType":"Staff__c","Sroles":true,"Staffname":"Sugunakar Routhu","Username":"sugunakarvr@dhruvsoft.com"}]';        
        test.startTest();
        Job_Detail_Section_Tab.getFieldsforObject('Job__c');
        Job_Detail_Section_Tab.geLabelforObject('Account');
        Job_Detail_Section_Tab.CustomSettingvalues(); 
        Job_Detail_Section_Tab.CreateScheduleSetting();
        Job_Detail_Section_Tab.todaySystemDate();
        Job_Detail_Section_Tab.createSchedule(testJob1.Id);
        Job_Detail_Section_Tab.getAllTasksByStatus(testJob1.Id);
        Job_Detail_Section_Tab.getResourceWorkLoad('Designer');
        Job_Detail_Section_Tab.getjobteamrecords(testJob1.Id);
        Job_Detail_Section_Tab.getTeamPhotos(testJob1.Id);
        Job_Detail_Section_Tab.JobTeamAddEditStaffCont(testJob1.Id);
        Job_Detail_Section_Tab.SerachStaff(testJob1.Id, 'All');
        Job_Detail_Section_Tab.SerachStaff(testJob1.Id, 'Staff');
        Job_Detail_Section_Tab.SerachStaff(testJob1.Id, 'Client Contact');
        Job_Detail_Section_Tab.SerachStaff(testJob1.Id, 'Vendor Contact');
        Job_Detail_Section_Tab.AddstafftoJobTeam(testJob1.Id, selectedstaff);
        Job_Detail_Section_Tab.getjobSpecrecords(testJob1.Id);
        Job_Detail_Section_Tab.getjobSpecrecords1(testJob1.Id);
        Job_Detail_Section_Tab.deleteJobSpec(speclist[0].Id);
        Job_Detail_Section_Tab.getJobSpecTemplates(testJob1.Id);
        Job_Detail_Section_Tab.updateSpecs(speclist);
        Job_Detail_Section_Tab.getisAccessable();
        Job_Detail_Section_Tab.getHelpTextrecords();
       
        test.stopTest();
    }     
    
    @isTest static void testSecond(){
        test.startTest();
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];
        Job__c testJob2=[select Id,Name from Job__c where Name='Test Job 615'];  
        Specification_Template__c testSpec2=[select id,Name From Specification_Template__c where name='Testing Spcification Template 1311'];
        List <Job_Task__c> Jobtasklist=[select id,Name,Status__c,Completion_Date__c,Marked_Done__c from Job_Task__c];
        Job_Task__c testJobTask1=[select Id,Name from Job_Task__c where Name='Job Task 615' limit:1];
        Job_Task__c testJobTask2=[select Id,Name from Job_Task__c where Name='Job Task 616'  limit:1];
        Job_Task__c testJobTask3=[select Id,Name from Job_Task__c where Name='Job Task 617'  limit:1];
        
        List<SObject> selectedrecs=[Select Id,Name,Start_Date__c,Status__c,Media_Types__c,Schedule_Template__c,Specification_Template__c,JS_Client__c,Schedule_Calc__c from Job__c];
        
       
        Job_Detail_Section_Tab.TaskDueDateUpdate(testJobTask2.Id,String.valueOf(System.today()),String.valueOf(System.today()));
        Job_Detail_Section_Tab.statusChangeUpdate(testJobTask2.Id,'Active');
        Job_Detail_Section_Tab.statusChangeUpdate(testJobTask2.Id,'Completed');
        
        Job_Detail_Section_Tab.TaskEditSuccess(testJobTask2.Id,true,false);
        Job_Detail_Section_Tab.TaskEditSuccess(testJobTask2.Id,false,true);
        Job_Detail_Section_Tab.InsertAboveLoad(testJobTask2.Id,2,'Designer;Project Manager');
        Job_Detail_Section_Tab.InsertAboveSucess(testJobTask2.Id,testJobTask1.Id,testJob1.Id);
        
        Job_Detail_Section_Tab.CompleteTask(testJobTask2.Id);
        Job_Detail_Section_Tab.ActiveTask(testJobTask2.Id);
        Job_Detail_Section_Tab.getAlltasks(testJob1.Id);
        Job_Detail_Section_Tab.getStatusList();
        
        Job_Detail_Section_Tab.InsertBelowLoad(testJob1.Id,2,'Designer;Project Manager');
        Job_Detail_Section_Tab.InsertBelowLoad(testJob2.Id,2,'Designer;Project Manager');
        Job_Detail_Section_Tab.InsertBlowSucess(testJobTask3.Id,testJob2.Id,7,System.today());
        Job_Detail_Section_Tab.InsertBlowSucess(testJobTask1.Id,testJob1.Id,1,System.today());
        Job_Detail_Section_Tab.getListofJobTasks(testJob1.Id);
        test.stoptest();
    }
    
    @isTest static void testThird(){
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        Specification_Template__c testSpec2=[select id,Name From Specification_Template__c where name='Testing Spcification Template 1311'];
        List <Job_Task__c> Jobtasklist=[select id,Name,Status__c,Completion_Date__c,Marked_Done__c from Job_Task__c];
        Job_Task__c testJobTask1=[select Id,Name from Job_Task__c where Name='Job Task 615' limit:1];
        Job_Task__c testJobTask2=[select Id,Name from Job_Task__c where Name='Job Task 616'  limit:1];
        Job_Task__c testJobTask4=[select Id,Name from Job_Task__c where Name='Job Task 617'  limit:1];
        List<SObject> selectedrecs=[Select Id,Name,Start_Date__c,Status__c,Media_Types__c,Schedule_Template__c,Specification_Template__c,JS_Client__c,Schedule_Calc__c from Job__c];
        
        test.startTest();  
        Job_Detail_Section_Tab.addJobSpecTemplates(testJob1.Id,testSpec2.Id);
        Job_Detail_Section_Tab.getTimesheetRecords(testJob1.Id);
        Job_Detail_Section_Tab.getListofJobTasks(testJob1.Id);                                           
        Job_Detail_Section_Tab.updateTasksinlineEdit(Jobtasklist);
        Job_Detail_Section_Tab.updateScheduleOnDays(testJob1.Id,testJobTask2.Id,'4','true');
        Job_Detail_Section_Tab.updateScheduleOnDays(testJob1.Id,testJobTask2.Id,'2','false');
        Job_Detail_Section_Tab.updateRestSchedule(testJob1.Id,testJobTask2.Id,System.today(),'true');
        Job_Detail_Section_Tab.updateRestSchedule(testJob1.Id,testJobTask2.Id,System.today(),'false');
        Job_Detail_Section_Tab.MarkAllSelectedTasks(new list<string>{testJobTask4.id});
        //Job_Detail_Section_Tab.DeleteTask1234(testJobTask1.Id);
        Job_Detail_Section_Tab.DeleteTask(testJobTask1.Id);
        Job_Detail_Section_Tab.TeamCopytoJobsrelatedCamp(testJob1.Id);
        Job_Detail_Section_Tab.createSchedule(testJob1.Id);
        Job_Detail_Section_Tab.ShowMultipleScheduleCopyJobs(testJob1.Id);
        Job_Detail_Section_Tab.saveRsc(testJob1.Id,selectedrecs);
        Job_Detail_Section_Tab.getRoles();
        test.stoptest();
    }  
    
   
    
}