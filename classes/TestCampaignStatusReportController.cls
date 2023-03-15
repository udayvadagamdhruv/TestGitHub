@isTest
public class TestCampaignStatusReportController {

    static testMethod void TestCampaignStatusReportController() 
       {
       
      Media_Type__c objMedia = new Media_Type__c (Name = 'Outdoor');

      insert objMedia ;
      
      GL_Department__c objGLDept = new GL_Department__c(Name = 'Test GL dept - 010001');
      insert objGLDept;
      
      GL_Code__c objGLCode = new GL_Code__c(Name = 'Test GL Code - 010001', GL_Department__c  = objGLDept.id, GL_ID__c = '00001');
      insert objGLCode ;
      
      
      Schedule_Template__c objSchedule = new Schedule_Template__c(Name = 'Billboard Repair', Media_Types__c = objMedia.id);
      insert objSchedule ;
     
      Campaign__c objCampaign = new Campaign__c(Name = 'Test Campaign -001001');
      insert objCampaign ;
      
      
      list<Client__c> lstCl = new list<Client__c>();      
      Client__c objClient=new Client__c(Name='Test Client 01001',Client_Code__c='234',Dummy_Picklist_1__c ='1942');
      
      Client__c objClient1=new Client__c(Name='Test Client 01002',Client_Code__c='567',Dummy_Picklist_1__c='1946' );

      lstCl.add(objClient);
      lstCl.add(objClient1);
      Insert lstCl;
      
      
      Job__c objJob1 = new Job__c(Name= 'Test Job - 0011001', Media_Types__c= objMedia.Id,Status__c = 'Active', Schedule_Template__c = objSchedule.id,Schedule_Calc__c= 'Start Date', Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,Due_Date__c = System.Today(),Start_Date__c = System.Today(),Job_Auto_Number__c = '00010');
      insert objJob1 ;               
      System.assertEquals('Test Job - 0011001',objJob1.Name); 
      
      Job__c objJob = new Job__c(Name= 'Test Job - 0012001', Media_Types__c= objMedia.Id,Status__c = 'Active', Schedule_Template__c = objSchedule.id,Schedule_Calc__c= 'Start Date', Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,Due_Date__c = System.Today(),Start_Date__c = System.Today(),Job_Auto_Number__c = '002010');
      insert objJob ; 
      
       
      
     
   
      
      Job_Spec__c jobspec= new Job_Spec__c (name='role',Job__c=objJob.id);
      insert jobspec;
      Job_Spec__c jobspec1 =new Job_Spec__c (name='role1',Job__c=objJob.id);
       insert jobspec1;
      Job_Spec__c jobspec2= new Job_Spec__c (name='role2',Job__c=objJob1.id);
       insert jobspec2;
       
       
       Job_Team__c  jobteam= new Job_Team__c(role__c='role',Job__c=objJob.id,Staff__c='staff');
       insert jobteam;
       Job_Team__c jobteam1 =new Job_Team__c(role__c='role1',Job__c=objJob.id,Staff__c='staff1');
       insert jobteam1;
       Job_Team__c jobteam2= new Job_Team__c(role__c='role2',Job__c=objJob1.id,Staff__c='staff2');
       insert jobteam2;
       
       Job_Task__c jobtask= new Job_Task__c(Name='task',Job__c=objJob.id);
      insert jobtask;
      Job_Task__c jobtask1 =new Job_Task__c(Name='task1',Job__c=objJob.id);
       insert jobtask1;
      Job_Task__c  jobtask2= new Job_Task__c(Name='task2',Job__c=objJob1.id);
       insert jobtask2;
       
         
       
      
      
      
      CampaignStatusReportController ext = new CampaignStatusReportController();
      
      CampaignStatusReportController.JobWrapper jb = new CampaignStatusReportController.JobWrapper();
      CampaignStatusReportController.CampaignNameWrapper jn = new CampaignStatusReportController.CampaignNameWrapper();
          Document document=new Document();
                document.Body = Blob.valueOf('Some Text');
                document.ContentType = 'application/pdf';
                document.DeveloperName = 'my_document';
                document.IsPublic = true;
                document.Name = 'JobSuite_OrganizationLogo';
                document.FolderId = [select id from folder where name = 'JobSuiteFolder'].id;
                insert document;
      CampaignStatusReportController ext1 = new CampaignStatusReportController();
      
 }
 }