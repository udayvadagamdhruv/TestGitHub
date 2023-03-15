@isTest
Public class TestProductionEstimateReportExtension{
static testMethod void TestProductionEstimateReportExtension()
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
         
           Production_Estimate__c testELI=new Production_Estimate__c(Name='Estimate 1318',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL1.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,Amount__c=2000,Quantity__c=120);
           insert testELI;
          
           Production_Estimate__c testELI1=new Production_Estimate__c(Name='Estimate 1319',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL1.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,Amount__c=5000,Quantity__c=100);
           insert testELI1;
          
           
            ApexPages.currentPage().getParameters().put('id',testJob1.Id);
            ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
            ProductionEstimateReportExtension ext=new ProductionEstimateReportExtension(con);
           
           ext.theId=testJob1.id;
           Double s=ext.getSumCash();

}







}