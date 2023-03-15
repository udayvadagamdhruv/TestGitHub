@IsTest (SeeAllData = true) 
public class Test_Job_TS_GD_Tags {
    public static testMethod void Test_Job_TS_GD_Tags(){                
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
        
        Estimate_Line_Items__c objESLT = new Estimate_Line_Items__c();
        objESLT.Name = 'Test Line Item 1';
        objESLT.GL_Department__c = objGLD.Id;
        objESLT.GL_Code__c = objGLC.Id;
        objESLT.Job__c = objJob.Id;
        objESLT.Quantity__c = 200;
        objESLT.Vendor__c = objV.Id;      
        insert objESLT;
        system.debug('>>>>>>>Insert Estimate>>>>>>>'+objESLT);
        
        Production_Estimate__c   objpESLT = new Production_Estimate__c  ();
        objpESLT.Name = 'Test Line Item 1';
        objpESLT.GL_Department__c = objGLD.Id;
        objpESLT.GL_Code__c = objGLC.Id;
        objpESLT.Job__c = objJob.Id;
        objpESLT.Quantity__c = 200;
        objpESLT.Vendor__c = objV.Id;      
        insert  objpESLT;
        
        Boolean ShowProductionEstimate =True;
        
        Timesheet_Entries__c objJSTS = new Timesheet_Entries__c();
        objJSTS.Job__c = objJob.Id;
        objJSTS.Date__c = Date.Today();
        objJSTS.Notes__c = 'Test-Worked on task 1 today';
        objJSTS.Hours_Worked__c = 10;
        objJSTS.User__c = UserInfo.getUserId();
        insert objJSTS;
        
        list<Timesheet_Entries__c> TsList = [select id from Timesheet_Entries__c];
        /****************************** TimeSheet ********************************************/
        Test.startTest(); 
        
        TSMobileExt.getMobTsEntyRecs(10,10);
        TSMobileExt.gettodaydate();
        TSMobileExt.getUserName();
        TSMobileExt.getjobName();
        TSMobileExt.getTaskName(objJob.Id);
        TSMobileExt.getGLCodeOfTask(objJob.Id,objSchTask2.Name);
        TSMobileExt.getTotalHours(objJob.Id,objGLC.Id);
        TSMobileExt.getRemainHours(objJob.Id,objSchTask1.GL_Code__c,20);
        
        Job_TS_GD_Tags.getTSrecords(objJob.Id,10,10);
        Job_TS_GD_Tags.getisAccessable();
        Job_TS_GD_Tags.getTotalRecords(objJob.Id);
        Job_TS_GD_Tags.getTSAllrecords(objJob.Id,10);
        Job_TS_GD_Tags.getTaskInformation(objJobTask2.Id);
        Job_TS_GD_Tags.getJobName(objJob.Id);
        Job_TS_GD_Tags.updateTS(TsList);        
        Job_TS_GD_Tags.DeleteTS(objJSTS.Id);
        Job_TS_GD_Tags.getTotalHours(objJob.Id,objGLC.Id);
        Job_TS_GD_Tags.getRemainHours(objJob.Id,objSchTask1.GL_Code__c,20);
        Job_TS_GD_Tags.gettodaydate();
        Job_TS_GD_Tags.getUserName();
        Job_TS_GD_Tags.getTaskName(objJob.Id);
        DateTime StartDateTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        DateTime EndDateTime = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        Job_TS_GD_Tags.calcTimeDiff(StartDateTime,EndDateTime);
        Job_TS_GD_Tags.getTaskNameonLoad(objJob.Id,objJobTask2.Name);
        Job_TS_GD_Tags.getGLCodeOfTask(objJob.Id,objJobTask2.Name);
        
        TSMobileExt.calcTimeDiff(StartDateTime,EndDateTime);
        
        /****************************** Graphics Deliverables  ********************************************/
        
        list<Graphics_Deliverables__c> GDList = [select id from Graphics_Deliverables__c];
        
        Job_TS_GD_Tags.getDataTableDetails('Graphics_Deliverables__c','Graphics_Deliverables_Fieldset',objJob.Id);
        Job_TS_GD_Tags.getFieldsforObject('Graphics_Deliverables__c','Graphics_Deliverables_Fieldset');
        Job_TS_GD_Tags.geLabelforObject('Account');
        Job_TS_GD_Tags.getGDrecords(objJob.Id);
        Job_TS_GD_Tags.updateGD(GDList);
        
        Graphics_Deliverables__c testGD1=new Graphics_Deliverables__c(Name='Test Graphics 1777',Job__c=objJob.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
        insert testGD1;
        
        Graphics_Deliverables__c testGD2=new Graphics_Deliverables__c(Name='Test Graphics 1888',Job__c=objJob.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
        insert testGD2;  
        
        Graphics_Deliverables__c testGD22=new Graphics_Deliverables__c(Name='Test Graphics 1889',Job__c=objJob.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
        insert testGD22;
        
        Graphics_Deliverables__c testGD23=new Graphics_Deliverables__c(Name='Test Graphics 1890',Job__c=objJob.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
        insert testGD23;  
        
        Job_TS_GD_Tags.DeleteGD(testGD22.Id);
        Job_TS_GD_Tags.duplicateGD(testGD23.Id);
       
        
        /****************************** Tags  ********************************************/   
        
        list<Tag__c> TagList = [select id from Tag__c];
        
        Job_TS_GD_Tags.getTagTemplates();
        
        Tag_Template__c TT=new Tag_Template__c();
        TT.Name='Tag Template';
        insert TT;
        
        Tag_Template_Item__c TTL =new Tag_Template_Item__c();
        TTL.Name='Tag Template Line Item';
        TTL.TagTemplate__c=TT.id;
        insert TTL;
        
        Job_TS_GD_Tags.getTagTemplates();
        Job_TS_GD_Tags.importTags(objJob.Id,TT.Id);
        
        Tag__c testJobTag = new Tag__c(Name='Test temp Item 5Apr13', Job__c=objJob.id);
        insert testJobTag;
        
        Tag__c testJobTag1 = new Tag__c(Name='Test temp Item', Job__c=objJob.id);
        insert testJobTag1;
        
        Job_TS_GD_Tags.updateTag(TagList);
        Job_TS_GD_Tags.duplicateTag(testJobTag1.Id);
        Job_TS_GD_Tags.DeleteTag(testJobTag.Id);
        Test.stopTest();
        
    }
}