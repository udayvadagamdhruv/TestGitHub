public with sharing class ClientController {
    
    @AuraEnabled
    public static String getObjectType(List<String> ObjNames) {
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
    }
    
    @AuraEnabled 
    public static Boolean getisAccessable()
    {
        boolean ShowMap;
        // Client Control custom setting 
        ClientControl__c  activeSettings = ClientControl__c.getOrgDefaults();
        ShowMap= activeSettings.Detail_Page_Map__c;
        return ShowMap;
    }
    
    @AuraEnabled
    public static List<String> getFieldsforObject(String sObjName) {
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.FieldSet> fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        
        string fieldsetname;
        for (string s: fieldMap.keyset())
            fieldsetname = s;
        List<Schema.FieldSetMember> fields = fieldMap.get(fieldsetname).getFields();
        List<string> fieldsname = new List<string> ();
        
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        return fieldsname;
    }
    
    @AuraEnabled
    public static String geLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        return objlabel;
    }
    
    /******************************************************* Get Latitude and Longitude Records ***************************************************************/
    @AuraEnabled
    public static Client__c ClientLoc(Id recordId) {
        system.debug('record id' + recordId);
        Client__c ClientLoc = [SELECT Id,Name,Latitude__c,Longitude__c FROM Client__c where Id = : recordId WITH SECURITY_ENFORCED];
        return ClientLoc;
    }
    
    // ================================================= Delete Client Records ===================================================================//
    @AuraEnabled
    public static string DeleteClient(String ClientId){
        
        try{
            Client__c DeleteClient =[Select id,Name from Client__c where id =:ClientId WITH SECURITY_ENFORCED];
            if(Schema.sObjectType.Client__c.isDeletable()){
                delete DeleteClient;
                return 'OK';
            }
            else{
                return 'Client has insufficient access to delete the record';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    /******************************************************* Get Client Contact Records ***************************************************************/
    @AuraEnabled
    public static list<SObject> ClientContacts(Id recordId) {
        system.debug('record id' + recordId);
        List <Client_Contact__c> Client_contacts = [SELECT Id,Name, Client__r.Name ,Client__c, Business_Phone__c,Active__c, Email__c, Mobile_Phone__c, Fax__c, UserName__c, Department__c, Salesforce_User__c FROM Client_Contact__c where Client__c = : recordId WITH SECURITY_ENFORCED];
        return Client_contacts;
    }
    
    // This method is called on to populate Roles from Organization
    @AuraEnabled
    public Static Map <Id, String> getRole()
    {
        Map < Id, String > optionMap = new Map < Id, String > ();//WITH SECURITY_ENFORCED        
        for (UserRole roles :[SELECT Id,Name FROM UserRole  ORDER BY Name])  
        {    
            optionMap.put(roles.Id, roles.name);
        }
        return optionMap; 
    }
    
    // ================================================= Delete Client Contact Records ===================================================================//
    @AuraEnabled
    public static string DeleteCCon(String CConId){
       
        try{
            Client_Contact__c DeleteCCon =[Select id,Name,Client__c from Client_Contact__c where id =:CConId WITH SECURITY_ENFORCED];
            string Clientid=DeleteCCon.Client__c;
            if(!(Client_Contact__c.sObjectType.getDescribe().isDeletable())){
                return 'Client Contact has insufficient access to delete the record';
                
            }
            else{
                delete DeleteCCon;
                return 'OK';
            }
           
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
	
	@AuraEnabled
    public static List<Job__c> ClientContactJobs(Integer recordLimit, Integer recordOffset,Id recordId) {
       Integer intLimit = Integer.valueof(recordLimit);
        system.debug('---intLimit---'+intLimit);
        Integer intOffset = Integer.valueof(recordOffset);
         system.debug('---intOffset---'+intOffset);
        List<Job__c> Jobs=[Select id,Name,JS_Client__c,Job_Auto_Number__c,Campaign__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client_Contact__c =: recordId WITH SECURITY_ENFORCED ORDER BY Job_Auto_Number__c LIMIT :intLimit Offset :intOffset];
        system.debug('Jobs.size()---'+Jobs.size());
        return Jobs;
    }
     //Get Total Number of Records
    @AuraEnabled
    public static Integer getTotalClientContactJobs(Id recordId,String JobStatusString){
        AggregateResult results = [SELECT Count(Id) TotalRecords  from Job__c where JS_Client_Contact__c =: recordId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
	
    /******************************************************* Get Client Job Records ***************************************************************/ 
    @AuraEnabled
    public static list<String> fetchPicklistvalues(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Job__c.Status__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    } 
    
    @AuraEnabled
    public static list<Job__c> getClientJobs(Integer recordLimit, Integer recordOffset, Id recordId,String JobStatusString) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        
        system.debug('record id' + recordId);
        List <Job__c> ClientJobs = [Select id,Name,JS_Client__c,Job_Auto_Number__c,Campaign__c,JS_Client_Contact__c,JS_Client_Contact__r.Name,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: recordId and status__c = : jobstatusstring WITH SECURITY_ENFORCED Order BY Job_Auto_Number__c LIMIT :intLimit Offset :intOffset];
        return ClientJobs;
    }
    
    //Get Total Number of Records
    @AuraEnabled
    public static Integer getTotalCJRecords(Id recordId,String JobStatusString){
        AggregateResult results = [SELECT Count(Id) TotalRecords  from Job__c where JS_Client__c =: recordId and status__c = : jobstatusstring WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    @AuraEnabled
    public static list<Client_Invoice__c> getClientInvs(Integer recordLimit, Integer recordOffset, Id recordId) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        
        system.debug('record id' + recordId);
        List <Client_Invoice__c> ClientInvs = [Select id,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Job__r.Name,Notes__c,Term__c from Client_Invoice__c where Client_Name__c =: recordId WITH SECURITY_ENFORCED Order BY Name LIMIT :intLimit Offset :intOffset];
        return ClientInvs;
    }
    
    //Get Total Number of Records
    @AuraEnabled
    public static Integer getTotalCInvRecords(Id recordId){
        AggregateResult results = [SELECT Count(Id) TotalRecords from Client_Invoice__c where Client_Name__c =: recordId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    
      /******************************************************* Get Client BillBoard Records ***************************************************************/
    @AuraEnabled
    public static list<Billboard__c> getClientBB(Integer recordLimit, Integer recordOffset, Id recordId,String Status) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        system.debug('record id' + recordId);
        List<String> statusList=Status.split(';');
        List <Billboard__c> vendorBB = [Select id,Name,Billboard_Type__c,Expiration_Date__c,Client_Name__c,Client_Name__r.Name,Location__c,BB_Vendor__c,BB_Vendor__r.Name,Title__c,Billboard_Status__c,PMT__c from Billboard__c where Client_Name__c=: recordId and Billboard_Status__c IN:statusList WITH SECURITY_ENFORCED  Order BY Name LIMIT :intLimit Offset :intOffset];
        return vendorBB;
    } 
    
    /********************************************** Get Total Number of Records ************************************************************************/
    @AuraEnabled
    public static Integer getTotalCBBRecords(Id recordId,String Status){
        List<String> statusList=Status.split(';');
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Billboard__c where Client_Name__c=: recordId and Billboard_Status__c IN:statusList WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    @AuraEnabled
    public static list<String> BBfetchPicklistvalues(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Billboard__c.Billboard_Status__c.getDescribe().getPicklistValues();
        //Options.add('All Billboards');
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    } 
}