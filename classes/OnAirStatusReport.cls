public with sharing class OnAirStatusReport

{
    // Global variables
   /* private String soql{get;set;}
    private List<Job__c> tempJobs; 
    public List<CampaignWrapper> pWrapper {get;set;}
    public List<ClientWrapper> cWrapper {get;set;}
    String strMakeList, strCampName, strStatus, strMediaType, strScheduleTemplate, strPriority, startDate1, compDate1, strClient, promoStartDate1, promoDueDate1,strProperty1 ;   
    Date dtStartDt1, dtCompDt1, dtPromoStartDt1, dtPromoDueDt1;
    public List<Job__c>  t2;
    public List<ClientWrapper>  t3;
    public CampaignWrapper tmpwrapper;
    public ClientWrapper tmpclientwrapper;
   // public CampaignWrapper tmpwrapper;
    public Job__c twrap2;
    public boolean isTrue{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public Date today{get;set;}
    // End of Global variables
    // This wrapper class is used to hold the property of searched Jobs  
    class CampaignWrapper

    {
       public string strCampaign{get;set;}
       // public string strClient{get;set;}
        public List<ClientWrapper> clientWrapper{get;set;}
        public CampaignWrapper()
       {
           if(clientWrapper== NULL) {clientWrapper= new List<clientWrapper>();}
        }
    }
    // End of wrapper class CampaignWrapper
   class ClientWrapper   
   {
        public string strClient{get;set;}
        public List<JobWrapper> jobWrapper{get;set;}
        public ClientWrapper()
        {
            if(jobWrapper == NULL) {jobWrapper = new List<JobWrapper>();}
        }
    }
    class JobWrapper
    {
       public Job__c job {get;set;}
       public List<Tag__c> jobTags{get;set;}
       public List<Job_Task__c> jobTasks{get;set;}
    }
     // End of wrapper class JobWrapper
    // This method is called on to handle Search button
    public OnAirStatusReport()
    {
          today=System.Today();
        // Code to display subscriber logo in PDF header
        // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
        imageURL = '/servlet/servlet.FileDownload?file=';
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId;
           imageNotFound = False;
        }   
        else
       {
           imageNotFound = True;
       }

        // End of code for Subscriber Logo
         isTrue = False;

         pWrapper = new List<CampaignWrapper>();
         String s1, s2, s3, s4, strStartDt1, strCompDt1, strStartPromoDt1, strPromoDueDt1;
         //Set<String> TaskName = new Set<String>();
         soql = 'Select Id, Name, Job_Description__c,Dummy_Text_5__c, Dummy_Text_4__c, Campaign__c, Start_Date__c, JS_Client__r.Name, Schedule_Template__r.Name, Status__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Date_1__c,Dummy_Date_2__c, Dummy_Picklist_2__c,Dummy_Picklist_1__c ,(Select Id,Name,Job__c,Start_Date__c,Revised_Due_Date__c from Job_Task__r where Name IN: TaskName Limit 5000) from Job__c '; 
        //soql +=' order by Dummy_Picklist_1__c, Dummy_Date_2__c  ';
        System.debug('Query is : ' + soql); 
     tempJobs = Database.query(soql);
     System.debug('Count = ' + tempjobs);
     string strCampaignNew;
     string strClientNew;
     pWrapper = new List<CampaignWrapper>();
    t2 = new List<Job__c>();
     t3 = new List<ClientWrapper>();
     for(Job__c aa:tempjobs)
       {
        if (strCampaignNew != aa.Campaign__r.Name)
        {
            if (strCampaignNew != null)
            {               
               tmpwrapper.clientWrapper = t3;
               pWrapper.add(tmpwrapper);
            }
            tmpwrapper = new CampaignWrapper();
            tmpwrapper.strCampaign=strCampaignNew  = aa.Dummy_Picklist_1__c;
            t2 = new List<Job__c>();
        }
        //t2.add(aa);
        if (strClientNew != null)
        {       
        // tmpclientwrapper.clientWrapper =t2;
          cWrapper.add(tmpclientwrapper);
        }
        else if(strClientNew != aa.Client__r.Name)        
        {
        }
       }
        if (strCampaignNew != null)
        {
          tmpwrapper.clientWrapper = t3;
          pWrapper.add(tmpwrapper);
        }
    */
    // End of method
} // End of class