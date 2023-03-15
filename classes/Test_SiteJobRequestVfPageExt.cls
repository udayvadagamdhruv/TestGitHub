@isTest
public class Test_SiteJobRequestVfPageExt {


    //Public string MTName;
  
       
     static testMethod void Test_SiteJobRequestVfPageExt2()
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
         
          Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='Active',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign1;
         
          Client__c a =new Client__c(Name='Account001');
          insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 001',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
          insert c;

          Client_Contact__c c2=new Client_Contact__c(First_Name__c='Contact 002',Last_Name__c='LN002',Client__c=a.id,Email__c='testEmail002@sfdc.com',UserName__c='testEmail002@sfdc.com',Salesforce_User__c=False);
          insert c2;

          Job__c testJob22=new Job__c(Name='Job0022',Due_Date__c = system.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
          insert testJob22;
          
          Job__c testJob1=new Job__c(Name='Job0023',Due_Date__c = system.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
       
          ApexPages.StandardController con=new ApexPages.StandardController(testjob1);
          
          SiteJobRequestFormVfPageExt ext=new SiteJobRequestFormVfPageExt(con);
         
        
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
          
          ext.ClientName = a.Id;
          String ClientName1 = ext.getClientName();
          ext.setClientName(ClientName1);
          List<SelectOption> options10 = ext.getClients();
          
      
          ApexPages.Pagereference result4=ext.saveme();    
          ext.cancelme(); 
          
         
         
          ext.CampaignName  = testCampaign1.Name; 
          String CampaignName= ext.getCampaignName();
          ext.setCampaignName(CampaignName);
          List<SelectOption> options11 = ext.getCampaigns();
         
         
          ext.MTName = testMedia.Id; // To check MediaType as NULL
          String MTName6 = ext.getMTName();
          ext.setMTName(MTName6);
          List<SelectOption> options12 = ext.getMediaTypes();
          
          ext.ScheduleTemp = testST.Id;
          String ScheduleTemp6 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp6);
          List<SelectOption> options13 = ext.getScheduleTemplates();
          
          ext.SpecTempName = testSpec.Id;          
          String SpecTempName6 = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName6);
          List<SelectOption> options14 = ext.getSpecificationTemplates();
          
          ext.ClientName = a.Id;
          String ClientName2 = ext.getClientName();
          ext.setClientName(ClientName2);
          List<SelectOption> options15 = ext.getClients();
          
         
          ApexPages.Pagereference result6=ext.saveme();    
          ApexPages.Pagereference result7=ext.cancelme(); 
          
         
          ext.CampaignName  = null; 
          String CampaignName1= ext.getCampaignName();
          ext.setCampaignName(CampaignName1);
          List<SelectOption> options16 = ext.getCampaigns();
         
         
         
          ext.MTName = testMedia.Id; // To check MediaType as NULL
          String MTName7= ext.getMTName();
          ext.setMTName(MTName7);
          List<SelectOption> options17 = ext.getMediaTypes();
          
          ext.ScheduleTemp = testST.Id;
          String ScheduleTemp7= ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp7);
          List<SelectOption> options18 = ext.getScheduleTemplates();
          
          ext.SpecTempName = testSpec.Id;          
          String SpecTempName7 = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName7);
          List<SelectOption> options19 = ext.getSpecificationTemplates();
          
          ext.ClientName = a.Id;
          String ClientName3 = ext.getClientName();
          ext.setClientName(ClientName3);
          List<SelectOption> options20 = ext.getClients();
          
          
          ext.CCName= a.Id;
          String CCName = ext.getCCName();
          ext.setCCName(CCName);
          List<SelectOption> options21 = ext.getClientContacts();
        
ext.obJob =new Job__c(Name=null,Due_Date__c = null,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
          ApexPages.Pagereference result123=ext.saveme(); 
         ext.obJob =new Job__c(Name='Job123',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
          ApexPages.Pagereference result1234=ext.saveme(); 
         
ext.obJob =new Job__c(Name='Job1234',Due_Date__c = System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
         ext.MTName = 'MTName';
         ext.ScheduleTemp = 'ScheduleTemp';
         ext.ClientName = 'ClientName';
         ext.CCName = 'ccname';
         ext.CampaignName = null;
          string CampainNamee = ext.getCampaignName();
         ext.setCampaignName(CampainNamee);
       //  ApexPages.Pagereference resultc=ext.saveme();
         
         ext.obJob =new Job__c(Name='Job1234',Due_Date__c = System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
         ext.MTName = testMedia.Id;
         ext.ScheduleTemp = testST.Id;
         ext.ClientName = a.Id;
         ext.CCName = a.Id;
         ext.CampaignName = testCampaign1.id;
          string CampainNameee = ext.getCampaignName();
         ext.setCampaignName(CampainNameee);
         ApexPages.Pagereference resultce=ext.saveme();
         
          SiteJobRequestForm.getFieldsforObject('Job__c','JobRequestFormFields');
         SiteJobRequestForm.getObjectType(new list<String>{'Job__c'});
         SiteJobRequestForm.CustomSettingData();
         SiteJobRequestForm.geLabelforObject('Job__c');
         SiteJobRequestForm.imageURL();      
         SiteJobRequestForm.getSpecrecords(testSPI.id);
         SiteJobRequestForm.getSpecTemp();
         SiteJobRequestForm.SaveSpecrecWithJob(testJob1.id,new list<Spec_Item__c>{testSPI});
         SiteJobRequestForm.saveChunk(testJob1.id,'testfile', 'ttque31', '', '');
         //SiteJobRequestForm.saveTheFile(testJob1.id, 'testfile', 'ttque31', '');
     }
       
       
       
    

}