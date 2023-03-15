public with sharing class WorkDocDocument{
    // It is not used (Sugunakar)
    /*-- public string docId{set;get;}
    public string docName{set;get;}
    public Boolean foundActivity{set;get;}
    public Workdocs_Connection__c wc{set; get;}
    
    
    @AuraEnabled
    public static List<String>  loadWorkdocItems(String CampId){ 
        String docId,docName;
        List<String> WorkdocIds=new List<String>();
        Campaign__c Camp = [select id, name, Workdocs_Folder_Id__c from Campaign__c where id = : CampId WITH SECURITY_ENFORCED];
        Workdocs_Connection__c wdc=[select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, WD_Org_Id__c,Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = : userinfo.getuserid() WITH SECURITY_ENFORCED limit 1];
        
        if (Camp.Workdocs_Folder_Id__c != null && Camp.Workdocs_Folder_Id__c != '') {
            
            String token = 'Bearer ' + wdc.Access_Token__c;
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/' + Camp.Workdocs_Folder_Id__c + '/contents'); //?include=Include&order=ASCENDING&sort=DATE&type=FOLDER
            httpRequest.setHeader('Authentication', token);
            httpRequest.setMethod('GET');
            
            Http http = new Http();
            HttpResponse response = http.send(httpRequest);
            
            if (response.getStatus() != 'Unauthorized' && response.getStatuscode() != 401) {
                if (response.getStatus() != 'Not Found' && response.getStatuscode() != 404) {
                    System.debug('==== After FID status===' + response.getStatus() + '====statusCode====' + response.getStatuscode());
                    
                    Map < String, Object > fconMap = (Map < String, Object > ) JSON.deserializeUntyped(response.getBody());
                    System.debug('======Response of Folder contents with Thmbnails=====' + response.getBody());
                    List < Object > DocList = (List < Object > ) fconMap.get('Documents');
                    //ListofMap = new List<Map <String, Object>>();
                    //MapofMap = new Map<String, Map <String, Object>>();
                    System.debug('====DocList=====' + DocList);
                    
                    Map < String, WorkDocDocument > DIdNameMap = new Map < String, WorkDocDocument > ();
                    if (DocList != null) {
                        System.debug('====inside the null DocList=====' + DocList);
                        if (DocList.size() > 0) {
                            for (Object d: DocList) {
                                Map < String, Object > Dmpa = (Map < String, Object > ) d;
                                Map < String, Object > Dmpa1 = (Map < String, Object > ) Dmpa.get('LatestVersionMetadata');
                                Map < String, Object > ThumbD = (Map < String, Object > ) Dmpa1.get('Thumbnail');
                                System.debug('===ThumbD==' + ThumbD);
                                docId = '' + String.valueof(Dmpa.get('Id'));
                                docName = '' + String.valueof(Dmpa1.get('Name'));
                                WorkdocIds.add(docId);
                                
                            }
                        }
                    }
                    
                    
                    List < Object > SFolderList = (List < Object > ) fconMap.get('Folders');
                    System.debug('==SubFolders List==' + SFolderList);
                    
                    if (SFolderList != null) {
                        System.debug('==inside the null SubFolders List==' + SFolderList);
                        if (SFolderList.size() > 0) {
                            
                            for (Object sf: SFolderList) {
                                Map < String, Object > SFmap = (Map < String, Object > ) sf;
                                string SubFloderId = String.valueof(SFmap.get('Id'));
                                string SubFloderName = String.valueof(SFmap.get('Name'));
                                System.debug('====Sub Folder Name==' + SubFloderName);
                                HttpRequest rqSFC = new HttpRequest();
                                rqSFC.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/' + SubFloderId + '/contents'); //?include=Include&order=ASCENDING&sort=DATE&type=ALL
                                rqSFC.setHeader('Content-type', 'application/json');
                                rqSFC.setHeader('Authentication', token);
                                rqSFC.setMethod('GET');
                                
                                http htSFC = new http();
                                httpResponse resSFC = htSFC.send(rqSFC);
                                
                                Map < String, Object > sfconMap = (Map < String, Object > ) JSON.deserializeUntyped(resSFC.getbody());
                                // Job Folder Documents
                                List < Object > SFDocList = (List < Object > ) sfconMap.get('Documents');
                                System.debug('==SFDocList 1===' + SFDocList);
                                Map <String, WorkDocDocument> SFDIdNameMap = new Map <String, WorkDocDocument> ();
                                WorkDocDocument s_wd; // sub directory work document
                                if (SFDocList != null) {
                                    if (SFDocList.size() > 0) {
                                        for (Object sfd: SFDocList) {
                                            Map < String, Object > SFDmap = (Map < String, Object > ) sfd;
                                            Map < String, Object > SFDmap1 = (Map < String, Object > ) SFDmap.get('LatestVersionMetadata');
                                            Map < String, Object > ThumbSFD = (Map < String, Object > ) SFDmap1.get('Thumbnail');
                                            System.debug('===ThumbSFD==' + ThumbSFD);
                                            docId = '' + String.valueof(SFDmap.get('Id'));
                                            docName = '' + String.valueof(SFDmap1.get('Name'));
                                            WorkdocIds.add(docId);
                                            
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                
                System.debug('=====WorkdocIds=======' + WorkdocIds);
                System.debug('=====WorkdocIds size======' + WorkdocIds.size());
            }
        }
        return WorkdocIds;
    }
    
   @AuraEnabled
    public static Boolean getActivites(String DocId){
        Boolean isActivityFound=false;
        Workdocs_Connection__c wc=[select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, WD_Org_Id__c,Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = : userinfo.getuserid() WITH SECURITY_ENFORCED limit 1];
         
        HttpRequest reqAll = new HttpRequest();
        reqAll.setEndpoint('https://workdocs.' + wc.State__c + '.amazonaws.com/api/v1/activities?resourceId=' + DocId + '&activityTypes=DOCUMENT_COMMENT_ADDED,DOCUMENT_ANNOTATION_ADDED,DOCUMENT_VERSION_VIEWED'); //
        reqAll.setHeader('Content-type', 'application/json');
        reqAll.setHeader('Authentication', 'Bearer ' + wc.Access_Token__c);
        reqAll.setMethod('GET');
        
        try {
            http htAll = new http();
            httpResponse resAll = htAll.send(reqAll);
            System.debug('===activites Response Code======'+resAll.getStatusCode());
            System.debug('===activites Response Status======'+resAll.getStatus());
            System.debug('===activites Response body======'+resAll.getBody()); 
            if (resAll.getStatusCode() == 200) {
                 System.debug('===DocId======'+DocId);
                System.debug('===Document version Viewed======' + resAll.getBody());
                Map < String, Object > allActmap = (Map < String, Object > ) JSON.deserializeUntyped(resAll.getBody());
                list < Object > activityList = (list < Object > ) allActmap.get('UserActivities');
                System.debug('===Document version Viewed======' + activityList.size());
                
                if (activityList != null) {
                    if (activityList.size() > 0) {
                        for (Object ac: activityList) {
                            Map <String, Object> acty = (Map <String, Object> ) ac;
                            Map <String, Object> actyIntiator = (Map <String, Object> ) acty.get('Initiator');
                            if (wc.Workdocs_UserId__c != String.Valueof(actyIntiator.get('Id')) && (String.valueof(acty.get('Type')) == 'DOCUMENT_COMMENT_ADDED' || String.valueof(acty.get('Type')) == 'DOCUMENT_ANNOTATION_ADDED')) {
                                isActivityFound = true;
                                break;
                            }
                        }
                    }
                }
            }
        } catch (System.CalloutException e) {
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + e.getMessage()));
            system.debug('=========CalloutException for Activites========='+e.getMessage());
        }
        //foundActivity = isActivityFound;
        return isActivityFound;
 
    }
    
    
    public WorkDocDocument(String docId, String docName, Workdocs_Connection__c wc){            
        this.docId = docId;
        this.docName = docName;
        this.wc = wc;
    }
    public Boolean getCallActivity(){
        Boolean isActivityFound = false;
        HttpRequest reqAll = new HttpRequest();
        reqAll.setEndpoint('https://workdocs.' + wc.State__c + '.amazonaws.com/api/v1/activities?resourceId=' + DocId + '&activityTypes=DOCUMENT_COMMENT_ADDED,DOCUMENT_ANNOTATION_ADDED,DOCUMENT_VERSION_VIEWED'); //
        reqAll.setHeader('Content-type', 'application/json');
        reqAll.setHeader('Authentication', 'Bearer ' + wc.Access_Token__c);
        reqAll.setMethod('GET');
        
        try {
            http htAll = new http();
            httpResponse resAll = htAll.send(reqAll);
            System.debug('===activites Response Code======'+resAll.getStatusCode());
            System.debug('===activites Response Status======'+resAll.getStatus());
            System.debug('===activites Response body======'+resAll.getBody()); 
            if (resAll.getStatusCode() == 200) {
                // System.debug('===DocId======'+DocId);
                System.debug('===Document version Viewed======' + resAll.getBody());
                Map < String, Object > allActmap = (Map < String, Object > ) JSON.deserializeUntyped(resAll.getBody());
                list < Object > activityList = (list < Object > ) allActmap.get('UserActivities');
                System.debug('===Document version Viewed======' + activityList.size());
                
                if (activityList != null) {
                    if (activityList.size() > 0) {
                        for (Object ac: activityList) {
                            Map <String, Object> acty = (Map <String, Object> ) ac;
                            Map <String, Object> actyIntiator = (Map <String, Object> ) acty.get('Initiator');
                            
                            /*
                            if (wc.Workdocs_UserId__c == String.Valueof(actyIntiator.get('Id')) && (String.valueof(acty.get('Type')) == 'DOCUMENT_VERSION_VIEWED' || String.valueof(acty.get('Type')) == 'DOCUMENT_COMMENT_ADDED' || String.valueof(acty.get('Type')) == 'DOCUMENT_ANNOTATION_ADDED')) {
                                FileHighlightMap.put(DocId, false);
                                break;
                            } else if (wc.Workdocs_UserId__c != String.Valueof(actyIntiator.get('Id')) && (String.valueof(acty.get('Type')) == 'DOCUMENT_COMMENT_ADDED' || String.valueof(acty.get('Type')) == 'DOCUMENT_ANNOTATION_ADDED')) {
                                isActivityFound = true;
                                break;
                            } else {
                                FileHighlightMap.put(DocId, false);
                                break;
                            }
                            */
                           /*-- if (wc.Workdocs_UserId__c != String.Valueof(actyIntiator.get('Id')) && (String.valueof(acty.get('Type')) == 'DOCUMENT_COMMENT_ADDED' || String.valueof(acty.get('Type')) == 'DOCUMENT_ANNOTATION_ADDED')) {
                                isActivityFound = true;
                                break;
                            }
                        }
                    }
                }
            }
        } catch (System.CalloutException e) {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + e.getMessage()));
        }
        foundActivity = isActivityFound;
        return isActivityFound;
        
        
    }  --*/
}