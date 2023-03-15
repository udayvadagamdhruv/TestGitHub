//@isTest
public class TestBillboardAttachmentExtensions {
    
    /*static testMethod void TestBillboardAttachmentExtensions()
        {
              Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
           
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
               
               ApexPages.StandardController con=new ApexPages.StandardController(testI);
                   
               ApexPages.currentPage().getParameters().put('Id', testI.Id);
               
               // Instantiate the extention instance with the standard controller 
               BillboardAttachmentExtensions ext= new BillboardAttachmentExtensions(con);
               
               test.startTest();
               
               ext.getmyfile();
               
               // Invoke the primary method on the extension   
               Pagereference pg=ext.SaveDoc();
               
               Pagereference pg1=ext.cancelme();
               
               Billboard__c obj1=[Select id,name from Billboard__c where Name=: 'test 123'];
               obj1.name='Test 234';
               update obj1;
         
               Billboard__c obj2=[Select id from Billboard__c where Name=: 'Test 234'];
               delete obj2;
               pg=ext.SaveDoc();
               
               test.stopTest();
        }*/
    /* End of Test Coverage*/


}