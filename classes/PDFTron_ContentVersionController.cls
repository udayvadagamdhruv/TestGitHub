public with sharing class PDFTron_ContentVersionController {


  /*  @AuraEnabled(cacheable=true)
    public static User getUserDetails(String recId) {
        return  [Select Id , Name ,Email from User where Id =:recId];
    }*/

   /* @AuraEnabled( cacheable=true )  
    public static List < JobSuite_Metadata__mdt > fetchJSMetadata() {
        return [SELECT Id, Token__c FROM JobSuite_Metadata__mdt];
    }*/

    @AuraEnabled(cacheable=true)
    public static List<Job_Team__c> getJobTeamList(String recordId){
        List<Job_Team__c> jobteamList=[SELECT Id, Name, Email__c, Staff__c, Job__c FROM Job_Team__c  WHERE Job__c = :recordId];
        return jobteamList;
    }

    @AuraEnabled(cacheable=true)
    public static List<ContentVersionWrapper> getAttachments(String recordId){
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
            for(ContentVersion cv :  [SELECT Id, LastModifiedDate,Title,FileExtension, ContentDocumentId, VersionData  FROM ContentVersion WHERE ContentDocumentId IN :cdIdList AND IsLatest = true Order by LastModifiedDate DESC]) {
                if(fileFormats.contains(cv.FileExtension.toLowerCase())) {
                    //System.debug('Converting CV: ' + cv.Id);
                    cvwList.add(new ContentVersionWrapper(cv));
                    //System.debug('Completed CV Conversion:' + cv);
                }
            }
            system.debug(cvwList);
            return cvwList;
        } catch (Exception e) {
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
    }*/


    @AuraEnabled
    public static List<ContentVersionBodyWrapper> getAttachmentBody(String recordId){
        try {
            List<ContentVersionBodyWrapper> cvwbList = new List<ContentVersionBodyWrapper> ();

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
            
            for(ContentVersion cv : [SELECT Id,LastModifiedDate,ContentDocumentId, Title,FileExtension, VersionData FROM ContentVersion WHERE /*Id =:recordId*/ ContentDocumentId =:recordId AND IsLatest = true]) {
                if(fileFormats.contains(cv.FileExtension.toLowerCase())) {
                    //System.debug('Converting CV: ' + cv.Id);
                    cvwbList.add(new ContentVersionBodyWrapper(cv));
                   // System.debug('Completed CV Conversion:' + cv);
                }
            }
            system.debug(cvwbList);
            return cvwbList;
           //return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static void saveDocument(String json, String recordId) {
        //system.debug('json>>>>>>>>>>'+json);
        //system.debug('Recid>>>>>'+recordId);
        try {
            PDFTron_ContentVersionPayload pl = PDFTron_ContentVersionPayload.parse(json);
           // system.debug('Payload document Id>>>>>>>>>>: ' + pl.contentDocumentId);
          /*  ContentVersion cv = new ContentVersion();
            // 'S' = a Salesforce File
            
            if(pl.contentDocumentId != null) {
                cv.ContentDocumentId = pl.contentDocumentId;
                cv.ReasonForChange = 'Saved from WebViewer';//only for file updates
            } else {
                for(ContentDocumentLink cdl :  [SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :recordId AND ContentDocument.Title = :pl.title ]) {
                            if(cdl.ContentDocumentId != null) {
                                cv.ContentDocumentId = cdl.ContentDocumentId;
                                system.debug('cv.ContentDocumentId>>>>>>>>>>: ' + cv.ContentDocumentId);
                            }
                        }
            }*/
            List<ContentVersion> cvidList=[select id,IsLatest,ReasonForChange,ContentDocumentId,FileType FROM ContentVersion where ContentDocumentId=:pl.contentDocumentId];
            List<ContentVersion> updateCVList=new List<ContentVersion>();
            List<ContentVersion> insertCVList=new List<ContentVersion>();
            //system.debug('>>>>>>>>>>>>>cvidList size>>>>>>>>>>>>>'+cvidList.size());
                
            /*if(cvidList.size()==1)
            {
                ContentVersion cv1 = new ContentVersion();
                cv1.VersionData = EncodingUtil.base64Decode(pl.base64Data);
                cv1.Title = pl.title;
                cv1.PathOnClient = pl.filename;
                cv1.ContentDocumentId=cvidList[0].ContentDocumentId;
                // system.debug('### Upserting cv: ' + cv1);
                insert cv1; 
            }
            else{
                for(ContentVersion cvd:cvidList)
                {
                    if(cvd.IsLatest == true)
                    {
                        cvd.VersionData = EncodingUtil.base64Decode(pl.base64Data);  cvd.Title = pl.title;    updateCVList.add(cvd);
                    }
                }
                update updateCVList; 
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

    public class ContentVersionBodyWrapper {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String body {get; set;}
        @AuraEnabled
        public ContentVersion cv;
        
        public ContentVersionBodyWrapper(ContentVersion contentVer) {
            this.cv = contentVer;
            this.name = contentVer.Title + '.' + contentVer.FileExtension;
            this.body = EncodingUtil.base64Encode(contentVer.VersionData);
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
    }
}