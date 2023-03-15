public with sharing class SiteJobRequestForm {
    
    // ================================================= FieldSets fields =====================================================================//
    
    @AuraEnabled
    public static List < String > getFieldsforObject(String sObjName,String fieldsetname) {
        
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        
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
    public static String getObjectType(List<String> ObjNames) {
        Map<String,Schema.SobjectType> allObjMap=Schema.getGlobalDescribe();
        List<String> ObjApiNameList=new List<String>();
        for(String SObj:allObjMap.keyset()){
            Schema.DescribeSObjectResult objResult=allObjMap.get(SObj).getDescribe();
            //objResult.getLabel();
            //objResult.getKeyPrefix();
            if(objResult.isCustom())
            {
                ObjApiNameList.add(objResult.getName());    
            }
            
        }
        System.debug('===SObj====='+ObjApiNameList);
        // Passing the sObject name in the method, it could be multiple objects too
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
    }
    
    @AuraEnabled
    public static List<Object> CustomSettingData() {
        List<Object> sitedataList=new List<Object>();
        Site_Request_Form_Settings__c activeSettings = Site_Request_Form_Settings__c.getOrgDefaults();
        
        sitedataList.add(activeSettings.Height_of_the_Image__c);
        sitedataList.add(activeSettings.Width_of_the_Image__c);
        sitedataList.add(activeSettings.Site_Header_Name__c);
        sitedataList.add(activeSettings.CustomText__c);
        sitedataList.add(activeSettings.Files_Section__c);
        
        return sitedataList;
    }
    
    @AuraEnabled
    public static String geLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        return objlabel;
    }
    
    @AuraEnabled
    public static String imageURL() {
        String imageBody;
        Site_Request_Form_Settings__c activeSettings = Site_Request_Form_Settings__c.getOrgDefaults();
        imageBody= activeSettings.Org_URL__c;
        
        /* String imageURL = '/servlet/servlet.FileDownload?file='; 
List<Document> lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
if(!lstDoc.isEmpty())
{
String imageId =  lstDoc[0].Id;
imageBody = org_url;//imageURL+imageId; */
        
        return imageBody;
    }
    
    @AuraEnabled 
    public static List <Spec_Item__c> getSpecrecords(Id recordId) {
        system.debug(recordId);
        List<Spec_Item__c> lstSpecs = [select Name,Description__c,Specification_Template__r.Name,Sort_Order__c from Spec_Item__c where Specification_Template__c =: recordId WITH SECURITY_ENFORCED Order BY Sort_Order__c];
        return lstSpecs;
    }
    
    @AuraEnabled 
    public static List<Specification_Template__c> getSpecTemp() {
        List<Specification_Template__c> optionList = new  List<Specification_Template__c>();        
        optionList=[SELECT Id, name FROM Specification_Template__c WITH SECURITY_ENFORCED order by Name];
        return optionList;  
    }
    
    @AuraEnabled 
    public static string SaveSpecrecWithJob(Id recordId,List<Spec_Item__c > Specs) {
        
        List<Job_Spec__c> JobSpecsOld = [select id,name from Job_Spec__c where Job__c=:recordId WITH SECURITY_ENFORCED];   
        If(JobSpecsOld.size()>0){
            if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
             delete JobSpecsOld;}
        }
        
        list<Job_Spec__c> lstJspec = new list<Job_Spec__c>();
        
        for(Spec_Item__c obj:Specs)
        {
            Job_Spec__c jobSpec = new Job_Spec__c();
             if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) {   
                 jobSpec.Job__c = recordId;}
             if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) {   
                 jobSpec.Name = obj.Name;}
             if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) {   
                 jobSpec.Description__c = obj.Description__c;}
            lstJspec.add(jobSpec);
        }
        
        try{
            if(lstJspec.size()>0)
            {
                if(Schema.sObjectType.Job_Spec__c.isCreateable()){ insert lstJspec; return 'true'; }
            }
            return 'true';
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
  /*  
    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        /*   Attachment attach = new Attachment();
attach.parentId = parentId;
attach.Body = EncodingUtil.base64Decode(base64Data);
attach.Name = fileName;
attach.ContentType = contentType;
Insert attach;
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = fileName; // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
        insert conVer;
        
        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = parentId; // you can use objectId,GroupId etc
        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        //   cDe.Visibility = 'InternalUsers';
        insert cDe;
        
        return cDe.Id;
    }*/
    
    
    @AuraEnabled
    public static string saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
           system.debug('>>>>>>> Save Chunk File Id>>>>null>>>>>'+fileId);
        if (fileId == '' || fileId == null || fileId =='undefined') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        system.debug('>>>>>>> Save Chunk File Id>>>>>>>>>'+fileId);
        return fileId;
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        ContentVersion conVer = new ContentVersion();
        if (Schema.sObjectType.ContentVersion.fields.ContentLocation.isCreateable()) {   
            conVer.ContentLocation = 'S';} // S specify this document is in SF, use E for external files
        if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {   
            conVer.PathOnClient = fileName;} // The files name, extension is very important here which will help the file in preview.
        if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable()) {   
            conVer.Title = fileName;} // Display name of the files
        if (Schema.sObjectType.ContentVersion.fields.versionData.isCreateable()) {   
            conVer.versionData = EncodingUtil.base64Decode(base64Data);} // converting your binary string to Blog
        if (Schema.sObjectType.ContentVersion.fields.IsMajorVersion.isCreateable()) {   
            conVer.IsMajorVersion=false;}
        if(Schema.sObjectType.ContentVersion.isCreateable()){insert conVer;}
        
         // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id WITH SECURITY_ENFORCED].ContentDocumentId;
        
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        if (Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable()) {  
            cDe.ContentDocumentId = conDoc;}
       if (Schema.sObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable()) {  
           cDe.LinkedEntityId = parentId; }// you can use objectId,GroupId etc
       if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {  
           cDe.ShareType = 'V';} // Inferred permission, checkout description of ContentDocumentLink object for more details
       // cDe.Visibility = 'InternalUsers';
        if(Schema.sObjectType.ContentDocumentLink.isCreateable()){ 
            if(!Test.isRunningTest()){ insert cDe;}
        }
			
        system.debug('>>>>>>> saveTheFile FileId >>>>>>>>>'+conVer.Id);
        return conVer.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
      //  base64Data = ;
        
      transient  ContentVersion contentVersion = [
            SELECT Id, versionData
            FROM ContentVersion
            WHERE Id = :fileId
        WITH SECURITY_ENFORCED ];
        
        //String existingBody = ;
        if(schema.SobjectType.ContentVersion.Fields.versionData.isUpdateable()){ 
            contentVersion.versionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(contentVersion.versionData) + EncodingUtil.urlDecode(base64Data, 'UTF-8'));}
        if(Schema.sObjectType.contentVersion.isUpdateable()){
            update contentVersion;   }
    }
    
}