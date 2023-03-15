@IsTest
Public class sendMailTest{
    public static testMethod void sendMailTest(){
        Development_Item__c objDev = new Development_Item__c();
        
        objDev.Name = 'TestDev01';
        objDev.Platform__c = 'Saleforce';        
        objDev.Priority__c = '1';
        objDev.Status__c = 'Open';
        objDev.Estimate_Number__c = 'test001';
        objDev.Description__c = 'This is test development item';
        insert objDev;
        
        objDev = new Development_Item__c();
        objDev = [select Status__c , Description__c  from Development_Item__c where Name='TestDev01'];
        objDev.Description__c  = 'This one is changed description';
        update objDev;
    }
}