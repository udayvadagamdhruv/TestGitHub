@isTest
public class TestMyTimesheetlistviewController {
    public static testMethod void TestMyTimesheetlistviewController(){               
	 /*   GL_Department__c objGLD = new GL_Department__c(Name='Test GL Dept');
        insert objGLD;
        
        GL_Code__c objGLC = new GL_Code__c(Name='Test GL Code', GL_ID__c='Test Id1', GL_Department__c=objGLD.Id,Unit_Type__c='Days',Unit_Cost__c=100);
        insert objGLC;
        
        Media_Type__c objMType = new Media_Type__c(Name='Test Media Type');
        insert objMType;
        
        Schedule_Template__c objST = new Schedule_Template__c(Name='Test Schedule Temp', Active__c=true, Media_Types__c=objMType.Id);
        insert objST;
        
        Schedule_Task__c objSchTask1 = new Schedule_Task__c(Name='Task 1', GL_Code__c=objGLC.Id, Schedule_Template__c=objST.Id, Days__c=10);
        insert objSchTask1;
        
        Schedule_Task__c objSchTask2 = new Schedule_Task__c(Name='Task 2', GL_Code__c=objGLC.Id, Schedule_Template__c=objST.Id, Days__c=10);
        insert objSchTask2;
        
        Job__c objJob = new Job__c();
        objJob.Name = 'Test Job 1';
        objJob.Status__c = 'Active';
        objJob.Media_Types__c = objMType.Id;
        objJob.Schedule_Template__c = objST.Id;
        objJob.Schedule_Calc__c = 'Start Date';
        objJob.Start_Date__c = Date.Today();
        insert objJob;
        
        Job_Task__c objJobTask1 = new Job_Task__c();
        objJobTask1.Name = objSchTask1.Name;
        objJobTask1.GL_Code__c = objSchTask1.GL_Code__c;
        objJobTask1.Job__c = objJob.Id;
        objJobTask1.Days__c = objSchTask1.Days__c;
        objJobTask1.Start_Date__c = Date.Today();
        objJobTask1.Task_Order__c = 1;
        insert objJobTask1;

        Job_Task__c objJobTask2 = new Job_Task__c();
        objJobTask2.Name = objSchTask2.Name;
        objJobTask2.GL_Code__c = objSchTask2.GL_Code__c;
        objJobTask2.Job__c = objJob.Id;
        objJobTask2.Days__c = objSchTask2.Days__c;
        objJobTask2.Start_Date__c = Date.Today();
        objJobTask2.Task_Order__c = 2;
        insert objJobTask2;
        
        Vendor__c objV = new Vendor__c();
        objV.Name = 'Test Vendor';
        insert objV;
        
        Vendor_GL_Code__c objVGL = new Vendor_GL_Code__c();
        objVGL.GL_Code__c = objGLC.Id;
        objVGL.Vendor__c = objV.Id;
        insert objVGL;
        
        Estimate_Line_Items__c objESLT = new Estimate_Line_Items__c();
        objESLT.Name = 'Test Line Item 1';
        objESLT.GL_Department__c = objGLD.Id;
        objESLT.GL_Code__c = objGLC.Id;
        objESLT.Job__c = objJob.Id;
        objESLT.Quantity__c = 200;
        objESLT.Vendor__c = objV.Id;      
        insert objESLT;
        
        Timesheet_Entries__c objJSTS = new Timesheet_Entries__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(objJSTS);
        
        MyTimesheetlistviewController objJTExt = new MyTimesheetlistviewController(sc);
        
        objJTExt.getTsEnty();
        objJTExt.NewMethod();
        objJTExt.beginning();
        objJTExt.previous();
        objJTExt.next();
        objJTExt.end();
        objJTExt.getprev();
        objJTExt.getnxt();
        
        */
        
        
    }
}