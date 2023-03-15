public with  Sharing class customLookUpController {
    @AuraEnabled
    public static list<String> getcustomLookUpObjectLables(String ObjAPIName, String DObjeAPIName){
        System.debug('=====ObjAPIName==='+ObjAPIName);
        System.debug('=====DObjeAPIName==='+DObjeAPIName);
        list<String> ObjLableList=new  list<String>();
        if(ObjAPIName!=null && ObjAPIName!=''){
            ObjLableList.add(Schema.getGlobalDescribe().get(ObjAPIName).getDescribe().getLabel());
        }
        if(DObjeAPIName!=null && DObjeAPIName!=''){
            ObjLableList.add(Schema.getGlobalDescribe().get(DObjeAPIName).getDescribe().getLabel());
        }
        return ObjLableList;
    }
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName,String ParentFilter,String ParentSortBy) {
        List <sObject> returnList = new List <SObject> ();
        
        system.debug('========ObjectName=======' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        DescribeSObjectResult describeResult =Schema.getGlobalDescribe().get(ObjectName).getDescribe();
       // List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	
        
         // Create a Dynamic SOQL Query For Fetch Records  
       // String sQuery =' SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName() +' where Name LIKE: searchKey';
       String sQuery =' SELECT Id,Name FROM ' + describeResult.getName() +' where Name LIKE: searchKey ';
        
        if(ParentFilter!='' && ParentFilter!=null ){
            sQuery+=' And '+ParentFilter; 
        }
        if(ParentSortBy!='' && ParentSortBy!=null){
            sQuery+='  WITH SECURITY_ENFORCED '+ParentSortBy; 
        }
      
         returnList = Database.query(sQuery);
        System.debug('======SOquey of Media Type========'+sQuery);
        return returnList;
    }
    
    
    @AuraEnabled
    public static List < sObject > getDependetRecords(String depsearchKeyWord,String ParentRecId, String ObjectName,String RelationShipName, String ChildFilter, String ChildSortBy) {
        system.debug('======ObjectName=======' + ObjectName); 
        string ParentId=ParentRecId;
        String depsearchKey = depsearchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        
        DescribeSObjectResult describeResult =Schema.getGlobalDescribe().get(ObjectName).getDescribe();
        //List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	

         // Create a Dynamic SOQL Query For Fetch Records  
        //String sQuery =' SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName()+' where Name Like:depsearchKey AND '+RelationShipName+'=:ParentId';
        String sQuery =' SELECT Id,Name FROM ' + describeResult.getName()+' where Name Like:depsearchKey AND '+RelationShipName+'=:ParentId';

        if(ChildFilter!='' && ChildFilter!=null ){
            sQuery+=' And '+ChildFilter; 
        }
        if(ChildSortBy!='' && ChildSortBy!=null ){
            sQuery+=' WITH SECURITY_ENFORCED '+ChildSortBy; 
        }
       
        System.debug('======Soquy ========'+sQuery);
        returnList=Database.query(sQuery);
        System.debug('======returnList======='+returnList);
        return returnList;
    }
    
}