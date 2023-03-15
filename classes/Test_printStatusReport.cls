//@istest
public class Test_printStatusReport 
{
	   //Test Method 
    /*   static testMethod void Test_printStatusReport()
       {
        Media_Type__c objMedia = new Media_Type__c (Name = 'Test Media type-00001');
        insert objMedia;
        
        Schedule_Template__c objSchedule = new Schedule_Template__c(Name = 'Test Schedule Template-00001', Media_Types__c = objMedia.id);
        insert objSchedule;
        
        Campaign__c objCampaign = new Campaign__c(Name = 'Test Campaign -00001');
        insert objCampaign;
        
        Staff__c objJobTeam=new Staff__c(Name='Test staf-0001',UserName__c='test@test.com');
        insert objJobTeam;
        
        GL_Department__c objGLDept = new GL_Department__c(Name = 'Test GL dept - 00001');
        insert objGLDept;
        
        GL_Code__c objGLCode = new GL_Code__c(Name = 'Test GL Code - 00001', GL_Department__c  = objGLDept.id, GL_ID__c = '00001');
        insert objGLCode ;
        
            
        Client__c objClient=new Client__c(Name='Test Client 0001');
        insert objClient;
        Client__c objClient1=new Client__c(Name='Test Client 0002');
        insert objClient1;
               
        Client_Contact__c objClientContact=new Client_Contact__c(Name='Test Client Contact',First_Name__c='Test Client Contact',Last_Name__c='00001',Client__c= objClient.id,Email__c='test0001@SFDC.com',UserName__c='test0001@SFDC.com',Salesforce_User__c=True);
        insert objClientContact;    
        
        
        Job__c objJob1 = new Job__c(Name= 'Test Job - 00001', Media_Types__c= objMedia.Id,Status__c = 'Active', Schedule_Template__c = objSchedule.id, Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,JS_Client_Contact__c =objClientContact.id,Start_Date__c = System.Today(),Job_Auto_Number__c = '00001');
        insert objJob1 ;
               
        System.assertEquals('Test Job - 00001',objJob1.Name);   
        Job__c objJob2 = new Job__c(Name= 'Test Job - 00002', Media_Types__c= objMedia.Id,Status__c = 'Active', Schedule_Template__c = objSchedule.id, Campaign__c  = objCampaign.Id,JS_Client__c = objClient1.id,Start_Date__c = System.Today(),Job_Auto_Number__c = '00002');
        insert objJob2 ;
               
       
               
        
        Job_Task__c objTask1 = new  Job_Task__c(Name = 'Test Job Task1 - 00001', GL_Code__c = objGLCode.id, Days__c = 2,Job__c = objJob1.id);
        insert objTask1;
        
        Job_Task__c objTask2 = new  Job_Task__c(Name = 'Test JobTask2 - 00001', GL_Code__c = objGLCode.id, Days__c = 4,Job__c = objJob2.id);
        insert objTask2; 
        Job_Task__c objTask3 = new  Job_Task__c(Name = 'Test JobTask3 - 00001', GL_Code__c = objGLCode.id, Days__c = 4,Job__c = objJob2.id);
        insert objTask3;   
             
        
        Job_Task_Role__c objTaskRole1 = new  Job_Task_Role__c(Name = 'Test Role 1',User__c = 'Test User1' ,Job_Task__c = objTask1 .id );
        insert objTaskRole1 ;
      
        Job_Task_Role__c objTaskRole2 = new  Job_Task_Role__c(Name = 'Test Role 2',User__c = 'Test User2' ,Job_Task__c = objTask2 .id);
        insert objTaskRole2 ;
        
        Job_Task_Role__c objTaskRole3 = new  Job_Task_Role__c(Name = 'Test Role 3',User__c = 'Test User3' ,Job_Task__c = objTask1 .id );
        insert objTaskRole3 ;
      
        Job_Task_Role__c objTaskRole4 = new  Job_Task_Role__c(Name = 'Test Role 4',User__c = 'Test User4' ,Job_Task__c = objTask3 .id);
        insert objTaskRole4 ;
      
          printStatusReport ext = new printStatusReport();
          List<String> lstCampaign = ext.CampaignList;
          List<String> lstJobTeam = ext.JobTeamList;
          List<String> lstJob = ext.JobList;
          List<String> lstActive = ext.jobStatus;
          List<String> lstClient = ext.clientList;
          List<String> lstScheduleTemplate = ext.scheduleTempList;
           List<String> lstMediaList = ext.MediaList;
    
       
      
       
   
      ApexPages.CurrentPage().getParameters().put('CampaignList','');
          ApexPages.CurrentPage().getParameters().put('clientList','');
          ApexPages.CurrentPage().getParameters().put('JobTeamList','');
          ApexPages.CurrentPage().getParameters().put('JobList','');
          ApexPages.CurrentPage().getParameters().put('statusList','Active');
          ApexPages.CurrentPage().getParameters().put('MediaList','');
          ApexPages.CurrentPage().getParameters().put('scheduleTempList','');
          ApexPages.CurrentPage().getParameters().put('startdt1','');
                
       ApexPages.Pagereference  result2 = ext.searchJobs();
        result2 =ext.clearForm();
       result2 = ext.exportToPDF();
       
        ApexPages.CurrentPage().getParameters().put('CampaignList',objCampaign.Name);
          ApexPages.CurrentPage().getParameters().put('clientList',objClient.Name);
          ApexPages.CurrentPage().getParameters().put('JobTeamList',objJobTeam.Name);
          ApexPages.CurrentPage().getParameters().put('JobList',objJob1.Name);
          ApexPages.CurrentPage().getParameters().put('statusList','Active');
          ApexPages.CurrentPage().getParameters().put('MediaList','objMedia');
          ApexPages.CurrentPage().getParameters().put('scheduleTempList',objSchedule.Name);
          ApexPages.CurrentPage().getParameters().put('startdt1',Datetime.now().format('MM/dd/yyyy'));
          
       ApexPages.Pagereference  result3 = ext.searchJobs();
        result3 =ext.clearForm();
       result3 = ext.exportToPDF();
   }*/
}