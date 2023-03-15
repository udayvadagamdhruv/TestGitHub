public with sharing class VendorsController {
    
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
    
    
    @AuraEnabled
    public static String getObjectType(List<String> ObjNames) {
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);
    }
    
     
    
     // ================================================= Delete Vendor Records ===================================================================//
    
    @AuraEnabled
    public static string DeleteVen(String VenId){
        Vendor__c DeleteVen =[Select id,Name from Vendor__c where id =:VenId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.Vendor__c.isDeletable()){
                delete DeleteVen;
                return 'OK';
            }
            else{
                return 'Vendor has Insufficient access to Delete';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
        
    }
    
    /******************************************************* Get Vendor Contact Records ***************************************************************/
    @AuraEnabled
    public static list < SObject > vendorContacts(Id recordId) {
        system.debug('record id' + recordId);
        List <Vendor_Contact__c> vendor_contacts = [SELECT Id, Name,First_Name__c,Last_Name__c, Vendor__c, Vendor__r.Name, Active__c, Email__c, Phone_1__c, Phone_2__c FROM Vendor_Contact__c where Vendor__c = : recordId WITH SECURITY_ENFORCED];
        return vendor_contacts;
    }
    
    // This method is called on to populate Roles from Organization
    @AuraEnabled
    public Static Map < Id, String > getRole()
    {
        Map < Id, String > optionMap = new Map < Id, String > ();        
       // optionMap.put(null, '--None--');  //WITH SECURITY_ENFORCED
        for (UserRole roles :[SELECT Id,Name FROM UserRole ORDER BY Name])  
        {    
            optionMap.put(roles.Id, roles.name);
        }
        return optionMap; 
    }
    
     // ================================================= Delete Vendor Contact Records ===================================================================//
    
    @AuraEnabled
    public static string DeleteVenCon(String VenId){
        Vendor_Contact__c DeleteVenCon =[Select id,Name,Vendor__c from Vendor_Contact__c where id =:VenId WITH SECURITY_ENFORCED];
        string Vendorid=DeleteVenCon.Vendor__c;
        try{
            if(Schema.sObjectType.Vendor_Contact__c.isDeletable()){
                delete DeleteVenCon;
                return 'OK';
            }
            else{
                return 'Vendor Contact has Insufficient access to Delete';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    /******************************************************* Get Vendor GLcode Records ***************************************************************/
    @AuraEnabled
    public static list <SObject> vendorGlcode(Id recordId) {
        system.debug('record id' + recordId);
        List <Vendor_GL_Code__c> vendorGlcode = [SELECT GL_Code__c,GL_Code__r.Name,  Vendor__c, Name, Id FROM Vendor_GL_Code__c where Vendor__c = : recordId WITH SECURITY_ENFORCED];
        return vendorGlcode;
    }
    
    // ================================================= Delete Vendor GlCode Records ===================================================================//
    @AuraEnabled
    public static string DeleteVenGlcode(String VenGlcId){
        Vendor_GL_Code__c DeleteVenGlcode =[Select id,Name,Vendor__c from Vendor_GL_Code__c where id =:VenGlcId WITH SECURITY_ENFORCED];
        string Vendorid=DeleteVenGlcode.Vendor__c;
        try{
            if(Schema.sObjectType.Vendor_GL_Code__c.isDeletable()){
                delete DeleteVenGlcode;
                return 'OK';
            }
            else{
                return 'Vendor GL_Code has Insufficient access to Delete';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    
     /************************************************** Populate GLCodes in picklist*******************************************************/
    @AuraEnabled
    public Static List<GL_Code__c> getGLCodes()     
    {
        List<GL_Code__c> ListGLC = new List<GL_Code__c> ();        
        for (GL_Code__c a : [SELECT Id, name FROM GL_Code__c WITH SECURITY_ENFORCED order by Name]) 
        {  
            ListGLC.add(a);
        }
        return ListGLC;  
    }  
    
     /******************************************************* Get Vendor Quote Records ***************************************************************/
    @AuraEnabled
    public static list<Vendor_Quote__c> getvendorQuote(Integer recordLimit, Integer recordOffset, Id recordId) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        
        system.debug('record id' + recordId);
        List <Vendor_Quote__c> vendorQuote = [select id,Name,Date__c,Amount__c,Quote__r.Name,Vendor__r.Name,Vendor__c,Restrict__c,Quote__c,Quote__r.Job__c,Quote__r.Job__r.Name from Vendor_Quote__c where Vendor__c =: recordId WITH SECURITY_ENFORCED Order BY Name LIMIT :intLimit Offset :intOffset];
        return vendorQuote;
    }
    
     //Get Total Number of Records
    @AuraEnabled
    public static Integer getTotalVQRecords(Id recordId){
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Vendor_Quote__c where Vendor__c =: recordId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    
    /******************************************************* Get Vendor PO Records ***************************************************************/
    @AuraEnabled
    public static list<Purchase_Order__c> getvendorPO(Integer recordLimit, Integer recordOffset, Id recordId) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        
        system.debug('record id' + recordId);
        List <Purchase_Order__c > vendorPO = [Select id,Name,Due_Date__c,Job__r.Name,Approved_By_Staff__r.Name,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Vendor__c =: recordId WITH SECURITY_ENFORCED Order BY Name LIMIT :intLimit Offset :intOffset];
        return vendorPO;
    }
    
     //Get Total Number of Records
    @AuraEnabled
    public static Integer getTotalVPRecords(Id recordId){
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Purchase_Order__c where Vendor__c =: recordId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
     /******************************************************* Get Vendor PO Records ***************************************************************/
  
    @AuraEnabled
    public static list<Invoice__c> getvendorInv(Integer recordLimit, Integer recordOffset, Id recordId) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        system.debug('record id' + recordId);
        List <Invoice__c> vendorInv = [Select id,Name,Job__r.Name,Purchase_Order__r.Name,Job__c,Vendor__c,Vendor__r.Name,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c from Invoice__c where Vendor__c =: recordId WITH SECURITY_ENFORCED Order BY Name LIMIT :intLimit Offset :intOffset];
        return vendorInv;
    }
    
    //Get Total Number of Records
    @AuraEnabled
    public static Integer getTotalVINVRecords(Id recordId){
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Invoice__c where Vendor__c =: recordId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    /******************************************************* Get Vendor BillBoard Records ***************************************************************/
    @AuraEnabled
    public static list<Billboard__c> getvendorBB(Integer recordLimit, Integer recordOffset, Id recordId,String Status) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        system.debug('record id' + recordId);
        List<String> statusList=Status.split(';');
        List <Billboard__c> vendorBB = [Select id,Name,Billboard_Type__c,Expiration_Date__c,Client_Name__c,Client_Name__r.Name,Location__c,BB_Vendor__c,BB_Vendor__r.Name,Title__c,Billboard_Status__c,PMT__c	 from Billboard__c where BB_Vendor__c=: recordId and Billboard_Status__c IN:statusList WITH SECURITY_ENFORCED Order BY Name LIMIT :intLimit Offset :intOffset];
        return vendorBB;
    }
    
    /********************************************** Get Total Number of Records ************************************************************************/
    @AuraEnabled
    public static Integer getTotalVBBRecords(Id recordId,String Status){
        List<String> statusList=Status.split(';');
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Billboard__c where BB_Vendor__c=: recordId and Billboard_Status__c IN:statusList WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    @AuraEnabled
    public static list<String> fetchPicklistvalues(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Billboard__c.Billboard_Status__c.getDescribe().getPicklistValues();
        //Options.add('All Billboards');
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    } 
    
    
      /******************************************************* Get Vendor BillBoard Invoice Records ***************************************************************/
    @AuraEnabled
    public static list<Billboard_Invoice__c> getvendorBBI(Integer recordLimit, Integer recordOffset, Id recordId) {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        system.debug('record id' + recordId);
        List <Billboard_Invoice__c> vendorBBI = [Select id,Name,Billboard_Vendor__c,Billboard__c,Billboard__r.Name,BB_Invoice_Due_Date__c,BB_Invoice_Amount__c,Location__c,Billboard_Vendor__r.Name from Billboard_Invoice__c where Billboard_Vendor__c=: recordId WITH SECURITY_ENFORCED Order By Name LIMIT :intLimit Offset :intOffset];
        return vendorBBI;
    }
    
    /********************************************** Get Total Number of Records ************************************************************************/
    @AuraEnabled
    public static Integer getTotalVBBIRecords(Id recordId){
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Billboard_Invoice__c where Billboard_Vendor__c=:recordId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
 
}