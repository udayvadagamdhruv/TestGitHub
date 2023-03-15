/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-16-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PDFTron_Task_Creator {
   
    //gets Approval Task's associated Documents to open by default
    @AuraEnabled(Cacheable=true)
    public static DocumentWrapper getRelatedDocuments(String recordId) {
        system.debug('>>>>>>recordId>>>>>>>>>'+recordId);
         String cvId = [SELECT Content_Document_ID__c FROM Job_Task__c WHERE Id = :recordId].Content_Document_ID__c;
         system.debug('>>>>>>cvId>>>>>>>>>'+cvId);
        return new DocumentWrapper([SELECT ContentDocumentId, Id, VersionData, Title, FileExtension FROM ContentVersion WHERE ContentDocumentId = :cvId AND IsLatest = true Order by LastModifiedDate DESC LIMIT 1], true);
    }

    public class DocumentWrapper {
        @AuraEnabled
        public String recordId {get;set;}
        @AuraEnabled
        public String title {get;set;}
        @AuraEnabled
        public String body {get;set;}
        @AuraEnabled
        public String docId {get;set;}

        public DocumentWrapper(ContentVersion cv, Boolean encode) {
            this.recordId = cv.Id;
            this.title = cv.Title + '.' + cv.FileExtension;
            this.docId = cv.ContentDocumentId;
            if(encode == true) {
                this.body = EncodingUtil.base64Encode(cv.VersionData);
            } else {
                this.body = '';
            }
        }
    } 
    
    
    @AuraEnabled
    public static void saveDocument(String json, String recordId) {
        try {
            PDFTron_ContentVersionPayload pl = PDFTron_ContentVersionPayload.parse(json);
            //system.debug('Payload>>>>>>>: ' + pl);
           /* system.debug('Task Creator RecordId>>>>>>>: ' + recordId);
            Approval_Job_Task__c ApproveJT= [select id,Name,Job__c from Approval_Job_Task__c where id=:recordId];
            string ApproveJobId = ApproveJT.Job__c;
            ContentVersion cv = new ContentVersion();
            // 'S' = a Salesforce File
            cv.ContentLocation = 'S';
            if(pl.contentDocumentId != null) {
                cv.ContentDocumentId = pl.contentDocumentId;
                cv.ReasonForChange = 'Saved from WebViewer';//only for file updates
            } else {
                for(ContentDocumentLink cdl : 
                    [   SELECT ContentDocumentId, ContentDocument.Title
                     FROM ContentDocumentLink 
                     WHERE LinkedEntityId = :ApproveJobId
                     AND ContentDocument.Title = :pl.title ]) {
                         if(cdl.ContentDocumentId != null) {
                             cv.ContentDocumentId = cdl.ContentDocumentId;
                         }
                     }
            }
            cv.VersionData = EncodingUtil.base64Decode(pl.base64Data);
            cv.Title = pl.title;
            cv.PathOnClient = pl.filename;
            
            system.debug('### Upserting cv: ' + cv);
            upsert cv; */

            List<ContentVersion> cvidList=[select id,IsLatest,ReasonForChange,ContentDocumentId,FileType FROM ContentVersion where ContentDocumentId=:pl.contentDocumentId];
            List<ContentVersion> updateCVList=new List<ContentVersion>();
            List<ContentVersion> insertCVList=new List<ContentVersion>();
           // system.debug('>>>>>>>>>>>>>cvidList size>>>>>>>>>>>>>'+cvidList.size());
           /* if(cvidList.size()==1)
            {
                ContentVersion cv1 = new ContentVersion();
                cv1.VersionData = EncodingUtil.base64Decode(pl.base64Data);
                cv1.Title = pl.title;  
                cv1.PathOnClient = pl.filename; 
                cv1.ContentDocumentId=cvidList[0].ContentDocumentId; // system.debug('### Upserting cv: ' + cv1);
                insert cv1; 
            }
            else{
                for(ContentVersion cvd:cvidList)
                {
                    if(cvd.IsLatest == true)
                    {
                        cvd.VersionData = EncodingUtil.base64Decode(pl.base64Data); cvd.Title = pl.title;  updateCV.add(cvd);
                    }
                }
                
                update updateCV; 
            }*/


            for(ContentVersion cvd:cvidList)
            {
                if(cvd.IsLatest == true && cvd.ReasonForChange!='Saved from WebViewer')
                {
                    system.debug('>>>>>>>>>>>>>IsLatest PDF if>>>>>>>>>>>>>');
                    ContentVersion cv = new ContentVersion();
                    cv.VersionData = EncodingUtil.base64Decode(pl.base64Data);
                    cv.Title = pl.title;
                    cv.PathOnClient = pl.filename;
                    cv.ContentDocumentId=cvidList[0].ContentDocumentId;
                    cv.ReasonForChange='Saved from WebViewer';
                    insertCVList.add(cv);
                }
                else if(cvd.IsLatest == true && cvd.ReasonForChange=='Saved from WebViewer'){
                    system.debug('>>>>>>>>>>>>>IsLatest PDF else>>>>>>>>>>>>>');
                    cvd.VersionData = EncodingUtil.base64Decode(pl.base64Data);  
                    cvd.Title = pl.title;   
                    updateCVList.add(cvd);
                }
            }
            insert insertCVList;
            update updateCVList; 


        } catch (Exception e) {
            system.debug('### ERROR: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
   /* @AuraEnabled
    public static List<ContentVersionWrapper> getAttachments1(String recordId){
        try {
            List<String> cdIdList = new List<String> ();
            List<ContentVersionWrapper> cvwList = new List<ContentVersionWrapper> ();

            //Define supported file extensions
            Set<String> fileFormats = new Set<String> {
                'pdf', 
                'docx', 
                'xlsx',
                'pptx',
                'jpg',
                'jpeg',
                'png',
                'tif',
                'xlsx'
            };
            //Find links between record & document
            for(ContentDocumentLink cdl : [SELECT id, ContentDocumentId, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ]) {
                cdIdList.add(cdl.ContentDocumentId);
                System.debug('ContentDocumentLink List: ' + cdIdList);
            }
            //Use links to get attachments
            for(ContentVersion cv :  [SELECT Id, LastModifiedDate,Title,FileExtension, VersionData  FROM ContentVersion WHERE ContentDocumentId IN :cdIdList AND IsLatest = true Order by LastModifiedDate DESC]) {
                if(fileFormats.contains(cv.FileExtension.toLowerCase())) {
                    //System.debug('Converting CV: ' + cv.Id);
                    cvwList.add(new ContentVersionWrapper(cv));
                    //System.debug('Completed CV Conversion:' + cv);
                }
            }
            //system.debug(cvwList);
            return cvwList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class ContentVersionWrapper {
        @AuraEnabled
        public String name {get; set;}
       // @AuraEnabled
       // public String body {get; set;}
        @AuraEnabled
        public ContentVersion cv;
        
        public ContentVersionWrapper(ContentVersion contentVer) {
            this.cv = contentVer;
            this.name = contentVer.Title + '.' + contentVer.FileExtension;
           // this.body = EncodingUtil.base64Encode(contentVer.VersionData);
        }
    }*/

    
}