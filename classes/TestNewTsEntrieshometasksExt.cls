@IsTest
public class TestNewTsEntrieshometasksExt{
    public static testMethod void TestNewTsEntrieshometasksExt(){                
      /*  GL_Department__c objGLD = new GL_Department__c(Name='Test GL Dept');
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
        ApexPages.currentPage().getParameters().put('jobId',objJob.id);
        ApexPages.currentPage().getParameters().put('tid',objJobTask1.id);
       // ApexPages.currentPage().getParameters().put('TaskId',objJobTask1.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objJSTS);
        
        NewTsEntrieshometasksExt objJTExt = new NewTsEntrieshometasksExt(sc);
        objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = objJobTask1.Id; 
               
        objJTExt.getJobName();
        objJTExt.getTaskName();        
       // objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Date.Today();
        objJTExt.objTSDetail.Notes__c = 'Test-Worked on task 1 today';
        objJTExt.objTSDetail.Hours_Worked__c = 10;
        objJTExt.objTSDetail.User__c = UserInfo.getUserId();        
        //objJTExt.Save();
      //   objJTExt.cancel();
        objJTExt.JobNameStr = '';
        objJTExt.JobTaskNameStr = '';
        objJTExt.getJobName();
        objJTExt.getTaskName();        
       // objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Null;
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 0.00;
        objJTExt.objTSDetail.User__c = Null; 
        objJTExt.end();
        objJTExt.start();       
        objJTExt.Save();
        
        objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = '';
        objJTExt.getJobName();
        objJTExt.getTaskName();        
      //  objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Null;
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 0.00;
        objJTExt.objTSDetail.User__c = Null;        
        objJTExt.Save();
        
        objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = objJobTask1.Id;
        objJTExt.getJobName();
        objJTExt.getTaskName();        
       // objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Null;
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 0.00;
        objJTExt.objTSDetail.User__c = Null;        
        objJTExt.Save();
        
     /*    objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = objJobTask1.Id;
        objJTExt.getJobName();
        objJTExt.getTaskName();        
        objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Date.Today();
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 0.00;
        objJTExt.objTSDetail.User__c = Null;        
        objJTExt.Save();
        
       objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = objJobTask1.Id;
        objJTExt.getJobName();
        objJTExt.getTaskName();        
        objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Date.Today();
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 10;
        objJTExt.objTSDetail.User__c = Null;        
        objJTExt.Save();
        
        objJTExt.Cancel();
        
        ApexPages.currentPage().getParameters().put('jobId',objJob.id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(objJSTS);
        TimesheetEntriesExt objJTExt1 = new TimesheetEntriesExt(sc1);
        objJTExt1.JobNameStr = objJob.Id;
        objJTExt1.JobTaskNameStr = objJobTask1.Id;        
        objJTExt1.getJobName();
        objJTExt1.getTaskName();        
        objJTExt1.getGLCodeOfTask();
        objJTExt1.getTotalHours();
        objJTExt1.getRemainHours();
        objJTExt1.objTSDetail.Date__c = Date.Today();
        objJTExt1.objTSDetail.Notes__c = 'Test-Worked on task 1 today';
        objJTExt1.objTSDetail.Hours_Worked__c = 10;
        objJTExt1.objTSDetail.User__c = UserInfo.getUserId();        
        objJTExt1.Save();
    }
    
    /* public static testMethod void TestTimesheetEntriesExt1(){                
        GL_Department__c objGLD = new GL_Department__c(Name='Test GL Dept');
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
        
        
        
        
        
        Production_Estimate__c   objpESLT = new Production_Estimate__c  ();
         objpESLT.Name = 'Test Line Item 1';
         objpESLT.GL_Department__c = objGLD.Id;
         objpESLT.GL_Code__c = objGLC.Id;
         objpESLT.Job__c = objJob.Id;
         objpESLT.Quantity__c = 200;
         objpESLT.Vendor__c = objV.Id;      
        insert  objpESLT;
        
        Timesheet_Entries__c objJSTS = new Timesheet_Entries__c();
        objJSTS.Start_Watch__c =system.now();
        objJSTS.End_Watch__c=system.now()+1;
        ApexPages.StandardController sc = new ApexPages.StandardController(objJSTS);
        
        TimesheetEntriesExt objJTExt = new TimesheetEntriesExt(sc);
        objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = objJobTask1.Id; 
           
        boolean t=True;
        objJTExt.ShowProductionEstimate=t;
        boolean s=objJTExt.error;
        string t1=objJTExt.calcTimeDiff;
        objJTExt.getJobName();
        objJTExt.getTaskName();        
        objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Date.Today();
        objJTExt.objTSDetail.Notes__c = 'Test-Worked on task 1 today';
        objJTExt.objTSDetail.Hours_Worked__c = 10;
        objJTExt.objTSDetail.User__c = UserInfo.getUserId();        
        objJTExt.Save();
        
        objJTExt.JobNameStr = '';
        objJTExt.JobTaskNameStr = '';
        objJTExt.getJobName();
        objJTExt.getTaskName();        
        objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Null;
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 0.00;
        objJTExt.objTSDetail.User__c = Null; 
        objJTExt.end();
        objJTExt.start();       
        objJTExt.Save();
        
        objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = '';
        objJTExt.getJobName();
        objJTExt.getTaskName();        
        objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Null;
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 0.00;
        objJTExt.objTSDetail.User__c = Null;        
        objJTExt.Save();
        
        objJTExt.JobNameStr = objJob.Id;
        objJTExt.JobTaskNameStr = objJobTask1.Id;
        objJTExt.getJobName();
        objJTExt.getTaskName();        
        objJTExt.getGLCodeOfTask();
        objJTExt.getTotalHours();
        objJTExt.getRemainHours();
        objJTExt.objTSDetail.Date__c = Null;
        objJTExt.objTSDetail.Notes__c = '';
        objJTExt.objTSDetail.Hours_Worked__c = 0.00;
        objJTExt.objTSDetail.User__c = Null;        
        objJTExt.Save();
        */
        }
    
    
    
    
    
    
}