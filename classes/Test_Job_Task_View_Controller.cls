@isTest
public class Test_Job_Task_View_Controller {
    
    @testSetup public static void SetupData(){
        
        Client__c c=new Client__c(name='Manikanta Kurella');
        insert c;
        
        Vendor__c v=new Vendor__c(name='test Vendor');
        insert v;
        
        GL_Department__c testGLD = new GL_Department__c(Name='GLD1232');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='GLC1232',GL_ID__c='GLC1232',GL_Department__c = testGLD.id);
        insert testGL;
        
        Campaign__c testCampaign1=new Campaign__c(Name='C1232',Active__c=True,Status__c='Active',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
        insert testCampaign1;
        
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
        
        Job__c testJob1=new Job__c(Name='Test Job 614',Campaign__c=testCampaign1.Id,Start_Date__c=System.Today(),Status__c='Active',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id,JS_Client__c=c.id,Schedule_Calc__c='Start Date');
        insert testJob1;
        
        Job_Spec__c testJobSpec1=new Job_Spec__c(Name='Job Spec-1',Job__c=testJob1.id,Creative_Brief_Template__c='test1',Sort_Order__c=1);        
        insert testJobSpec1;
        
        Job_Spec__c testJobSpec2=new Job_Spec__c(Name='Job Spec-2',Job__c=testJob1.id,Creative_Brief_Template__c='test2',Sort_Order__c=2);        
        insert testJobSpec2;
        
        List<Job_Spec__c> speclist=new list<Job_Spec__c>{testJobSpec1,testJobSpec2};
            
        Job_Team__c jteam1 = new Job_Team__c(staff__c='manikanta', Role__c='Designer', email__c='test1@test.com', job__c=testJob1.id);  
        insert jteam1;
        
        Job_Team__c jteam11 = new Job_Team__c(staff__c='manikanta', Role__c='Project Manager', email__c='test1@test.com', job__c=testJob1.id);  
        insert jteam11;
        
        Job_Team__c jteam2 = new Job_Team__c(staff__c='Manikanta Kurella', Role__c='Project Manager', email__c='test2@test.com', job__c=testJob1.id);  
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
        
        Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask1.Id,User__c='Sugunakar Routhu');
        insert testJTR1;
        
