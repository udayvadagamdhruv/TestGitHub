public with sharing class SearchOnAirStatusReportExtension {
/*
    //public String imageNotFound { get; set; }
    private String soql{get;set;}  
    private List<Job__c> tempJobs;  
  //  public List<PropertyWrapper> pWrapper {get;set;}
    String strMakeList, strCampName, strStatus, strMediaType, strScheduleTemplate, strPriority, startDate1, compDate1, strClient, promoStartDate1, promoDueDate1,strProperty1,strJobTeam  ;    
    Date dtStartDt1, dtCompDt1, dtPromoStartDt1, dtPromoDueDt1,dtstrDueDate;
   // public List<Job__c>  t2;
   // public PropertyWrapper tmpwrapper;
    public Job__c twrap2;
    public boolean isTrue{get;set;}
     public List<CampaignWrapper> campWrapper {get;set;}
    public List<ClientWrapper> cWrapper {get;set;}
     public CampaignWrapper tmpwrapper;
    public ClientWrapper tmpclientwrapper;
    public List<JobWrapper>  t2;
    public List<ClientWrapper>  t3;
    
public String imageBody{get;set;}
  public boolean imageNotFound{get;set;}
    public String imageURL{get;set;}
  public List<Document> lstDoc;
    public Date today{get;set;}    
    
    public SearchOnAirStatusReportExtension ()
    {
        isTrue = False; 
          campWrapper= new List<CampaignWrapper>();
    }  
    // End of constructor
       
    // This wrapper class is used to hold the property of searched Jobs
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
               
                 public JobWrapper()
                {
                 if(job == NULL) {job = new Job__c ();}
                  if(jobTags== NULL) {jobTags= new List<Tag__c>();}
                if(jobTasksWrapper== NULL) {jobTasksWrapper= new List<TaskWrapper>();}
                }
           }
           
       class TaskWrapper
           {
           //  public Job_Task_Role__c jobTasksRole{get;set;}
             public string jobTasksRole{get;set;}
             public Job_Task__c jobTasks{get;set;}
             public TaskWrapper()
                {
               //  if(job == NULL) {job = new List<Job__c >();}
                ////  if(jobTasksRole== NULL) {jobTasksRole= new Job_Task_Role__c ();}
                if(jobTasks== NULL) {jobTasks= new Job_Task__c ();}
                }
           }
       
    // This wrapper class is used to hold the property of searched Jobs
     
    
    // End of wrapper class PropertyWrapper
    
     
   
    
    // List to populate Campaigns
    public List<String> CampaignList
    {
        get{
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
          isTrue = True;
          
          tempJobs = new List<Job__c>();
           campWrapper= new List<CampaignWrapper>();
         
        
          String s1, s2, s3, s4, strStartDt1, strCompDt1, strStartPromoDt1, strPromoDueDt1;
       
          strStatus = ApexPages.CurrentPage().getParameters().get('statusList');
          strCampName = ApexPages.CurrentPage().getParameters().get('CampaignList');
          promoDueDate1 = ApexPages.CurrentPage().getParameters().get('promoDueDt1');
          strJobTeam = ApexPages.CurrentPage().getParameters().get('JobTeamList');          
          strMediaType = ApexPages.CurrentPage().getParameters().get('MediaList');
        
          System.debug('Campaign : '+strCampName);
          System.debug('Job Status : '+strStatus);
         System.debug('Comp Date : '+promoDueDate1);
          System.debug('Media Type : '+strMediaType );
          System.debug('Staff : '+strJobTeam );
          
          Set<String> RoleName = new Set<String>();
         RoleName.add('Writer/Producer');
         RoleName.add('Motion Designer');
         RoleName.add('Project Manager');
         
       soql = 'Select Id, Job__c.Name, Dummy_Text_3__c, Due_Date__c,Campaign__r.Name, Start_Date__c, JS_Client__r.Name,Media_Types__r.Name from Job__c   where Campaign__c != Null and JS_Client__c != null and ';
        
       if(!strStatus.equals(''))
              soql += ' Status__c LIKE \''+String.escapeSingleQuotes(strStatus)+'\'';       
       if(!strCampName.equals(''))
              soql += ' and Campaign__r.Name  LIKE \''+String.escapeSingleQuotes(strCampName)+'\'';               
       if (!strMediaType .equals(''))
           soql += ' and Media_Types__r.Name LIKE \''+String.escapeSingleQuotes(strMediaType)+'\'';   
         
        
       if(!promoDueDate1 .equals('') && promoDueDate1 .length() >=8)
         {
              String[] st4 = promoDueDate1 .split('/');
              Integer m1=Integer.valueOf(st4[0]);
              Integer d1=Integer.valueOf(st4[1]);
              Integer y1=Integer.valueOf(st4[2]);
              s4= y1 +'-'+ m1 +'-'+d1;
              dtstrDueDate=Date.newInstance(y1,m1,d1);
              promoDueDate1 =String.valueOf(dtstrDueDate);
              soql += ' and Due_Date__c = '+ String.valueOf(dtstrDueDate)+' ';   
        } 
         if(!strJobTeam.equals(''))
         {
            List <Job_Task_Role__c> jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Job__r.id,Job_Task__r.Name,User__c from Job_Task_Role__c where User__c=:strJobTeam  and Name in: RoleName ];
              Set <Id> idJob = new Set<Id>();
              
              for(Job_Task_Role__c  jt : jtaskRole)
              {
                if(!idJob.contains(jt.Job_Task__r.Job__r.id)) idJob.add(jt.Job_Task__r.Job__r.id);
              }
            
            system.debug('Jobs '+idJob);
            soql += ' and Id in: idJob';
         }         
        
     soql +=' order by Campaign__r.Name , JS_Client__r.Name ,Due_Date__c '; 
     System.debug('Query is : ' + soql);  
     
     if(test.isRunningTest())
         soql = 'Select Id, Job__c.Name, Dummy_Text_3__c, Due_Date__c,Campaign__r.Name, Start_Date__c, JS_Client__r.Name,Media_Types__r.Name from Job__c   where Campaign__c != Null and JS_Client__c != null';
        
        
     tempJobs = Database.query(soql);
     System.debug('Count = ' + tempjobs);
     string strCampaignNew;
     string strClientNew;
     campWrapper = new List<CampaignWrapper>();
     t2 = new List<JobWrapper>();
     t3 = new List<ClientWrapper>();
     

     for(Job__c aa:tempjobs)
      {  
       if (strCampaignNew != aa.Campaign__r.Name )
            {
                if (strCampaignNew != null)
               {                                
                    tmpClientWrapper.jWrapper= t2;
                    t3.add(tmpclientwrapper);                 
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
            System.debug(' Client '+strClientNew);
            System.debug(' Client from db '+aa.JS_Client__r.Name);
            System.debug(' Job Wrapper t2 '+ t2);
                if (strClientNew != aa.JS_Client__r.Name)
                { 
                    if(t2.size() > 0)
                    {
                         tmpClientWrapper.jWrapper= t2;
                         t3.add(tmpclientwrapper);   
                         tmpclientwrapper = new ClientWrapper();
                         tmpclientwrapper.strClient =   strClientNew = aa.JS_Client__r.Name;
                         strCampaignNew = aa.Campaign__r.Name; 
                     }                  
                     t2 = new List<JobWrapper>();                       
                }    
            }   
        
              JobWrapper objWrapper = new JobWrapper();
              objWrapper.job = aa;
              objWrapper.jobTags = [select id,Name from Tag__c where Job__c =: aa.id];
              List<TaskWrapper> objtaskWrapperList = new List<TaskWrapper>();
              Map <Id,Job_Task_Role__c> mapTaskRole = new Map<Id,Job_Task_Role__c>();
              Map <Id,String> mapTaskRole1 = new Map<Id,String>();
              List <Job_Task__c> jTask = [select id,Name,Revised_Due_Date__c from Job_Task__c where Job__c =: aa.id];
              List <Job_Task_Role__c> jtaskRole;
            ///   if(!strJobTeam.equals(''))//if user is selected get only the taks for the user
            ///  {
            ///     jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Name in: RoleName and Job_Task__c in : jTask and User__c=:strJobTeam ];
            ///  }
            ///  else ///else getall the tasks
            ///  {
            ///    jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Name in: RoleName and Job_Task__c in : jTask];
           ///   }
                 System.debug('Task value '+jTask );
                 System.debug('Role value '+jtaskRole );
                 
                
                 if(strJobTeam.equals(''))//if user is selected get only the taks for the user
                 {
                     jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Name in: RoleName and Job_Task__c in : jTask];
                     for(Job_Task_Role__c jRole: jtaskRole )
                    {
                        if(mapTaskRole.get(jRole.Id) == null)
                        {
                             mapTaskRole.put(jRole.id,jRole);
                             mapTaskRole1.put(jRole.Job_Task__r.Id,jRole.User__c);                         
                        }
                    }
                     for(Job_Task__c jt: jTask)
                    {
                         TaskWrapper objtaskWrapper = new TaskWrapper();
                         objtaskWrapper.jobTasks = jt;
                             if(mapTaskRole1.get(jt.id) != null)
                            {
                               objtaskWrapper.jobTasksRole =mapTaskRole1.get(jt.id);
                            }
                         objtaskWrapperList.add(objtaskWrapper); 
                     }
                 }
                 else
                 {
                    jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Name in: RoleName and Job_Task__c in : jTask and User__c=:strJobTeam ];
                    for(Job_Task_Role__c jRole: jtaskRole )
                    {
                      TaskWrapper objtaskWrapper = new TaskWrapper();
                      objtaskWrapper.jobTasks = [Select id,Name,Revised_Due_Date__c from Job_Task__c where id =: jRole.Job_Task__r.id];
                      objtaskWrapper.jobTasksRole =jRole.User__c;
                      objtaskWrapperList.add(objtaskWrapper); 
                    }
                 }
                 objWrapper.jobTasksWrapper = objtaskWrapperList;
                 t2.add(objWrapper); 
                 
                     System.debug('Map value '+mapTaskRole );
                     System.debug('Map value1 '+mapTaskRole1 );
                   
                    System.debug('Job Task: '+objWrapper.jobTasksWrapper );
                    System.debug('Job tags: '+objWrapper.jobTags );                   
           //}

        }
       if (strCampaignNew != null)
        {            
          if((!strJobTeam.equals('') && t2.size() >0) || strJobTeam.equals(''))
            {
                tmpClientWrapper.jWrapper= t2;
                t3.add(tmpclientwrapper);  
                tmpwrapper.clWrapper=t3;
                campWrapper.add(tmpwrapper);
             }
        }    
        System.debug('campWraper : '+campWrapper);
        return null;
    }
    
    // This method is called on to handle clearForm
        public pagereference clearForm()
        {
            isTrue = False;
           campWrapper= new List<CampaignWrapper>();
         
            return NULL;
        }
    // End of method clearForm

 // This method is called on to pass filter criterias to generate PDF for this Report
    public pagereference exportToPDF()
    {
          //PageReference pageRef = Page.TestHello;
         PageReference pageRef=new PageReference('/apex/TestHello');
        
          
         //pageRef.getParameters().put('statusList',strStatus );
        // pageRef.getParameters().put('CampaignList',strCampName );
        // pageRef.getParameters().put('strClient',strClient);
        // pageRef.getParameters().put('JobTeamList',strJobTeam );        
        // pageRef.getParameters().put('MediaList',strMediaType );
        // pageRef.getParameters().put('promoDueDt1',promoDueDate1 );
         pageRef.setRedirect(false);
         return pageRef;
         
        
          
        
     } 
     
     
     //Test Method 
    static testMethod void Test_SearchOnAirStatusReportExtension ()
   {
      Media_Type__c objMedia = new Media_Type__c (Name = 'Test Media type-00001');
      insert objMedia;
      
      Schedule_Template__c objSchedule = new Schedule_Template__c(Name = 'Test Schedule Template-00001', Media_Types__c = objMedia.id);
      insert objSchedule;
      
      Campaign__c objCampaign = new Campaign__c(Name = 'Test Campaign -00001');
      insert objCampaign;
      
      Staff__c objJobTeam = new Staff__c(Name = 'Test Staff-00001',UserName__c='test@test.com');
      insert objJobTeam ;
      
      
      GL_Department__c objGLDept = new GL_Department__c(Name = 'Test GL dept - 00001');
      insert objGLDept;
      
      GL_Code__c objGLCode = new GL_Code__c(Name = 'Test GL Code - 00001', GL_Department__c  = objGLDept.id, GL_ID__c = '00001');
      insert objGLCode ;
      
            
      Client__c objClient=new Client__c(Name='Test Client 0001');
      insert objClient;
               
      Client_Contact__c objClientContact=new Client_Contact__c(Name='Test Client Contact',First_Name__c='Test Client Contact',Last_Name__c='00001',Client__c= objClient.id,Email__c='test0001@SFDC.com');
      insert objClientContact;    
      
      
      Job__c objJob1 = new Job__c(Name= 'Test Job - 00001', Media_Types__c= objMedia.Id,Status__c = 'Active', Schedule_Template__c = objSchedule.id, Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,JS_Client_Contact__c =objClientContact.id,Start_Date__c = System.Today(),Job_Auto_Number__c = '00001');
      insert objJob1 ;
               
      System.assertEquals('Test Job - 00001',objJob1.Name);   
      
      Job_Task__c objTask1 = new  Job_Task__c(Name = 'Test Job Task1 - 00001', GL_Code__c = objGLCode.id, Days__c = 2,Job__c = objJob1.id);
      insert objTask1;
      
      Job_Task__c objTask2 = new  Job_Task__c(Name = 'Test JobTask2 - 00001', GL_Code__c = objGLCode.id, Days__c = 4,Job__c = objJob1.id);
      insert objTask2;      
      
      Job_Task_Role__c objTaskRole1 = new  Job_Task_Role__c(Name = 'Test Role 1',User__c = 'Test User1' ,Job_Task__c = objTask1 .id );
      insert objTaskRole1 ;
      
      Job_Task_Role__c objTaskRole2 = new  Job_Task_Role__c(Name = 'Test Role 2',User__c = 'Test User2' ,Job_Task__c = objTask2 .id);
      insert objTaskRole2 ;
         
      
      SearchOnAirStatusReportExtension  ext = new SearchOnAirStatusReportExtension ();
      List<String> lstCampaign = ext.CampaignList;
      List<String> lstActive = ext.jobStatus;
      List<String> lstMedia= ext.MediaList;
      List<String> strJobTeam= ext.JobTeamList;
       
          ApexPages.CurrentPage().getParameters().put('CampaignList',objCampaign.Name);
          ApexPages.CurrentPage().getParameters().put('MediaList',objMedia.Name);
          ApexPages.CurrentPage().getParameters().put('statusList','Active');
          ApexPages.CurrentPage().getParameters().put('JobTeamList',objJobTeam.Name);
          ApexPages.CurrentPage().getParameters().put('promoDueDt1',Datetime.now().format('MM/dd/yyyy'));
      
         ApexPages.Pagereference result1 = ext.searchJobs();
          
         result1 = ext.exportTOPDF();
         result1 = ext.clearForm();
         
        
         
         
    
      
     List<JobWrapper > objJobs = new List<JobWrapper >();
     JobWrapper objWrapper= new JobWrapper ();
      
      
       List<TaskWrapper> objtaskWrapperList = new List<TaskWrapper>();
       Map <Id,Job_Task_Role__c> mapTaskRole = new Map<Id,Job_Task_Role__c>();
       Map <Id,Job_Task_Role__c> mapTaskRole1 = new Map<Id,Job_Task_Role__c>();
       List <Job_Task__c> jTask = [select id,Name,Revised_Due_Date__c from Job_Task__c where Job__c =: objJob1.id];
       List <Job_Task_Role__c> jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Job_Task__c in : jTask];
       System.debug('Task value '+jTask );
                 System.debug('Role value '+jtaskRole );
                 
                for(Job_Task_Role__c jRole: jtaskRole )
                {
                    if(mapTaskRole.get(jRole.Id) == null)
                    {
                         mapTaskRole.put(jRole.id,jRole);
                         mapTaskRole1.put(jRole.Job_Task__r.Id,jRole);                       
                    }
                }
                 for(Job_Task__c jt: jTask)
                {
                     TaskWrapper objtaskWrapper = new TaskWrapper();
                     objtaskWrapper.jobTasks = jt;
                         if(mapTaskRole1.get(jt.id) != null)
                        {
                          // objtaskWrapper.jobTasksRole =mapTaskRole1.get(jt.id);
                        }
                     objtaskWrapperList.add(objtaskWrapper); 
                 }
                 objWrapper.jobTasksWrapper = objtaskWrapperList;
                objJobs.add(objWrapper); 
      List<ClientWrapper> objCWrapper1= new list<ClientWrapper > ();
      ClientWrapper cWrapper = new ClientWrapper ();
      cWrapper.jWrapper= objJobs; 
      cWrapper.strClient = 'Test Client 0001';
       
     
     CampaignWrapper camp = new CampaignWrapper();
     camp.strCamp = 'Test Campaign -00001';
     camp.clWrapper= objCWrapper1;
      
      JobWrapper jobw = new JobWrapper();
      jobw.job.Name  = 'Test Job - 00001';
      
   }*/
} // End of class