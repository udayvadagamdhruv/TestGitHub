@isTest
private class Testclass_ApprovalJobTaskExt {
    @testSetup static void SetupMethod() {
        string text='This is a sample test for the content';
        Blob bodyBlob=Blob.valueOf(text);
        ContentVersion cvt=new ContentVersion(Title='sample PDFk',VersionData=bodyBlob,PathOnClient ='sample_PDFk.pdf');
        insert cvt;
        
        
        string text2='This is a sample test for the content';
        Blob bodyBlob2=Blob.valueOf(text2);
        ContentVersion cvt2=new ContentVersion(Title='sample2 PDFk',VersionData=bodyBlob2,PathOnClient ='sample2_PDFk.pdf');
        insert cvt2;
        
        string text3='This is a sample test for the content';
        Blob bodyBlob3=Blob.valueOf(text3);
        ContentVersion cvt3=new ContentVersion(Title='sample3 PDFk',VersionData=bodyBlob3,PathOnClient ='sample3_PDFk.pdf');
        insert cvt3;
        
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
        
        Approval_Schedule_Template__c testSTA2=new Approval_Schedule_Template__c(Name='Test Schedule Template 714');
        
        insert testSTA2;
        Approval_Schedule_Task__c testSchedule1A2=new Approval_Schedule_Task__c(Name='Test Schedule Task 914',Approval_Schedule_Template__c=testSTA2.id,Days__c=3);
        insert testSchedule1A2;
        
        
        Approval_Schedule_Template__c testSTA=new Approval_Schedule_Template__c(Name='Test Schedule Template 614');
        
        insert testSTA;
        
        Approval_Schedule_Task__c testSchedule1A=new Approval_Schedule_Task__c(Name='Test Schedule Task 914',Approval_Schedule_Template__c=testSTA.id,Days__c=3);
        insert testSchedule1A;
        
        Approval_Schedule_Task__c	 testSchedule2A=new Approval_Schedule_Task__c(Name='Test Schedule Task 915',Approval_Schedule_Template__c=testSTA.id,Days__c=3);
        insert testSchedule2A;
        
        Approval_Schedule_Task_Role__c	 testSTR1A=new Approval_Schedule_Task_Role__c(Name='Designer',Approval_Schedule_Task__c=testSchedule1A.id);
        insert testSTR1A;
        
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
        Job__c testJob2=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Status__c='Active',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id,JS_Client__c=c.id,Schedule_Calc__c='End Date');
        
        insert testJob2;
        
        
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
        
