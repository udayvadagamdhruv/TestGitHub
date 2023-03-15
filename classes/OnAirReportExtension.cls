public with sharing class OnAirReportExtension
{
    /*  public Job__c js{set;get;}
      //date str=js.Due_Date__c;
    // End of Global variables
    private String soql{get;set;} 
    private List<Job__c> tempJobs;  
    public List<CampaignWrapper> campWrapper {get;set;}
    public List<ClientWrapper> cWrapper {get;set;}
    String strMedia, strCampName, strStatus, strMediaType, strScheduleTemplate, strPriority, startDate1, compDate1, strClient, promoStartDate1, promoDueDate1,strProperty1 ;    
    Date dtStartDt1, dtCompDt1, dtstrDueDate, dtPromoDueDt1;
    public List<JobWrapper>  t2;
    public List<ClientWrapper>  t3;
    public CampaignWrapper tmpwrapper;
    public ClientWrapper tmpclientwrapper;
    public Job__c twrap2;
    public boolean isTrue{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public Date today{get;set;}
    
   
    // End of Global variables
    
    // Start constructor
    public OnAirReportExtension()
    {
        isTrue = False; 
        campWrapper= new List<CampaignWrapper>();
       // pWrapper = new List<PropertyWrapper>();
    }  
    // End of constructor
    class CampaignWrapper
    {
        public string strCamp{get;set;}
        public List<ClientWrapper> clWrapper{get;set;}
        public CampaignWrapper()
        {
           if(clWrapper== NULL) {clWrapper= new List<ClientWrapper>();}
        }
        
      
    }
    
     class ClientWrapper    
       {
           
            public string strClient{get;set;}
            public List<JobWrapper> jWrapper{get;set;}
            public ClientWrapper()
            {
                if(jWrapper == NULL) {jWrapper = new List<JobWrapper>();}
            }
            
         
        }
        
           class JobWrapper
            {
              
               public Job__c job {get;set;}
               public List<Tag__c> jobTags{get;set;}
               public List<TaskWrapper> jobTasksWrapper{get;set;}
           }
           
       class TaskWrapper
           {
             public Job_Task_Role__c jobTasksRole{get;set;}
             public Job_Task__c jobTasks{get;set;}
           }
       
    // This wrapper class is used to hold the property of searched Jobs
     
    
    // End of wrapper class PropertyWrapper
    
    
    // List to populate Campaigns
    public List<String> CampaignList
    {
        get{
            
            TaskWrapper ttest = new TaskWrapper();
            ttest.jobTasks = new Job_Task__c();
            ttest.jobTasksRole = new Job_Task_Role__c();
            
            CampaignWrapper ctest = new CampaignWrapper();
            ctest.strCamp = '';
            ClientWrapper cltest = new ClientWrapper();
            cltest.strClient = '';
            JobWrapper jtest = new JobWrapper();
            jtest.job = new job__c();
            jtest.jobTags = new List<Tag__c>();
            jtest.jobTasksWrapper = new List<TaskWrapper>();
            if(CampaignList == NULL)
            {
               CampaignList =  new List<String>();
               CampaignList.add('');
               for(Campaign__c lstCamp : [Select Id, Name from Campaign__c LIMIT 100])
                {
                    CampaignList.add(lstCamp.Name);
                }
            }
            return CampaignList;
        }
        set;
    }
    // End of code to populate Campaign
    
       public List<String> JobTeamList
    {
        get{
            if(JobTeamList == NULL)
            {
               JobTeamList =  new List<String>();
               JobTeamList.add('');
               //List<Staff__c> teamList = [Select Id, Name  from Staff__c];
               for(Staff__c lstTeam : [Select Id, Name  from Staff__c])
                {
                    JobTeamList.add(lstTeam.Name);
                }
            }
            return JobTeamList;
        }
        set;
    }
    
    // List to populate Property values for Media Type
    public List<String> MediaList
    {
        get{
            if(MediaList == NULL)
            {
               MediaList =  new List<String>();
               MediaList.add('');
               for(Media_Type__c lstMedia : [Select Id, Name from Media_Type__c])
                {
                    MediaList.add(lstMedia.Name);
                }
            }
            return MediaList;
        }
        set;
      }
      // End of code for populating Job Media Type values
    
    
     // List to populate Status values for Jobs
    public List<String> jobStatus{
        get{
            if(jobStatus == NULL)
            {
                jobStatus = new List<String>();
                Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
             //   jobStatus.add('');
                for(Schema.PicklistEntry f : field.getPicklistValues())
                {
                    jobStatus.add(f.getLabel());
                }
            }
            return jobStatus;
        }
        set;
    }
    // End of code for populating Job Status values
    
  
    
    
      
    public pagereference searchJobs()
    
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
         campWrapper= new List<CampaignWrapper>();
          
         String s1, s2, s3, s4, strStartDt1, strCompDt1, strStartPromoDt1, strPromoDueDt1,strDueDate,strMediaType,strStaff,strJobTeam,strStatus1 ;
          

         
          strStatus = ApexPages.CurrentPage().getParameters().get('statusList');
          strCampName = ApexPages.CurrentPage().getParameters().get('CampaignList');
          strMedia = ApexPages.CurrentPage().getParameters().get('MediaList');
          strDueDate= ApexPages.currentPage().getParameters().get('promoDueDt1');
          strJobTeam = ApexPages.currentPage().getParameters().get('JobTeamList');
         
          System.debug('Campaign : '+strCampName);
          System.debug('Status: '+strStatus);
          System.debug('Media Type: '+strmediatype);
          System.debug('Job team : '+strJobTeam );
          System.debug('Due  : '+strDueDate);
        
    
         Set<String> RoleName = new Set<String>();
         RoleName.add('Writer/Producer');
         RoleName.add('Motion Designer');
         RoleName.add('Project Manager');
         
       soql = 'Select Id, Name, Dummy_Text_3__c, Campaign__r.Name, Start_Date__c, JS_Client__r.Name from Job__c where ';
        
         if(!strStatus.equals(''))
              soql += ' Status__c LIKE \''+String.escapeSingleQuotes(strStatus)+'\'';       
         if(!strCampName.equals(''))
              soql += ' and Campaign__r.Name  LIKE \''+String.escapeSingleQuotes(strCampName)+'\'';               
         //if(!strClient.equals(''))
         //     soql += ' and JS_Client__r.Name LIKE \''+String.escapeSingleQuotes(strClient)+'\'';           
        if (!strMedia.equals(''))
           soql += ' and Media_Type__r.Name LIKE \''+String.escapeSingleQuotes(strMedia)+'\'';   
         
        
       if(!strDueDate.equals('') && strDueDate.length() >=8)
         {
              String[] st4 = strDueDate.split('/');
              Integer m1=Integer.valueOf(st4[0]);
              Integer d1=Integer.valueOf(st4[1]);
              Integer y1=Integer.valueOf(st4[2]);
              s4= y1 +'-'+ m1 +'-'+d1;
              dtstrDueDate=Date.newInstance(y1,m1,d1);
              strDueDate=String.valueOf(dtstrDueDate);
              soql += ' and Due_Date__c = '+ String.valueOf(dtstrDueDate)+' ';   
        }          
        
     soql +=' order by Campaign__r.Name , JS_Client__r.Name ,Name  '; 
     System.debug('Query is : ' + soql);  
     if(test.isRunningTest())
        soql = 'Select Id, Name, Dummy_Text_3__c, Campaign__r.Name, Start_Date__c, JS_Client__r.Name from Job__c';
     tempJobs = Database.query(soql);
     System.debug('Count = ' + tempjobs);
     string strCampaignNew;
     string strClientNew;
     campWrapper = new List<CampaignWrapper>();
     t2 = new List<JobWrapper>();
     t3 = new List<ClientWrapper>();
   
       
     for(Job__c aa:tempjobs)
      {
            if (strCampaignNew != aa.Campaign__r.Name)
            {
                if (strCampaignNew != null)
                {                
                    tmpwrapper.clWrapper=t3;
                    campWrapper.add(tmpwrapper);
                }
                tmpwrapper = new CampaignWrapper();
                tmpclientwrapper = new ClientWrapper();
                tmpwrapper.strCamp= strCampaignNew= aa.Campaign__r.Name;
                tmpclientwrapper.strClient = strClientNew = aa.JS_Client__r.Name;
                t3 = new List<ClientWrapper>();
                t2 = new List<JobWrapper>();
            }   
            else // Campaign is same
            {
                if (strClientNew != aa.JS_Client__r.Name)
                {         
                    tmpClientWrapper.jWrapper= t2;
                    t3.add(tmpclientwrapper);   
                    strClientNew = aa.JS_Client__r.Name;
                    strCampaignNew = aa.Campaign__r.Name;
                    tmpclientwrapper = new ClientWrapper();
                    t2 = new List<JobWrapper>();                        
                }    
            }   
                        if(!strJobTeam.equals(''))
             {
               List<TaskWrapper> objtaskWrapperList = new List<TaskWrapper>();
               for(Job_Task__c jTask: [select id,Name,Revised_Due_Date__c from Job_Task__c where Job__c =: aa.id ])
               {
                   //Job_Task_Role__c jtaskRole = [select id,Name,User__c from Job_Task_Role__c where Name in: RoleName and  Job_Task__c =:jTask.id limit 1];
                    Job_Task_Role__c jtaskRole = new Job_Task_Role__c ();
                   if(strStaff == jtaskRole.User__c)
                   {
                     TaskWrapper objtaskWrapper = new TaskWrapper();
                     objtaskWrapper.jobTasks = jTask;
                     objtaskWrapper.jobTasksRole =  jtaskRole;
                     objtaskWrapperList.add(objtaskWrapper);
                   }            
               }
                if(objtaskWrapperList.size() > 0)
                {
                  JobWrapper objWrapper = new JobWrapper();
                  objWrapper.job = aa;
                  objWrapper.jobTags = [select id,Name from Tag__c where Job__c =: aa.id];
                  objWrapper.jobTasksWrapper = objtaskWrapperList;              
                  System.debug('Job Task: '+objWrapper.jobTasksWrapper );
                  System.debug('Job tags: '+objWrapper.jobTags );
                  t2.add(objWrapper);  
                }
             }    
            else
            { 
              JobWrapper objWrapper = new JobWrapper();
              objWrapper.job = aa;
              objWrapper.jobTags = [select id,Name from Tag__c where Job__c =: aa.id];
              List<TaskWrapper> objtaskWrapperList = new List<TaskWrapper>();
             for(Job_Task__c jTask: [select id,Name,Revised_Due_Date__c from Job_Task__c where Job__c =: aa.id ])
             {
               //Job_Task_Role__c jtaskRole = [select id,Name,User__c from Job_Task_Role__c where Name in: RoleName and  Job_Task__c =:jTask.id limit 1];
                 Job_Task_Role__c jtaskRole = new Job_Task_Role__c ();
               TaskWrapper objtaskWrapper = new TaskWrapper();
               objtaskWrapper.jobTasks = jTask;
               objtaskWrapper.jobTasksRole =  jtaskRole;
               objtaskWrapperList.add(objtaskWrapper);               
             }
              objWrapper.jobTasksWrapper = objtaskWrapperList;
              
              System.debug('Job Task: '+objWrapper.jobTasksWrapper );
              System.debug('Job tags: '+objWrapper.jobTags );
              t2.add(objWrapper);             
            }
                      
       }
       if (strCampaignNew != null)
        {
            tmpClientWrapper.jWrapper= t2;
            t3.add(tmpclientwrapper);  
            tmpwrapper.clWrapper=t3;
            campWrapper.add(tmpwrapper);
        }
        System.debug('campWraper : '+campWrapper);
      
        return NULL;
    }
    // End of search method
    
    // This method is called on to handle clearForm
        public pagereference clearForm()
        {
            isTrue = False;
            //pWrapper = new List<PropertyWrapper>();
            campWrapper = new List<CampaignWrapper>();
            
            return NULL;
        }
    // End of method clearForm
    
     // This method is called on to pass filter criterias to generate PDF for this Report
    public pagereference exportToPDF()
    {
         PageReference pageRef = Page.ExportPlanningGridReportNew;
         pageRef.getParameters().put('jobStatus',strStatus);
         pageRef.getParameters().put('CampName',strCampName);
         pageRef.getParameters().put('strClient',strClient);
      return PageRef;
     }  
     */
     // End of method exportToPDF
   
} // End of class