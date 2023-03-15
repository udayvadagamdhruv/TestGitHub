//@isTest
public class Test_NewJobFromSite{
    /*static testMethod void Test_NewJobFromSite()
     {
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
         
          Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account001');
          insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 001',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
          insert c;
                
          Job__c testJob1=new Job__c(Name='Job002',Due_Date__c = system.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
          
          ApexPages.StandardController con=new ApexPages.StandardController(testjob1);
          
          NewJobFromSite ext=new NewJobFromSite(con);
          
          ext.specList(); 
          
          ext.MTName = null; // To check MediaType as NULL
          String MTName2 = ext.getMTName();
          ext.setMTName(MTName2);
          List<SelectOption> options7 = ext.getMediaTypes();
          
          ApexPages.Pagereference result=ext.saveme(); 
          
          ext.MTName = testMedia.Id; // To check MediaType as NULL
          String MTName3 = ext.getMTName();
          ext.setMTName(MTName3);
          List<SelectOption> options1 = ext.getMediaTypes();
          
          ext.ScheduleTemp = null;
          String ScheduleTemp2 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp2);
          List<SelectOption> options8 = ext.getScheduleTemplates();
          
          ApexPages.Pagereference result2=ext.saveme();
          
          ext.MTName = testMedia.Id; // To check MediaType as NULL
          String MTName4 = ext.getMTName();
          ext.setMTName(MTName4);
          List<SelectOption> options2 = ext.getMediaTypes();
          
          ext.ScheduleTemp = testST.Id;
          String ScheduleTemp1 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp1);
          List<SelectOption> options3 = ext.getScheduleTemplates();
          
          ext.SpecTempName = null;
          String SpecTempName = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName);
          List<SelectOption> options6 = ext.getSpecificationTemplates();
          
          ApexPages.Pagereference result3=ext.saveme();
          
          ext.MTName = testMedia.Id; // To check MediaType as NULL
          String MTName5 = ext.getMTName();
          ext.setMTName(MTName5);
          List<SelectOption> options4 = ext.getMediaTypes();
          
          ext.ScheduleTemp = testST.Id;
          String ScheduleTemp5 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp5);
          List<SelectOption> options5 = ext.getScheduleTemplates();
          
          ext.SpecTempName = testSpec.Id;
          String SpecTempName4 = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName4);
          List<SelectOption> options9 = ext.getSpecificationTemplates();
          
          ApexPages.Pagereference result6=ext.saveme();

          
          
          ApexPages.Pagereference result10=ext.saveme();
          
          ApexPages.Pagereference result9=ext.newJob();
          
          ApexPages.Pagereference result8=ext.cancel();
     }*/
}