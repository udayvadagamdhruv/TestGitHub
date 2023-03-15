@isTest
Public class TestaddProductionEstimateLineItem{
/*
static testMethod void TestaddProductionEstimateLineItem()
    {
         Job_Number_Setting__c customSetting955 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting955;
    
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 318');
          try
           {
               insert testMedia;
           }
          catch(System.DMLException e)
           {
               System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
           }
           
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 318',Media_Types__c=testMedia.Id);
          insert testST;
                 
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 318',Media_Types__c=testMedia.Id);
           try
            {
                insert testST1;
            }
           catch(System.DMLException e)
            {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }

           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 318');
           insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 318');
            try
             {
                 insert testSpec1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
              
           Job__c testJob1=new Job__c(Name='Test Job 318',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
             insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             } 
            System.assertEquals('Test Job 318',testJob1.Name);    
                
           Vendor__c testVendor=new Vendor__c(Name='Test Vendor 318');
           insert testVendor;
          
           Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Vendor__c=testVendor.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No');
           insert testPO;
          
           GL_Department__c testGLD = new GL_Department__c(Name='TestGLD6');
            try
             {
                 insert testGLD;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
          
           GL_Code__c testGL=new GL_Code__c();
            testGL.Name='Test GL Code21';
            testGL.GL_Id__c='GL Code555';
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
            testGL1.Name='Test GL Code22';
            testGL1.GL_Id__c='GL Code565';
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
         
           Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 20',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,GL_Code__c=testGL.id,Amount__c=2000,Quantity__c=120);
           insert testELI;
          
           Production_Estimate__c testELI1=new Production_Estimate__c(Name='Estimate 21',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,GL_Code__c=testGL1.Id,Amount__c=5000,Quantity__c=100);
           insert testELI1;
          
           Production_Estimate__c ELI=[Select id,Name,Total_cost__c,Vendor__c,Job__c,Approved__c From Production_Estimate__c where Vendor__c =: testVendor.Id and Job__c =: testJob1.Id and Approved__c = true and PO_Created__c = false limit 1];
          
            ApexPages.currentPage().getParameters().put('id',testPO.Id);
            addProductionEstimateLineItem ext=new addProductionEstimateLineItem();
           
            // Invoke the primary method on the extension
            ApexPages.PageReference result=ext.Save(); 
            ext.roleWraps[0].checked=True;
            result=ext.save();   
            ApexPages.PageReference result1=ext.Back();     
         
    }
   // End of Test Coverage 
   
    static testMethod void TestaddEstimateLineItem()
    {
         Job_Number_Setting__c customSetting955 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting955;
    
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 318');
          try
           {
               insert testMedia;
           }
          catch(System.DMLException e)
           {
               System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
           }
           
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 318',Media_Types__c=testMedia.Id);
          insert testST;
                 
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 318',Media_Types__c=testMedia.Id);
           try
            {
                insert testST1;
            }
           catch(System.DMLException e)
            {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }

           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 318');
           insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 318');
            try
             {
                 insert testSpec1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
              
           Job__c testJob1=new Job__c(Name='Test Job 318',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
             insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             } 
            System.assertEquals('Test Job 318',testJob1.Name);    
                
           Vendor__c testVendor=new Vendor__c(Name='Test Vendor 318');
           insert testVendor;
          
           Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Vendor__c=testVendor.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No');
           insert testPO;
          
           GL_Department__c testGLD = new GL_Department__c(Name='TestGLD6');
            try
             {
                 insert testGLD;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
          
           GL_Code__c testGL=new GL_Code__c();
            testGL.Name='Test GL Code21';
            testGL.GL_Id__c='GL Code555';
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
            testGL1.Name='Test GL Code22';
            testGL1.GL_Id__c='GL Code565';
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
           
             
            
            
          Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote010',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=TestGL.id,Vendor__c=testVendor.id,Approved__c=true,PO_Created__c=false,Amount__c=100,Quantity__c=10);
             try
              {
                  insert testELI;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
        
        
           
            ApexPages.currentPage().getParameters().put('id',testPO.Id);
            addEstimateLineItem ext1=new addEstimateLineItem();
           
            // Invoke the primary method on the extension
            ApexPages.PageReference resEst1=ext1.Save(); 
            ApexPages.PageReference resEst2=ext1.Back();
            ext1.roleWraps[0].checked=True;
            ApexPages.PageReference resEst3=ext1.Save(); 
         
    }*/


}