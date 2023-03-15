//@isTest
 Public Class  TestAddInvoiceLineItemNewExtension{
 
 /*static testMethod void TestAddInvoiceLineItemNewExtension()
        {
            Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
            
           Media_Type__c testMedia=new Media_Type__c(Name='TM01March');
            try
             {
               insert testMedia;
             }
            catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             }
           
           Schedule_Template__c testST=new Schedule_Template__c(Name='TST01March',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='TST01March');
           
                 insert testSpec;
                
           Job__c testJob1=new Job__c(Name='TJ01March',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
               }
            System.assertEquals('TJ01March',testJob1.Name);
               
            GL_Department__c testGLD = new GL_Department__c(Name='GLD01March');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }   
                    
            Vendor__c testVendor=new Vendor__c(Name='TV01March');
            insert testVendor;
             
            GL_Code__c testGL1=new GL_Code__c();
              testGL1.Name='TGLCode01March';
              testGL1.GL_Id__c='GLC01March';
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
             Vendor_GL_Code__c testVGLCode = new Vendor_GL_Code__c(Vendor__c = testVendor.id,GL_Code__c = testGL1.id);
             insert testVGLCode;
             
             Invoice__c inv = new Invoice__c(Name = 'INV00987',Job__c=testJob1.id,Vendor__c = testVendor.id,Revised_Amount__c = 1000);
             insert inv;
             
             Invoice_Line_Item__c ILI = new Invoice_Line_Item__c(GL_Code__c = testGL1.id,Amount__c = 900);
                   
            // Invoke the primary method on the extension 
            ApexPages.currentPage().getParameters().put('Invid',inv.Id);
            ApexPages.StandardController con=new ApexPages.StandardController(ILI);
            
            // Instantiate the extention instance with the standard controller
            
            AddInvoiceLineItemNewExtension ext=new AddInvoiceLineItemNewExtension(con); 
            List<SelectOption> options1 = ext.getGLCode();       
        
            // Invoke the primary method on the extension
           
             ApexPages.PageReference result1=ext.saveme();
             ApexPages.PageReference result2=ext.cancelme();
       }*/
       
 }