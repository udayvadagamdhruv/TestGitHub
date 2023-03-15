@isTest
private class Test_StatusreportSaerch {

    static testMethod void myUnitTest() 
       {
      Media_Type__c objMedia = new Media_Type__c (Name = 'Test Media type-010001');
      insert objMedia;
      
      GL_Department__c objGLDept = new GL_Department__c(Name = 'Test GL dept - 010001');
      insert objGLDept;
      
      GL_Code__c objGLCode = new GL_Code__c(Name = 'Test GL Code - 010001', GL_Department__c  = objGLDept.id, GL_ID__c = '00001');
      insert objGLCode ;
      
      Schedule_Template__c objSchedule = new Schedule_Template__c(Name = 'Test Schedule Template-001001', Media_Types__c = objMedia.id);
      insert objSchedule;
      
      Schedule_Template__c objSchedule1 = new Schedule_Template__c(Name = 'Test Schedule Template-00s1001', Media_Types__c = objMedia.id);
      insert objSchedule1;
      
      Schedule_Task__c objSTask1 = new  Schedule_Task__c(Name = 'Test Job Task1 - 010001', Schedule_Template__c = objSchedule.Id, GL_Code__c = objGLCode.id, Days__c = 2 );
      insert objSTask1;
      
     Schedule_Task__c objSTask2 = new  Schedule_Task__c(Name = 'Test JobTask2 - 001001', Schedule_Template__c = objSchedule.Id,GL_Code__c = objGLCode.id, Days__c = 2 );
      insert objSTask2;
      
      Campaign__c objCampaign = new Campaign__c(Name = 'Test Campaign -001001');
      insert objCampaign;
      
      Campaign__c objCampaign1 = new Campaign__c(Name = 'Test Campaign -000102');
      insert objCampaign1;
      
     
      
      

      
            
      Client__c objClient=new Client__c(Name='Test Client 01001');
      insert objClient;
      
      Client__c objClient1=new Client__c(Name='Test Client 01002');
      insert objClient1;
       
      
      
      Job__c objJob1 = new Job__c(Name= 'Test Job - 0011001', Media_Types__c= objMedia.Id,Status__c = 'Active', Schedule_Template__c = objSchedule.id,Schedule_Calc__c= 'Start Date', Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,Due_Date__c = System.Today(),Start_Date__c = System.Today(),Job_Auto_Number__c = '00010');
      insert objJob1 ;               
      System.assertEquals('Test Job - 0011001',objJob1.Name); 
      
      Job__c objJob = new Job__c(Name= 'Test Job - 0012001', Media_Types__c= objMedia.Id,Status__c = 'Active', Schedule_Template__c = objSchedule.id,Schedule_Calc__c= 'Start Date', Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,Due_Date__c = System.Today(),Start_Date__c = System.Today(),Job_Auto_Number__c = '002010');
      insert objJob ;
           
         Job_Task__c testJTS1=new Job_Task__c(Name='Test JT 897',Days__c=2,Job__c=objJob.id);
          
                  insert testJTS1;
           Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test JT 897',Job_Task__c=testJTS1.Id);
        
                insert testJTR1;     
           
    
          
           Job_Team__c testJT1=new Job_Team__c(Job__c=objJob.Id,Role__c='Designer');
           
               insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=objJob.Id,Role__c='Project Manager',Staff__c='manikanta');
           
               insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=objJob.Id,Role__c='Art Director',Staff__c='manikanta');
              
             insert testJT3;
                 
           
      
     
       Job_Task__c objTask1 = new  Job_Task__c(Name = 'Test Job Task1 - 010001', GL_Code__c = objGLCode.id, Days__c = 2,Job__c = objJob1.id);
      insert objTask1;
      
      Job_Task__c objTask2 = new  Job_Task__c(Name = 'Test JobTask2 - 001001', GL_Code__c = objGLCode.id, Days__c = 4,Job__c = objJob1.id);
      insert objTask2;   
      
     
      
      Job__c objJob2 = new Job__c(Name= 'Test Job - 001002', Media_Types__c= objMedia.Id,Status__c = 'Completed', Schedule_Calc__c = 'Start Date', Due_Date__c = System.Today(),Schedule_Template__c = objSchedule.id, Campaign__c  = objCampaign1.Id,JS_Client__c = objClient1.id,Start_Date__c = System.Today(),Job_Auto_Number__c = '00020');
      insert objJob2 ;               
      System.assertEquals('Test Job - 001002',objJob2.Name); 
      
       
      
      Tag__c objTag = new Tag__c(Name = 'Test tag1',Job__c = objJob1.Id);
      insert objTag;
      
      Tag__c objTag2 = new Tag__c(Name = 'Test t1ag2',Job__c = objJob1.Id);
      insert objTag2; 
      
      Tag__c objTag1 = new Tag__c(Name = 'Test t1ag3',Job__c = objJob2.Id);
      insert objTag1;
      
      Tag__c objTag3 = new Tag__c(Name = 'Test t1ag4',Job__c = objJob2.Id);
      insert objTag3;
      
      
           
     
     

      StatusReport  ext = new StatusReport();
      List<String> lstCampaign = ext.CampaignList;
      List<String> lstActive = ext.jobStatus;
      List<String> lstClient= ext.clientList;
       
      StatusReport.JobWrapper jb = new StatusReport.JobWrapper();
      StatusReport.ClientWrapper jc = new StatusReport.ClientWrapper();
      StatusReport.ScheduleWrapper js = new StatusReport.ScheduleWrapper();
      
       
      
          ApexPages.CurrentPage().getParameters().put('CampaignList','');
          ApexPages.CurrentPage().getParameters().put('clientList','');
          ApexPages.CurrentPage().getParameters().put('statusList','Active');
          ApexPages.CurrentPage().getParameters().put('JobTeamList','');
          ApexPages.CurrentPage().getParameters().put('promoDueDt1',(DateTime.now().addYears(-2)).format('MM/dd/yyyy'));
          ApexPages.CurrentPage().getParameters().put('promoDueDt2',(DateTime.now().addyears(1)).format('MM/dd/yyyy'));
          
          ApexPages.Pagereference result = ext.searchJobs();
          
          result = ext.exportTOPDF();
         result = ext.clearForm();
         
          ApexPages.CurrentPage().getParameters().put('CampaignList',objCampaign.Name);
          ApexPages.CurrentPage().getParameters().put('clientList',objClient.Name);
          ApexPages.CurrentPage().getParameters().put('statusList','Active'); 
          ApexPages.CurrentPage().getParameters().put('promoDueDt1',Datetime.now().format('MM/dd/yyyy'));
          ApexPages.CurrentPage().getParameters().put('promoDueDt2',(Datetime.now().addDays(1)).format('MM/dd/yyyy'));
      
         ApexPages.Pagereference result1 = ext.searchJobs();
          
         result1 = ext.exportTOPDF();
         result1 = ext.clearForm();
         
         
           Document document=new Document();
                document.Body = Blob.valueOf('Some Text');
                document.ContentType = 'application/pdf';
                document.DeveloperName = 'my_document';
                document.IsPublic = true;
                document.Name = 'JobSuite_OrganizationLogo';
                document.FolderId = [select id from folder where name = 'JobSuiteFolder'].id;
                insert document; 
         StatusReport  ext1 = new StatusReport();
         
        
   
    }
}