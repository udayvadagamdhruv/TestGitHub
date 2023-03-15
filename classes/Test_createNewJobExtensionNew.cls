@isTest
public class Test_createNewJobExtensionNew{
    //Public string MTName;
    static testMethod void Test_createNewJobExtensionNew()
 {/*
          Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting001;
            
          Media_Type__c testMedia=new Media_Type__c(Name='TM001');
          insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST001',Media_Types__c=testMedia.Id);
          insert testST;
   
          Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST001',Schedule_Template__c=testST.Id);
          insert testSCT1;
                 
          Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST002',Schedule_Template__c=testST.Id);
          insert testSCT2;
                 
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='R001',Schedule_Task__c=testSCT1.Id);
          insert testSTR1;
                 
          ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='R002',Schedule_Task__c=testSCT2.Id);
          insert testSTR2;            
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT001');
          insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='SI001',Specification_Template__c=testSpec.Id); 
          insert testSPI;
         
          Campaign__c testCampaign1=new Campaign__c(Name='C01',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign1;
     
          Campaign__c testCampaign11=new Campaign__c(Name='C02',Active__c=True,Status__c='Active',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign11;
     		
     	  
          Client__c a=new Client__c(Name='Account001');
          insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 001',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
          insert c;
                
          Job__c testJob1=new Job__c(Name='Job002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
          insert testJob1;

          ApexPages.currentPage().getParameters().put('Campaign',testCampaign1.Id);  
          ApexPages.StandardController con=new ApexPages.StandardController(testjob1);
          createNewJobExtensionNew ext=new createNewJobExtensionNew(con);
 		  boolean x=ext.isLtng;
          boolean y=ext.isMob;
          ext.orgId='00DG0000000k48JMAQ';
          ext.startDate=string.valueof(system.today());
          ext.cmpName='camp';
          ext.MTName = NULL; // To check MediaType as NULL
          String MTName2 = ext.getMTName();
          ext.setMTName(MTName2);
          List<SelectOption> options7 = ext.getMediaTypes(); 
          
          ext.ScheduleTemp = testST.id;
          String ScheduleTemp1 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp1);
          List<SelectOption> options8 = ext.getScheduleTemplates();  
          
          
          String ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
          List<SelectOption> options11 = ext.getScheduleCalcList();
          
          ApexPages.Pagereference result=ext.saveme();
          ext.strCampaignName='testcamp';
          ext.MTName = testMedia.id;
          String MTName1 = ext.getMTName();
          ext.setMTName(MTName1);
          List<SelectOption> options9 = ext.getMediaTypes(); 
          
          ext.ScheduleTemp = NULL; // To Check Schedule Template as NULL
          String ScheduleTemp2 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp2);
          List<SelectOption> options10 = ext.getScheduleTemplates();  
          
          ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
          List<SelectOption> options12 = ext.getScheduleCalcList();
            
          result=ext.saveme();
          
          ext.MTName = testMedia.id;
          String MTName = ext.getMTName();
          ext.setMTName(MTName);
          List<SelectOption> options1 = ext.getMediaTypes(); 
          
          ext.ClientName = a.id;
          String ClientName = ext.getClientName();
          ext.setClientName(ClientName);
          List<SelectOption> options2 = ext.getClients(); 
          
          ext.CCName = c.Id;
          String CCName = ext.getCCName();
          ext.setCCName(CCName);
          List<SelectOption> options3 = ext.getClientContacts();
        
          
          ext.ScheduleTemp = testST.id;
          String ScheduleTemp = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp);
          List<SelectOption> options4 = ext.getScheduleTemplates(); 
          
          ext.CampaignName = testCampaign1.id;
          String CampaignName = ext.getCampaignName();
          ext.setCampaignName(CampaignName);
          List<SelectOption> options5 = ext.getCampaigns(); 
          //
          ext.SpecTempName = testSpec.Id;
          String SpecTempName = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName);
          List<SelectOption> options6 = ext.getSpecificationTemplates();
          
          
          ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
           options11 = ext.getScheduleCalcList();
          
          result=ext.saveme();  
          
          //System.assertEquals('Job002',testJob1.Name);
          
           // Delete Job Tasks
         List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob1.Id];
         delete lstTask;
         
         // Delete Job Specs
         
         List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob1.Id];
         delete lstSpecs;
         
         // Delete Estimates
         List<Estimate_Line_Items__c> lstELI=[select id from Estimate_Line_Items__c where Job__c=:testJob1.Id];
         delete lstELI;
        
         // Delete PO's
         List<Purchase_Order__c> lstPO=[select id from Purchase_Order__c where Job__c=:testJob1.Id];
         delete lstPO;

         // Delete Quotes
        List<Quote__c> lstQ=[select id from Quote__c where Job__c=:testJob1.Id];
         delete lstQ;
        
         Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Job002'];
         obj1.Status__c='Cancelled';
         update obj1;

         Job__c obj2=[Select id from Job__c where Name=: 'Job002'];
         delete obj2;
         result=ext.saveme();
         result=ext.cancel();
     	 result=ext.cancelCal();
     result=ext.savemecal();
    */
       }    
    
  
   
}