        Approval_Job_Task__c testJobTask1=new Approval_Job_Task__c(Name='Job Task 615',Job__c=testJob1.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 2,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com',Schedule_Roles__c='Designer',File_ID__c=cvt.id);
        insert testJobTask1;
        Approval_Job_Task__c testJob2Task1=new Approval_Job_Task__c(Name='Job Task 715',Job__c=testJob2.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com',Schedule_Roles__c='Designer',File_ID__c=cvt3.id,File_Name__c =cvt3.Title+'.'+'pdf');
        insert testJob2Task1;
        Approval_Job_Task__c testJob2Task2=new Approval_Job_Task__c(Name='Job Task 716',Job__c=testJob2.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 4,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com',Schedule_Roles__c='Designer',File_ID__c=cvt3.id,File_Name__c =cvt3.Title+'.'+'pdf',Status__c='In Progress');
        insert testJob2Task2;
        
        
        
        list<Approval_Job_Task__c> Jobtasklist=new list<Approval_Job_Task__c>();
        
        Approval_Job_Task__c testJobTask2=new Approval_Job_Task__c(Name='Job Task 616',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 2,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com',File_ID__c=cvt.id,Schedule_Roles__c='Designer',File_Name__c =cvt.Title+'.'+'pdf');
        
        Jobtasklist.add(testJobTask2);
        
        Approval_Job_Task__c testJobTask3=new Approval_Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com',File_ID__c=cvt.id,Schedule_Roles__c='Designer',File_Name__c =cvt.Title+'.'+'pdf');
        
        
        Jobtasklist.add(testJobTask3);
        Approval_Job_Task__c testJobTask4=new Approval_Job_Task__c(Name='Job Task 618',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com',File_ID__c=cvt.id,Schedule_Roles__c='Designer',File_Name__c =cvt.Title+'.'+'pdf');
        
        
        Jobtasklist.add(testJobTask4);
        Approval_Job_Task__c testJobTask5=new Approval_Job_Task__c(Name='Job Task 619',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
        
        Jobtasklist.add(testJobTask5);
        
        
        insert Jobtasklist;    
        
        Approval_Job_Task_Roles__c testJTR1=new Approval_Job_Task_Roles__c(Name='Designer',Approval_Job_Task__c=testJobTask1.Id);
        insert testJTR1;
        Approval_Job_Task_Roles__c testJTR22=new Approval_Job_Task_Roles__c(Name='Project Manager',Approval_Job_Task__c=testJobTask2.Id);
        insert testJTR22;
        
        
        Approval_Job_Task__c taskViewJobTask1=new Approval_Job_Task__c(Name='Job Task View',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=2,Task_Order__c = 1,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert taskViewJobTask1;
        
        Approval_Job_Task_Roles__c tViewJTR1=new Approval_Job_Task_Roles__c(Name='Designer',Approval_Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR1;
        Approval_Job_Task_Roles__c tViewJTR2=new Approval_Job_Task_Roles__c(Name='Project Manager',Approval_Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR2;
        
        
        /*   Job__c testJob2=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Status__c='Active',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id,Schedule_Calc__c='End Date');

insert testJob2;


Job_Team__c jteam22 = new Job_Team__c(staff__c='manikanta', Role__c='Designer', email__c='test1@test.com', job__c=testJob2.id);  
insert jteam22;

List<SObject> selectedrecs=new List<SObject>{testJob2};

System.assertEquals('Test Job 615',testJob2.Name);

Approval_Job_Task__c testJobTask4=new Approval_Job_Task__c(Name='Job Task 617',Schedule_Roles__c='Designer;Project Manager',Job__c=testJob2.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 4,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');

insert testJobTask4;


Approval_Job_Task__c testJobTask8=new Approval_Job_Task__c(Name='Job Task 6188',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3,Task_Order__c = 4,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');

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
insert testVC2;*/
        
        
        
        
    }
    @isTest static void testFirst(){
        ContentVersion testcontent=[select Id,Title,VersionData from ContentVersion where Title='sample PDFk'];
        ContentVersion testcontent2=[select Id,Title,VersionData from ContentVersion where Title='sample2 PDFk'];
        Approval_Schedule_Template__c aprschtemp=[select id,Name from Approval_Schedule_Template__c where Name='Test Schedule Template 614'];
        Approval_Job_Task__c objCurrentJobTask =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c,Schedule_Roles__c	 from Approval_Job_Task__c where Name='Job Task 615'];
        Approval_Job_Task__c objCurrentJobTask2 =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c,Schedule_Roles__c	 from Approval_Job_Task__c where Name='Job Task 616'];
        Approval_Job_Task__c objCurrentJobTask3 =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c,Schedule_Roles__c	 from Approval_Job_Task__c where Name='Job Task 617']; 
        Approval_Job_Task__c objCurrentJobTask4 =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c,Schedule_Roles__c from Approval_Job_Task__c where Name='Job Task 618']; 
        Approval_Job_Task__c objCurrentJobTask5 =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c,Schedule_Roles__c from Approval_Job_Task__c where Name='Job Task 619']; 
        
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];
        // Job__c testJob2=[select Id,Name from Job__c where Name='Test Job 615'];   
        List<Job_Spec__c> speclist=[select Id,Name,Creative_Brief_Template__c,Sort_Order__c from Job_Spec__c];
        String selectedstaff='[{"Active":true,"Email":"manikanta@dhruvsoft.com","Rolename":"Account Mgr","selection":true,"sobjet":{"Id":"a0y36000002IC17AAG","Name":"Kvns Manikanta","Active__c":true,"First_Name__c":"Kvns","Last_Name__c":"Manikanta","Email__c":"manikanta@dhruvsoft.com","Role__c":"Account Mgr","Username__c":"jsdev2manikanta@dhruvsoft.com"},"SobjType":"Staff__c","Sroles":false,"Staffname":"Kvns Manikanta","Username":"jsdev2manikanta@dhruvsoft.com"},{"Active":true,"Email":"amy.geppert@temple.edu","Rolename":"Copywriter","selection":false,"sobjet":{"Id":"a0y36000006OipSAAS","Name":"Amy Geppert","Active__c":true,"First_Name__c":"Amy","Last_Name__c":"Geppert","Email__c":"amy.geppert@temple.edu","Role__c":"Copywriter","Username__c":"js.amy.geppert@temple.edu"},"SobjType":"Staff__c","Sroles":true,"Staffname":"Amy Geppert","Username":"js.amy.geppert@temple.edu"},{"Active":true,"Email":"manikanta@dhruvsoft.com","Rolename":"Copywriter","selection":true,"sobjet":{"Id":"a0y1R00000Hy0ByQAJ","Name":"Dhruv Hyd","Active__c":true,"First_Name__c":"Dhruv","Last_Name__c":"Hyd","Email__c":"manikanta@dhruvsoft.com","Role__c":"Copywriter","Username__c":"manikantad@dhruvsoft.com"},"SobjType":"Staff__c","Sroles":true,"Staffname":"Dhruv Hyd","Username":"manikantad@dhruvsoft.com"},{"Active":true,"Email":"sugunakar@dhruvsoft.com","Rolename":"Copywriter","selection":false,"sobjet":{"Id":"a0y1R00000Hy7TYQAZ","Name":"Sugunakar Routhu","Active__c":true,"First_Name__c":"Sugunakar","Last_Name__c":"Routhu","Email__c":"sugunakar@dhruvsoft.com","Role__c":"Copywriter","Username__c":"sugunakarvr@dhruvsoft.com"},"SobjType":"Staff__c","Sroles":true,"Staffname":"Sugunakar Routhu","Username":"sugunakarvr@dhruvsoft.com"}]';        
        test.startTest();
        ApprovalJobTaskExt.getRolesAppro();
        ApprovalJobTaskExt.getHelpTextrecordsAppro();
        ApprovalJobTaskExt.getFieldsforObject('Job__c');
        ApprovalJobTaskExt.geLabelforObject('Job__c');
        ApprovalJobTaskExt.getisAccessable();
        ApprovalJobTaskExt.CustomSettingvalues();
        ApprovalJobTaskExt.CreateScheduleSetting();
        ApprovalJobTaskExt.todaySystemDate();
        ApprovalJobTaskExt.getAttachments(testJob1.Id);
        ApprovalJobTaskExt.getApprovalSchTemplates();
        ApprovalJobTaskExt.getListofAprJobTasks(testJob1.Id);
        ApprovalJobTaskExt.getListofAprJobTasks1(testJob1.Id);
        ApprovalJobTaskExt.createApprovalTask(testJob1.Id, testcontent2.id, aprschtemp.id);
        ApprovalJobTaskExt.ApprTaskEditSuccess(objCurrentJobTask.id,True,True);
        ApprovalJobTaskExt.ApprTaskEditSuccess(objCurrentJobTask.id,False,False);
        ApprovalJobTaskExt.ApprTaskEditSuccess(objCurrentJobTask.id,False,True);
        ApprovalJobTaskExt.ApprTaskEditSuccess(objCurrentJobTask.id,True,False);
        ApprovalJobTaskExt.ApproveInsertAboveLoad(objCurrentJobTask.id,10,objCurrentJobTask.Schedule_Roles__c	);
        ApprovalJobTaskExt.ApproveInsertAboveSucess(objCurrentJobTask2.id,objCurrentJobTask3.id,testJob1.Id);
        ApprovalJobTaskExt.ApproveInsertBelowLoad(testJob1.Id,10,objCurrentJobTask4.Schedule_Roles__c,objCurrentJobTask4.File_ID__c);
        ApprovalJobTaskExt.ApproveInsertBlowSucess(objCurrentJobTask.id, testJob1.Id, 5,System.today(), objCurrentJobTask.File_Name__c, objCurrentJobTask.File_ID__c);
        ApprovalJobTaskExt.SubmitApproveTask(objCurrentJobTask.id);
        ApprovalJobTaskExt.ApprovedTsk(objCurrentJobTask.id);
        ApprovalJobTaskExt.taskChangesNeeded(objCurrentJobTask.id);
        ApprovalJobTaskExt.DeleteApproveTask(objCurrentJobTask.id);
        // ApprovalJobTaskExt.ApprTskStaffWrappers
        ApprovalJobTaskExt.getStaffWrapperMembers(objCurrentJobTask2.id);
        ApprovalJobTaskExt.AddStaffToTask(objCurrentJobTask2.id,selectedstaff);
        
        
        ApprovalJobTaskExt.gettodaydate();
        ApprovalJobTaskExt.getUserName();
        ApprovalJobTaskExt.getTaskInformation(objCurrentJobTask2.id);
        ApprovalJobTaskExt.calcTimeDiff(system.today(),system.today()+2);
        
        test.stopTest();
    }
    @istest static void sectest(){
        ContentVersion testcontent3=[select Id,Title,VersionData from ContentVersion where Title='sample3 PDFk'];
        Job__c testJob2=[select Id,Name from Job__c where Name='Test Job 615'];
        Approval_Job_Task__c objCurrentJob2Task =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c,Schedule_Roles__c	 from Approval_Job_Task__c where Name='Job Task 715'];
        Approval_Job_Task__c objCurrentJob2Task2 =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c,Schedule_Roles__c	 from Approval_Job_Task__c where Name='Job Task 716'];
        Approval_Schedule_Template__c aprsch2temp=[select id,Name from Approval_Schedule_Template__c where Name='Test Schedule Template 714'];
        test.startTest();
        ApprovalJobTaskExt.createApprovalTask(testJob2.Id, objCurrentJob2Task.File_ID__c, aprsch2temp.id);
        ApprovalJobTaskExt.ApproveInsertBlowSucess(objCurrentJob2Task.id, testJob2.Id, 2,System.today(), objCurrentJob2Task.File_Name__c, objCurrentJob2Task.File_ID__c);
        ApprovalJobTaskExt.ApprTaskEditSuccess(objCurrentJob2Task.id,False,False);
        ApprovalJobTaskExt.ApprTaskEditSuccess(objCurrentJob2Task.id,False,True);
        ApprovalJobTaskExt.ApprTaskEditSuccess(objCurrentJob2Task.id,True,False);
        ApprovalJobTaskExt.ApprovedTsk(objCurrentJob2Task.id);
        ApprovalJobTaskExt.taskChangesNeeded(objCurrentJob2Task.id);
        //ApprovalJobTaskExt.ApproveInsertBelowLoad(testJob2.Id,10,objCurrentJob2Task2.Schedule_Roles__c,testcontent3.id);
        ApprovalJobTaskExt.ApproveInsertBelowLoad(testJob2.Id,4,objCurrentJob2Task.Schedule_Roles__c,testcontent3.id);
        ApprovalJobTaskExt.ApproveInsertBelowLoad(testJob2.Id,5,objCurrentJob2Task2.Schedule_Roles__c,testcontent3.id);
        ApprovalJobTaskExt.taskChangesNeeded(objCurrentJob2Task2.id);
        ApprovalJobTaskExt.DeleteApproveTask(objCurrentJob2Task.id);
        test.stopTest();
    }
    
}