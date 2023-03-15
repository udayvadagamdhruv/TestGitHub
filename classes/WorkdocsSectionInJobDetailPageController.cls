public with sharing class WorkdocsSectionInJobDetailPageController {
    
    public Job__c job{get;set;}
    public Workdocs_Connection__c wdc{get;set;}
   
    public boolean accTokenExpire {set;get;}
    public boolean folderAccess   {set;get;}
     
 public list<String> flrdocmaplst {set;get;}
 public Map<String,Map<String,String>> flrdocmap  {set;get;}
 public map<String,String> docidNameMap {set;get;}
 public map<String,String> f_SubNameIdmap {set;get;}
 public Map<String, Boolean> FileHighlightMap{get;set;} 
 public Map<String,Integer> flderDocSizeMap {get;set;}
    
   Public String SubFolderName {set;get;}
   public Boolean SubFolderpopUp {set;get;}
 
   public string SubFolderId {set;get;}
   public string WdDocumentId {set;get;}
   public boolean subfoldererror {set;get;}
   public boolean subflderconflict {set;get;}
   public boolean subflodercrationerror {set;get;}
   public boolean uploaddocError {set;get;}
   
    
    Public WorkdocsSectionInJobDetailPageController(ApexPages.StandardController controller) {
        //accTokenExpire=true;
        callouts();
    } 
    
   Public WorkdocsSectionInJobDetailPageController() {
        //accTokenExpire=true;
        callouts();
    }

    public void callouts() {

        SubFolderpopUp = false;
        subfoldererror = false;
        subflderconflict = false;
        subflodercrationerror = false;
        uploaddocError = false;

        flrdocmaplst = new list < String > ();
        flrdocmap = new Map < String, Map < String, String >> ();
        f_SubNameIdmap = new map < String, String > ();
        docidNameMap = new Map < String, String > ();
        FileHighlightMap = new Map < String, Boolean > ();
        flderDocSizeMap = new Map < String, Integer > ();
        String jobId = apexpages.currentpage().getparameters().get('id');
        job = [select id, name, Job_Auto_Number__c, Workdocs_Folder_Id__c from job__c where id = : jobId];

        list < Workdocs_Connection__c > wdcList = new list < Workdocs_Connection__c > ();
        wdcList = [select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, WD_Org_Id__c, Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = : userinfo.getuserid() limit 1];
        if (wdcList.size() == 1) {
            wdc = wdcList[0];

            String tokenz = 'Bearer ' + wdc.Access_Token__c;
            HttpRequest httpRequest1z = new HttpRequest();
            httpRequest1z.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/me');
            httpRequest1z.setHeader('Authentication', tokenz);
            httpRequest1z.setMethod('GET');

            Http http1z = new Http();
            HttpResponse response1z = http1z.send(httpRequest1z);

            if (response1z.getStatus() == 'Unauthorized' || response1z.getStatusCode() == 401) {
                accTokenExpire = true;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'You are Connected to the WorkDocs. Please go to Job List View'));
            } else {

                if (job.Workdocs_Folder_Id__c != null && job.Workdocs_Folder_Id__c != '') {

                    String token = 'Bearer ' + wdc.Access_Token__c;
                    HttpRequest httpRequest = new HttpRequest();
                    httpRequest.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/' + job.Workdocs_Folder_Id__c + '/contents');
                    httpRequest.setHeader('Authentication', token);
                    httpRequest.setMethod('GET');

                    Http http = new Http();
                    HttpResponse response = http.send(httpRequest);

                    if (response.getStatus() != 'Unauthorized' && response.getStatuscode() != 401) {
                        accTokenExpire = false;

                        if (response.getStatus() != 'Not Found' && response.getStatuscode() != 404) {
                            folderAccess = true;
                            System.debug('==== After FID status===' + response.getStatus() + '====statusCode====' + response.getStatuscode());

                            Map < String, Object > fconMap = (Map < String, Object > ) JSON.deserializeUntyped(response.getBody());
                            System.debug('======Response of Folder contents with Thmbnails=====' + response.getBody());
                            List < Object > DocList = (List < Object > ) fconMap.get('Documents');
                            //ListofMap = new List<Map <String, Object>>();
                            //MapofMap = new Map<String, Map <String, Object>>();
                            System.debug('====DocList=====' + DocList);

                            Map < String, string > DIdNameMap = new Map < String, string > ();
                            if (DocList != null) {
                                System.debug('====inside the null DocList=====' + DocList);
                                if (DocList.size() > 0) {
                                    for (Object d: DocList) {
                                        Map < String, Object > Dmpa = (Map < String, Object > ) d;
                                        Map < String, Object > Dmpa1 = (Map < String, Object > ) Dmpa.get('LatestVersionMetadata');
                                        Map < String, Object > ThumbD = (Map < String, Object > ) Dmpa1.get('Thumbnail');
                                        System.debug('===ThumbD==' + ThumbD);
                                        DIdNameMap.put('' + String.valueof(Dmpa.get('Id')), '' + String.valueof(Dmpa1.get('Name')));
                                        docidNameMap.put('' + String.valueof(Dmpa.get('Id')), '' + String.valueof(Dmpa1.get('Name')));
                                    }
                                }
                            }
                            flrdocmap.put('' + job.Workdocs_Folder_Id__c, DIdNameMap);
                            f_SubNameIdmap.put('' + job.Workdocs_Folder_Id__c, '' + job.Name);
                            flderDocSizeMap.put('' + job.Workdocs_Folder_Id__c, DIdNameMap.size());
                            flrdocmaplst.add('' + job.Workdocs_Folder_Id__c);
                            System.debug('==Documennt List (flrdocmap)==' + flrdocmap);

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
                                        rqSFC.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/' + SubFloderId + '/contents'); //&order=Order&sort=Sort&type=ALL
                                        rqSFC.setHeader('Content-type', 'application/json');
                                        rqSFC.setHeader('Authentication', token);
                                        rqSFC.setMethod('GET');

                                        http htSFC = new http();
                                        httpResponse resSFC = htSFC.send(rqSFC);

                                        Map < String, Object > sfconMap = (Map < String, Object > ) JSON.deserializeUntyped(resSFC.getbody());
                                        // Job Folder Documents
                                        List < Object > SFDocList = (List < Object > ) sfconMap.get('Documents');
                                        System.debug('==SFDocList 1===' + SFDocList);
                                        Map < String, string > SFDIdNameMap = new Map < String, string > ();
                                        if (SFDocList != null) {
                                            if (SFDocList.size() > 0) {
                                                for (Object sfd: SFDocList) {
                                                    Map < String, Object > SFDmap = (Map < String, Object > ) sfd;
                                                    Map < String, Object > SFDmap1 = (Map < String, Object > ) SFDmap.get('LatestVersionMetadata');
                                                    Map < String, Object > ThumbSFD = (Map < String, Object > ) SFDmap1.get('Thumbnail');
                                                    System.debug('===ThumbSFD==' + ThumbSFD);
                                                    SFDIdNameMap.put('' + String.valueof(SFDmap.get('Id')), '' + String.valueof(SFDmap1.get('Name')));
                                                    docidNameMap.put('' + String.valueof(SFDmap.get('Id')), '' + String.valueof(SFDmap1.get('Name')));
                                                }
                                            }
                                        }
                                        flrdocmap.put('' + SubFloderId, SFDIdNameMap);
                                        flderDocSizeMap.put('' + SubFloderId, SFDIdNameMap.size());
                                        flrdocmaplst.add('' + SubFloderId);
                                        System.debug('==Documennts & Sub Folder Documents List (flrdocmap)==' + flrdocmap);
                                        f_SubNameIdmap.put(SubFloderId, SubFloderName);
                                    }
                                }
                            }

                            System.debug('=====docidNameMap (Id,Name)=======' + docidNameMap);
                            System.debug('=====docidNameMap Size)=======' + docidNameMap.size());

                            if (docidNameMap.size() > 0) {
                                folderAccess = true;
                                for (String DocId: docidNameMap.keySet()) {

                                    HttpRequest reqAll = new HttpRequest();
                                    reqAll.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/activities?resourceId=' + DocId + '&activityTypes=DOCUMENT_COMMENT_ADDED,DOCUMENT_ANNOTATION_ADDED,DOCUMENT_VERSION_VIEWED'); //
                                    reqAll.setHeader('Content-type', 'application/json');
                                    reqAll.setHeader('Authentication', token);
                                    reqAll.setMethod('GET');

                                    try {
                                        http htAll = new http();
                                        httpResponse resAll = htAll.send(reqAll);
                                        System.debug('===activites Response Code======' + resAll.getStatusCode());
                                        System.debug('===activites Response Status======' + resAll.getStatus());
                                        System.debug('===activites Response body======' + resAll.getBody());
                                        if (resAll.getStatusCode() == 200) {
                                            // System.debug('===DocId======'+DocId);
                                            System.debug('===Document version Viewed======' + resAll.getBody());
                                            Map < String, Object > allActmap = (Map < String, Object > ) JSON.deserializeUntyped(resAll.getBody());
                                            list < Object > activityList = (list < Object > ) allActmap.get('UserActivities');
                                            System.debug('===Document version Viewed======' + activityList.size());

                                            if (activityList != null) {
                                                if (activityList.size() > 0) {
                                                    for (Object ac: activityList) {
                                                        Map < String, Object > acty = (Map < String, Object > ) ac;
                                                        Map < String, Object > actyIntiator = (Map < String, Object > ) acty.get('Initiator');

                                                        if (wdc.Workdocs_UserId__c == String.Valueof(actyIntiator.get('Id')) && (String.valueof(acty.get('Type')) == 'DOCUMENT_VERSION_VIEWED' || String.valueof(acty.get('Type')) == 'DOCUMENT_COMMENT_ADDED' || String.valueof(acty.get('Type')) == 'DOCUMENT_ANNOTATION_ADDED')) {
                                                            FileHighlightMap.put(DocId, false);
                                                            break;
                                                        } else if (wdc.Workdocs_UserId__c != String.Valueof(actyIntiator.get('Id')) && (String.valueof(acty.get('Type')) == 'DOCUMENT_COMMENT_ADDED' || String.valueof(acty.get('Type')) == 'DOCUMENT_ANNOTATION_ADDED')) {
                                                            FileHighlightMap.put(DocId, true);
                                                            break;
                                                        } else {
                                                            FileHighlightMap.put(DocId, false);
                                                            break;
                                                        }
                                                    }

                                                    if (!FileHighlightMap.ContainsKey(DocId)) {
                                                        FileHighlightMap.put(DocId, false);
                                                    }
                                                } else {
                                                    FileHighlightMap.put(DocId, false);
                                                }
                                            } else {
                                                FileHighlightMap.put(DocId, false);
                                            }

                                        } else if (!FileHighlightMap.ContainsKey(DocId)) {
                                            FileHighlightMap.put(DocId, false);
                                        }
                                    } catch (System.CalloutException e) {
                                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + e.getMessage()));
                                    }
                                }

                                System.debug('===Jobs FileHighlightMap======' + FileHighlightMap);

                            }

                        } else {
                            System.debug('==== After FID status===' + response.getStatus() + '====statusCode====' + response.getStatuscode());
                            folderAccess = false;
                        }
                    } else {
                        accTokenExpire = true;
                    }

                }
            }
        }
    }

    public void deleteWorkDoc() {

        WdDocumentId = apexpages.currentpage().getparameters().get('WdDocumentId');
        system.debug('workDocId ===========' + WdDocumentId);

        Workdocs_Connection__c a1 = [select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = : userinfo.getuserid() limit 1];
        String token = 'Bearer ' + a1.Access_Token__c;

        HttpRequest httpRequest44 = new HttpRequest();
        httpRequest44.setEndpoint('https://workdocs.' + a1.State__c + '.amazonaws.com/api/v1/documents/' + WdDocumentId);
        httpRequest44.setHeader('Authentication', token);
        httpRequest44.setHeader('Content-Type', 'application/json');
        httpRequest44.setMethod('DELETE');
        Http http44 = new Http();
        HttpResponse response44 = http44.send(httpRequest44);
        if (response44.getStatuscode() == 204) {
            callouts();
        } else if (response44.getStatusCode() == 404 && response44.getStatus() == 'Not Found') {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + 'You Don\'t have the Delete Permission on this Document'));
        }
    }

    public void createWorkDocsFolder() {
        String token = 'Bearer ' + wdc.Access_Token__c;
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/me/root');
        httpRequest.setHeader('Authentication', token);
        httpRequest.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(httpRequest);

        if (response.getStatus() != 'Unauthorized' && response.getStatuscode() != 401) {

            accTokenExpire = false;
            Map < String, Object > root = (Map < String, Object > ) JSON.deserializeUntyped(response.getBody());
            List < Object > Folders = (List < Object > ) root.get('Folders');
            Map < String, Object > objectMap = (Map < String, Object > ) Folders[0];
            System.debug('FileBody: ' + objectMap.get('Id'));

            //job.Workdocs_Folder_Id__c = string.valueof(objectMap.get('Id'));
            //update job;

            createFolder(job.Job_Auto_Number__c + ' - ' + job.name, string.valueof(objectMap.get('Id')), wdc.State__c, token, job.id);
        } else {
            accTokenExpire = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Your Access Token Expired, Please connect to WorkDocs again'));
        }
    }

    @future(callout = true)
    public static void createFolder(String Name, String Parent, String State, String token, String JobId) {
        HttpRequest httpRequest1 = new HttpRequest();
        httpRequest1.setEndpoint('https://workdocs.' + State + '.amazonaws.com/api/v1/folders');
        httpRequest1.setHeader('Authentication', token);
        httpRequest1.setHeader('Content-Type', 'application/json');
        httpRequest1.setBody('{\"Name\": \"' + Name + '\",\"ParentFolderId\": \"' + Parent + '\"}');
        httpRequest1.setMethod('POST');

        Http http1 = new Http();
        HttpResponse response1 = http1.send(httpRequest1);

        Map < String, Object > root = (Map < String, Object > ) JSON.deserializeUntyped(response1.getBody());
        Map < String, Object > objectMap = (Map < String, Object > ) root.get('Metadata');
        System.debug('FileBody: ' + root);

        Job__c jjj = new Job__c(Id = JobId);
        jjj.Workdocs_Folder_Id__c = string.valueof(objectMap.get('Id'));
        update jjj;
        //System.debug('FileStatus 1:'+response1.getStatusCode());
        //System.debug('FileBody 1:'+response1.getBody());
    }

    public void SubFolderPopUpAction() {
        SubFolderpopUp = true;
    }

    public void SubFolderPopUpActionClose() {
        SubFolderpopUp = false;
    }

    public void CreateSubFolder() {

        if (SubFolderName != '') {

            string token211 = 'Bearer ' + wdc.Access_Token__c;

            HttpRequest req211 = new HttpRequest();
            req211.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders');
            req211.setHeader('Content-type', 'application/json');
            req211.setHeader('Authentication', token211);
            req211.setBody('{\"Name\": \"' + SubFolderName + '\",\"ParentFolderId\": \"' + job.Workdocs_Folder_Id__c + '\"}');
            req211.setMethod('POST');

            http h211 = new http();
            httpResponse res211 = h211.send(req211);
            System.debug('====Status SubFolder Creation==' + res211.getStatus());
            System.debug('====Status SubFolder Creation==' + res211.getStatusCode());
            if (res211.getStatusCode() == 201) {

                Map < String, Object > sfd_map = (Map < String, Object > ) JSON.deserializeUntyped(res211.getbody());
                Map < String, Object > sflder_map = (Map < String, Object > ) sfd_map.get('Metadata');
                String jobSubFolderId = String.valueof(sflder_map.get('Id'));
                system.debug(jobSubFolderId);

                //Job_Sub_Folders__c jsfolder=new Job_Sub_Folders__c ();
                // jsfolder.Sub_Folder_Id__c=jobSubFolderId;
                // jsfolder.Job__c=Jobid;
                // insert jsfolder;
                callouts();
                SubFolderpopUp = false;
                SubFolderName = '';
            } else if (res211.getStatusCode() == 409 && res211.getStatus() == 'Conflict') {
                subfoldererror = false;
                subflderconflict = true;
                subflodercrationerror = false;
                SubFolderpopUp = true;
            } else if (res211.getStatusCode() == 404 && res211.getStatus() == 'Not Found') {
                subfoldererror = false;
                subflderconflict = false;
                subflodercrationerror = true;
                SubFolderpopUp = true;

            }
        } else {
            subflderconflict = false;
            subfoldererror = true;
            SubFolderpopUp = true;
        }
    }

    public void deltesubFolderContent() {

        SubFolderId = Apexpages.Currentpage().getParameters().get('SubFolderId');

        //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error,''+SubFolderId));
        string token44 = 'Bearer ' + wdc.Access_Token__c;
        HttpRequest req44 = new HttpRequest();
        req44.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/' + SubFolderId);
        req44.setHeader('Content-type', 'application/json');
        req44.setHeader('Authentication', token44);
        req44.setMethod('DELETE');

        http ht44 = new http();
        httpResponse res44 = ht44.send(req44);

        System.debug('Response for delete SubFolder Content' + res44.getBody());
        if (res44.getStatusCode() == 204) {
            callouts();
        }

        if (res44.getStatusCode() == 404) {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + 'You Don\'t have the Delete Permission on this Folder'));
        }

    }

    @RemoteAction
    public static String doUploadAttachment(String attachmentName, String attachmentBody, String attachmentType, String JobFolderId) {

        //system.debug('Attachment Body: '+ attachmentBody);

        Workdocs_Connection__c a = [select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = : userinfo.getuserid() limit 1];
        String token = 'Bearer ' + a.Access_Token__c;

        HttpRequest httpRequest1 = new HttpRequest();
        httpRequest1.setEndpoint('https://workdocs.' + a.State__c + '.amazonaws.com/api/v1/documents');
        httpRequest1.setHeader('Authentication', token);
        httpRequest1.setHeader('Content-Type', 'application/json');
        httpRequest1.setBody('{\"Name\": \"' + attachmentName + '\",\"ParentFolderId\": \"' + JobFolderId + '\", \"ContentType\": \"' + attachmentType + '\"}');
        httpRequest1.setMethod('POST');

        Http http1 = new Http();
        HttpResponse response1 = http1.send(httpRequest1);
        System.debug('FileStatus 1:' + response1.getStatusCode());
        System.debug('FileBody 1:' + response1.getBody());

        if (response1.getStatusCode() == 201) {
            Map < String, Object > uplinkMap = (Map < String, Object > ) JSON.deserializeUntyped(response1.getBody());

            system.debug('=======message Body=========' + uplinkMap);
            Map < String, Object > uplinkMap2 = (Map < String, Object > ) uplinkMap.get('Metadata');
            String docId = string.valueof(uplinkMap2.get('Id'));
            system.debug('Doc Id: ' + docId);

            Map < String, Object > uplinkMap3 = (Map < String, Object > ) uplinkMap2.get('LatestVersionMetadata');
            String VersionId = string.valueof(uplinkMap3.get('Id'));
            system.debug('Version Id: ' + VersionId);

            Map < String, Object > uplinkMap1 = (Map < String, Object > ) uplinkMap.get('UploadMetadata');
            String url = string.valueof(uplinkMap1.get('UploadUrl'));
            system.debug('Upload URL: ' + url);

            HttpRequest httpRequest2 = new HttpRequest();
            httpRequest2.setEndpoint(url);
            httpRequest2.setHeader('Authentication', token);
            httpRequest2.setHeader('Content-Type', attachmentType);
            httpRequest2.setHeader('x-amz-server-side-encryption', 'AES256');
            httpRequest2.setBodyAsBlob(EncodingUtil.base64Decode(attachmentBody));
            httpRequest2.setMethod('PUT');

            Http http2 = new Http();
            HttpResponse response2 = http2.send(httpRequest2);
            System.debug('FileStatus 2:' + response2.getStatusCode());
            System.debug('FileBody 2:' + response2.getBody());

            HttpRequest httpRequest3 = new HttpRequest();
            httpRequest3.setEndpoint('https://workdocs.' + a.State__c + '.amazonaws.com/api/v1/documents/' + docId + '/versions/' + VersionId);
            httpRequest3.setHeader('Authentication', token);
            httpRequest3.setHeader('Content-Type', 'application/json');
            httpRequest3.setBody('{\"VersionStatus\": \"ACTIVE\"}');
            httpRequest3.setHeader('X-HTTP-Method-Override', 'PATCH');
            httpRequest3.setMethod('POST');

            Http http3 = new Http();
            HttpResponse response3 = http3.send(httpRequest3);
            System.debug('FileStatus 3:' + response3.getStatusCode());
            System.debug('FileBody 3:' + response3.getBody());

        } else if (response1.getStatusCode() == 404 || response1.getStatus() == 'Not Found') {
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error,''+'You Don\'t have the Upload Permission on this Folders'));
            //uploaddocError=true;
            return 'NO';
        }
        return 'YES';
    }
   
}