public without sharing class SiteJobRequestFormVfPageExt {
    
    public boolean isMobile{private set; get{
        String theme = UserInfo.getUITheme();
        return (theme=='Theme4t')?true:false;
    }
                           }
    
    transient Public Attachment att;
    Public Attachment getatt()
    {
        att = new Attachment();
        return att;
    }
    
    public String CSimageBody {get; set;}
    public String CSImgH {get; set;}
    public String CSImgW {get; set;}
    public String CSSiteHeader {get; set;}
    public String CSCusText {get; set;}
    public String CSFileSecCusText {get; set;}
    
    public boolean CSFileSec {get; set;}
    
    public String SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid,ScheduleType,ScheduleCalc;
    
    public Job__c obJob;
    
    public Job__c objJob{get; set;}
    
    public String getCampaignName() { return CampaignName; }
    public void setCampaignName(String s) {  this.CampaignName = s; }
    
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    
    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }
    
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
    public String getCCName() {  return CCName; }
    public void setCCName(String s) {  this.CCName = s; }
    
    public list<Spec_Item__c> lstspecItems{get; set;}
    
    public list<Job_Spec__c> lstJobspec{get; set;}
    
    Public Map<String,String> MapSpecItems{get;set;}
    
    public boolean pgb2{get; set;}
    
    public boolean pgb1{get; set;}    
    
    // public boolean displayPopup {get; set;} 
    
    public string pwdVal;
    public string loginHeader{get; set;}
    public String PasswordVal {get; set;}
    public boolean JobReqEnable {get; set;}
    public boolean PasswordEnable {get; set;}
    Public String paramVal;
    
    
    public SiteJobRequestFormVfPageExt(ApexPages.StandardController controller) {
        
        this.obJob=(Job__c)controller.getRecord();     
        paramVal=System.currentPagereference().getParameters().get('createJob');
        system.debug('>>paramVal>>>>>>'+paramVal);
        pgb2 = true;        
        pgb1 = true;
        
       /* if(paramVal == 'newJob')
        {
            JobReqEnable = true;
            PasswordEnable = false;
        }
        else{
            JobReqEnable = false;
            PasswordEnable = true;
        }
        */
        Site_Request_Form_Settings__c activeSettings = Site_Request_Form_Settings__c.getOrgDefaults();
        CSimageBody= activeSettings.Org_URL__c;
        CSImgH=activeSettings.Height_of_the_Image__c;
        CSImgW=activeSettings.Width_of_the_Image__c;
        CSSiteHeader=activeSettings.Site_Header_Name__c;
        CSCusText=activeSettings.CustomText__c;
        CSFileSec=activeSettings.Files_Section__c;
        CSFileSecCusText=activeSettings.File_Section_custom_text__c;
        pwdVal=activeSettings.Dummy_Text_Area_2__c;
        loginHeader=activeSettings.Dummy_Text_Area_1__c;
    }
    
    
    
    Map<id,List<Spec_Item__c>> maplstspec=new Map<id,List<Spec_Item__c>>();
    
    public List<selectOption> getCampaigns() 
    {   
        List<selectOption> optionList = new List<selectOption>();
        
        optionList.add(new selectOption('', '- None -')); 
        
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c where Status__c='Active' order by Name]) 
        {         
            optionList.add(new selectOption(a.Id, a.Name)); 
            
        }
        
        return optionList;  
    }
    
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }            
        return optionList;  
    }
    // public List<selectOption> optionList1{get;set;}
    public List<selectOption> getScheduleTemplates()
    {
        List<selectOption> optionList1 = new List<selectOption>();   
        optionList1.add(new selectOption('', '- None -')); 
        for (Schedule_Template__c r : [SELECT Id,Name FROM Schedule_Template__c where Media_Types__c=: MTName and Active__c=True order by Name]) 
        { 
            optionList1.add(new selectOption(r.Id, r.Name));
        }
        return optionList1;
    }
    
    public List<selectOption> getClients() 
    {        
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));  
        }
        return optionList;  
    }
    
    public List<selectOption> getClientContacts()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Client_Contact__c r : [SELECT Id,Name FROM Client_Contact__c where Client__c =: Clientname and Active__c =:true order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    
    
    public void specList(){           
        lstspecItems = new list<Spec_Item__c>();
        MapSpecItems = new Map<String,String>();
        system.debug('spec is ....'+SpecTempName);
        lstspecItems = [select Name,Description__c,Sort_Order__c,Specification_Template__r.Name from Spec_Item__c where Specification_Template__c =: SpecTempName order by Sort_Order__c];
        if(lstspecItems.size()>0)
        {
            for(Spec_Item__c SpecItem:lstspecItems)
            {
                MapSpecItems.put(SpecItem.Name, SpecItem.Description__c);
            }
        }
        
    }
    
    public List<selectOption> getSpecificationTemplates() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Specification_Template__c a : [SELECT Id, name FROM Specification_Template__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
    public void Login(){  
        system.debug('>>>>>>>'+pwdVal);
        system.debug('>>>>>>>'+PasswordVal);
        if(pwdVal.equals(PasswordVal))
        {
            JobReqEnable = true;
            PasswordEnable = false;
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Password!! Please try again.');
            ApexPages.addMessage(myMsg);
        }        
       /* if(pwdVal == PasswordVal)
        {
            JobReqEnable = true;
            PasswordEnable = false;
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Password!! Please try again.');
            ApexPages.addMessage(myMsg);
        }*/
        
    }
    
    public void Reset(){  
        PasswordVal='';
    }
    
    public PageReference cancelme(){  
       PageReference p = new PageReference('/apex/JobRequestFormSiteVfPage');
        p.setRedirect(true); 
        return p;
    }
    
    Public pagereference newJob(){
        Pagereference pg= new Pagereference('/apex/JobRequestFormSiteVfPage');
        pg.setRedirect(true);
        return pg;    
    }
    
    
    public PageReference saveme(){  
        
        /* if(att.Body == null)
{
//String stringMediaType = Schema.Job__c.fields.Name.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' : You must select a file.');
ApexPages.addMessage(myMsg);
return null;
}*/
        
        if(obJob.Name == null)
        {
            String stringProjectName = Schema.Job__c.fields.Name.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringProjectName+' : You must enter a '+stringProjectName);
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        /*  if(obJob.Requested_Due_Date__c == null)
{
String stringDueDate = Schema.Job__c.fields.Requested_Due_Date__c.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringDueDate+' : You must enter a '+stringDueDate);
ApexPages.addMessage(myMsg);
return null;
}*/
        
        
        
        if(MTName == null)
        {
            String stringMediaType = Schema.Job__c.fields.Media_Types__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must select a '+stringMediaType+'.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        
        if(ScheduleTemp == null)
        {
            String strSchedule = Schema.Job__c.fields.Schedule_Template__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select a '+strSchedule +'.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        /* if(ClientName == null )
{
String strClientName = Schema.Job__c.fields.JS_Client__c.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strClientName +' : You must select a '+strClientName +'.' );
ApexPages.addMessage(myMsg);
return null;
}*/
        
        
        if(SpecTempName == null )
        {
            String strSpecificationTemp = Schema.Job__c.fields.Specification_Template__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSpecificationTemp +' : You must select a '+strSpecificationTemp +'.' );
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        else{
            if (Schema.sObjectType.Job__c.fields.Campaign__c.isCreateable()) {
                obJob.Campaign__c=CampaignName;
            }
            if (Schema.sObjectType.Job__c.fields.Media_Types__c.isCreateable()) {   
                obJob.Media_Types__c=MTName;
            }
            if (Schema.sObjectType.Job__c.fields.Schedule_Template__c.isCreateable()) {   
                obJob.Schedule_Template__c=ScheduleTemp;
            }    
            if (Schema.sObjectType.Job__c.fields.Specification_Template__c.isCreateable()) {   
                obJob.Specification_Template__c=SpecTempName;
            }
            if (Schema.sObjectType.Job__c.fields.Schedule_Calc__c.isCreateable()) {   
                obJob.Schedule_Calc__c ='End Date';
            }
            if (Schema.sObjectType.Job__c.fields.JS_Client__c.isCreateable()) {   
                obJob.JS_Client__c=ClientName;
            }
            if (Schema.sObjectType.Job__c.fields.JS_Client_Contact__c.isCreateable()) {   
                obJob.JS_Client_Contact__c =CCName;
            }
            /* if (Schema.sObjectType.Job__c.fields.Site_Job_Request__c.isCreateable()) {   
                obJob.Site_Job_Request__c =true;
            }*/
            
            
            
            try{
                
                If(Test.isRunningTest()==false){ 
                    if(Schema.sObjectType.Job__c.isCreateable()){
                        insert obJob;
                    }
                }
                list<Job_Spec__c> lstJspec = new list<Job_Spec__c>();
                if(SpecTempName != null){
                    
                    List<Job_Spec__c> lstExtSpecs = new List<Job_Spec__c>();
                    lstExtSpecs = [select Id, Name from Job_Spec__c where Job__c =:obJob.Id];
                    If(lstExtSpecs.size()>0){
                        if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
                            delete lstExtSpecs;
                        }
                    }
                    /*integer i=0;
for(String mapSpec:MapSpecItems.keySet())
{
Job_Spec__c jobSpec = new Job_Spec__c();
if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) { 
jobSpec.Job__c = obJob.Id;
}
if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) { 
jobSpec.Name = mapSpec;
}
if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) { 
jobSpec.Description__c = MapSpecItems.get(mapSpec);
}

if (Schema.sObjectType.Job_Spec__c.fields.Sort_Order__c.isCreateable()) { 
jobSpec.Sort_Order__c = i+1;
}

lstJspec.add(jobSpec);
}*/
                    for(Spec_Item__c obj:lstspecItems)
                    {
                        Job_Spec__c jobSpec = new Job_Spec__c();
                        if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) { 
                            jobSpec.Job__c = obJob.Id;
                        }
                        if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) { 
                            jobSpec.Name = obj.Name;
                        }
                        if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) { 
                            jobSpec.Description__c = obj.Description__c;
                        }
                        if (Schema.sObjectType.Job_Spec__c.fields.Sort_Order__c.isCreateable()) { 
                            jobSpec.Sort_Order__c = obj.Sort_Order__c;
                        }
                        
                        lstJspec.add(jobSpec);
                        
                    }
                    if(lstJspec.size()>0)
                    {
                        if(Schema.sObjectType.Job_Spec__c.isCreateable()){ 
                            insert lstJspec; 
                        }
                    }
                }
                string strid = obJob.Id; 
                if(CSFileSec)
                {
                    if(att.Body != null)
                    {
                        
                        ContentVersion conVer = new ContentVersion();
                        conVer.ContentLocation = 'S'; 
                        conVer.PathOnClient = att.name;
                        conVer.Title = att.name; 
                        conVer.versionData = att.body; 
                        conVer.IsMajorVersion=true;
                        conVer.SharingOption='A';
                       // conVer.PublishStatus='P';
                        conVer.Origin='C';
                        conVer.ContentLocation='S';
                        conVer.IsAssetEnabled = false;
                        insert conVer;
                         System.debug('conVer : ' + conVer.Id);
                        
                        // First get the content document Id from ContentVersion
                        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                        
                        //Create ContentDocumentLink
                        ContentDocumentLink cDe = new ContentDocumentLink();
                        cDe.ContentDocumentId = conDoc;
                        cDe.LinkedEntityId = obJob.Id; // you can use objectId,GroupId etc
                        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                        cDe.Visibility = 'AllUsers';
                        insert cDe;
                         System.debug('cDe : ' + cDe.Id);
                        
                     /*   Attachment attach = new Attachment(
                            parentid = obJob.Id,
                            name = att.name,
                            body = att.body);
                        insert attach;*/
                        
                    }
                }
                // displayPopup = true; 
                obJob = new Job__c();           
                PageReference p = new PageReference('/apex/SessionDetailPage');
                p.setRedirect(true); 
                objJob =  obJob;
                lstJobspec = new list<Job_Spec__c>();  
                lstJobspec  = [Select Id, Name,Description__c from Job_Spec__c where Job__c =:strid ];
                return p;
                
            }
            catch(Exception e)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,e.getMessage());
                ApexPages.addMessage(myMsg);             
                return null; 
            }
            
        }
        
    }
    
    // End of method Save  
    
}