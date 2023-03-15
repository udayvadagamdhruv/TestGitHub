//@isTest
public class CreateInvoiceFromPOTest{
/*static testMethod void CreateInvoiceFromPOTest()
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
             ext.orgId = userInfo.getOrganizationId();
              // Invoke the primary method on the extension         
             ApexPages.PageReference result1=ext.save();
             ext.roleWraps[0].checked=False;
             ext.roleWraps[0].Calc_amnt=5000;
             result1=ext.save();
        
             ext.roleWraps[0].checked=True;
             ext.roleWraps[0].Calc_amnt=5000;       
             result1=ext.save();

             ApexPages.PageReference result3=ext.save();
             ext.roleWraps[0].checked=True;
             ext.roleWraps[0].Calc_amnt=5001;       
             result3=ext.save();
                       
            ApexPages.PageReference result2=ext.cancel();
   }*/
}