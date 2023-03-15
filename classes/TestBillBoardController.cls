@IsTest
public class TestBillBoardController {
	public static testMethod void TestBillBoardController(){  
        Client__c testClient=new Client__c(Name='Client 623',Client_Code__c='22');
        insert testClient;  
        
        Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
        insert testvendor; 
        
        Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
        insert testI;
        
        Billboard__c  testI2=new Billboard__c(Client_Name__c=testClient.Id,name='test 1234',BB_Vendor__c=testvendor.id);
        insert testI2;
        
        Billboard_Contract__c testBC=new Billboard_Contract__c(Billboard__c=testI.id);
        insert testBC;
        
        Billboard_Contract__c testBC1=new Billboard_Contract__c(Billboard__c=testI.id);
        insert testBC1;
        
        Billboard_Invoice__c testbi=new Billboard_Invoice__c(name='bbi',Billboard__c=testI.id);
        insert testbi;
        
        Billboard_Invoice__c testbi2=new Billboard_Invoice__c(name='bbi',Billboard__c=testI.id);
        insert testbi2;
        
        Billboard_Invoice_Line_Item__c testbbli=new Billboard_Invoice_Line_Item__c(Billboard_Invoice__c=testbi.id);
        insert testbbli;
        
        Billboard_Invoice_Line_Item__c testbbli1=new Billboard_Invoice_Line_Item__c(Billboard_Invoice__c=testbi.id);
        insert testbbli1;
        
        BB_Invoice_Payment__c testbbp = new BB_Invoice_Payment__c(Billboard_Invoice__c=testbi.id);
        insert testbbp;
        
        BB_Invoice_Payment__c testbbp1 = new BB_Invoice_Payment__c(Billboard_Invoice__c=testbi.id);
        insert testbbp1;
        
        List<Billboard_Invoice_Line_Item__c> BBInvList=[select id,name from Billboard_Invoice_Line_Item__c where Billboard_Invoice__c=:testbi.id];
       
        test.startTest();
        BillBoardController.getFieldsforObject('Billboard__c');
        BillBoardController.geLabelforObject('Account');
        BillBoardController.BBLoc(testI.Id);
        BillBoardController.DeleteBB(testI2.Id);
        BillBoardController.getBBInvrecords(testI.Id);
        BillBoardController.DeleteBBInv(testbi2.Id);
        BillBoardController.getBBInvLIrecords(testbbli.Id);
        BillBoardController.updateBBInvLI(BBInvList);
        BillBoardController.getBBInvPayrecords(testbbp.Id);
        BillBoardController.DeleteBBInvPay(testbbp1.Id);
        BillBoardController.getBBConrecords(testBC.Id);
        BillBoardController.DeleteBBCon(testBC1.Id);
        BillBoardController.DeleteBBInvLI(testbbli1.Id);
        BillBoardController.FetchObjectType(new list<string>{'Job__c'});
        
        BB_Search_Controller.getTotalNoOfBB();
        BB_Search_Controller.getBB(1);
        BB_Search_Controller.runSearch('test 123', 'Client 623', '22', 'Test vendor', '', '', '');
        test.stopTest();
    }
}