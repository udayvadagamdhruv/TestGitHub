public with sharing class LDS_Controller {
    
    @AuraEnabled
    public static List<Tool_Tip__c> getHelpTextrecords() {
        List <Tool_Tip__c> lsthelptxt = [Select Id,Quotes__c,Estimate__c,Production_Estimate__c,Purchase_Order__c,Vendor_Invoice__c,Shipment__c from Tool_Tip__c WITH SECURITY_ENFORCED];
        return lsthelptxt;
    }
    
    @AuraEnabled
    public static String getObjectType() {
        Map<String,Schema.SobjectType> allObjMap=Schema.getGlobalDescribe(); //getting all objects
         System.debug('===allObjMap====='+allObjMap);
        List<String> ObjApiNameList=new List<String>();
        for(String SObj:allObjMap.keyset()){
            Schema.DescribeSObjectResult objResult=allObjMap.get(SObj).getDescribe(); //describing here
             System.debug('===objResult====='+objResult);
            //objResult.getLabel();
            //objResult.getKeyPrefix();
            if(objResult.isCustom())
            {
                ObjApiNameList.add(objResult.getName());    //checking whether it is custom and adding to list
            }
        }
        System.debug('===SObj====='+ObjApiNameList);
        // Passing the sObject name in the method, it could be multiple objects too
        return getDynamicLabelUtility.getDescribedObjects(new list<string> {'Job__c'});    
    }
    
    @AuraEnabled 
    public static List<Boolean> getisAccessable()
    {
        List<boolean> isAccessList=new  List<boolean>();
        isAccessList.add(Schema.sObjectType.Quote__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Production_Estimate__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Estimate_Line_Items__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Purchase_Order__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Invoice__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Shipment__c.isAccessible());  
        return isAccessList;
    }
    
    
    @AuraEnabled
    public static List < String > getFieldsforJobObject(String sObjName,String fieldsetname) {
        
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        system.debug('The schemaMap=='+schemaMap);
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
          system.debug('The fieldMap=='+fieldMap);
        //  string fieldsetname;
        // for (string s: fieldMap.keyset())
        //   fieldsetname = s;
        List <Schema.FieldSetMember> fields = fieldMap.get(fieldsetname).getFields();
        System.debug('====Fields of Tags==='+fields);
        List <string> fieldsname = new List <string> ();
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        System.debug('====Fields of Tags==='+fieldsname);
        return fieldsname;
    }
    
    @AuraEnabled
    public static List < String > getFieldsforObject(String sObjName) {
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        string fieldsetname;
        for (string s: fieldMap.keyset())
            fieldsetname = s;
        List < Schema.FieldSetMember > fields = fieldMap.get(fieldsetname).getFields();
        List < string > fieldsname = new List < string > ();
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        return fieldsname;
    }
    
    @AuraEnabled
    public static List<Object> CustomSettingvalues(){
        list<Object> CS=new list<Object>();
        String ProfileId=userinfo.getProfileId();
        ProductionEstimate__c  PECustom = ProductionEstimate__c.getOrgDefaults();
        CS.add(PECustom);
        // if (Schema.sObjectType.Organization.fields.Address.isAccessible()==true && Schema.sObjectType.Organization.fields.Name.isAccessible()==true){
        Organization OrgInfo=[SELECT Name, Id, Address FROM Organization   Limit:1 ];//WITH SECURITY_ENFORCED
        CS.add(OrgInfo);
        //}
        // if (Schema.sObjectType.Profile.fields.Name.isAccessible()==true){
        Profile proInfo = [Select Id, Name from Profile where Id =: ProfileId ];//WITH SECURITY_ENFORCED 
        CS.add(proInfo);
        
        if(proInfo.Name=='Client Contact' || proInfo.Name=='SP Client Contact' ) { 
            List<Client_Contact__c> cc=[Select Id, Name, Client__c,Client__r.Name, Email__c From Client_Contact__c where UserName__c =: UserInfo.getUserName() WITH SECURITY_ENFORCED LIMIT 1];
            if(cc.size()>0){
                CS.add(cc[0]);  
            }
        }
        //  } 
        return CS;
    }
    
    @AuraEnabled
    public static String geLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        system.debug('The objlabel is '+objlabel);
        return objlabel;
    }
    
    @AuraEnabled
    public static Map < String, list < SObject >> vendorviewcmp(Id recordId) {
        system.debug('record id' + recordId);
        Map < String, list < SObject >> vendorrelated = new Map < String, list < SObject >> ();
        List < Vendor_Contact__c > vendor_contacts = [SELECT Id, Name, Vendor__c, Active__c, Email__c, Phone_1__c, Phone_2__c FROM Vendor_Contact__c where Vendor__c = : recordId WITH SECURITY_ENFORCED];
        vendorrelated.put('vendor_contacts', vendor_contacts);
        system.debug('=====vendor contacts====' + vendorrelated);
        return vendorrelated;
    }
    
    @AuraEnabled
    public static list < SObject > vendorviewcm1(Id recordId) {
        system.debug('record id' + recordId);
        List < Vendor_Contact__c > vendor_contacts = [SELECT Id, Name, Vendor__c, Vendor__r.Name, Active__c, Email__c, Phone_1__c, Phone_2__c FROM Vendor_Contact__c where Vendor__c = : recordId  WITH SECURITY_ENFORCED];
        return vendor_contacts;
    }
    
    @AuraEnabled
    public static Map < Id, String > getMediaTypes() {
        Map < Id, String > MediaMap = new Map < Id, String > ();
        MediaMap.put(null, '--None--');
        for (Media_Type__c a: [SELECT Id, name FROM Media_Type__c WITH SECURITY_ENFORCED order by Name ]) {
            MediaMap.put(a.Id, a.Name);
        }
        
        return MediaMap;
    }
    
    @AuraEnabled
    public static Map < Id, String > getScheduleTemplates(String MTName) {
        Map < Id, String > ScheduleMap = new Map < Id, String > ();
        ScheduleMap.put(null, '--None--');
        for (Schedule_Template__c r: [SELECT Id, Name FROM Schedule_Template__c where Media_Types__c = : MTName and Active__c = True WITH SECURITY_ENFORCED Order by Name]) {
            ScheduleMap.put(r.Id, r.Name);
        }
        return ScheduleMap;
    }
    
    @AuraEnabled
    public Static Map < Id, String > getClients() {
        Map < Id, String > ClientMap = new Map < Id, String > ();
        // && (orgId == '00DE0000000ZEOuMAO' || orgId == '00D0U0000000Q7wUAE') for NBC CC 
        
        Boolean isLtng = Userinfo.getUiTheme() == 'Theme4d' ? true : false;
        String orgId = Userinfo.getOrganizationId();
        ClientMap.put(null, '- None -');
        if (isLtng || orgId == '00DE0000000ZEOuMAO' || orgId == '00D0U0000000Q7wUAE' || orgId == '00D3F0000004b48UAA') {
            for (Client__c a: [SELECT Id, name, client_code__c, Active__c FROM Client__c where Active__c = : true WITH SECURITY_ENFORCED order by Name]) {
                
                ClientMap.put(a.Id, a.Name + (a.client_code__c != null ? ' - ' : '') + (a.client_code__c != null ? a.client_code__c : ''));
            }
        } else {
            for (Client__c a: [SELECT Id, name, client_code__c FROM Client__c WITH SECURITY_ENFORCED order by Name]) {
                
                ClientMap.put(a.Id, a.Name + (a.client_code__c != null ? ' - ' : '') + (a.client_code__c != null ? a.client_code__c : ''));
            }
        }
        
        return ClientMap;
    }
    
    @AuraEnabled
    public Static Map < Id, String > getClientContacts(String Clientname) {
        Map < Id, String > CContactsMap = new Map < Id, String > ();
        CContactsMap.put(null, '- None -');
        for (Client_Contact__c r: [SELECT Id, Name FROM Client_Contact__c where Client__c = : Clientname and Active__c = : true WITH SECURITY_ENFORCED order by Name]) {
            CContactsMap.put(r.Id, r.Name);
        }
        return CContactsMap;
    }
}