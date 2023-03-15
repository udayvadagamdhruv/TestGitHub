@isTest
Public class TestVendorQuoteController{

  /* static testMethod void TestVendorQuoteController()
    {
         ProductionEstimate__c customSetting1 = new  ProductionEstimate__c(Active__c=true);

            insert customSetting1;
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 328');
            insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 328',Media_Types__c=testMedia.Id);
            insert testST;
        
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 328');
            insert testSpec;
      
        Job__c testJob1=new Job__c(Name='Test Job 328',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         try
          {
              insert testJob1;
          }
         catch(System.DMLException e)
          {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
         System.assertEquals('Test Job 328',testJob1.Name);
               
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD12');
          try
           {
               insert testGLD;
           }
          catch(System.DMLException e)
          {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
   
       Quote__c testQ=new Quote__c(Name='Quote 328',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
       try
        {
            insert testQ;
        }
       catch(System.DMLException e)
        {
        System.assertEquals('REQUIRED_FIELD_MISSING',e.getDmlStatusCode(0));
        }
       catch(Exception f)
        {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',f.getDmlStatusCode(0));
        }
        
        Quote_Spec_Item__c qsinew = new Quote_Spec_Item__c(Name='testQSI',Description__c='Desc1',Quote__c=testQ.id);
        insert qsinew;
        
        Quote_Spec_Item__c qsinew1 = new Quote_Spec_Item__c(Name='testQSI1',Description__c='Desc1',Quote__c=testQ.id);
        insert qsinew1;
              
     Vendor__c testVendor=new Vendor__c(Name='Vendor 328');
     insert testVendor;
             
     Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
     insert testVQ;
              
     Vendor_Quote_Line_Item__c testVQLI=new Vendor_Quote_Line_Item__c(Name='test333',Description__c='Des333',Vendor_Quote__c=testVQ.Id); 
     insert testVQLI;
             
     ApexPages.StandardController con=new ApexPages.StandardController(testVQ);
     ApexPages.currentPage().getParameters().put('Id',testVQ.Id);
          
    // Instantiate the extention instance with the standard controller
     VendorQuoteController ext=new VendorQuoteController(con);
        
    // Invoke the primary method on the extension 
     ApexPages.PageReference result1=ext.autoRun();
     delete testVQ;
     result1=ext.autoRun();
    }  
   static testMethod void TestVendorQuoteController1()
    {
         
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 328');
            insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 328',Media_Types__c=testMedia.Id);
            insert testST;
        
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 328');
            insert testSpec;
      
        Job__c testJob1=new Job__c(Name='Test Job 328',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         try
          {
              insert testJob1;
          }
         catch(System.DMLException e)
          {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
         System.assertEquals('Test Job 328',testJob1.Name);
               
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD12');
          try
           {
               insert testGLD;
           }
          catch(System.DMLException e)
          {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
   
       Quote__c testQ=new Quote__c(Name='Quote 328',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
       try
        {
            insert testQ;
        }
       catch(System.DMLException e)
        {
        System.assertEquals('REQUIRED_FIELD_MISSING',e.getDmlStatusCode(0));
        }
       catch(Exception f)
        {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',f.getDmlStatusCode(0));
        }
        
        Quote_Spec_Item__c qsinew = new Quote_Spec_Item__c(Name='testQSI',Description__c='Desc1',Quote__c=testQ.id);
        insert qsinew;
        
        Quote_Spec_Item__c qsinew1 = new Quote_Spec_Item__c(Name='testQSI1',Description__c='Desc1',Quote__c=testQ.id);
        insert qsinew1;
              
     Vendor__c testVendor=new Vendor__c(Name='Vendor 328');
     insert testVendor;
             
     Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
     insert testVQ;
              
     Vendor_Quote_Line_Item__c testVQLI=new Vendor_Quote_Line_Item__c(Name='test333',Description__c='Des333',Vendor_Quote__c=testVQ.Id); 
     insert testVQLI;
             
     ApexPages.StandardController con=new ApexPages.StandardController(testVQ);
     ApexPages.currentPage().getParameters().put('Id',testVQ.Id);
          
    // Instantiate the extention instance with the standard controller
     VendorQuoteController ext=new VendorQuoteController(con);
        
    // Invoke the primary method on the extension 
     ApexPages.PageReference result1=ext.autoRun();
     delete testVQ;
     result1=ext.autoRun();
    } */

}