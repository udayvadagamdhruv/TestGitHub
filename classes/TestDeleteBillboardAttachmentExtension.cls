//@isTest
public class TestDeleteBillboardAttachmentExtension {
	// Test Coverage 
    /*    static testMethod void TestDeleteBillboardAttachmentExtension()
        {
          Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
            
            Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
           
           System.assertEquals('test 123',testI.Name);
               
           Blob b = Blob.valueOf('Hello');

           Attachment a=new Attachment(parentId=testI.Id,Name='Test File',Body=b);
           
               insert a;
               
        // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.StandardController(a);
           ApexPages.currentPage().getParameters().put('Id', a.Id);
        
        // Instantiate the extention instance with the standardcontroller
           DeleteBillboardAttachmentExtension ext=new DeleteBillboardAttachmentExtension(con);
        
        // Invoke the Delete method 
           ApexPages.Pagereference result=ext.checkDelete();
        
        // The below line covers the catch block in checkDetele method 
           ApexPages.Pagereference result1=ext.checkDelete();
     }*/
    // End of Test Coverage
}