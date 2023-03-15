@isTest

Public class TestBillboardAttachment
{
static testMethod void BillboardAttachment()
{

 Material_Item__c  testI=new Material_Item__c (name='test 123');
    insert testI;
    
 Client__c testClient=new Client__c(Name='Test client');
           insert testClient; 
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
   
           Billboard__c  BtestI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert BtestI;   
     
attachment att= new attachment(name='test', parentid=testI.id, body=Blob.valueOf('Unit Test Attachment Body')); 
    
insert att;  
attachment att1= new attachment(name='test1', parentid=testI.id, body=Blob.valueOf('Unit Test Attachment Body1'));  
insert att1;
attachment att2= new attachment(name='test2', parentid=BtestI.id, body=Blob.valueOf('Unit Test Attachment Body2'));  
insert att2;

attachment att3= new attachment(name='test3', parentid=BtestI.id, body=Blob.valueOf('Unit Test Attachment Body2'));  
insert att3;

attachment att4= new attachment(name='test4', parentid=BtestI.id, body=Blob.valueOf('Unit Test Attachment Body2'));  
insert att4;

 delete att;                          
 delete att2;                 
  }

}