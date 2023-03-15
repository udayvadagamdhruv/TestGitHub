public with sharing class BillBoardController {
	
     @AuraEnabled
    public static string FetchObjectType(List<String> ObjNames) {
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
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
    
    // ================================================= Delete BB Records ===================================================================//
    
    @AuraEnabled
    public static string DeleteBB(String BBId){
        Billboard__c DeleteBB =[Select id,Name from Billboard__c where id =:BBId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.Billboard__c.isDeletable()){
                delete DeleteBB;
                return 'OK';
            }
            else{
                return 'Billboard has insufficient access to Delete';
            }
        } catch(Exception e){return ''+e.getMessage();
        }
    }
    
    /******************************************************* Get Latitude and Longitude Records ***************************************************************/
    @AuraEnabled
    public static Billboard__c BBLoc(Id recordId) {
        system.debug('record id' + recordId);
        Billboard__c BBLoc = [SELECT Id,Name,Latitude__c,Longitude__c FROM Billboard__c where Id = : recordId WITH SECURITY_ENFORCED];
        return BBLoc;
    }
    
     // ================================================= Display Records in Billboard Invoice table Section ==============================================================================//
    @AuraEnabled 
    public static List<Billboard_Invoice__c> getBBInvrecords(Id recordId) {
        system.debug(recordId);
        List <Billboard_Invoice__c> lstBBInv = [select id,Name,BB_Invoice_Due_Date__c,Billboard_Vendor__c,Location__c,Billboard__c,Billboard__r.Name,Billboard_Vendor__r.Name from Billboard_Invoice__c where Billboard__c =:recordId WITH SECURITY_ENFORCED];
        return lstBBInv;
    }
    /********************************************** Delete Billboard Invoice from the table **********************************************************/
    @AuraEnabled
    public static list<string> DeleteBBInv(String BBInvId){
        list<string> aa=new  list<string>();
        Billboard_Invoice__c DeleteBBInv =[Select id,Name from Billboard_Invoice__c where id =:BBInvId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.Billboard_Invoice__c.isDeletable()){
                delete DeleteBBInv;
                aa.add('OK');
                return aa;
            }
            else{
                aa.add('Billboard Invoice has insufficient access to Delete');return aa;
            }
            
        } catch(Exception e){aa.add('NO');aa.add(''+e.getMessage());return aa;}
         
    }
    
     // ================================================= Display Records in Billboard Invoice table Section ==============================================================================//
    @AuraEnabled 
    public static List<Billboard_Invoice_Line_Item__c> getBBInvLIrecords(Id recordId) {
        system.debug(recordId);
        List <Billboard_Invoice_Line_Item__c> lstBBInv = [select id,Name,Amount__c,GL_Code_No__c,Unit_Type__c,Billboard_Invoice__c,GL_Department__c,GL_Department__r.name,GL_Code__c,GL_Code__r.name,Quantity__c from Billboard_Invoice_Line_Item__c where Billboard_Invoice__c=:recordId WITH SECURITY_ENFORCED ORDER BY Name];
        return lstBBInv;
    }
    
    // ================================================= Edit BB Inv LI Records ==============================================================================//
    
    @AuraEnabled
    public static string updateBBInvLI(List <Billboard_Invoice_Line_Item__c> editedBBInvLIList){
        try{
            if(Schema.sObjectType.Billboard_Invoice_Line_Item__c.isUpdateable()){
                update editedBBInvLIList;
                return 'true';
            }
            else{
                return 'Billboard Invoice Line Item has insufficient access to update';
            }
        } catch(Exception e){return ''+e.getMessage();
        }
    }
    /********************************************** Delete Billboard Invoice from the table **********************************************************/
    @AuraEnabled
    public static list<string> DeleteBBInvLI(String BBInvLIId){
        list<string> aa=new  list<string>();
        Billboard_Invoice_Line_Item__c DeleteBBInvLI =[Select id,Name from Billboard_Invoice_Line_Item__c where id =:BBInvLIId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.Billboard_Invoice_Line_Item__c.isDeletable()){
                delete DeleteBBInvLI;
                aa.add('OK');
                return aa;
            }
            else{
                aa.add('Billboard Invoice Line Item has Insufficient access to Delete');return aa;
            }
            
        } catch(Exception e){
            aa.add('NO');   aa.add(''+e.getMessage());return aa;
        }
    }
    
     // ================================================= Display Records in Billboard Invoice  Payment table Section ==============================================================================//
    @AuraEnabled 
    public static List<BB_Invoice_Payment__c> getBBInvPayrecords(Id recordId) {
        system.debug(recordId);
        List <BB_Invoice_Payment__c> lstBBInvPay = [select id,Name,Check_New__c,Check_Amount__c,Check_Date__c ,Vendor__c,Billboard_Invoice__c from BB_Invoice_Payment__c where Billboard_Invoice__c=:recordId WITH SECURITY_ENFORCED ORDER BY Name];
        return lstBBInvPay;
    }
    
   
    /********************************************** Delete Billboard Invoice Payment from the table **********************************************************/
    @AuraEnabled
    public static list<string> DeleteBBInvPay(String BBInvPayId){
        list<string> aa=new  list<string>();
        BB_Invoice_Payment__c DeleteBBInvPay =[Select id,Name from BB_Invoice_Payment__c where id =:BBInvPayId WITH SECURITY_ENFORCED];
        try{
            
            if(Schema.sObjectType.BB_Invoice_Payment__c.isDeletable()){
                delete DeleteBBInvPay;
                aa.add('OK');
                return aa;
            }
            else{
                aa.add('BB Invoice Payment has Insufficient access to Delete');return aa;
            }
        } catch(Exception e){
            aa.add('NO');    aa.add(''+e.getMessage());return aa;
        }
    }
    
    // ================================================= Display Records in Billboard Contract table Section ==============================================================================//
    @AuraEnabled 
    public static List<Billboard_Contract__c> getBBConrecords(Id recordId) {
        system.debug(recordId);
        List <Billboard_Contract__c> lstBBCon = [select id,Name,BB_Vendor_Name__c,BB_Vendor_Name__r.Name,Billboard__c,Billboard__r.Name,Billboard_Type__c,Contract_Number__c,Contract_Title__c,End_Date__c,Expiration_Date__c,No_of_Insertions__c,Rate__c,Start_Date__c,Status__c from Billboard_Contract__c where Billboard__c =:recordId WITH SECURITY_ENFORCED ORDER BY End_Date__c];
        return lstBBCon;
    }
    
    /********************************************** Delete Billboard Contract from the table **********************************************************/
    @AuraEnabled
    public static list<string> DeleteBBCon(String BBConId){
        list<string> aa=new  list<string>();
        Billboard_Contract__c DeleteBBCon =[Select id,Name from Billboard_Contract__c where id =:BBConId WITH SECURITY_ENFORCED];
         try{
             if(Schema.sObjectType.Billboard_Contract__c.isDeletable()){
                 delete DeleteBBCon;
                 aa.add('OK');
                 return aa;
             }
             else{
                 aa.add('Billboard Contract has Insufficient access to Delete');return aa;
             }
        } catch(Exception e){
            aa.add('NO');aa.add(''+e.getMessage());return aa;
        }
    }

}