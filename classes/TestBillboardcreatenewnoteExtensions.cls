//@isTest
public class TestBillboardcreatenewnoteExtensions {
	// Test Coverage 
   /*     static testMethod void TestBillboardcreatenewnoteExtensions()
        {
             Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
           
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
               
               // Instantiate the standard controller with the Job
               
               ApexPages.StandardController con=new ApexPages.StandardController(testI);
                   
               ApexPages.currentPage().getParameters().put('Id', testI.Id);
               
               // Instantiate the extention instance with the standard controller 
               
               BillboardcreatenewnoteExtensions ext= new BillboardcreatenewnoteExtensions(con);
               
               test.startTest();
               
               ext.getmynote();
               
               // Invoke the primary method on the extension
               
               Pagereference pg=ext.SaveNote();
               
               Pagereference pg1=ext.cancelme();
               
               test.stopTest();
        }*/
    // End Test Coverage
}