//@istest
Public class TestEditBillboardExtension{
/*
static testMethod void TestEditBillboardExtension()
      {
           Client__c testClient=new Client__c(Name='Test client');
           insert testClient; 
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
   
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
          System.assertEquals('test 123',testI.Name);
          
         
          
           Billboard__c  testBB = [Select id,name,BB_Vendor__c,Client_Name__c  from Billboard__c  where id =:testI.Id];
          
            note a1=new note(ParentId=testBB.id,Title='Test Title 852',IsPrivate=True,Body='Test Note Body');
            insert a1;
          
             // Instantiate the standard controller with the Client
          ApexPages.StandardController con = new ApexPages.StandardController(testBB);
           ApexPages.CurrentPage().getParameters().put('id',testBB.id);
            // Instantiate the extention instance with the standardcontroller
          
          EditBillboardExtension ext = new EditBillboardExtension(con);
        
        // Invoke the primary method on the extensio
          ApexPages.PageReference result1=ext.saveme();
          ApexPages.PageReference result2=ext.cancelme();
          
          result1=ext.saveme();
          List<SelectOption> vendors=ext.getVendors();
          List<SelectOption> Clients=ext.getClients();
           
          string result4=ext.getVendorName();
          string result5=ext.getClientName();
          ext.setClientName('Test Client');
          ext.setVendorName('Test vendor');
          
          System.currentPagereference().getParameters().put('Id',a1.id);
          EditBillboardNoteLightning edic=new EditBillboardNoteLightning(new ApexPages.StandardController(a1));
          Apexpages.pagereference pp12=edic.SaveNote();
          pp12=edic.cancelme();
          
          
     }// End of Test Coverage
*/

}