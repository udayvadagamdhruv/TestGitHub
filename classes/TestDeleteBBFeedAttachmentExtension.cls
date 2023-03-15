//@isTest
Public class TestDeleteBBFeedAttachmentExtension{
// Test Coverage 
       /* static testMethod void TestDeleteBBFeedAttachmentExtension()
        {
          Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
            
            Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 1234',BB_Vendor__c=testvendor.id);
           insert testI;
               
           System.assertEquals('test 1234',testI.Name);
               
           Blob b = Blob.valueOf('Hello');

           FeedItem a=new FeedItem (parentId=testI.Id,Body='hello');
           
               insert a;
               
        // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.StandardController(a);
             System.currentPagereference().getParameters().put('Id', a.Id);
        
        // Instantiate the extention instance with the standardcontroller
           DeleteBillboardFeedAttachmentExtension ext=new DeleteBillboardFeedAttachmentExtension(con);
        
        // Invoke the Delete method 
           ApexPages.Pagereference result=ext.checkDelete();
        
        // The below line covers the catch block in checkDetele method 
           ApexPages.Pagereference result1=ext.checkDelete();
     }*/
    // End of Test Coverage



}