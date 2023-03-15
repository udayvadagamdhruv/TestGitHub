@IsTest
public class Test_Home_Page {
    public static testMethod void Test_Home_Page(){  
        
        
        Profile p=[Select Id from Profile where Name=: 'System Administrator'];
        
        User u=[Select Id,Name,Email from User where IsActive=: True and ProfileId=: p.Id LIMIT 1];
        
        System.runAs(u)
        {
            
            GL_Department__c objGLD = new GL_Department__c(Name='Test GL Dept');
            insert objGLD;
            
            GL_Code__c objGLC = new GL_Code__c(Name='Test GL Code', GL_ID__c='Test Id1', GL_Department__c=objGLD.Id,Unit_Type__c='Days',Unit_Cost__c=100);
            insert objGLC;
            
            Vendor__c objV = new Vendor__c();
            objV.Name = 'Test Vendor';
            insert objV;
            
            Vendor_GL_Code__c objVGL = new Vendor_GL_Code__c();
            objVGL.GL_Code__c = objGLC.Id;
            objVGL.Vendor__c = objV.Id;
            insert objVGL;
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 810');
            insert testMedia;
            
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 810',Media_Types__c=testMedia.Id);
            insert testST;
            
            Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 810',Schedule_Template__c=testST.Id);
            insert testScheduleTask1;
            
            Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 810');
            insert testSpec;
            
            Job__c testJob1=new Job__c(Job_Auto_Number__c='810',Name='Test Job 810',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,status__C='Active');
            insert testJob1;
            
            Job__c testJob2=new Job__c(Job_Auto_Number__c='819',Name='Test Job 810111',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,status__C='Active');
            insert testJob2;
            
            Job__c testJob3=new Job__c(Job_Auto_Number__c='854',Name='Test Job 81440111',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,status__C='Active');
            insert testJob3;
            
            
            System.assertEquals('Test Job 810',testJob1.Name);
            
            Job_Task__c testJT1=new Job_Task__c(Name='Test Job Task 8100',Job__c=testJob1.Id,Marked_Done__c=True, Days__c=1,Revised_Due_Date__c=system.today());
            insert testJT1;        
            
            Job_Task__c testJT2=new Job_Task__c(Name='Test Job Task 812310',Job__c=testJob1.Id,Status__c='Active',Marked_Done__c=False,Days__c=1,Start_Date__c=system.today(),Revised_Due_Date__c=system.today(),Next_Task_Due__c=True);
            insert testJT2;
            
            Job_Task__c testJT3=new Job_Task__c(Name='Test Job Task 8123311',Job__c=testJob2.Id,Marked_Done__c=False,Days__c=1,Revised_Due_Date__c=system.today());
            insert testJT3;
            
            Job_Task__c testJT4=new Job_Task__c(Name='Test Job Task 8132311',Job__c=testJob2.Id,Marked_Done__c=False,Days__c=1,Revised_Due_Date__c=system.today());
            insert testJT4;
            
            Job_Team__c  objTeam = new Job_Team__c(Job__c=testJob1.Id,Task__c=testJT2.id,Role__c= 'tset',Staff__c=u.Name);
            insert objTeam;
            
            Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT1.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR1;  
            
            Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT2.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR2;  
            
            Job_Task_Role__c testJTR3=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT3.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR3;
            
            Job_Task_Role__c testJTR4=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT4.Id, User__c=u.Name,Email__c=u.Email);
            insert testJTR4;  
            
            
            Estimate_Line_Items__c objESLT = new Estimate_Line_Items__c();
            objESLT.Name = 'Test Line Item 1';
            objESLT.GL_Department__c = objGLD.Id;
            objESLT.GL_Code__c = objGLC.Id;
            objESLT.Job__c = testJob1.Id;
            objESLT.Quantity__c = 200;
            objESLT.Vendor__c = objV.Id;      
            insert objESLT;
            Production_Estimate__c pe=new Production_Estimate__c(Job__c = testJob1.Id,Name = 'Test Line Item 1',GL_Code__c = objGLC.Id,Quantity__c = 200);
            insert pe;
            
            Timesheet_Entries__c te=new Timesheet_Entries__c(GL_Code__c=objGLC.Id,Job__c=testJob1.Id);
            insert te;
            Test.startTest(); 
            Home_Page.getObjectFieldLabels(new list<string>{'job__c'});
            Home_Page.getMyJobData('Active');
            Home_Page.getMyJobData('Completed');
            Home_Page.assignMarkedDone(testJT4.Id);
            Home_Page.getTsEnty(10,10);
            Home_Page.getTaskName(testJob1.Id);
            Home_Page.getGLCodeOfTask(testJob2.Id,testJT4.Name);
            Home_Page.getTotalHours(testJob1.Id,objGLC.id);
            insert new ProductionEstimate__c(Active__c=true);
            Home_Page.getTotalHours(testJob1.Id,objGLC.id);
            Home_Page.getRemainHours(testJob1.id,objGLC.Id,10.00);
            DateTime StartDateTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);
            DateTime EndDateTime = datetime.newInstance(2014, 9, 15, 13, 30, 0);
            Home_Page.calcTimeDiff(StartDateTime,EndDateTime);
            
            Home_Page.fetchPicklistvalues();
            Home_Page.getjobName();
            Home_Page.gettodaydate();
            Home_Page.getMyTaskData();
            Home_Page.getUserName();
            Home_Page.getTotalRecords();
            Home_Page.getisAccessable();
           Home_Page.getMyDueTasksOnCalender('MyTaskDues');
            Home_Page.TaskDueDateUpdateFromHomePage('200120201020','200120201020',testJT2.id);
            Home_Page.getTotalJobRecords('Active');
         
            Test.stopTest();
        }
        
        
        
    }
}