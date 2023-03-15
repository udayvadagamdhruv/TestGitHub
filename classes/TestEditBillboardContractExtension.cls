//@isTest
Public class TestEditBillboardContractExtension{
// Test Coverage Code
    /* Private static testMethod void TestEditBillboardContractExtension()
     {
         Client__c testClient=new Client__c(Name='Client 623');
           insert testClient; 
          Vendor__c testvendor=new Vendor__c (Name='Vendor 623',Vendor_Type__c ='Outdoor');
           insert testvendor; 
   
          Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
            insert testI;
           
          Billboard_Contract__c bbc=new Billboard_Contract__c(Billboard__c=testI.id,BB_Vendor_Name__c=testvendor.id);
           try
           {
               insert bbc; 
           }
          catch(System.DMLException e)
           {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
           }

         Billboard_Contract__c  testBBC = [Select id,BB_Vendor_Name__c,Billboard__c from Billboard_Contract__c  where id =:bbc.Id];

         // Instantiate the standard controller with the Invoice
         ApexPages.StandardController con=new ApexPages.StandardController(testBBC);
         ApexPages.currentPage().getParameters().put('Id',testBBC.Id);

         // Instantiate the extention instance with the standard controller 
          EditBillboardContractExtension ext=new EditBillboardContractExtension(con);
        
         // Invoke the primary method on the extension 
          ApexPages.PageReference result1=ext.saveme();
          result1=ext.saveme();
           List<SelectOption> vendors=ext.getVendors();
          string result4=ext.getVendorName();
          ext.setVendorName('Test vendor');
       }    */
   // End of Test Coverage Case

}