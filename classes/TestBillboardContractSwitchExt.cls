//@isTest
public class TestBillboardContractSwitchExt {
  /*  static testMethod void TestBillboardContractSwitchExt (){
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
        
          Billboard_Invoice_Line_Item__c testbbli=new Billboard_Invoice_Line_Item__c(Billboard_Invoice__c=testbi.id);
		  insert testbbli;
        
          BB_Invoice_Payment__c testbbp = new BB_Invoice_Payment__c(Billboard_Invoice__c=testbi.id);
          insert testbbp;
    
    		 ApexPages.currentPage().getParameters().put('id',testI.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testI);
           // Instantiate the extention instance with the standard controller
           BillboardContractSwitchExt ext =new BillboardContractSwitchExt(con);
           BillboardSwitchExt extt=new BillboardSwitchExt(con);
        
           ApexPages.StandardController con1=new ApexPages.StandardController(testBC1);
           BillboardContractListViewSwitchExt ext1 =new BillboardContractListViewSwitchExt(con1);
           Apexpages.pagereference res=ext1.pagedir();
        
        
           ApexPages.StandardController con2=new ApexPages.StandardController(testbi);
           BillboardListViewSwitchExt ext2 =new BillboardListViewSwitchExt(con2);
           Apexpages.pagereference res1=ext2.pagedir();
        
           ApexPages.StandardController con3=new ApexPages.StandardController(testbbli);
           BillboardInvoiceLISwitchExt ext3=new BillboardInvoiceLISwitchExt(con3);
        
           ApexPages.StandardController con4=new ApexPages.StandardController(testbbp);
           BillboardInvoicePaymentSwitchExt ext4=new BillboardInvoicePaymentSwitchExt(con4);
        
    }*/
}