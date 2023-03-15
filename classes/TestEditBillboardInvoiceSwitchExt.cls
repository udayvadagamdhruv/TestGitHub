//@isTest
public class TestEditBillboardInvoiceSwitchExt {
	/* static testMethod void TestBillboardContractSwitchExt (){
	       Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
           
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
        
        
          Billboard_Contract__c testBC=new Billboard_Contract__c(Billboard__c=testI.id);
          insert testBC;
          
          Billboard_Contract__c testBC1=new Billboard_Contract__c(Billboard__c=testI.id);
          insert testBC1;
        
          Billboard_Invoice__c testbi=new Billboard_Invoice__c(name='bbi',Billboard__c=testI.id);
          insert testbi;
        
        
    
    		 ApexPages.currentPage().getParameters().put('id',testbi.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testbi);
           // Instantiate the extention instance with the standard controller
           EditBillboardInvoiceSwitchExt ext =new EditBillboardInvoiceSwitchExt(con);
         
        
    }*/
}