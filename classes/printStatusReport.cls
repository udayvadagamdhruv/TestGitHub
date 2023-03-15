public with sharing class printStatusReport
{
    // Global variables
   /* 
    private String soql{get;set;}  
    private List<Job__c> tempJobs;  
    public List<ClientWrapper> cWrapper {get;set;}
    String strMakeList, strCampName, strStatus,strJob,strMediaType, strScheduleTemplate, strPriority, startDate1, compDate1, strClient, promoStartDate1, promoDueDate1,strProperty1,strJobTeamList ;    
    Date dtStartDt1, dtCompDt1, dtPromoStartDt1, dtPromoDueDt1;
    public List<JobWrapper>  t2;
    public ClientWrapper tmpwrapper;
    public Job__c twrap2;
    public boolean isTrue{get;set;}
    public String imageBody{get;set;}
    public boolean imageNotFound{get;set;}
    public String imageURL{get;set;}
    public List<Document> lstDoc;
    public Date today{get;set;}       
    // End of Global variables
    
    // Start constructor
    public printStatusReport()
    {  
        isTrue = False; 
        cWrapper = new List<ClientWrapper>();
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
     }  
      // End of constructor
      
      // List to populate Schedule Templates
    public List<String> scheduleTempList
    {
        get{
            if(scheduleTempList == NULL)
            {
                scheduleTempList =  new List<String>();
                scheduleTempList.add('');
                for(Schedule_Template__c lstTemp : [Select Id, Name from Schedule_Template__c where Active__c =: true order by name limit 1000 ])
                {
                    scheduleTempList.add(lstTemp.Name);
                }
            }
            return scheduleTempList;
        }
        set;
    }
    // End of code to populate Schedule Templates
    
    // List to populate Job Team
    public List<string> JobTeamList
     {
     get{
          if(JobTeamList == NULL)     
          {
              JobTeamList = new List<string>();
              JobTeamList.add('');
               for( Staff__c lstJobTeam : [Select Id, Name from Staff__c where IsDeleted__c=: false order by name limit 1000] )
                {
                  JobTeamList.add(lstJobTeam.Name);
                }               
          }
          return JobTeamList;
         }
      set;
      }
      // End of code to populate Job Team
       
    public List<string> JobList
     {
     get{
          if(JobList == NULL)     
          {
              JobList = new List<string>();
              JobList.add('');
               for( Job__c lstJob : [Select Id, Name from Job__c where Status__c =: 'Active' order by name limit 1000] )
                {
                  JobList.add(lstJob.Name);
                }               
          }
          return JobList;
         }
      set;
      }    
    
          
    public List<String> CampaignList
    {
        get{
            if(CampaignList == NULL)
            {
               CampaignList =  new List<String>();
               CampaignList.add('');
               for(Campaign__c lstCamp : [Select Id, Name from Campaign__c where Active__c =: true order by name LIMIT 1000])
                {
                    CampaignList.add(lstCamp.Name);
                }
            }
            return CampaignList;
        }
        set;
    }
    // End of code to populate Campaign
    
    
    
    
     // List to populate Status values for Jobs
    public List<String> jobStatus{
        get{
            if(jobStatus == NULL)
            {
                jobStatus = new List<String>();
                Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
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
    
   
    
     // List to populate all Clients
    public List<String> clientList
    {
        get{
            if(clientList == NULL)
            {
                clientList = new List<String>();
                clientList.add('');
                for(Client__c lstClients : [Select Id, Name from Client__c  where Active__c =: true order by name limit 1000])
                {
                    clientList.add(lstClients.Name);
                }
            }
            return clientList;
        }
        set;
    }
    // End of code to retrieve clientList
    
     // List to populate Property values for Media Type
    public List<String> MediaList
    {
        get{
            if(MediaList == NULL)
            {
               MediaList =  new List<String>();
               MediaList.add('');
               for(Media_Type__c lstMedia : [Select Id, Name from Media_Type__c order by name])
                {
                    MediaList.add(lstMedia.Name);
                }
            }
            return MediaList;
        }
        set;
      }
      // End of code for populating Job Media Type values
    
      // This wrapper class is used to hold the property of searched Jobs
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
          public List<TaskWrapper> jobTasksWrapper{get;set;}
               
          public JobWrapper()
           {
             // if(job == NULL) {job = new Job__c ();}
              if(jobTasksWrapper== NULL) {jobTasksWrapper= new List<TaskWrapper>();}
           }
      }
           
       class TaskWrapper
           {
             public Job_Task_Role__c jobTasksRole{get;set;}
             public Job_Task__c jobTasks{get;set;}
             public TaskWrapper()
                {                
                    if(jobTasksRole== NULL) {jobTasksRole= new Job_Task_Role__c ();}
                    if(jobTasks== NULL) {jobTasks= new Job_Task__c ();}
                }
           }
    // End of wrapper class ClientWrapper
    
    // This method is called on to handle Search button
    public pagereference searchJobs()
    { 
        
        isTrue = True;
        
        tempJobs = new List<Job__c>();
        cWrapper = new List<ClientWrapper>();
        
        String s1, s2, s3, s4, strStartDt1, strCompDt1, strStartPromoDt1, strPromoDueDt1;
        
        strCampName = ApexPages.CurrentPage().getParameters().get('CampaignList');
        strScheduleTemplate = ApexPages.CurrentPage().getParameters().get('scheduleTempList');
        strJob = ApexPages.CurrentPage().getParameters().get('JobList');
        strStatus = ApexPages.CurrentPage().getParameters().get('statusList');
        strJobTeamList = ApexPages.currentPage().getParameters().get('JobTeamList');
        strClient = ApexPages.CurrentPage().getParameters().get('clientList');     
        startDate1= ApexPages.CurrentPage().getParameters().get('startdt1');     
        strMediaType = ApexPages.CurrentPage().getParameters().get('MediaList');
        System.debug('Campaign : '+strCampName);
        System.debug('Job Status : '+strStatus);
        System.debug('Schedule Template : '+strScheduleTemplate);
        System.debug('Client Name : '+strClient);
        System.debug('Start Date : '+startDate1);
        System.debug('Job  : '+strJob );
        System.debug('JobTeamList : '+strJobTeamList );
         System.debug('Media Type : '+strMediaType );
        
        soql = 'Select Id, Name, Dummy_Text_5__c, Job_Auto_Number__c,  Campaign__c, Start_Date__c, JS_Client__r.Name, Schedule_Template__r.Name, Status__c, Dummy_Text_1__c, Dummy_Text_2__c from Job__c where ';  
        
         if(!strStatus.equals(''))
              soql += ' Status__c LIKE \''+String.escapeSingleQuotes(strStatus)+'\'';       
         if(!strCampName.equals(''))
              soql += ' and Campaign__r.Name  LIKE \''+String.escapeSingleQuotes(strCampName)+'\'';               
         if(!strClient.equals(''))
              soql += ' and JS_Client__r.Name LIKE \''+String.escapeSingleQuotes(strClient)+'\'';           
         if (!strScheduleTemplate.equals(''))
              soql += ' and Schedule_Template__r.Name LIKE \''+String.escapeSingleQuotes(strScheduleTemplate)+'\'';   
         if (!strJob .equals(''))
              soql += ' and Name LIKE \''+String.escapeSingleQuotes(strJob )+'\''; 
         if (!strMediaType .equals(''))
           soql += ' and Media_Types__r.Name LIKE \''+String.escapeSingleQuotes(strMediaType)+'\'';   
       
          if(!strJobTeamList.equals(''))
         {
            List <Job_Task_Role__c> jtaskRole1 = [select id,Name,Job_Task__r.Id,Job_Task__r.Job__r.id,Job_Task__r.Name,User__c from Job_Task_Role__c where User__c=: strJobTeamList  ];
              Set <Id> idJob = new Set<Id>();
              
              for(Job_Task_Role__c  jt : jtaskRole1)
              {
                if(!idJob.contains(jt.Job_Task__r.Job__r.id))
                    idJob.add(jt.Job_Task__r.Job__r.id);
              }
            system.debug('Jobs '+idJob);
            soql += ' and Id in: idJob';
         }
         if(!startdate1.equals('') && startdate1.length() >=8)
         {
              String[] st1=startdate1.split('/');
              Integer m1=Integer.valueOf(st1[0]);
              Integer d1=Integer.valueOf(st1[1]);
              Integer y1=Integer.valueOf(st1[2]);
              s1= y1 +'-'+ m1 +'-'+d1;
              dtStartDt1=Date.newInstance(y1,m1,d1);
              strStartDt1=String.valueOf(dtStartDt1);
              soql += ' and Start_Date__c = '+ String.valueOf(dtStartDt1)+' ';   
        }    
       
       // soql +=' order by Dummy_Picklist_1__c, Name '; 
        soql +=' order by JS_Client__r.Name, Name '; 
        System.debug('Query is : ' + soql);  
        
     tempJobs = Database.query(soql);
     Set<Id> JobIds = new Set<Id>();
      for(Job__c aa:tempjobs)
        {
          JobIds.add(aa.id);
        }
        
     System.debug('Count = ' + tempjobs);
     string strClientNew;
     cWrapper = new List<ClientWrapper>();
     t2 = new List<JobWrapper>();
      
      Map <Id,Job_Task__c > mapTask = new  Map <Id,Job_Task__c >();
      Map <Id,Job_Task__c> mapTask1 = new Map<Id,Job_Task__c>(); 
     
      List <Job_Task__c> jTask = [select id,Name,Revised_Due_Date__c,Job__r.id from Job_Task__c where Job__c =: JobIds ];
       
      for(Job_Task__c objobtask:jTask)
        {
           mapTask.put(objobtask.Job__r.id,objobtask);
           mapTask1.put(objobtask.id,objobtask);
        }
   //   Map <Id,Job_Task_Role__c> mapTaskRole = new Map<Id,Job_Task_Role__c>();
       Map <Id,Job_Task_Role__c> mapTaskRole1 = new Map<Id,Job_Task_Role__c>();
      List <Job_Task_Role__c> jtaskRole;
      Set<ID> setJobTask = new Set<ID>();
            
      if(strJobTeamList.equals(''))//if user is selected get only the taks for the user
        {
          jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Job_Task__c in : jTask]; 
         for(Job_Task_Role__c jtr :jtaskRole)
           {
            //  mapTaskRole.put(jtr.id, jtr);
             mapTaskRole1.put(jtr.Job_Task__r.id, jtr);
             }
        }
       else
         {
           jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Job_Task__c in : jTask and User__c=:strJobTeamList ];
           //for(Job_Task_Role__c jtr1 :jtaskRole  )
           // {
          //       setJobTask.add(jtr1.Job_Task__r.id); 
          //       mapTaskRole.put(jtr1.Job_Task__r.Id,jtr1);
          //  }
            
            // jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c,Job_Task__r.Job__r.id from Job_Task_Role__c where Name in: RoleName and Job_Task__c in : jTask and User__c=:strJobTeam];
            for(Job_Task_Role__c jr: jtaskRole )
            {
                 if(!setJobTask.contains(jr.Job_Task__r.id))
                    setJobTask.add(jr.Job_Task__r.id);//add the task only once
                 mapTaskRole1.put(jr.Job_Task__r.Id,jr);                         
            } 
            jtask = [select id,Name,Revised_Due_Date__c,Job__r.id from Job_Task__c where id in: setJobTask];     
         
         }
            
      for(Job__c aa:tempjobs)
        {

        if (strClientNew != aa.JS_Client__r.Name)
        {
          if (strClientNew != null)
            {                
               tmpwrapper.jobWrapper=t2;
               cWrapper.add(tmpwrapper);
            }
            tmpwrapper = new ClientWrapper();
            tmpwrapper.strClient = strClientNew = aa.JS_Client__r.Name;
            t2 = new List<JobWrapper>();
        }        
        //t2.add(aa); 
        //code section  for adding all the wrappers
                JobWrapper objWrapper = new JobWrapper();
                objWrapper.job = aa;
                //objWrapper.jobTags = [select id,Name from Tag__c where Job__c =: aa.id];
                List<TaskWrapper> objtaskWrapperList = new List<TaskWrapper>();
               
                // List <Job_Task_Role__c> jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Job_Task__c in : jTask];
                System.debug('Task value '+jTask );
                System.debug('Role value '+jtaskRole );
                
               // if(strJobTeamList.equals(''))//if user is selected get only the taks for the user
               //  {
                   // jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Job_Task__c in : jTask]; 
                   //  for(Job_Task__c jt: jTask)
                   // {
                   //      if(jt.Job__r.id == aa.id)
                   //     {
                    //         mapTaskRole.put(jRole.id,jRole);
                   //          mapTaskRole1.put(jRole.Job_Task__r.Id,jRole);                       
                   //     }
                   // }
                   
                    for(Job_Task__c jt: jTask)
                    {
                     if(jt.Job__r.id == aa.id)
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
                // }
                // else
               //  {
                    
                    //jtaskRole = [select id,Name,Job_Task__r.Id,Job_Task__r.Name,User__c from Job_Task_Role__c where Job_Task__c in : jTask and User__c=:strJobTeamList ];
                   // set<Id> setTaskRole = new set<id>();
                   // list<Job_Task_Role__c> ListJrole = new list<Job_Task_Role__c>(); 
                  //  for(Job_Task_Role__c jRole: jtaskRole)
                 //   {
                      //setTaskRole.add(jRole.Job_Task__r.id);
                     // ListJrole.add(jRole);
                     
                     
                   //  TaskWrapper objtaskWrapper = new TaskWrapper();
                   //  objtaskWrapper.jobTasksRole =jRole;
                   //  objtaskWrapper.jobTasks = mapTask1.get(jRole.Job_Task__r.id); // [Select id,Name,Revised_Due_Date__c from Job_Task__c where id in :setTaskRole];
                   //  objtaskWrapperList.add(objtaskWrapper);
                   //   
                  //  }
                    
                         
           
                 //}
                 objWrapper.jobTasksWrapper = objtaskWrapperList;
                 t2.add(objWrapper); 
                 
              //   System.debug('Map value '+mapTaskRole );
                 System.debug('Map value1 '+mapTaskRole1 );
                   
                 System.debug('Job Task: '+objWrapper.jobTasksWrapper );
             
      }
            if (strClientNew != null)
            {
                tmpwrapper.jobWrapper=t2;
                cWrapper.add(tmpwrapper);
            }
       System.debug('cWraper : '+cWrapper);
       return NULL;
    }
    // End of search method
    
    // This method is called on to handle clearForm
    public pagereference clearForm()
     {
            isTrue = False;
            cWrapper = new List<ClientWrapper>();
            return NULL;
      }
    // End of method clearForm
    
     // This method is called on to pass filter criterias to generate PDF for this Report
    public pagereference exportToPDF()
    {    
  
         //PageReference pageRef = new PageReference('/apex/PrintStatusPdf'); 
          PageReference pageRef = Page.PrintStatusPdf;
         pageRef.getParameters().put('jobStatus',strStatus );
         pageRef.getParameters().put('CampaignList',strCampName );
         pageRef.getParameters().put('clientList',strClient );
         pageRef.getParameters().put('startdt1',startDate1);
         pageRef.getParameters().put('JobList',strJob );        
         pageRef.getParameters().put('scheduleTempList',strScheduleTemplate );
         pageRef.getParameters().put('JobTeamList',strJobTeamList );
         pageRef.getParameters().put('MediaList',strMediaType );
     
         //PageReference redirect = new PageReference('/apex/PrintStatusPdf');
           
         //pageRef.setRedirect(true); 
        
         return pageRef;
          
        
      }  */
     
      // End of method exportToPDF
   
    
} // End of class