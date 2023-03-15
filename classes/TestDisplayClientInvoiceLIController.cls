//@isTest
Public class TestDisplayClientInvoiceLIController{
/*
 static testMethod void TestDisplayClientInvoiceLIController()
     {
           
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
           
           Estimate_Line_Items__c eli = new Estimate_Line_Items__c(Name = 'Test Eli', GL_Department__c = testGLD.Id, GL_Code__c = testGL.Id,Job__c = testJob1.Id,Quantity__c = 12,Vendor__c = v.Id);
           
           Production_Estimate__c peli = new Production_Estimate__c(Name = 'Test PEli', GL_Department__c = testGLD.Id, GL_Code__c = testGL.Id,Job__c = testJob1.Id,Quantity__c = 12);
           
           Client_Invoice_Line_Item__c ili = new Client_Invoice_Line_Item__c(Client_Invoice__c = ESI.Id,GL_Code__c = testGL.Id,Billable_Amount__c= 100,Estimate_Line_Item__c = eli.Id );
           insert ili;
           
            ApexPages.currentPage().getParameters().put('id',ESI.Id);

            
           
              // Instantiate the extention instance with the Custom Controller
           DisplayClientInvoiceLIController ext1=new DisplayClientInvoiceLIController();
          
           
            // Invoke the primary method on the extension
           ApexPages.PageReference result1=ext1.add_ELI();
           result1 = ext1.add_PELI();
           ext1.strCILI= ili.Id;
           result1 = ext1.save();
           result1 = ext1.cancelme();
           result1 = ext1.deleteCILI();
      } 
     // End of test Method

*/

}