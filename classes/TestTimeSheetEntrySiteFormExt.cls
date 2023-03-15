@isTest
public class TestTimeSheetEntrySiteFormExt {
    
    static TestMethod void TestTimeSheetEntrySiteFormExt(){
      /*
         GL_Department__c testGLD = new GL_Department__c(Name='Test GLD 9980');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='GL Code 9980',GL_ID__c='TestGL9980',GL_Department__c = testGLD.id,Unit_Type__c='Project',Unit_Cost__c=120);
        insert testGL;
        
        Job__c testJob1=new Job__c(Name='Job858',Start_Date__c=System.Today(),status__c='Active');
        insert testJob1;
        
        Staff__c testST=new Staff__c(User_Type__c='Unlicensed Staff',First_Name__c='Test',Last_Name__c='Staff',Username__c='testStaff1021@jobsuite.com',Email__c='testStaff1021@jobsuite.com',Alias__c='TEST',Profile__c='System Administrator',IsDeleted__c=false,Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
        insert testST;
          
        
        job_Task__c jTask = new Job_Task__c(Job__c = testJob1.id,GL_Code__c=testGL.id);
        insert jTask;
        
        Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 8901',Job__c=testjob1.Id,Quantity__c=10,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
                insert testELI;
        
        Production_Estimate__c testpELI=new Production_Estimate__c(Name='Quote 8901',Job__c=testjob1.Id,Quantity__c=10,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
                insert testpELI;
        
        Job_Team__c objTeam2 = new  Job_Team__c(Role__c= 'Project Manager',Job__c= testjob1.Id,Staff__c='Test Staff');
       insert objTeam2 ;     
        
       
        
        Document document;

        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'JobSuite_OrganizationLogo2';
        document.FolderId = [select id from folder where name ='JobSuiteFolder'].id;
        insert document;
        

       
        Timesheet_Entries__c t = new Timesheet_Entries__c(Date__c = date.valueOf('2016-10-01 09:09:09') ,Job__c=testJob1.id,Start_Watch__c=datetime.valueOf('2016-11-11 11:11:11'), End_Watch__c=datetime.valueOf('2016-11-11 12:11:11'),GL_Code__c=testGL.id);
      //  insert t;
        TimeSheetEntrySiteFormExt controller = new TimeSheetEntrySiteFormExt(new ApexPages.StandardController(t));
        controller.objTSDetail = t;
         controller.StaffName = 'manikurella';
        string x = controller.calcTimeDiff;
        boolean y = controller.error;
    //    controller.isMobile = false;
        controller.jobId = testJob1.id;
        controller.getJobName();
        controller.getStaff();
        
       // controller.Cancel();
        controller.End();
        controller.getGLCodeOfTask();
        controller.getRemainHours();
        controller.getTaskName();
        controller.getStaffName();
        controller.getTotalHours();
        controller.Save();
        controller.start();
        
        
        controller.objTSDetail = t;
     //   controller.GLCodeVal=testGL.name;
       controller.JobNameStr = testJob1.id;
       controller.JobTaskNameStr = jTask.id;
   
        controller.ShowProductionEstimate = true;
       
        controller.Save();
        controller.getGLCodeOfTask();
        
        controller.isMobile = true;
       */
    }
    
   
    
    

}