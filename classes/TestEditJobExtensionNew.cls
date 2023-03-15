//@isTest

Public class TestEditJobExtensionNew{


  /*  Static testMethod void TestEditJobExtensionNew()
     {
     Job_Number_Setting__c customSetting998 = new  Job_Number_Setting__c(Name= 'yy');
             insert customSetting998;
          
          Media_Type__c testMedia=new Media_Type__c(Name='MT011');
              insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST011',Media_Types__c=testMedia.Id);
              insert testST;
          
          Schedule_Task__c testSchedule1=new Schedule_Task__c(Name='Test Schedule Task 011',Days__c=2,Schedule_Template__c=testST.id);
              insert testSChedule1;   
           
          Schedule_Task__c testSchedule2=new Schedule_Task__c(Name='Test Schedule Task 012',Days__c=2,Schedule_Template__c=testST.id);
              insert testSChedule2;   
   
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT011');
              insert testSpec;
         
          Spec_Item__c testSPI1=new Spec_Item__c(Name='Test Spec Item 0011',Specification_Template__c=testSpec.id);
              insert testSPI1;
         
          Spec_Item__c testSPI2=new Spec_Item__c(Name='Test Spec Item 0012',Specification_Template__c=testSpec.id);
              insert testSPI2;
        
          Campaign__c testCampaign1=new Campaign__c(Name='C011',Active__c=True,Status__c='Active');
              insert testCampaign1;
         
        
          Client__c a=new Client__c(Name='Account011');
              insert a;
              
          Client__c b=new Client__c(Name='Client1001');
              insert b;    
              
          Client__c a1=new Client__c(Name='Account011');
             try
              {
               insert a1;     
              }
             catch(System.DMLException e)
              {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
              }
            
          Client__c a2 = [select id,Name from Client__c where id =: a.id];
            a2.Name = 'Client1001';
            try
             {
             update a2;
             }
            catch(System.DMLException e)
             {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
             }
            
         
          Client_Contact__c c=new Client_Contact__c(Name='Contact 011 LN011',First_Name__c='Contact 011',Last_Name__c='LN011',Client__c=a.id,Email__c='testC011@SFDC.com');
              insert c;
                
          Job__c testJob1=new Job__c(Name='Job011',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
           try
            {
                insert testJob1;
            }
           catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
          System.assertEquals('Job011',testJob1.Name);  
                  
         // Instantiate the standard controller with the Job
          ApexPages.StandardController con=new ApexPages.StandardController(testjob1);
          ApexPages.currentPage().getParameters().put('Id',testJob1.id);
          // Instantiate the extention instance with the standard controller
          
          EditJobExtensionNew ext=new EditJobExtensionNew(con);
          
          // Invoke the primary method on the extension 
          ApexPages.Pagereference result=ext.saveme();
          
        Specification_Template__c testSpec1=new Specification_Template__c(Name='SPT012');
              insert testSpec1;
         
          Spec_Item__c testSPI3=new Spec_Item__c(Name='Test Spec Item 0013',Specification_Template__c=testSpec1.id);
              insert testSPI3;
         
          Spec_Item__c testSPI4=new Spec_Item__c(Name='Test Spec Item 0014',Specification_Template__c=testSpec1.id);
              insert testSPI4;
         
          Schedule_Template__c testST1=new Schedule_Template__c(Name='ST014',Media_Types__c=testMedia.Id);
              insert testST1;
          
          Schedule_Task__c testSchedule3=new Schedule_Task__c(Name='Test Schedule Task 014',Days__c=2,Schedule_Template__c=testST1.id);
              insert testSChedule3;   
           
          Schedule_Task__c testSchedule4=new Schedule_Task__c(Name='Test Schedule Task 015',Days__c=2,Schedule_Template__c=testST1.id);
              insert testSChedule4; 
           
          Job__c objJob=[Select id from Job__c where id=:testJob1.id];
             
          objJob.Specification_Template__c=testSpec1.id;
          objJob.Schedule_Template__c=testST1.id;
          objJob.Campaign__c = null;
         
         
          update objJob; 
    
         Delete testCampaign1;
          ext.ApprovePe='true';ext.markDone='true';ext.SpectempName = 'spec';
         ext.MTName = NULL;  
          String MTName1 = ext.getMTName();
          ext.setMTName(MTName1);
          List<SelectOption> options6 = ext.getMediaTypes();
          result=ext.saveme();
          
          ext.ScheduleTemp = NULL;
          String ScheduleTemp1 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp1);
          List<SelectOption> options7 = ext.getScheduleTemplates();   
          result=ext.saveme();
          
          ext.MTName = testMedia.id;
          String MTName = ext.getMTName();
          ext.setMTName(MTName);
          List<SelectOption> options = ext.getMediaTypes(); 
          
         ext.ClientName = a.id;
          String ClientName = ext.getClientName();
          ext.setClientName(ClientName);
          List<SelectOption> options1 = ext.getClients(); 
          
          ext.CCName = c.Id;
          String CCName = ext.getCCName();
          ext.setCCName(CCName);
          List<SelectOption> options2 = ext.getClientContacts();
          
          ext.ScheduleTemp = testST.id;
          String ScheduleTemp = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp);
          List<SelectOption> options3 = ext.getScheduleTemplates(); 
          
         ext.CampaignName = testCampaign1.id;
          String CampaignName = ext.getCampaignName();
          ext.setCampaignName(CampaignName);
          List<SelectOption> options4 = ext.getCampaigns(); 
          
          ext.SpecTempName = testSpec.Id;
          String SpecTempName = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName);
          List<SelectOption> options5 = ext.getSpecificationTemplates();
     
          ext.ScheduleCalc= NULL;
          String ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
          List<SelectOption> options8 = ext.getScheduleCalcList();
          result=ext.saveme();
     
          result=ext.saveme();
          result=ext.saveme();
          result=ext.cancelme();
          result=ext.revertMediaType();
          
   
      }*/


}