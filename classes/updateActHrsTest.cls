@IsTest
Public class updateActHrsTest{
    public static testMethod void updateActHrsTest(){    
        Development_Item__c objDev = new Development_Item__c();
        
        objDev.Name = 'TestDev01';
        objDev.Platform__c = 'Saleforce';        
        objDev.Priority__c = '1';
        objDev.Status__c = 'Open';
        objDev.Estimate_Number__c = 'test001';
        objDev.Description__c = 'This is test development item';
        insert objDev;
        
        Time_Sheet__c objTs = new Time_Sheet__c();
        objTs.Name = objDev.Name;
        objTs.Dev_Item__c = objDev.Id;
        objTs.TS_Long_Description__c = 'Worked on testdev01';
        objTs.TS_Date__c = date.today();
        objTs.Developer__c = UserInfo.getUserId();
        objTs.Hours__c = 5.5;
        objTs.Duration__c = 6.0; 
        insert objTs;   
        
        objTs.TS_Long_Description__c = 'Worked extra';
        objTs.Hours__c = 1.5;
        objTs.Duration__c = 3.5;        
        update objTs;
        
        delete objTs;
    }    
}