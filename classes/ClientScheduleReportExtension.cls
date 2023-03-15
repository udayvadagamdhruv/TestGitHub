public with sharing class ClientScheduleReportExtension {
    // Global variables  
    public DateTime today{get;set;}
    String jobid;
    //public List<Job_Team__c> JobTeam{get;set;} 
    public List<Job_Spec__c> JobSpec{get;set;} 
    public List<Job_Task__c> JobTask{get;set;} 
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End Global variables

      // Start Cobstructor
    public ClientScheduleReportExtension(ApexPages.StandardController controller) 
    {
         // To display Subscriber Organization Logo
         
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId;   imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }
           // End of code to display Subscriber Organization Logo
           
       jobid = ApexPages.currentpage().getParameters().get('id');
       //JobTeam = [select id,Name,Role__c,Staff__c from Job_Team__c where Job__c =: jobid];
       JobTask = [select id,Name,Due_Date__c,Start_Date__c,Revised_Due_Date__c,Task_Order__c,Marked_Done__c,Assigned_Users__c from Job_Task__c where Job__c =: jobid WITH SECURITY_ENFORCED Order By Task_Order__c];
       today=System.NOW();
    }
    // End Constructor 
}