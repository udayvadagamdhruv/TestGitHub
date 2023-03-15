public class DetailPageComponentController {
    @AuraEnabled
    public static Map<String,list<SObject>> findjobsandnotes(Id recordId)
    {
        Map<String,list<SObject>> JobDataUnderCmp= new Map<String,list<SObject>>();
        List<Job__c> lstJob=[Select Id,Name,Job_Auto_Number__c,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c from Job__c where Campaign__c=:recordId and Status__c='Active' ORDER BY Job_Auto_Number__c DESC LIMIT 1000];
        List<Note> lstJobNotes=[Select Id,Title, Body,ParentId,Parent.Name from Note where ParentId IN:lstJob ORDER BY CreatedDate LIMIT 1000];
        List<Attachment> lstJobAttach=[Select Id,Name,ParentId,Parent.Name from Attachment where ParentId IN:lstJob ORDER BY CreatedDate LIMIT 1000];
        List<Job__c> lstJobChatter= [Select Id,Name,Job_Auto_Number__c,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Id IN:lstJob and  Status__c='Active' ORDER BY Job_Auto_Number__c DESC LIMIT 1000];        
        
        JobDataUnderCmp.put('JobSuite__Jobs',lstJob);
        JobDataUnderCmp.put('Job__Notes',lstJobNotes);
        JobDataUnderCmp.put('Job__Attachments',lstJobAttach);
        JobDataUnderCmp.put('Job__ChatterFiles',lstJobChatter);  
        return  JobDataUnderCmp;
    }
    
    @AuraEnabled
    public static list<String> fetchPicklistvalues(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Job__c.Status__c.getDescribe().getPicklistValues();
        Options.add('All Jobs');
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    } 
    
    @AuraEnabled
    public static Map<Id,String> getCampaignTemplates(){
        Map<Id,String>  CmpTempMap=new Map<Id,String>(); 
        list<Campaign_Template__c> ctempLst=new list<Campaign_Template__c>();
        ctempLst=[select Id,Name from Campaign_Template__c];
        
        CmpTempMap.put(null,'--None--');
        for(Campaign_Template__c ct:ctempLst){
            CmpTempMap.put(ct.Id,ct.Name);
        }
        return CmpTempMap;  
    }
    
    @AuraEnabled
    public static String ImpCampTempJobs(Id CmpId,String selectedCTemp ){
        
        list<Job__c> CTJInsert=new list<Job__c>();
        list<Campaign_Jobs__c> cmpjobs=new list<Campaign_Jobs__c>();
        
        if(selectedCTemp!=null && selectedCTemp!=''){
            list<Job__c> CTjobs=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Campaign_Template__c,Job_Auto_Number__c,JS_Client__r.name,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c from Job__c where Campaign__c=:CmpId and Campaign_Template__c=:selectedCTemp];
            if(CTjobs.size()>0){
                return 'This Template already Imported for this Campaign';
            }
            else{
                cmpjobs=[select id,name,Media_Type__c,Schedule_Template__c,Campaign_Template__c from Campaign_Jobs__c where Campaign_Template__c=:selectedCTemp];
                if(cmpjobs.size()==0){
                    return 'This Template doesn\'t have jobs to import';
                }
                else{ 
                for(Campaign_Jobs__c cj:cmpjobs){
                    Job__c j=new Job__c();
                    j.Name=cj.name;
                    j.Campaign__c=CmpId;
                    j.Media_Types__c=cj.Media_Type__c;
                    j.Schedule_Template__c=cj.Schedule_Template__c;
                    J.Schedule_Calc__c='Start Date';
                    J.Start_Date__c=System.today();
                    J.Campaign_Template__c=cj.Campaign_Template__c;
                    CTJInsert.add(j);
                }
                
                
                try{
                    insert CTJInsert;
                }
                catch(System.DMLException e){
                    return ''+e.getMessage();
                }
              }
            }
        }
        else{
            return 'Please select the  Campaign Template';
        }
        
        return 'Sucessfully Imported Campaign Template Jobs';
    }
    
    
    @AuraEnabled 
    public static Map<String,list<SObject>> RefreshJobNotes(Id recordId,String JobStatus)
    {
        System.debug('===recordId======'+recordId);
        System.debug('===JobStatus======'+JobStatus);
        
        Map<String,list<SObject>> JobDataUnderCmp= new Map<String,list<SObject>>();
        List<Job__c> lstJob=new  List<Job__c>();
        if(JobStatus=='All Jobs')
            lstJob=[Select Id,Name,Job_Auto_Number__c,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c from Job__c where Campaign__c=:recordId  ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        else
            lstJob=[Select Id,Job_Auto_Number__c,Name,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c from Job__c where Campaign__c=:recordId and Status__c=:JobStatus ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        
        List<Note> lstJobNotes=[Select Id,Title, Body,ParentId,Parent.Name from Note where ParentId IN:lstJob ORDER BY CreatedDate LIMIT 1000];
        List<Attachment> lstJobAttach=[Select Id,Name,ParentId,Parent.Name from Attachment where ParentId IN:lstJob ORDER BY CreatedDate LIMIT 1000];
        List<Job__c> lstJobChatter= [Select Id,Name,Job_Auto_Number__c,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Id IN:lstJob  ORDER BY Job_Auto_Number__c DESC LIMIT 1000];        
        
        JobDataUnderCmp.put('JobSuite__Jobs',lstJob);
        JobDataUnderCmp.put('Job__Notes',lstJobNotes);
        JobDataUnderCmp.put('Job__Attachments',lstJobAttach);
        JobDataUnderCmp.put('Job__ChatterFiles',lstJobChatter);  
        
        return  JobDataUnderCmp;
        
    }
    
    
}