@isTest
Public class Test_JobSearchController{
  static TestMethod void Test_JobSearchController()
     {
         Job_Number_Setting__c customSetting988 = new  Job_Number_Setting__c(Name= 'yy');
         insert customSetting988;
            
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 858');
          Media_Type__c testMedia=new Media_Type__c(Name='Media Type 858');
              insert testMedia;
              
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST858',Media_Types__c=testMedia.Id);
              insert testST;
   
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT858');
              insert testSpec;
                
          Campaign__c testCampaign1=new Campaign__c(Name='Camp858',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
              insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account858');
              insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 858',Last_Name__c='Contact 858',Client__c=a.id,Email__c='testEmail858@sfdc.com',Salesforce_User__c=False);
              insert c;
                
          Job__c testJob1=new Job__c(Name='Job858',Start_Date__c=System.Today(),Job_Description__c ='test description',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
             
              insert testJob1;
         
          Job__c testJob2=new Job__c(Name='Job858',Start_Date__c=System.Today(),Job_Description__c ='test description',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
             
              insert testJob2;
         
        list<Job__c> joblist=new list<Job__c>(); 
         joblist.add(testJob1);
         joblist.add(testJob2);
          System.assertEquals('Job858',testJob1.Name);    
            
         ApexPages.StandardSetController stanSetCon=new ApexPages.StandardSetController(joblist);
          ApexPages.CurrentPage().getParameters().put('jobName',testJob1.Name);
          ApexPages.CurrentPage().getParameters().put('jobDescription',testJob1.Job_Description__c);
          ApexPages.CurrentPage().getParameters().put('clientName',a.Name);
          ApexPages.CurrentPage().getParameters().put('campaignName',testCamp.Name);
          ApexPages.CurrentPage().getParameters().put('status','Active');
          ApexPages.currentPage().getParameters().put('startdt1','11/0/2012');
          ApexPages.currentPage().getParameters().put('startdt2','11/02/2012');
          ApexPages.currentPage().getParameters().put('duedt1','11/0/2012');
          ApexPages.currentPage().getParameters().put('duedt2','11/0/2012');
          ApexPages.CurrentPage().getParameters().put('compdt1','11/0/2012'); 
          ApexPages.CurrentPage().getParameters().put('compdt2','11/0/2012');  
          JobSearchController ext=new JobSearchController(stanSetCon);
          
          //ext.jobName='ABC';
          ext.getPageNumber();
         System.debug('====pageNumber==='+ext.getPageNumber());
          ext.getTotalPageNumber();
        //  ext.runQuery(1);
          ext.toggleSort();
          //ext.previousBtnClick();
         Pagereference pg1=ext.previousBtnClick();
          //ext.nextBtnClick();
        Pagereference pg2=ext.nextBtnClick();
          ext.createNewJob();
          ext.editJob();
          ext.deleteJob();
          ext.getJobs();
          ext.navigate();
          ext.createPDF();
          ext.getPageSize();
          ext.getPreviousButtonEnabled();
          ext.getNextButtonDisabled();
        
          //ext.getJObsW();    //commented by yogini on 10-sep-12
          List<String> a1=ext.status;
          Pagereference result1=ext.runSearch();
          String strDebug=ext.debugSOQL;
          
          Apexpages.currentPage().getParameters().put('jobId',testJob1.id);
          ApexPages.CurrentPage().getParameters().put('ip','false');
          
         // result1=ext.followRecord();
        
          List<Job__c> lst=new List<Job__c>();
          // Bulk Record Insert
          for(Integer i=0;i< 2;i++)
          {
             Job__c obj=new Job__c(Name='Job '+i,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
             
             lst.add(obj);
          }
           insert lst;
           JobSearchController ext1=new JobSearchController();
          // ext1.runQuery(1);
           //ext1.getJObsW();        //commented by yogini on 10-sep-12
           Apexpages.currentPage().getParameters().put('jobId',testJob1.id);
           ApexPages.CurrentPage().getParameters().put('ip','false');
          
         // result1=ext1.followRecord();
          
        // UserUpdatefromClientContactTrigger.UpdateUserWithDetails(Userinfo.getUserId(),'testing','user','testing','','');
        // UserUpdatefromClientContactTrigger.InsertUserWithDetails('');
     } // End of Test Method
    
    //test class for 'PrintQuoteExtension' apex class
     @isTest static  void Test_PrintQuoteExtension()
    {
        Job_Number_Setting__c customSetting1001 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1001;
            
       Media_Type__c testMedia=new Media_Type__c(Name='TM1001');
       insert testMedia;
             
       Schedule_Template__c testST=new Schedule_Template__c(Name='TST1001',Media_Types__c=testMedia.Id);
       insert testST;
                 
       Specification_Template__c testSpec=new Specification_Template__c(Name='TST1001');
       insert testSpec;
                
       Campaign__c testCamp=new Campaign__c(Name='TC1001');    
       insert testCamp;  
   
       Account testClient=new Account(Name='Client1001');
       insert testClient;
               
       Contact testContact=new Contact(FirstName='TCon',LastName='Test',AccountId=testClient.id,Email='testclientcontact1001@SFDC.com');
       insert testContact;    
                      
       Job__c testJob1=new Job__c(Name='TestJ1001',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,Client__c=testClient.id,Client_Contact__c=testContact.id);
       insert testJob1;
               
       System.assertEquals('TestJ1001',testJob1.Name);
       
       GL_Department__c testGLD = new GL_Department__c(Name='GLD001');
       try
        {
        insert testGLD;
        }
       catch(System.DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
       
        GL_Code__c testGL1=new GL_Code__c(Name='GLC1001',GL_ID__c='TestGLC1001',GL_Department__c = testGLD.id,Unit_Type__c='Project',Unit_Cost__c=120);
        try
         {
         insert testGL1;
         }
        catch(System.DMLException e)
         {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }
               
       Quote__c testQ=new Quote__c(Name='Q1001',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL1.id,Quantity__c=20);
       try
        {
        insert testQ;
        }
       catch(System.DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
       System.assertEquals('Q1001',testQ.Name);  
       
       Quote_Spec_Item__c QSI=new Quote_Spec_Item__c(Name='Test QSI',Description__c='Des Test',Quote__c=testQ.Id);
       insert QSI;
       Quote_Spec_Item__c QSI1=new Quote_Spec_Item__c(Name='Test QSI1',Description__c='Des Test1',Quote__c=testQ.Id);
       insert QSI1;
               
       Vendor__c testVendor=new Vendor__c(Name='V1001');
       insert testVendor;
             
       Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
       insert testVQ;        
       ApexPages.currentPage().getParameters().put('id',testVQ.id);
       ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
       PrintQuoteExtension ext=new PrintQuoteExtension(con);
    }
    
    //test class for 'EstimateReportExtension' apex class 
       static testMethod void Test_EstimateReportExtension()
        {
            Job_Number_Setting__c customSetting1008 = new  Job_Number_Setting__c(Name= 'NO');

                insert customSetting1008;
            
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1318');
          try
           {
               insert testMedia;
           }
          catch(System.DMLException e)
           {
               System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
           }
           
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1318',Media_Types__c=testMedia.Id);
          insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1318');
           insert testSpec;
                
          Job__c testJob1=new Job__c(Job_Auto_Number__c='1318',Name='Test Job 1318',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                 insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             } 
            System.assertEquals('Test Job 1318',testJob1.Name);    
                
           Vendor__c testVendor=new Vendor__c(Name='Test Vendor 1318');
               insert testVendor;
          
           Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Vendor__c=testVendor.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No');
               insert testPO;
          
           GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1318');
            try
             {
                 insert testGLD;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
          
           GL_Code__c testGL=new GL_Code__c();
            testGL.Name='Test GL Code1318';
            testGL.GL_Id__c='GL Code1318';
            testGL.Unit_Cost__c=2500;
            testGL.Unit_Type__c='Days';
            testGL.GL_Department__c=testGLD.id;
            try
             {
             insert testGL;
             }
            catch(System.DMLException e)
             {
             System.assert(e.getMessage().contains('Record already exist with same GLCode'));
             }
        
           GL_Code__c testGL1=new GL_Code__c();
            testGL1.Name='Test GL Code1319';
            testGL1.GL_Id__c='GL Code1319';
            testGL1.Unit_Cost__c=1500;
            testGL1.Unit_Type__c='Project';
            testGL1.GL_Department__c=testGLD.id;
            try
             {
                 insert testGL1;
             }
            catch(System.DMLException e)
             {
                 System.assert(e.getMessage().contains('Record already exist with same GLCode'));
             }
         
           Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Estimate 1318',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL1.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,Amount__c=2000,Quantity__c=120);
           insert testELI;
          
           Estimate_Line_Items__c testELI1=new Estimate_Line_Items__c(Name='Estimate 1319',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL1.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,Amount__c=5000,Quantity__c=100);
           insert testELI1;
          
           
            ApexPages.currentPage().getParameters().put('id',testJob1.Id);
            ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
            EstimateReportExtension ext=new EstimateReportExtension(con);
           
           ext.theId=testJob1.id;
           Double s=ext.getSumCash();
        }// End of Test Coverage
     }