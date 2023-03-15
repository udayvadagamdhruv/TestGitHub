//@isTest
Public Class TestDisplayClientInvunderjobtabextension{
 // Start Test Coverage Code 
     /* static testMethod void TestDisplayClientInvunderjobtabextension()
      {
           DisplayClientInvoiceunderjobtabextension ext=new DisplayClientInvoiceunderjobtabextension();
           
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 313');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 313',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 314',Media_Types__c=testMedia.Id);
               insert testST1;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 313');
               insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 314');
               insert testSpec1;
           
           Job__c testJob1=new Job__c(Name='Test Job 314',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
          
            Client_Invoice__c  testI=new Client_Invoice__c(Job__c=testjob1.Id,Client_Name__c=testClient.Id);
            insert testI;
           
           System.assertEquals('Test Job 314',testJob1.Name);  
           
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
            
           // Instantiate the extention instance with the Custom Controller
           
           DisplayClientInvoiceunderjobtabextension ext1=new DisplayClientInvoiceunderjobtabextension();
          
          // Invoke the CreateInvoice method on the extension
           ApexPages.PageReference result1=ext1.CreateCI();
           Double result2=ext1.getSumCash();
           ext1.ciid= testI.Id;
           ext1.save(); // Invoke the Save and Cancel method on the extension
           ext1.cancelme();
           ext1.del();
           
          
    } 
 // End of test Method
*/

}