        Job_Task_Role__c testJTR11=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask1.Id,User__c='Upendra Routhu');
        insert testJTR11;
        
        Job_Task_Role__c testJTR111=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask1.Id,User__c='Manikanta Kurella');
        insert testJTR111;
        
        Job_Task_Role__c testJTR22=new Job_Task_Role__c(Name='Project Manager',Job_Task__c=testJobTask2.Id,User__c='Sugunakar Routhu');
        insert testJTR22;
        
        Job_Task__c taskViewJobTask1=new Job_Task__c(Name='Job Task View',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=2,Task_Order__c = 1,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert taskViewJobTask1;
        
        Job_Task_Role__c tViewJTR1=new Job_Task_Role__c(Name='Designer',Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR1;
        
        Job_Task_Role__c tViewJTR2=new Job_Task_Role__c(Name='Project Manager',Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR2;
        
        Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
        insert testStaff1;
        
        Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Project Manager',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
        insert testStaff2;
        
        Staff__c testStaff3=new Staff__c(First_Name__c='Sugunakar',Name='Sugunakar Routhu', Last_Name__c='Routhu',Role__c='Art Director',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
        insert testStaff3;
        
        Client_Contact__c  testcc1=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLasNam1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff176@gmail.com');
        insert testcc1;
        
        Client_Contact__c  testcc2=new Client_Contact__c(Client__c=c.id,First_Name__c='Manikanta',Last_Name__c='Kurella', Name='Sugunakar Routhu' ,Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff167@gmail.com');
        insert testcc2;
        
        Vendor_Contact__c testVC1=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLastName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
        insert testVC1;
        
        Vendor_Contact__c  testVC2=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='Upendra',Last_Name__c='Routhu', Name='Sugunakar Routhu' ,Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
        insert testVC2;
        
        test.startTest();
        Graphics_Deliverables__c grp1=new Graphics_Deliverables__c(Name='Grap test-1',Job__c= testJob1.id);
        insert grp1;
        
        Graphics_Deliverables__c grp2=new Graphics_Deliverables__c(Name='Grap test-2',Job__c= testJob1.id);
        insert grp2;
        
        Estimate_Line_Items__c est1=new Estimate_Line_Items__c(Name='Estimate test-1',Job__c= testJob1.id);
        insert est1;
        
        Estimate_Line_Items__c est2=new Estimate_Line_Items__c(Name='Estimate test-2',Job__c= testJob1.id);
        insert est2;
        
        Tag__c testtag1 = new Tag__c(Name='Tag1 ',Job__c = testJob1.id);
        insert testtag1;
        
        Tag__c testtag2 = new Tag__c(Name = 'Tag2 ',Job__c = testJob1.id) ;
        insert testtag2;
        
        Production_Estimate__c pesttag1 = new Production_Estimate__c (Name='pe1 test',Job__c= testJob1.id);
        insert pesttag1 ;
        
        Production_Estimate__c pesttag2 = new Production_Estimate__c (Name ='pe2 test',Job__c= testJob1.id) ;
        insert pesttag2 ;
        test.stopTest();
    }
    
    @isTest static void Task_view_First_Method(){
        test.startTest();
        String selectedStaff='[{"selection":true,"staff":{"Staff__c":"manikanta","Role__c":"Designer","Email__c":"manikanta@dhruvsoft.com"}},{"selection":false,"staff":{"Staff__c":"Sugunakar123","Role__c":"Project Manager","Email__c":"sugunakar@dhruvsoft.com"}}]';
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        Job_Task__c testJobTask1=[select Id,Name from Job_Task__c where Name='Job Task View' limit:1];
        
        Job_Task_View_Controller.ProfileInformation();
        Job_Task_View_Controller.getJobTaskRoles(testJobTask1.Id);
        Job_Task_View_Controller.getStaffWrapperMembers(testJobTask1.Id);
        Job_Task_View_Controller.AddStaffToTask(testJobTask1.Id,selectedStaff);
        Job_Task_View_Controller.duplicateJob(testJob1.Id);
        Job_Task_View_Controller.JobRelatedTeamlist(testJob1.Id);
        
        Job_Task_View_Controller.sendEmailWorkOrderToJobTeam(testJob1.Id,'test@gmail.com,test1@gmail.com','test','byy');
        test.stoptest();
    }
    
    @isTest static void Task_view_Second_Method(){
        Campaign__c camp=[select id,Name from Campaign__c where Name='C1232'];
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        ProductionEstimate__c jscntrls= new  ProductionEstimate__c(Active__c= True);
        insert jscntrls;
        test.startTest();
        Job_Task_View_Controller.duplicateJob(testJob1.Id);
        Job_Task_View_Controller.duplicateCampain(camp.Id);
        test.stoptest();
    }    
    @isTest static void Task_view_Third_Method(){
        test.startTest();  
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        Job_Task__c testJobTask1=[select Id,Name from Job_Task__c where Name='Job Task View' limit:1];
        Campaign__c camp=[select id,Name from Campaign__c where Name='C1232'];
        Job_Task_View_Controller.duplicateCampain(camp.Id);
        Job_Task_View_Controller.CampaignDelete(camp.Id); 
        Job_Task_View_Controller.checkDelete(testJob1.Id);
        Job_Task_View_Controller.ContinuetoDelete(testJob1.Id);
        test.stoptest();
    }
    
    @isTest static void LDS_Controller_FirstMethod(){
        Media_Type__c testMedia=[select id,Name from Media_Type__c where name='Test Media 614'];
        Client__c cli=[select id,Name From Client__c where name='Manikanta Kurella'];
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        test.startTest();
        LDS_Controller.getHelpTextrecords();
        LDS_Controller.CustomSettingvalues();
        LDS_Controller.getFieldsforObject('Job__c');
        LDS_Controller.geLabelforObject('Account');
        LDS_Controller.vendorviewcm1(vendor.Id);
        LDS_Controller.vendorviewcmp(vendor.Id);
        LDS_Controller.getMediaTypes();
        LDS_Controller.getScheduleTemplates(testMedia.Id);
        LDS_Controller.getClients();
        LDS_Controller.getClientContacts(cli.Id);
        LDS_Controller.getObjectType();
        LDS_Controller.getisAccessable();
        test.stoptest();
    }
    
}