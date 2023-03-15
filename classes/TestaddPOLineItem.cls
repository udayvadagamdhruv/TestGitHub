//@isTest
Public class TestaddPOLineItem {
 // Start Test Method
   /*static testMethod void TestAddPOLineItem()
     {
     test.starttest();
        Job_Number_Setting__c cs1999 = new  Job_Number_Setting__c(Name= 'yy');
        insert cs1999;
        
        Media_Type__c testMedia=new Media_Type__c(Name='TM 2999');
        try
         {
          insert testMedia;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
           
        Schedule_Template__c testST=new Schedule_Template__c(Name='TST2999',Media_Types__c=testMedia.Id);
        insert testST;
                 
        Specification_Template__c testSpec=new Specification_Template__c(Name='TST2999');
        insert testSpec;
                
        Job__c testJob1=new Job__c(Name='TJ2999',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
         {
          insert testJob1;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
        System.assertEquals('TJ2999',testJob1.Name);
           
        GL_Department__c testGLD = new GL_Department__c(Name='TGLD2999');
         try
          {
           insert testGLD;
          }
         catch(System.DMLException e)
          {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }   
                    
        Vendor__c testVendor=new Vendor__c(Name='TV2999');
        insert testVendor;
             
        GL_Code__c testGL1=new GL_Code__c();
          testGL1.Name='TGLC2999';
          testGL1.GL_Id__c='GL 2999';
          testGL1.GL_Department__c=testGLD.id;
          testGL1.Unit_Cost__c=2500;
          testGL1.Unit_Type__c='Days';
             
        try
         {
          insert testGL1;
         }
        catch(System.DMLException e)
         {
          System.assert(e.getMessage().contains('Record already exist with same GLCode'));
         }
             
        Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='ELI 2999',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Amount__c=500,Quantity__c=120,GL_Code__c =testGL1.Id);   
        insert testELI;
          
        Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,GL_Code__c=testGL1.Id);
        insert testPO;
          
        PO_Line_Item__c POLI = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
        insert POLI;
           
        PO_Line_Item__c POLI1 = new PO_Line_Item__c(Invoice_Created__c=True,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
        insert POLI1;
              
        Invoice__c testI=new Invoice__c(Job__c=testjob1.Id,Date_Received__c=System.Today(),Vendor__c=testVendor.Id,Purchase_Order__c=testPO.id);  
        insert testI;
            
        ApexPages.currentPage().getParameters().put('Invid', testI.Id);    
      
       // Invoke the primary method on the extension 
       addPOLineItem ext=new addPOLineItem();
       ApexPages.PageReference result1=ext.save();
             ext.roleWraps[0].checked=False;
         
             result1=ext.save();
        
             ext.roleWraps[0].checked=True;
       
            result1=ext.save();
            ApexPages.PageReference result2=ext.Back();
	  test.stoptest(); 
     }
   // End Test Coverage
   
   static testMethod void TestAddPOLineItem1()
     {
     
     test.starttest();
        ProductionEstimate__c cs11etting=new ProductionEstimate__c(Active__c=true);
           insert cs11etting;
        Job_Number_Setting__c cs1999 = new  Job_Number_Setting__c(Name= 'yy');
        insert cs1999;
        
        Media_Type__c testMedia=new Media_Type__c(Name='TM 2999');
        try
         {
          insert testMedia;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
           
        Schedule_Template__c testST=new Schedule_Template__c(Name='TST2999',Media_Types__c=testMedia.Id);
        insert testST;
                 
        Specification_Template__c testSpec=new Specification_Template__c(Name='TST2999');
        insert testSpec;
                
        Job__c testJob1=new Job__c(Name='TJ2999',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
         {
          insert testJob1;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
        System.assertEquals('TJ2999',testJob1.Name);
           
        GL_Department__c testGLD = new GL_Department__c(Name='TGLD2999');
         try
          {
           insert testGLD;
          }
         catch(System.DMLException e)
          {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }   
                    
        Vendor__c testVendor=new Vendor__c(Name='TV2999');
        insert testVendor;
             
        GL_Code__c testGL1=new GL_Code__c();
          testGL1.Name='TGLC2999';
          testGL1.GL_Id__c='GL 2999';
          testGL1.GL_Department__c=testGLD.id;
          testGL1.Unit_Cost__c=2500;
          testGL1.Unit_Type__c='Days';
             
        try
         {
          insert testGL1;
         }
        catch(System.DMLException e)
         {
          System.assert(e.getMessage().contains('Record already exist with same GLCode'));
         }
             
        Production_Estimate__c  testELI=new Production_Estimate__c (Name='ELI 2999',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Amount__c=500,Quantity__c=120,GL_Code__c =testGL1.Id);   
        insert testELI;
          
        Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,GL_Code__c=testGL1.Id);
        insert testPO;
          
        PO_Line_Item__c POLI = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Production_Estimate__c =testELI.Id);
        insert POLI;
           
        PO_Line_Item__c POLI1 = new PO_Line_Item__c(Invoice_Created__c=True,Amount__c=5000,Purchase_Order__c=testPO.Id,Production_Estimate__c =testELI.Id);
        insert POLI1;
              
        Invoice__c testI=new Invoice__c(Job__c=testjob1.Id,Date_Received__c=System.Today(),Vendor__c=testVendor.Id,Purchase_Order__c=testPO.id);  
        insert testI;
              test.stoptest();
        ApexPages.currentPage().getParameters().put('Invid', testI.Id);    
      
       // Invoke the primary method on the extension 
       addPOLineItem ext=new addPOLineItem();
       ApexPages.PageReference result1=ext.save();
             ext.roleWraps[0].checked=False;
         
             result1=ext.save();
        
             ext.roleWraps[0].checked=True;
       
            result1=ext.save();
            ApexPages.PageReference result2=ext.Back();

     }
   // End Test Coverage
	static testMethod void TestAddPOLineItem2()
     {
     
     test.starttest();
        ProductionEstimate__c cs11etting=new ProductionEstimate__c(Active__c=false);
           insert cs11etting;
        Job_Number_Setting__c cs1999 = new  Job_Number_Setting__c(Name= 'yy');
        insert cs1999;
        
        Media_Type__c testMedia=new Media_Type__c(Name='TM 2999');
        try
         {
          insert testMedia;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
           
        Schedule_Template__c testST=new Schedule_Template__c(Name='TST2999',Media_Types__c=testMedia.Id);
        insert testST;
                 
        Specification_Template__c testSpec=new Specification_Template__c(Name='TST2999');
        insert testSpec;
                
        Job__c testJob1=new Job__c(Name='TJ2999',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
         {
          insert testJob1;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
        System.assertEquals('TJ2999',testJob1.Name);
           
        GL_Department__c testGLD = new GL_Department__c(Name='TGLD2999');
         try
          {
           insert testGLD;
          }
         catch(System.DMLException e)
          {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }   
                    
        Vendor__c testVendor=new Vendor__c(Name='TV2999');
        insert testVendor;
             
        GL_Code__c testGL1=new GL_Code__c();
          testGL1.Name='TGLC2999';
          testGL1.GL_Id__c='GL 2999';
          testGL1.GL_Department__c=testGLD.id;
          testGL1.Unit_Cost__c=2500;
          testGL1.Unit_Type__c='Days';
             
        try
         {
          insert testGL1;
         }
        catch(System.DMLException e)
         {
          System.assert(e.getMessage().contains('Record already exist with same GLCode'));
         }
             
        Production_Estimate__c  testELI=new Production_Estimate__c (Name='ELI 2999',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Amount__c=500,Quantity__c=120,GL_Code__c =testGL1.Id);   
        insert testELI;
          
        Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,GL_Code__c=testGL1.Id);
        insert testPO;
          
        PO_Line_Item__c POLI = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Production_Estimate__c =testELI.Id);
        insert POLI;
           
        PO_Line_Item__c POLI1 = new PO_Line_Item__c(Invoice_Created__c=True,Amount__c=5000,Purchase_Order__c=testPO.Id,Production_Estimate__c =testELI.Id);
        insert POLI1;
              
        Invoice__c testI=new Invoice__c(Job__c=testjob1.Id,Date_Received__c=System.Today(),Vendor__c=testVendor.Id,Purchase_Order__c=testPO.id);  
        insert testI;
              test.stoptest();
        ApexPages.currentPage().getParameters().put('Invid', testI.Id);    
      
       // Invoke the primary method on the extension 
       addPOLineItem ext=new addPOLineItem();
       ApexPages.PageReference result1=ext.save();
             ext.roleWraps[0].checked=False;
         
             result1=ext.save();
        
             ext.roleWraps[0].checked=True;
       		 ext.roleWraps[0].Calc_amnt = 0;
            result1=ext.save();
            ApexPages.PageReference result2=ext.Back();

     }*/


}