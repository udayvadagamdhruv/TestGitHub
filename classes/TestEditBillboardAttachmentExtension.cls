@isTest
public class TestEditBillboardAttachmentExtension{
	// Start Test Coverage
  /*   static testMethod void TestEditBillboardAttachmentExtension()
    {
           Profile p=[Select Id from Profile where Name='System Administrator' limit 1];
            
           User u=[Select Id from User where IsActive=: True and profileId=: p.Id Limit 1];
            
            System.runAs(u)
           {
           
          
           Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
           
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
               
            Billboard__c  testI2=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI2;    

               Blob b = Blob.valueOf('Hello World');
               
               System.assertEquals('test 123',testI2.Name);

               Attachment a=new Attachment(parentId=testI2.Id,Name='Test File',Body=b);
               insert a;
               
               ApexPages.currentPage().getParameters().put('Id', a.Id);
            
               // Instantiate the standard controller with the Attachment 
               ApexPages.StandardController con=new ApexPages.StandardController(a);
        
               // Instantiate the extention instance with the standardcontroller 
               EditJobAttachmentExtension ext=new EditJobAttachmentExtension(con);
        
               // Invoke the primary method on the extension
               ApexPages.PageReference result=ext.SaveAttachment();
        
               ApexPages.currentPage().getParameters().put('Id', a.Id);
            
               // Instantiate the standard controller with the Job 
               ApexPages.StandardController con1=new ApexPages.StandardController(a);
        
              // Instantiate the extention instance with the standardcontroller 
              EditBillboardAttachmentExtension ext1=new EditBillboardAttachmentExtension(con1);
        
              // Invoke the primary method on the extension
                result=ext1.cancelme();
        
                delete a;
                result=ext1.SaveAttachment();
           }
    // End of Test Coverage
}*/
}