//@isTest
Public class TestCreateInvoiceFromPOExtension{
// Start Test Method
         /* static testMethod void TestCreateInvoiceFromPOExtension()
        {
        
        test.starttest();
           Job_Number_Setting__c customSetting993 = new  Job_Number_Setting__c(Name= 'yy');
           
           insert customSetting993;
        
        
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
            try
             {
               insert testMedia;
             }
            catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             }
           
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template22',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 19');
           
                 insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 22',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
               }
            System.assertEquals('Test Job 22',testJob1.Name);
               
            GL_Department__c testGLD = new GL_Department__c(Name='TestGLD15');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }   
                    
            Vendor__c testVendor=new Vendor__c(Name='Test Vendor3');
                 insert testVendor;
             
            GL_Code__c testGL1=new GL_Code__c();
              testGL1.Name='Test GL Code345';
              testGL1.GL_Id__c='GL Code015';
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
             
            Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 20',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Amount__c=500,Quantity__c=120,GL_Code__c =testGL1.Id);   
                 insert testELI;
          
            Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,GL_Code__c=testGL1.Id);
                 insert testPO;
          
            ApexPages.currentPage().getParameters().put('Id', testPO.Id); 
        
          
            PO_Line_Item__c POLI = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
              insert POLI;
           
            PO_Line_Item__c POLI1 = new PO_Line_Item__c(Invoice_Created__c=True,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
              insert POLI1;
              
            Invoice__c testINV = new Invoice__c(Name = 'Test INV 22', Job__c=testJob1.id, Purchase_Order__c=testPO.id, Date_Received__c=System.Today());
           test.stoptest();    
              // Put Purchase Order Id  
             ApexPages.CurrentPage().getParameters().put('POid',testPO.id);
             
             // Instantiate the standard controller with the Invoice
             ApexPages.StandardController con=new ApexPages.StandardController(testINV);
        
             CreateInvoiceFromPOExtension ext=new CreateInvoiceFromPOExtension(con);
            ext.ShowProductionEstimate = true;
       
              // Invoke the primary method on the extension         
             ApexPages.PageReference result1=ext.save();
             ext.roleWraps[0].checked=False;
         
             result1=ext.save();
        
             ext.roleWraps[0].checked=True;
       
            result1=ext.save();
            ApexPages.PageReference result2=ext.cancel();
       }*/
    // End Test Coverage
     /*
       static testMethod void TestCreateInvoiceFromPOExtension1()
        {
        //test.starttest();
           ProductionEstimate__c csetting=new ProductionEstimate__c(Active__c=true);
           insert csetting;
           Job_Number_Setting__c customSetting993 = new  Job_Number_Setting__c(Name= 'yy');
           
           insert customSetting993;
        
        
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
            try
             {
               insert testMedia;
             }
            catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             }
           
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template22',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 19');
           
                 insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 22',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
               }
            System.assertEquals('Test Job 22',testJob1.Name);
               
            GL_Department__c testGLD = new GL_Department__c(Name='TestGLD15');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }   
                    
            Vendor__c testVendor=new Vendor__c(Name='Test Vendor3');
                 insert testVendor;
             
            GL_Code__c testGL1=new GL_Code__c();
              testGL1.Name='Test GL Code345';
              testGL1.GL_Id__c='GL Code015';
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
             
            Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 20',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Amount__c=500,Quantity__c=120,GL_Code__c =testGL1.Id);   
                 insert testELI;
            
             Estimate_Line_Items__c testELI1=new Estimate_Line_Items__c(Name='Quote010',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL1.id,Vendor__c=testVendor.id,Quantity__c=120,Amount__c=500);
             try
              {
                  insert testELI1;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
          
            Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,GL_Code__c=testGL1.Id);
                 insert testPO;
          
            ApexPages.currentPage().getParameters().put('Id', testPO.Id); 
        
          
            PO_Line_Item__c POLI = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Production_Estimate__c=testELI.Id);
              insert POLI;
           
            PO_Line_Item__c POLI1 = new PO_Line_Item__c(Invoice_Created__c=True,Amount__c=5000,Purchase_Order__c=testPO.Id,Production_Estimate__c=testELI.Id);
              insert POLI1;
            
           
            
              
            Invoice__c testINV = new Invoice__c(Name = 'Test INV 22', Job__c=testJob1.id, Purchase_Order__c=testPO.id, Date_Received__c=System.Today());
            //test.stoptest();   
              // Put Purchase Order Id  
             ApexPages.CurrentPage().getParameters().put('POid',testPO.id);
             
             // Instantiate the standard controller with the Invoice
             ApexPages.StandardController con=new ApexPages.StandardController(testINV);
        
             CreateInvoiceFromPOExtension ext=new CreateInvoiceFromPOExtension(con);
            test.startTest();
              // Invoke the primary method on the extension         
             ApexPages.PageReference result1=ext.save();
             ext.roleWraps[0].checked=False;
             result1=ext.save();
             ext.roleWraps[0].checked=True;
             result1=ext.save();
            
            ApexPages.PageReference result2=ext.cancel();
            
        /*   ProductionEstimate__c csetting1=[select id, Active__c From ProductionEstimate__c];
            csetting1.Active__c=false;
            update csetting1;
            
            PO_Line_Item__c POLI1E = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI1.Id);
             insert POLI1E; 
        
            ext.ShowProductionEstimate = false;
            ext.roleWraps[0].checked=false;
       
             ext.save();
        
             ext.roleWraps[0].checked=true;
       
            ext.save();
            ext.cancel();
            test.stopTest();
            //ProductionEstimate__c csetting1=new ProductionEstimate__c(Active__c=false);
           //insert csetting1;
           
           
           
            
            
    /*         CreateInvoiceFromPOExtension ext2=new CreateInvoiceFromPOExtension(con);
            test.startTest();
              // Invoke the primary method on the extension         
             ApexPages.PageReference result12=ext2.save();
             ext2.roleWraps[0].checked=False;
             result12=ext2.save();
             ext2.roleWraps[0].checked=True;
             result1=ext2.save();
            
            ApexPages.PageReference result23=ext2.cancel();
            
            ext2.ShowProductionEstimate = false;
            ext2.roleWraps[0].checked=false;
         
             ext2.save();
        
             ext2.roleWraps[0].checked=true;
       
            ext2.save();
            ext2.cancel();
           test.stopTest();

            
       }*/
    // End Test Coverage

}