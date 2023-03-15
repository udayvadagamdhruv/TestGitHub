@isTest
Public class TestClientDetailPageMapExt{
static testMethod void TestClientDetailPageMapExt(){


          Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
           
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;

           ApexPages.currentPage().getParameters().put('id',testClient.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testClient);
     
           // Instantiate the extention instance with the standard controller
           ClientDetailPageMapExt ext =new ClientDetailPageMapExt(con);
           
            Test.startTest();
            List<Billboard__c> str = ClientDetailPageMapExt.findAll(testClient.Id);
            Test.stopTest();
            
           // Invoke the primary method on the extension 
           
           
           
             
}



}