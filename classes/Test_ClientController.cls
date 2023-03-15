@IsTest
public class Test_ClientController {
    public static testMethod void Test_ClientController(){  
        
        Client__c TestClnt=new Client__c(Name='Test Cllient',Active__c=true);
        insert TestClnt;
        
        Client_Contact__c testCC = new Client_Contact__c(First_Name__c='Test Client', Last_Name__c='Contact' ,Name = 'Test Client Contact', Client__c=TestClnt.id, Email__c='testClientContact9897@SFDC.com');     
        insert testCC;
        
        Test.startTest();
        
        ClientController.getFieldsforObject('Client__c');
        ClientController.geLabelforObject('Account');
        ClientController.getRole();
        ClientController.fetchPicklistvalues();
        ClientController.ClientLoc(TestClnt.Id);
        ClientController.DeleteClient(TestClnt.Id);
        ClientController.ClientContacts(TestClnt.Id);
        
        ClientController.ClientContactJobs(10,10,TestClnt.Id);
        ClientController.getClientJobs(10,10,TestClnt.Id,'Active');
        ClientController.getTotalCJRecords(TestClnt.Id,'Active');
        ClientController.getClientInvs(10,10,TestClnt.Id);
        ClientController.getTotalCInvRecords(TestClnt.Id);
        ClientController.BBfetchPicklistvalues();
        ClientController.getisAccessable();
        ClientController.getObjectType(new list<string>{'job__c'});
        ClientController.getClientBB(10,10,TestClnt.Id,'Active');
        ClientController.getTotalCBBRecords(TestClnt.Id,'Active');
        ClientController.DeleteCCon(testCC.Id);
        Test.stopTest();
        
    }
}