@istest
public class TestEditTimesheetEntryLightningExt {

    @istest static void TestTimeSheetEntry(){
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
        
        
        Timesheet_Entries__c tse=new Timesheet_Entries__c(job__c=objJob.id,Task_Name__c=objJobTask1.name,Date__c=System.today());
        insert tse;
        EditTimesheetEntryLightningExt est=new EditTimesheetEntryLightningExt(new Apexpages.StandardController(tse));
        
        est.getTaskName();
        est.getGlCodeofTask();
        est.Save();
        est.cancel();
       // Timesheet_Entries__c aa=[select id,Task_Name__c,Date__c from Timesheet_Entries__c where id=:tse.id];
       // aa.date__c=null;
        //update aa;
        est.selectedTask='';
        est.save();
        est.jobname='';
        est.save();
        est.showTaskSelectList=false;
        est.getGlCodeofTask();
        */
        
    }
}