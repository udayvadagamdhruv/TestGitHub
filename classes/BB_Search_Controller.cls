public with sharing class BB_Search_Controller {
    
    @AuraEnabled
    public static Integer getTotalNoOfBB(){
        AggregateResult results=[SELECT Count(Id)TotalBB From Billboard__c Where Name!=null WITH SECURITY_ENFORCED];
        Integer totalBB=(Integer)results.get('TotalBB');
        return totalBB;
    }
    
    @AuraEnabled
    public static list<Billboard__c> getBB(Integer intOffSet){
        list<Billboard__c> BBlist=Database.query('select Id, Name,BB_Vendor__r.Name,BB_Vendor__c,Client_Name__r.Name, Client_Name__r.Client_Code__c,Client_Name__c,Expiration_Date__c,Location__c from Billboard__c where name != null WITH SECURITY_ENFORCED LIMIT 50 OFFSET :intOffSet');
        System.debug('=====BBlist==='+BBlist);
        return BBlist;
    }
    
    @AuraEnabled
    public static list<Billboard__c> runSearch(String BB,String CLI,String CLICode,String BBV,String LOC,String ED1,String ED2)
    {
        String soql;
        soql = 'select Id, Name,BB_Vendor__r.Name,BB_Vendor__c,Client_Name__r.Name,Client_Name__r.Client_Code__c,Client_Name__c,Expiration_Date__c,Location__c from Billboard__c where name != null';
        
        if (!BB.equals(''))
            soql += ' and name LIKE \''+String.escapeSingleQuotes(BB)+'%\'';
        
        if (!CLI.equals(''))
            soql += ' and Client_Name__r.Name LIKE \''+String.escapeSingleQuotes(CLI)+'%\'';
        
        if (!CLICode.equals(''))
            soql += ' and Client_Name__r.Client_Code__c LIKE \''+String.escapeSingleQuotes(CLICode)+'%\'';
        
        if (!BBV.equals(''))
            soql += ' and BB_Vendor__r.Name LIKE \''+String.escapeSingleQuotes(BBV)+'%\'';  
        
        if (!LOC.equals(''))
            soql += ' and Location__c LIKE \''+String.escapeSingleQuotes(LOC)+'\'';
        
        if(ED1!=null){
            if(!ED1.equals(''))
                soql += ' and Expiration_Date__c >= '+ String.escapeSingleQuotes(ED1)+' '; 
        }
        if(ED2!=null){
            if(!ED2.equals(''))
                soql += ' and Expiration_Date__c <= '+ String.escapeSingleQuotes(ED2)+' '; 
        }
        soql +=' WITH SECURITY_ENFORCED';
        
       // soql+=' Order by Job_Auto_Number__c desc';
        
        System.debug('======soql========='+soql);
        list<Billboard__c> BBlist=Database.query(soql);
        return BBlist;
    }
   
}