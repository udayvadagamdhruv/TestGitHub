//@isTest
Public Class TestDisplayInvoiceAllocationLIController{

/*static testMethod void TestDisplayInvoiceAllocationLIController()
     {
           
           
           Invoice_Allocation_Template__c Iat= new Invoice_Allocation_Template__c(Name='Test IAt');
           insert Iat;
           
           Invoice_Allocation_Template_Line_Item__c IATLI=new Invoice_Allocation_Template_Line_Item__c(Invoice_Allocation_Template__c=Iat.id);
           
           insert IATLI;
           Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
     
            Media_Type__c testMedia=new Media_Type__c(Name='TM02Mar');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='TST02Mar',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='TST02Mar');
               insert testSpec;
           
           Job__c testJob1=new Job__c(Name='TJ02Mar',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('TJ02Mar',testJob1.Name);  
     
     
     
           Client_Invoice__c ESI = new Client_Invoice__c (Name='INV01March',Job__c=testJob1.id);
           insert ESI;
           
           GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1101');
           insert testGLD;
           
           GL_Code__c testGL=new GL_Code__c(Name='GL Code 1101',GL_ID__c='TestGL9988',GL_Department__c = testGLD.id);
           insert testGL;
           
           Vendor__c v = new Vendor__c(Name = 'Tset');
           
           Invoice_Allocation_Line_Item__c ina= new Invoice_Allocation_Line_Item__c(Client_Invoice__c =ESI.id);
           insert ina;
         
           Invoice_Allocation_Line_Item__c ina1= new Invoice_Allocation_Line_Item__c(Client_Invoice__c =ESI.id);
           insert ina1;
            
            ApexPages.currentPage().getParameters().put('id',ESI.Id);
         // Instantiate the extention instance with the Custom Controller
           DisplayInvoiceAllocationLIController ext1=new DisplayInvoiceAllocationLIController();
          
            // Invoke the primary method on the extension
           ApexPages.PageReference result1=ext1.createIALI();
           Double result2=ext1.getSumCash();
           Double result3=ext1.getSumQuant();
           ext1.strIALI= ina.Id;
           result1 = ext1.save();
            ext1.rowIndex=0;
            ext1.inlineInAllTemp();
            ext1.inlineSave();
           result1 = ext1.cancelme();
           result1 = ext1.deleteIALI();
           List<SelectOption> clients=ext1.getInvAllocationTemplates();
           ext1.InvAllocationTempName='Test IAt';
           result1 = ext1.importIATLI();
      } 
     // End of test Method
*/

}