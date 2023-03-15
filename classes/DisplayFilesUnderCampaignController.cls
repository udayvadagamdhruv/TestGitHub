public with sharing class DisplayFilesUnderCampaignController
{

   /* 
    public List<Job__c> lstJobNotes{get;set;}
    public List<Job__c> lstJobAttach{get;set;}
    public List<Job__c> lstJobChatter{get;set;}
    public String theId;
    public String strStatus{get;set;}
    
    
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
    
    
    public DisplayFilesUnderCampaignController()
    {
          strStatus= 'Active';
         theId=ApexPages.CurrentPage().getParameters().get('Id');
         lstJobNotes=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, title, body from notes) from Job__c where Campaign__c=:theId and Status__c = :'Active'  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
         lstJobAttach=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(select id, Name from Attachments) from Job__c where Campaign__c=:theId  and Status__c = :'Active' ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
         lstJobChatter=[Select Id,Job_Id__c,Budgeted_Cost__c,Name,Job_Auto_Number__c,JS_Client__c,Invoice_Actual_Amounts__c,Status__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Campaign__c=:theId and Status__c = :'Active'  ORDER BY JOB_Auto_NUmber__c desc LIMIT 1000];
    }
    
    public void populateJobList() {
       
    }

*/    
    
    
}