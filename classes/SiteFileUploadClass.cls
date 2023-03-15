public class SiteFileUploadClass {

 /*
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
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = parentId; // you can use objectId,GroupId etc
        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
       // cDe.Visibility = 'InternalUsers';
        insert cDe;
        system.debug('>>>>>>> saveTheFile FileId >>>>>>>>>'+conVer.Id);
        return conVer.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion contentVersion = [
            SELECT Id, versionData
            FROM ContentVersion
            WHERE Id = :fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(contentVersion.versionData);
        if(schema.SobjectType.ContentVersion.Fields.versionData.isUpdateable()){ 
            contentVersion.versionData = EncodingUtil.base64Decode(existingBody + base64Data);}
        if(Schema.sObjectType.contentVersion.isUpdateable()){
            update contentVersion;   }
    }*/
    
}