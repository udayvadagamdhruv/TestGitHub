// This class is used to Display Jobs Under Campaign
public with sharing class DisplayJobsUnderCampaignController 
{
  /*  
    // Global variables
    public String theId;
    public String strStatus{get;set;}
    public String selectedCTemp {set;get;}
    Transient public List<Job__c> lstJob{get;set;}
    public integer count;
    public integer countstr;
    Transient public List<Job__c> lstJobNotes{get;set;}       
    Transient public List<Job__c> lstJobAttach{get;set;}      
    Transient public List<Job__c> lstJobChatter{get;set;}
    Public Map<Id,String> CampTempMap    {set;get;}
    Public Map<Id,List<Job__c>> CampTempJobsMap  {set;get;}
    
    //   public boolean ShowCampaignTemplate{get;set;}
    
    //added by rahul
    public String orgId{get; set;}
    
    public boolean isLightning{ set; get{
        String theme = UserInfo.getUITheme();
        return (theme=='Theme4d')?true:false;
    }
                              }
    
    
    //added ends here
    
    // End of Global variables
    public List<selectOption> getStatusList() 
    {
        List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
        optionList.add(new selectOption('All Jobs', 'All Jobs')); 
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
        
        return optionList;  
    }
    // Start Constructor
    public DisplayJobsUnderCampaignController()
        
    {
        strStatus= 'Active';
        theId=ApexPages.CurrentPage().getParameters().get('Id');
        //code added by rahul
        orgId = UserInfo.getOrganizationId();
        system.debug('org id --------->'+orgId);
        //added condition for syfy org by rahul.
        //if(orgId == '00DE0000000Xp80MAC' || orgId == '00DL00000027DtxMAE' || orgId == '00DA0000000Cir8MAC'){
        lstJob=new list<Job__c>();
        // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+lstJob.size()));
        
        //      JS_Campaign_Settings__c activeSettings = JS_Campaign_Settings__c.getOrgDefaults();
        //      ShowCampaignTemplate =activeSettings.Campaign_Template__c;
        
        
        CampTempMap=new Map<Id,String>();
        CampTempJobsMap=new Map<Id,List<Job__c>>();
        
        
        lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__r.name,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:theId and Status__c = :'Active' ORDER BY JOB_Auto_NUmber__c  LIMIT 1000];
        lstJobNotes=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, title, body from notes) from Job__c where Campaign__c=:theId and Status__c = :'Active'  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];        
        lstJobAttach=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c ,(select id, Name from Attachments) from Job__c where Campaign__c=:theId  and Status__c = :'Active' ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];       
        lstJobChatter=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c ,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Campaign__c=:theId and Status__c = :'Active'  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
        
        
        list<Campaign_Template__c> ctempLst=new list<Campaign_Template__c>();
        ctempLst=[select id,Name from Campaign_Template__c];
        for(Campaign_Template__c temp:ctempLst){
            CampTempMap.put(temp.id,temp.Name);
        }
        
        
        // }
        //else{
        // strStatus= 'Active';
        //Yogini 07May13 added estimate field in select clause in below line
        // lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:theId and Status__c = :'Active' ORDER BY JOB_Auto_NUmber__c LIMIT 1000];
        //}
        //added code ends here
        
        //lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c from Job__c where Campaign__c=:theId ORDER BY JOB_Auto_NUmber__c LIMIT 5000];
    }
    // End of Constructor
    
    public PageReference createNewJob() 
    {
        
        if(isLightning)
        {
            PageReference pg = new PageReference('/apex/createJobUnderCampaignLightning?Campaign='+theId);
            pg.setRedirect(True);
            return pg;
        }
        else
        {
            PageReference pg = new PageReference('/apex/createJobUnderCampaign?Campaign='+theId);
            pg.setRedirect(True);
            return pg;
        }
    }
    
    public void populateJobList()
    {
        /*if(strStatus == 'All Jobs')
lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c from Job__c where Campaign__c=:theId ORDER BY JOB_Auto_NUmber__c LIMIT 1000];
else
lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c from Job__c where Campaign__c=:theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c LIMIT 1000];
system.debug('lst :::::::::::::::;; ' + lstJob.size());
        
        // count = [select count() from Job__c where JS_Client__c =: theId];
        count = [select count() from Job__c where Campaign__c =: theId];
        System.debug('=============================================theId===================================='+theId);
        System.debug('=============================================Count===================================='+count);
        
        
        if(strStatus != 'All Jobs')
        {
            countstr = [select count() from Job__c where Campaign__c=: theId and Status__c = :strStatus];
        }
        
        if(strStatus == 'All Jobs')
        {
            if(count>1000)
            {
                //Yogini 07May13 added estimate field in select clause
                // System.debug('============================count>1000-===========================================1000'+count);
                lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__r.name,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:theId ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                lstJobNotes=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, title, body from notes) from Job__c where Campaign__c=:theId   ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];        
                lstJobAttach=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, Name from Attachments) from Job__c where Campaign__c=:theId  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];     
                lstJobChatter=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Campaign__c=:theId  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
                
                
            }else
            {
                //Yogini 07May13 added estimate field in select clause 
                //System.debug('============================count<10==========================================='+count);
                lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__r.name,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:theId ORDER BY JOB_Auto_NUmber__c DESC  LIMIT 1000];
                lstJobNotes=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, title, body from notes) from Job__c where Campaign__c=:theId   ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];     
                lstJobAttach=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, Name from Attachments) from Job__c where Campaign__c=:theId  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];     
                lstJobChatter=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Campaign__c=:theId  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
            }
        }else
        {
            if(countstr >1000 )
            {
                //Yogini 07May13 added estimate field in select clause 
                lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__r.name,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                lstJobNotes=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, title, body from notes) from Job__c where Campaign__c=:theId  and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];       
                lstJobAttach=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, Name from Attachments) from Job__c where Campaign__c=:theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];       
                lstJobChatter=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Campaign__c=:theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
                
            }
            else
            {
                //Yogini 07May13 added estimate field in select clause 
                lstJob=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__r.name,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c DESC  LIMIT 1000];
                lstJobNotes=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, title, body from notes) from Job__c where Campaign__c=:theId and Status__c = :strStatus  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];        
                lstJobAttach=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, Name from Attachments) from Job__c where Campaign__c=:theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];       
                lstJobChatter=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Campaign__c=:theId and Status__c = :strStatus  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
            }
        }
    } 
    
    
    public void ImpCampTempJobs(){
        
        list<Job__c> CTJInsert=new list<Job__c>();
        list<Campaign_Jobs__c> cmpjobs=new list<Campaign_Jobs__c>();
        
        if(selectedCTemp!=null && selectedCTemp!=''){
            list<Job__c> CTjobs=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Campaign_Template__c,Job_Auto_Number__c,JS_Client__r.name,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:theId and Campaign_Template__c=:selectedCTemp];
            if(CTjobs.size()>0){
                Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,'This Template already Imported for this Campaign'));
                populateJobList();
            }
            else{
                cmpjobs=[select id,name,Media_Type__c,Schedule_Template__c,Campaign_Template__c from Campaign_Jobs__c where Campaign_Template__c=:selectedCTemp];
                for(Campaign_Jobs__c cj:cmpjobs){
                    Job__c j=new Job__c();
                    if(schema.SobjectType.Job__c.Fields.Name.isCreateable()){ 
                        j.Name=cj.name;
                    }
                    if(schema.SobjectType.Job__c.Fields.Campaign__c.isCreateable()){ 
                        j.Campaign__c=theId;
                    }
                    if(schema.SobjectType.Job__c.Fields.Media_Types__c.isCreateable()){ 
                        j.Media_Types__c=cj.Media_Type__c;
                    }
                    if(schema.SobjectType.Job__c.Fields.Schedule_Template__c.isCreateable()){ 
                        j.Schedule_Template__c=cj.Schedule_Template__c;
                    }
                    if(schema.SobjectType.Job__c.Fields.Schedule_Calc__c.isCreateable()){ 
                        J.Schedule_Calc__c='Start Date';
                    }
                    if(schema.SobjectType.Job__c.Fields.Start_Date__c.isCreateable()){ 
                        J.Start_Date__c=System.today();
                    }
                    if(schema.SobjectType.Job__c.Fields.Campaign_Template__c.isCreateable()){ 
                        J.Campaign_Template__c=cj.Campaign_Template__c;
                    }
                    CTJInsert.add(j);
                }
                
                
                try{
                    if(Schema.sObjectType.Job__c.isCreateable()){
                        insert CTJInsert;
                    }
                }
                catch(System.DMLException e){
                    Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
                }
                selectedCTemp='';
                strStatus='All Jobs';
                populateJobList();
                
            }
        }
        else{
            Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,'Please select the Campaign Template'));
            populateJobList();
        }
    }
    
    
    public List<selectOption>  getCampTemp(){
        List<selectOption>  op1=new List<selectOption>();
        op1.add(new selectOption('', '-None-'));
        list<Campaign_Template__c> ctempLst=new list<Campaign_Template__c>();
        ctempLst=[select id,name from Campaign_Template__c];
        
        for(Campaign_Template__c ct:ctempLst){
            op1.add(new selectOption(ct.id,ct.name));
        }
        
        return op1;
        
    }
    
    
    
    /* // Start Test Coverage Code       
static testMethod void DisplayJobsUnderCampaign()
{
Campaign__c Camp = new Campaign__c();

// Instantiate the extention instance with the Custom Controller
DisplayJobsUnderCampaignController ext=new DisplayJobsUnderCampaignController();

DisplayJobsUnderCampaignController ext1=new DisplayJobsUnderCampaignController();
ext.strStatus = 'All Jobs';
ext.populateJobList();
ext.strStatus = 'Active';
ext.populateJobList();

ext.strStatus= 'Active';
String strStatus1 = ext.strStatus;
// ext.strStatus(SpecTempName);
List<SelectOption> options5 = ext.getStatusList();

System.assertEquals(Camp.id,ext.theID);
} 
// End of Test Method */
}
// End of Class