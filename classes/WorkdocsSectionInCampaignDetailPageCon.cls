public with sharing class  WorkdocsSectionInCampaignDetailPageCon{
 
    public Campaign__c Camp{get;set;}
    public Workdocs_Connection__c wdc{get;set;}
    
    transient public Map<String, Map <String, Object>> MapofMap{get;set;}
    
    public list<String> flrdocmaplst {set;get;}
    public Map<String,Map<String,String>> flrdocmap {set;get;}
    public map<String,String> docidNameMap {set;get;}
    public map<String,String> f_SubNameIdmap {set;get;}
    public Map<String, Boolean> FileHighlightMap{get;set;} 
    public Map<String,Integer> flderDocSizeMap {get;set;}
    
    public string specialchars {set;get;}
    
        
    public Map<String,String> FolderIdNameMap {set;get;}
   
    public boolean accTokenExpire {set;get;}
    public boolean folderAccess   {set;get;}
    
   Public String SubFolderName {set;get;}
   public Boolean SubFolderpopUp {set;get;}
 
   public string SubFolderId {set;get;}
   public string WdDocumentId {set;get;}
   public boolean subfoldererror {set;get;}
   public boolean subflderconflict {set;get;}
   public boolean subflodercrationerror {set;get;}
   public boolean uploaddocError {set;get;}
   public boolean specialCharError {set;get;}
   
   public static string fileName {set;get;}
   public static  string contentType {set;get;}
   public transient static  blob filebody   {set;get;}
   public static string flderId    {set;get;}
    
   public Boolean isMainFolderDeleteButtonClick {set;get;}
  

  public WorkdocsSectionInCampaignDetailPageCon(ApexPages.StandardController controller) {
      CampCallouts();
   }
    
  public WorkdocsSectionInCampaignDetailPageCon(){
   //CampCallouts();
  }
 
  public void CampCallouts() {
        isMainFolderDeleteButtonClick=false;
        SubFolderpopUp = false;
        subfoldererror = false;
        subflderconflict = false;
        subflodercrationerror = false;
        uploaddocError = false;
        specialCharError=false;
        specialchars='" * / : < > ? \\ |';

        flrdocmaplst = new list < String > ();
        flrdocmap = new Map < String, Map < String, String >> ();
        f_SubNameIdmap = new map < String, String > ();
        docidNameMap = new Map < String, String > ();
        FileHighlightMap = new Map < String, Boolean > ();
        flderDocSizeMap = new Map < String, Integer > ();

        MapofMap = new Map < String, Map < String, Object >> ();
        FolderIdNameMap = new Map < String, String > ();
        String CampId = Apexpages.currentpage().getparameters().get('id');
        Camp = [select id, name, Workdocs_Folder_Id__c from Campaign__c where id = : CampId];

        list <Workdocs_Connection__c > wdcList = new list < Workdocs_Connection__c > ();
        wdcList = [select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, WD_Org_Id__c,Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = : userinfo.getuserid() limit 1];
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

                if (Camp.Workdocs_Folder_Id__c != null && Camp.Workdocs_Folder_Id__c != '') {

                    String token = 'Bearer ' + wdc.Access_Token__c;
                    HttpRequest httpRequest = new HttpRequest();
                    httpRequest.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/' + Camp.Workdocs_Folder_Id__c + '/contents'); //?include=Include&order=ASCENDING&sort=DATE&type=FOLDER
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
                            flrdocmap.put('' + Camp.Workdocs_Folder_Id__c, DIdNameMap);
                            f_SubNameIdmap.put('' + Camp.Workdocs_Folder_Id__c, '' + Camp.Name);
                            flderDocSizeMap.put('' + Camp.Workdocs_Folder_Id__c, DIdNameMap.size());
                            flrdocmaplst.add('' + Camp.Workdocs_Folder_Id__c);
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

                       /*     if (docidNameMap.size() > 0) {
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
                                        }
                                        else if(!FileHighlightMap.ContainsKey(DocId)) {
                                            FileHighlightMap.put(DocId, false);
                                        }
                                    } catch (System.CalloutException e) {
                                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + e.getMessage()));
                                    }
                                }

                            }
                        */
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
            

            createFolder(Camp.name, string.valueof(objectMap.get('Id')), wdc.State__c, token, Camp.id);
        } else {
            accTokenExpire = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Your Access Token Expired, Please connect to WorkDocs again'));
        }
    }

    @future(callout = true)
    public static void createFolder(String Name, String Parent, String State, String token, String CamId) {
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

        Campaign__c cmp = new Campaign__c(Id = CamId);
        system.debug(string.valueof(objectMap.get('Id')));
        cmp.Workdocs_Folder_Id__c = string.valueof(objectMap.get('Id'));
        update cmp;
        
        //System.debug('FileStatus 1:'+response1.getStatusCode());
        //System.debug('FileBody 1:'+response1.getBody());
    }

    public void SubFolderPopUpAction() {
        SubFolderpopUp = true;
    }

    public void SubFolderPopUpActionClose() {
        SubFolderpopUp = false;
    }
    
    public void mainFolderDeletePopAction() {
        isMainFolderDeleteButtonClick = true;
    }
    
    public void mainFolderDeletePopActionUpClose() {
        isMainFolderDeleteButtonClick = false;
    }

    
    
    
    public void deleteMainFolder(){
    
        String token = 'Bearer ' + wdc.Access_Token__c;
        HttpRequest hreq = new HttpRequest();
        hreq.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/'+ Camp.Workdocs_Folder_Id__c); //?include=Include&order=ASCENDING&sort=DATE&type=FOLDER
        hreq.setHeader('Authentication', token);
        hreq.setMethod('DELETE');
        
        http htp=new http();
        httpresponse hres=htp.send(hreq);
        System.debug('===Delete Main Folder response Status==='+hres.getStatus());
         System.debug('===Delete Main Folder response Status==='+hres.getBody());
        System.debug('===Delete Main Folder response Status Code==='+hres.getStatusCode());
        
        if(hres.getStatusCode()==204 ){
            isMainFolderDeleteButtonClick=false;
            Campaign__c cmp = new Campaign__c(Id = Camp.Id);
            cmp.Workdocs_Folder_Id__c =null;
            update cmp;
            Camp = [select id, name, Workdocs_Folder_Id__c from Campaign__c where id = : Camp.Id]; 
        }
        else{
            isMainFolderDeleteButtonClick=false;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFo,'You don\'t have access to Delete this Folder'));
        }
    }
    
     public void  shareMainFolder(){
         list<Workdocs_Connection__c> WDUsersList=[SELECT Id, Name,User__c, Site_Name__c, Workdocs_UserId__c, WD_Org_Id__c FROM Workdocs_Connection__c where State__c != null and User__c !=: userinfo.getuserid()];
         string Userlist='';
         String token = 'Bearer ' + wdc.Access_Token__c;  
         if(WDUsersList.size()>0){
             for(Workdocs_Connection__c wu:WDUsersList){
                 if(wu.Workdocs_UserId__c!=null && wu.Workdocs_UserId__c!=''){
                     if(Userlist!=''){
                         Userlist+=','+'{\"Id\": \"'+wu.Workdocs_UserId__c+'\",\"Role\": \"CONTRIBUTOR\", \"Type\": \"USER\"}';
                     }else{
                         Userlist='{\"Id\": \"'+wu.Workdocs_UserId__c+'\",\"Role\": \"CONTRIBUTOR\", \"Type\": \"USER\"}';
                     }
                     
                 }
             }
         }
         System.debug('=====ArrayObjects==='+ '['+Userlist+']');
         
         
         if(Userlist!=''){
             HttpRequest htreq=new HttpRequest();
             htreq.setEndpoint('https://workdocs.'+ wdc.State__c + '.amazonaws.com/api/v1/resources/'+Camp.Workdocs_Folder_Id__c+'/permissions');
             htreq.setHeader('Authentication', token);
             htreq.setHeader('Content-type','application/json');
             //htreq.setBody('{\"NotificationOptions\":{\"EmailMessage\": \"'+Camp.Name+' Folder is Shared with you\", \"SendEmail\": \"true\" },\"Principals\": [{ \"Id\": \"'+wu.Workdocs_UserId__c+'\", \"Role\": \"CONTRIBUTOR\", \"Type\": \"USER\"}]}');
             htreq.setBody('{\"NotificationOptions\":{\"EmailMessage\": \"'+Camp.Name+' Folder is Shared with you\", \"SendEmail\": \"true\" },\"Principals\":['+Userlist+']}'); 
             htreq.setMethod('POST');
             
              System.debug('=====Userlist String==='+ '{\"NotificationOptions\":{\"EmailMessage\": \"'+Camp.Name+' Folder is Shared with you\", \"SendEmail\": \"true\" },\"Principals\":['+Userlist+']}');
             
             http ht=new http();
             httpResponse hres=ht.send(htreq);
             System.debug('=====share response Body==='+hres.getBody());
             System.debug('=====share response Body==='+hres.getStatus());
             System.debug('=====share response Body==='+hres.getStatusCode());
           
             if(hres.getStatusCode()==201 && hres.getStatus()=='Created'){
                 Map<String,Object> sharingMap=(Map<String,Object>)JSON.deserializeUntyped(hres.getBody());
                 System.debug('=====sharingMap==='+sharingMap);
                 list<Object> ShareResult=(list<Object>)sharingMap.get('ShareResults');
                 for(Object aa: ShareResult){
                     System.debug('=====ShareResult==='+aa);
                 }
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'\"'+Camp.Name+'\" Folder is Shared with All Workdoc Users'));
             }
             else{
                 Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFo,'You don\'t have access to share the folder with workdoc Users'));
             }
             
         }
         
    }
    
