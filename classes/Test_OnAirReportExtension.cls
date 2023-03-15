@istest
public class Test_OnAirReportExtension 
{
	//Test Method 
 /*  static testMethod void Test_OnAirReportExtension()
   {
      Media_Type__c objMedia = new Media_Type__c (Name = 'Test Media type-00001');
      insert objMedia;
      
      Schedule_Template__c objSchedule = new Schedule_Template__c(Name = 'Test Schedule Template-00001', Media_Types__c = objMedia.id);
      insert objSchedule;
      
      Campaign__c objCampaign = new Campaign__c(Name = 'Test Campaign -00001');
      insert objCampaign;
      
      GL_Department__c objGLDept = new GL_Department__c(Name = 'Test GL dept - 00001');
      insert objGLDept;
      
      GL_Code__c objGLCode = new GL_Code__c(Name = 'Test GL Code - 00001', GL_Department__c  = objGLDept.id, GL_ID__c = '00001');
      insert objGLCode ;
      
            
      Client__c objClient=new Client__c(Name='Test Client 0001');
      insert objClient;
               
      Client_Contact__c objClientContact=new Client_Contact__c(Name='Test Client Contact',First_Name__c='Test Client Contact',Last_Name__c='00001',Client__c= objClient.id,Email__c='test0001@SFDC.com',UserName__c='test0001@SFDC.com',Salesforce_User__c=True);
      insert objClientContact;    
      
      
      Job__c objJob1 = new Job__c(Name= 'Test Job - 00001', Media_Types__c= objMedia.Id, Schedule_Template__c = objSchedule.id, Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,JS_Client_Contact__c =objClientContact.id,Start_Date__c = System.Today(),Job_Auto_Number__c = '00001');
      insert objJob1 ;
               
      System.assertEquals('Test Job - 00001',objJob1.Name);   
      
      Job_Task__c objTask1 = new  Job_Task__c(Name = 'Test Job Task1 - 00001', GL_Code__c = objGLCode.id, Days__c = 2,Job__c = objJob1.id);
      insert objTask1;
      
      Job_Task__c objTask2 = new  Job_Task__c(Name = 'Test JobTask2 - 00001', GL_Code__c = objGLCode.id, Days__c = 4,Job__c = objJob1.id);
      insert objTask2;      
      
      Job_Team__c objTeam2 = new  Job_Team__c(Role__c= 'Project Manager',Job__c= objJob1.id);
      insert objTeam2 ;     
      
      OnAirReportExtension ext = new OnAirReportExtension();
      List<String> lstCampaign = ext.CampaignList;
      List<String> lstActive = ext.jobStatus;
    
//      List<String> lstScheduleTemplate = ext.scheduleTempList;
//      List<String> lstProperty = ext.jobProperty;
      
//      Schema.DescribeFieldResult field = Job__c.Dummy_Picklist_1__c.getDescribe();
                
//      for(Schema.PicklistEntry f : field.getPicklistValues())
//     {
//          lstProperty.add(f.getLabel());
//     }
//     string  strselectedProperty = lstProperty[0];
    // string strDate = zConvert.ToString(System.Today());
          ApexPages.CurrentPage().getParameters().put('CampaignList',objCampaign.Name);
//          ApexPages.CurrentPage().getParameters().put('PropertyList',strselectedProperty );
          ApexPages.CurrentPage().getParameters().put('MediaList','');
          ApexPages.CurrentPage().getParameters().put('statusList','Active');
          ApexPages.CurrentPage().getParameters().put('JobTeamList',objTeam2.id);
//          ApexPages.currentPage().getParameters().put('startdt1',Datetime.now().format('MM/dd/yyyy'));
//          ApexPages.currentPage().getParameters().put('compdt1', Datetime.now().format('MM/dd/yyyy'));
          ApexPages.CurrentPage().getParameters().put('promoDueDt1',Datetime.now().format('MM/dd/yyyy'));
//          ApexPages.CurrentPage().getParameters().put('strDueDate',Datetime.now().format('MM/dd/yyyy'));
    
    

           
         ApexPages.Pagereference result1 = ext.searchJobs();
          
         result1 = ext.exportTOPDF();
        
      
      List<Job__c> objJobs = new List<Job__c>();
      objJobs.add(objJob1); 
      //PropertyWrapper pWrapper = new PropertyWrapper ();
      // CampaignWrapper  campWrapper = new List<CampaignWrapper>();
     // campWrapper.strcampaign=strselectedProperty ;
     // Wrapper.jobWrapper = objJobs;
      
       List<String> ts = ext.JobTeamList;
       List<String> st = ext.MediaList;
       
       
       ApexPages.Pagereference result2 =ext.clearForm();
      
   }*/

}