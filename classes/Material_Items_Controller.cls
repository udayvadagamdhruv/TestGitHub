public with sharing class Material_Items_Controller {
    
     // *************** Display today's date in MI Inv page *************************/
    @AuraEnabled 
    public static string gettodaydate()
    {
        return system.today().format();
    }
    
    @AuraEnabled
    public static list<string> getFieldsforObject(String sObjName){
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();

        string fieldsetname;
        for (string s: fieldMap.keyset())
            fieldsetname = s;
        List <Schema.FieldSetMember> fields = fieldMap.get(fieldsetname).getFields();
        List <string> fieldsname = new List <string> ();

        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }

        return fieldsname;
    }
    
    @AuraEnabled
    public static string getObjectType(list<String> ObjNames){
       return getDynamicLabelUtility.getDescribedObjects(ObjNames); 
    }
    
 /* @AuraEnabled
    public static list<string> getFieldsetsForMIWithRecordType(String sObjName,String recordTypeId){ 
        RecordType RType=[Select Id, Name From RecordType Where Id=:recordTypeId];
        String RTName=RType.Name;
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        
        List <Schema.FieldSetMember> fields = fieldMap.get(RTName).getFields();
        List <string > fieldsname = new List < string >();
        
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        return fieldsname;
    }*/
    
    @AuraEnabled
    public static list<Material_Usage_line_item__c> getMaterialUsageItems(String MItemId){
        list<Material_Usage_line_item__c>   MULI =[SELECT Id,Name,Qty_On_Hand__c,Date__c,Credit__c,Debit__c,Description__c,Type__c,Createddate  FROM Material_Usage_line_item__c  Where Material_Item__c=:MItemId WITH SECURITY_ENFORCED Order By Createddate DESC, Qty_On_Hand__c limit 1000 ];
        return MULI;
    }
    
    @AuraEnabled
    public static string updateMaterailItemQtyOnHandField (String MItemId){
        
       Material_Item__c objMaterial=[Select Id,Name ,Qty_On_Hand__c,Calc_Unit__c,Case_Pack__c,Roll_LF__c,(Select Id,Name,Qty_On_Hand__c from Material_Usage_line_items__r Order by Createddate DESC) from Material_Item__c  where Id=:MItemId WITH SECURITY_ENFORCED];
        
        if(objMaterial.Material_Usage_line_items__r.size()>0){
           // muc =[Select id,name,Qty_On_Hand__c,Date__c,Credit__c,Debit__c,Description__c,Type__c  from Material_Usage_line_item__c  where Material_Item__c=:objMaterial.id Order by Createddate DESC, Qty_On_Hand__c limit 1];
            if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){
                objMaterial.Qty_On_Hand__c=objMaterial.Material_Usage_line_items__r[0].Qty_On_Hand__c;
            }
        }
        
        try{
            if(Schema.sObjectType.Material_Item__c.isUpdateable()){
                update objMaterial;
                return 'OK';
            }
            else{
                return 'Material item has Insufficient access to update';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();}
    }
    
    @AuraEnabled
    public static list<Material_Inventory_Item__c> getMaterialInventory(String MItemId){
        List<Material_Inventory_Item__c> MInvItems =[SELECT Id,Name, Qty_On_Hand__c,Inventory_Date__c,Material_Item__c,Mfg_Item_Number__c,Qty_On_Shelf__c,Createddate  FROM Material_Inventory_Item__c Where Material_Item__c=:MItemId WITH SECURITY_ENFORCED Order By LastModifiedDate DESC limit 1000];  
        return MInvItems;
    }
    
    
    @AuraEnabled
    public static string deleteMInventoryItem(String MInvItemId){
        Material_Inventory_Item__c delMInvItem=[Select Id,Material_Item__c from Material_Inventory_Item__c where Id=:MInvItemId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.Material_Inventory_Item__c.isDeletable()){
                Database.Delete(delMInvItem);
                return 'OK';
            }
            else{
                return 'Material Inventory Item has Insufficient access to Delete';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();}
        
    }
    
    @AuraEnabled
    public static string deleteMIUsageItem(String MIUIId,String MItemId){
        
        list<Material_Usage_line_item__c> MUD=[SELECT Id,Name,Qty_On_Hand__c,Date__c,Credit__c,Debit__c,Description__c,Type__c  from Material_Usage_line_item__c  where Material_Item__c=:MItemId WITH SECURITY_ENFORCED Order by Createddate limit 10000];
        
        Material_Usage_line_item__c  objMU=[Select Id,Material_Item__c from Material_Usage_line_item__c where Id=:MIUIId WITH SECURITY_ENFORCED];
        
        Material_Item__c  objMaterial=[Select Id,Name ,Qty_On_Hand__c from Material_Item__c  where Id=:MItemId WITH SECURITY_ENFORCED];
        if(MUD.size()> 1){
            if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){
                objMaterial.Qty_On_Hand__c=MUD[MUD.size()-2 ].Qty_On_Hand__c;
            }
        }
        else{
            if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){objMaterial.Qty_On_Hand__c=null;}
        }
        
        try{
            
            if(Schema.sObjectType.Material_Item__c.isUpdateable()){
                update objMaterial;
            }
            else{
                return 'Material Item has Insufficient access to update';
            }
            if(Schema.sObjectType.Material_Usage_line_item__c.isDeletable()){
                Database.Delete(objMU); 
            }
            else{
                return 'Material Usage line Item has Insufficient access to Delete';
            }
            
            
        }
        Catch(System.DmlException e){return ''+e.getMessage();}
         return 'OK';
    }
    
    @AuraEnabled
    public static list<ContentVersion> fetchLatestFiles(String recordId){
        List<String> contentDocumentIdSet=new List<String>();
        for(ContentDocumentLink cdl:[SELECT Id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:recordId WITH SECURITY_ENFORCED Order by SystemModstamp DESC]){
            contentDocumentIdSet.add(cdl.ContentDocumentId);
        }
        List<ContentVersion> cvList =[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' WITH SECURITY_ENFORCED Order by CreatedDate DESC];
        return cvList;
    }
    
    
    
    
}