public void CreateSubFolder() {

    if (SubFolderName != '') {

        string token211 = 'Bearer ' + wdc.Access_Token__c;

        HttpRequest req211 = new HttpRequest();
        req211.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders');
        req211.setHeader('Content-type', 'application/json');
        req211.setHeader('Authentication', token211);
        req211.setBody('{\"Name\": \"' + SubFolderName + '\",\"ParentFolderId\": \"' + Camp.Workdocs_Folder_Id__c + '\"}');
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

            CampCallouts();
            SubFolderpopUp = false;
            SubFolderName = '';
        } else if (res211.getStatusCode() == 409 && res211.getStatus() == 'Conflict') {
            subfoldererror = false;
            subflodercrationerror = false;
            specialCharError=false;
            subflderconflict = true;
            SubFolderpopUp = true;
        } else if (res211.getStatusCode() == 404 && res211.getStatus() == 'Not Found') {
            subfoldererror = false;
            subflderconflict = false;
            specialCharError=false;
            subflodercrationerror = true;
            SubFolderpopUp = true;
        }
       else if(res211.getStatusCode() == 400 && res211.getStatus() == 'Bad Request'){
          subfoldererror = false;
          subflderconflict = false;
          subflodercrationerror = false;
          specialCharError=true;
          SubFolderpopUp = true;
         
      }
    } else {
        subflderconflict = false;
        subfoldererror = true;
        SubFolderpopUp = true;
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
            CampCallouts();
        } else if (response44.getStatusCode() == 404 && response44.getStatus() == 'Not Found') {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + 'You Don\'t have the Delete Permission on this Document'));
        }
    }

    public void deltesubFolderContent() {

        SubFolderId = Apexpages.Currentpage().getParameters().get('SubFolderId');

        string token44 = 'Bearer ' + wdc.Access_Token__c;
        HttpRequest req44 = new HttpRequest();
        req44.setEndpoint('https://workdocs.' + wdc.State__c + '.amazonaws.com/api/v1/folders/' + SubFolderId);
        req44.setHeader('Content-type', 'application/json');
        req44.setHeader('Authentication', token44);
        req44.setMethod('DELETE');

        http ht44 = new http();
        httpResponse res44 = ht44.send(req44);
        System.debug('===Response Status======' + res44.getStatus());
        System.debug('=====Response Status Code======' + res44.getStatuscode());
        System.debug('Response for delete SubFolder Content' + res44.getBody());
        if (res44.getStatusCode() == 204) {
            Campcallouts();
        }

        if (res44.getStatusCode() == 404) {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, '' + 'You Don\'t have the Delete Permission on this Folder'));
        }

    }

    @RemoteAction
    public static string doUploadAttachment(String filename, string filecontent, String filetype, String jobfolderid) {

        Workdocs_Connection__c a3 = [select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = : userinfo.getuserid() limit 1];
        String token3 = 'Bearer ' + a3.Access_Token__c;

        HttpRequest hreq = new HttpRequest();
        hreq.setEndpoint('https://workdocs.' + a3.State__c + '.amazonaws.com/api/v1/documents');
        hreq.setHeader('Authentication', token3);
        hreq.setHeader('Content-Type', 'application/json');
        // hreq.setBody('{\"Name\": \"'+filename+'\",\"ContentType\": \"'+filetype+'\", \"ParentFolderId\": \"'+jobfolderid+'\"}');
        hreq.setBody('{"Name": \"' + filename + '\","ParentFolderId": \"' + jobfolderid + '\", "ContentType": \"' + filetype + '\"}');
        hreq.setMethod('POST');

        Http ht1 = new Http();
        HttpResponse hres = ht1.send(hreq);
        
       if(hres.getStatusCode()==201){
        System.debug('==Intiate Doc Response Code:===' + hres.getStatusCode());
        System.debug('===Sharing Folder Response Code Body:===' + hres.getBody());
        Map < String, Object > uploadMap = (Map < String, Object > ) JSON.deserializeUntyped(hres.getBody());

        String DocumentId = String.valueOf(((Map < String, Object > ) uploadMap.get('Metadata')).get('Id'));
        String VersionId = String.valueOf(((Map < String, Object > )((Map < String, Object > ) uploadMap.get('Metadata')).get('LatestVersionMetadata')).get('Id'));
        String UploadUrl = String.valueOf(((Map < String, Object > ) uploadMap.get('UploadMetadata')).get('UploadUrl'));

        System.debug('===DocumentId===' + DocumentId);
        System.debug('===VersionId===' + VersionId);
        System.debug('===UploadUrl===' + UploadUrl);

        HttpRequest Upreq = new HttpRequest();
        Upreq.setEndpoint(UploadUrl);
        Upreq.setHeader('Authentication', token3);
        Upreq.setHeader('Content-Type', filetype);
        Upreq.setHeader('x-amz-server-side-encryption', 'AES256');
        Upreq.setBodyAsBlob(EncodingUtil.base64Decode(filecontent));
        Upreq.setMethod('PUT');

        Http ht2 = new Http();
        HttpResponse hres2 = ht2.send(Upreq);

        System.debug('==upload Response Code:===' + hres2.getStatusCode());
        System.debug('==upload Response status:===' + hres2.getStatus());
        System.debug('===Upload Response Code Body:===' + hres2.getBody());
        // Map<String,Object> uploadMap=(Map<String,Object>) JSON.deserializeUntyped(hres2.getBody());

        HttpRequest DUpdreq = new HttpRequest();
        DUpdreq.setEndpoint('https://workdocs.' + a3.State__c + '.amazonaws.com/api/v1/documents/' + DocumentId + '/versions/' + VersionId);
        DUpdreq.setHeader('Authentication', token3);
        DUpdreq.setHeader('Content-Type', 'application/json');
        DUpdreq.setBody('{"VersionStatus": "ACTIVE"}');
        DUpdreq.setHeader('X-HTTP-Method-Override', 'PATCH');
        DUpdreq.setMethod('POST');

        Http ht3 = new Http();
        HttpResponse hres3 = ht3.send(DUpdreq);

        System.debug('==Update Response Code:===' + hres3.getStatusCode());
        System.debug('==Update Response status:===' + hres3.getStatus());
        System.debug('===Update Response Code Body:===' + hres3.getBody());
       }
        else if (hres.getStatusCode() == 404 || hres.getStatus() == 'Not Found') {
            return 'NO';
        }
        return 'YES';

    }

    /* 
     public void uploadDocuments(){

     //flderId=apexpages.currentpage().getparameters().get('FlderId');

     //System.debug('=flderId='+flderId);

     System.debug('===fileName==='+fileName );
     System.debug('===contentType='+contentType);
     System.debug('===filebody==='+filebody);
     //System.debug('===filebody Size==='+filebody.size());

     Workdocs_Connection__c  a3 = [select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c, Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = :userinfo.getuserid() limit 1];
         String token3 = 'Bearer '+a3.Access_Token__c;

         HttpRequest hreq = new HttpRequest();
         hreq.setEndpoint('https://workdocs.'+a3.State__c+'.amazonaws.com/api/v1/documents');
         hreq.setHeader('Authentication', token3);
         hreq.setHeader('Content-Type', 'application/json');
        // hreq.setBody('{\"Name\": \"'+filename+'\",\"ContentType\": \"'+filetype+'\", \"ParentFolderId\": \"'+jobfolderid+'\"}');
         hreq.setBody('{"Name": \"'+fileName +'\","ParentFolderId": \"'+Camp.Workdocs_Folder_Id__c+'\", "ContentType": \"'+contentType+'\"}');
         hreq.setMethod('POST');

         Http ht1 = new Http();
         HttpResponse hres = ht1.send(hreq);
         System.debug('==Intiate Doc Response Code:==='+hres.getStatusCode());
         System.debug('===Sharing Folder Response Code Body:==='+hres.getBody());
         Map<String,Object> uploadMap=(Map<String,Object>) JSON.deserializeUntyped(hres.getBody());

         String DocumentId=String.valueOf(((Map<String,Object>)uploadMap.get('Metadata')).get('Id'));
         String VersionId=String.valueOf(((Map<String,Object>)((Map<String,Object>)uploadMap.get('Metadata')).get('LatestVersionMetadata')).get('Id'));
         String UploadUrl=String.valueOf(((Map<String,Object>)uploadMap.get('UploadMetadata')).get('UploadUrl'));

         System.debug('===DocumentId==='+DocumentId);
         System.debug('===VersionId==='+VersionId);      
         System.debug('===UploadUrl==='+UploadUrl);

         AsyncUpload(DocumentId,VersionId,UploadUrl,token3,filebody,contentType,a3.State__c);
      }

    @future(callout=true)
     public static void AsyncUpload(String DocumentId,String VersionId,String UploadUrl,String token3,blob filebody,String contentType,String state){

         HttpRequest Upreq = new HttpRequest();
         Upreq.setEndpoint(UploadUrl);
         Upreq.setHeader('Authentication', token3);
         Upreq.setHeader('Content-Type',contentType);
         Upreq.setHeader('x-amz-server-side-encryption', 'AES256');
         Upreq.setBodyAsBlob(filebody);
         Upreq.setMethod('PUT');

        Http ht2 = new Http();
         HttpResponse hres2 = ht2.send(Upreq);

         System.debug('==upload Response Code:==='+hres2.getStatusCode());
          System.debug('==upload Response status:==='+hres2.getStatus());
         System.debug('===Upload Response Code Body:==='+hres2.getBody());
        // Map<String,Object> uploadMap=(Map<String,Object>) JSON.deserializeUntyped(hres2.getBody());

         HttpRequest DUpdreq = new HttpRequest();
         DUpdreq.setEndpoint('https://workdocs.'+state+'.amazonaws.com/api/v1/documents/'+DocumentId+'/versions/'+VersionId);
         DUpdreq.setHeader('Authentication', token3);
         DUpdreq.setHeader('Content-Type', 'application/json');
         DUpdreq.setBody('{"VersionStatus": "ACTIVE"}');
         DUpdreq.setHeader('X-HTTP-Method-Override','PATCH');
         DUpdreq.setMethod('POST');

        Http ht3 = new Http();
         HttpResponse hres3 = ht3.send(DUpdreq);

         System.debug('==Update Response Code:==='+hres3.getStatusCode());
          System.debug('==Update Response status:==='+hres3.getStatus());
         System.debug('===Update Response Code Body:==='+hres3.getBody());

         if(hres3.getStatusCode()==404 || hres3.getStatus()=='Not Found'){
          //return 'NO';
          }
         //return 'YES';

     }
     */
    
}