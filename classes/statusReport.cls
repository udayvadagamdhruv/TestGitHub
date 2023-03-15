public with sharing class statusReport {

    
    String strMakeList, strCampName,strClientName, strStatus, strMediaType, strScheduleTemplate, strPriority, startDate1,startDate2, compDate1, strClient, promoStartDate1, promoDueDate1,promoDueDate2,strProperty1,strJobTeam  ;
    Date dtStartDt1, dtCompDt1, dtPromoStartDt1, dtPromoDueDt1,dtstrDueDate,dtPromoDueDt2;
    public List<ScheduleWrapper> schWrapper {get;set;}
    public List<ClientWrapper> cWrapper {get;set;}
    public ScheduleWrapper tmpschedulewrapper;
    public ClientWrapper tmpclientwrapper;
    public List<JobWrapper>  JW;
    public List<ScheduleWrapper>  SW;
    private String soql{get;set;}
    public boolean isCompleted {get;set;}
    private List<Job__c> tempJobs;
    public string printPage{get; set;}
    public boolean imageNotFound{get;set;}
    public String imageURL{get;set;} 
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    
        
    public statusReport (){
    
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
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
       
       
        system.debug('Page is ;;;;;'+printPage);
        if(ApexPages.CurrentPage().getParameters().get('statusList') == 'statusReportPrint'){
         searchJobs();
       }
       cWrapper = new List<ClientWrapper>();
         // searchJobs();
    
    }
    
    
    public class ScheduleWrapper
    {
        public string strschedule{get;set;}
        public List<JobWrapper> jWrapper{get;set;}
        public list<Schedule_Task__c> tskST{get; set;}
        public ScheduleWrapper()
        {
           if(jWrapper== NULL) {jWrapper= new List<JobWrapper>();}
        }
    }
    
    public class ClientWrapper    
       { 
            public string strClient{get;set;}
            public List<ScheduleWrapper> sWrapper{get;set;}
            public ClientWrapper()
            {
                if(sWrapper == NULL) {sWrapper = new List<ScheduleWrapper>();}
            }  
        }
    
    public class JobWrapper
        {              
           public Job__c job {get;set;}
           public List<Tag__c> jobTags{get;set;}
           public List<string> lstStaff{get; set;}
           public List<Job_Task__c> jobTasks{get;set;}
           public JobWrapper()
            {
                 
            }
        }
        
        
     public List<String> CampaignList
    {
        get{
            if(CampaignList == NULL)
            {
               CampaignList =  new List<String>();
               CampaignList.add('');
               for(Campaign__c lstCamp : [Select Id, Name from Campaign__c where Active__c =: true WITH SECURITY_ENFORCED order by name LIMIT 1000])
                {
                    CampaignList.add(lstCamp.Name);
                }
            }
            return CampaignList;
        }
        set;
    }
    
    public List<String> clientList
    {
        get{
            if(clientList == NULL)
            {
                clientList = new List<String>();
                clientList.add('');
                for(Client__c lstClients : [Select Id, Name from Client__c  where Active__c =: true WITH SECURITY_ENFORCED order by name limit 1000])
                {
                    clientList.add(lstClients.Name);
                }
            }
            return clientList;
        }
        set;
    }
    
    
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
    
        
        
    //On click of search button this method will get executed    
    public pagereference searchJobs()
    {
         
        JW = new List<JobWrapper>();
        CWrapper = new List<ClientWrapper>();
      
       
        tempJobs = new List<Job__c>();
        strStatus = ApexPages.CurrentPage().getParameters().get('statusList');
        strCampName = ApexPages.CurrentPage().getParameters().get('CampaignList');
        strClientName = ApexPages.CurrentPage().getParameters().get('clientList');
        promoDueDate1 = ApexPages.CurrentPage().getParameters().get('promoDueDt1');
        promoDueDate2 = ApexPages.CurrentPage().getParameters().get('promoDueDt2');
        
       
        
        system.debug('Ststus values:::'+strStatus );
        system.debug('Campaign values:::'+strCampName );
        system.debug('Client values:::'+strClientName );
           
        
        soql = 'Select Id,(select Id from Job_Team__r),  (select Id from Job_Task__r  ),Job__c.Name,Status_Notes__c,Job_Auto_Number__c,CreatedDate ,Job_Description__c, Dummy_Text_3__c,Schedule_Template__r.Name, Due_Date__c,Campaign__r.Name, Start_Date__c, JS_Client__r.Name,Media_Types__r.Name,Creative_Overview__c from Job__c   where JS_Client__c != Null and Schedule_Template__c != Null and';
        
       if(!strStatus.equals(''))
              soql += ' Status__c LIKE \''+String.escapeSingleQuotes(strStatus)+'\'';       
       if(!strCampName.equals(''))
              soql += ' and Campaign__r.Name  LIKE \''+String.escapeSingleQuotes(strCampName)+'\'';               
       if (!strClientName.equals(''))
           soql += ' and JS_Client__r.Name LIKE \''+String.escapeSingleQuotes(strClientName)+'\'';   
         
        
       if(!promoDueDate1 .equals('') && promoDueDate1 .length() >=8)
         {
              String[] st4 = promoDueDate1 .split('/');
              Integer m1=Integer.valueOf(st4[0]);
              Integer d1=Integer.valueOf(st4[1]);
              Integer y1=Integer.valueOf(st4[2]);
              string s4= y1 +'-'+ m1 +'-'+d1;
              dtstrDueDate=Date.newInstance(y1,m1,d1);
              promoDueDate1 =String.valueOf(dtstrDueDate);
              soql += ' and Due_Date__c > '+ String.valueOf(dtstrDueDate)+' ';   
        }
        if(!promoDueDate2 .equals('') && promoDueDate2 .length() >=8)
         {
              String[] st4 = promoDueDate2 .split('/');
              Integer m1=Integer.valueOf(st4[0]);
              Integer d1=Integer.valueOf(st4[1]);
              Integer y1=Integer.valueOf(st4[2]);
              string s4= y1 +'-'+ m1 +'-'+d1;
              dtstrDueDate=Date.newInstance(y1,m1,d1);
              promoDueDate2 =String.valueOf(dtstrDueDate);
              soql += ' and Due_Date__c < '+ String.valueOf(dtstrDueDate)+' ';   
        } 
          
       
        
     if(!strStatus.equals('') && strStatus.equals('Completed'))
     {
        isCompleted = true;
        soql +=' WITH SECURITY_ENFORCED order by JS_Client__r.Name,Schedule_Template__r.Name  limit 1000'; 
     }
     
     else     
        soql +=' WITH SECURITY_ENFORCED order by JS_Client__r.Name, Schedule_Template__r.Name '; 
     System.debug('Query is : ' + soql);  
      System.debug('is completed: ' + isCompleted );  
        
     tempJobs = Database.query(soql);
     
     /***************************/
        
        
        schWrapper = new List<ScheduleWrapper>();
        List<Job__c> jobList = new List<Job__c>();
        //jobList = [Select Id,Job_Auto_Number__c,CreatedDate , Job__c.Name,Job_Description__c, Dummy_Text_3__c, Due_Date__c,Campaign__r.Name, Start_Date__c,Schedule_Template__r.Name, JS_Client__r.Name,Media_Types__r.Name from Job__c where Schedule_Template__c !=null   order By Schedule_Template__r.Name,JS_Client__r.Name ];
        Set<string> JobIds = new Set<string>();
        Set<string> JobIds15 = new Set<string>();
        Set<Id> JobIdsr = new Set<Id>(); 
        set<Id> stIds = new set<Id>();//list of schedule template ids

        for(Job__c aa : tempJobs)
        {
          system.debug('JObName first'+aa.Name);
          if(aa.Job_Task__r.size() == 0)          
            {
                JobIds .add(string.valueOf(aa.id).substring(0,15));
                system.debug(aa.Name+' .. Job Task Count...'+aa.Job_Task__r.size());                             
            }
            JobIds.add(aa.id);
          if(aa.Job_Team__r.size()>0){
              JobIdsr .add(aa.id);
          }  
          stIds.add(aa.Schedule_Template__c);
        }
        
        //get the list of job Team for every job;
        List<Job_Team__c>jTeam  = [select id,Name,Job__r.id,Staff__c,Role__c from Job_Team__c where Job__c =: JobIdsr WITH SECURITY_ENFORCED];   
         Map <Id, List <Job_Team__c>> mapTeam = new Map<Id, List <Job_Team__c>>();//job id and job team list
         Map<Id,List<string>> mpStaff = new Map<Id,List<string>>();
         
           //get the job team for the job
         
           for(Job_Team__c jt:jTeam)
            {
              if(mapTeam.containsKey(jt.Job__r.id))
               {
                  List <Job_Team__c > jTeamlist =  mapTeam.get(jt.Job__r.id);
                  jTeamlist.add(jt);
                  mapTeam.put(jt.Job__r.id,jTeamlist );  
                }
                else
                {
                  mapTeam.put(jt.Job__r.id , new List<Job_Team__c >{jt}) ;
                }        
           
           }
          
           //get the list of first letters first Name and Last name for every job;
           // List<Job__c> jobList3 = new List<Job__c>();
            //jobList3 = [Select Id,(select Id from Job_Team__r), Job__c.Name,Job_Description__c, Dummy_Text_3__c, Due_Date__c,Campaign__r.Name, Start_Date__c,Schedule_Template__r.Name, JS_Client__r.Name,Media_Types__r.Name from Job__c where Schedule_Template__c !=null   order By Schedule_Template__r.Name,JS_Client__r.Name ];
            Map<Id,list<String>> STmap = new Map<Id, List<string>>();
            for(Job__c obj : tempJobs)
            {              
                if(obj.Job_Team__r.size()>0)
                {
                    List<string> stName = new List<string>();
                    List<Job_Team__c> lst1 = mapTeam.get(obj.Id);
                    for(Job_Team__c objT:lst1)
                    {
                       if(objT.Staff__c != null) 
                          {
                            string tName= ((objT.Staff__c).substringBefore(' ')).left(1)+((objT.Staff__c).substringAfter(' ')).left(1);
                            stName.add(tName);
                          }
                    }
                    STmap.put(obj.Id,stName);
                }
            
            }
              
              
        
        
        //get all tasks from schedule templates  in to map with schedule template id and list of schedule task
        list<Schedule_Task__c> stList = [select Name,Schedule_Template__c, Schedule_Template__r.Id from Schedule_Task__c where Schedule_Template__c =: stIds and Report__c =:true WITH SECURITY_ENFORCED order by Task_Order__c];
        Map <Id,List<Schedule_Task__c>> mapTaskListST = new Map<Id,List<Schedule_Task__c>>();
        for(Schedule_Task__c obj :stList){
            
            if(mapTaskListST.containsKey(obj.Schedule_Template__r.Id))
            {
                List <Schedule_Task__c> Stasklist =  mapTaskListST.get(obj.Schedule_Template__r.Id);
                Stasklist.add(obj);
                mapTaskListST.put( obj.Schedule_Template__r.Id ,Stasklist);
            }
            else{
                mapTaskListST.put( obj.Schedule_Template__r.Id , new List <Schedule_Task__c>{obj});
            }
        }
        
        
        //get all task from job in to map with job id and list of tasks related to jojb
        list<string> stId = new list<string>();
        for(Schedule_Task__c st:stList)
        {
            stId.add(st.Name);
        }
        List <Job_Task__c> jTask = [select id,Name,Revised_Due_Date__c,Job__r.Name,Job__r.id from Job_Task__c where Job__c =: JobIds and Name =: stId WITH SECURITY_ENFORCED];
        
        for(Job_Task__c tsk:jTask)
        {
            system.debug('Task Name'+tsk.Name+'--Job Name--'+tsk.Job__r.Name);
        }
        
        Map <Id,List<Job_Task__c>> mapTaskListJob = new Map<Id,List<Job_Task__c>>();
        for(Job_Task__c tt:jTask)
        {
           system.debug('Task Names :( :('+tt.Job__r.Name);
           if(mapTaskListJob.containsKey( tt.Job__r.id ))
           {
              List <Job_Task__c> tasklist =  mapTaskListJob.get( tt.Job__r.id );
              tasklist.add(tt);
              mapTaskListJob.put( tt.Job__r.id ,tasklist);  
            }
            else
            {
              mapTaskListJob.put( tt.Job__r.id , new List<Job_Task__c>{tt}) ;
            }
              
          
        }
        
        
        
      /*  list<Job_Task__c> lttt = new list<Job_Task__c>();
        for(Id obj:JobIds )
        {
           list<Job_Task__c> lttt1 = new list<Job_Task__c>();
          lttt1 =  mapTaskListJob.get(obj);
           if((mapTaskListJob.get(obj)).size() != null){
                for(Job_Task__c tsk1:lttt1)
                {
                    system.debug('Task Name:::'+tsk1.Name+'--Job Name--:::'+tsk1.Job__r.Name); 
                }  
            }
        }*/
        
       // for(Job_Task__c tsk:mapTaskListJob.values())
       // {
        //    system.debug('Task Name'+tsk.Name+'--Job Name--'+tsk.Job__r.Name);
       // }
         
       List <Tag__c> jTag = [select id,Name,Job__r.id,Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c from Tag__c where Job__c =: JobIds WITH SECURITY_ENFORCED];        
       Map <Id, List <Tag__c>> mapTag = new Map<Id, List <Tag__c>>();//job id and job tag list
       for(Tag__c tg:jTag)
        {
          if(mapTag.containsKey(tg.Job__r.id))
           {
              List <Tag__c> taglist =  mapTag.get(tg.Job__r.id);
              taglist.add(tg);
              mapTag.put(tg.Job__r.id,taglist );  
            }
            else
            {
              mapTag.put(tg.Job__r.id , new List<Tag__c>{tg}) ;
            }        
        }
        
        
        //Map for job task with job id (job task name same as schedule task name ) 
        map<Id,List<Job_Task__c>> taskListMapwithjob = new map<Id,List<Job_Task__c>>();
        //List<Job__c> jobList2 = new List<Job__c>();
        //jobList2 = [Select Id,(select Id from Job_Task__r), Job__c.Name,Job_Description__c, Dummy_Text_3__c, Due_Date__c,Campaign__r.Name, Start_Date__c,Schedule_Template__r.Name, JS_Client__r.Name,Media_Types__r.Name from Job__c where Schedule_Template__c !=null   order By Schedule_Template__r.Name,JS_Client__r.Name ];
        
        for(Job__c obj : tempJobs){ 
                   
            if(obj.Job_Task__r.size()>0 && mapTaskListST.containsKey(obj.Schedule_Template__r.Id)){
                List<Schedule_Task__c> lst = new List<Schedule_Task__c>();
                 
                     lst = mapTaskListST.get( obj.Schedule_Template__r.Id);
                     
                system.debug('Sched Task List:::::)'+lst); 
                system.debug('Job is :::'+obj.name);
                List<Job_Task__c> lst1 = new List<Job_Task__c> ();
                if(mapTaskListJob.get(obj.Id).size()>0)
                {
                    lst1 =  mapTaskListJob.get(obj.Id);
                    
                    }
                // system.debug('job Task List:::::)'+lst1);
                list<Job_Task__c> listFinalJT = new list<Job_Task__c>();
                map<string, Job_Task__c > taskMapwithName = new map<string, Job_Task__c >();
                if(lst1.size()>0){
                    for(Job_Task__c obj22:lst1)
                    {
                        taskMapwithName.put(obj22.Name, obj22);
                        system.debug('Map with Task Name  ;( ;)'+taskMapwithName);
                    }
                    system.debug('Map  Task List'+mapTaskListST.get( obj.Schedule_Template__r.Id));
                    system.debug('Job Name'+obj.Name);
                    if(lst.size()>0){
                    for(Schedule_Task__c obj1: lst){
                    
                        if(taskMapwithName.containsKey(obj1.Name))
                        {
                            Job_Task__c obj11 = taskMapwithName.get(obj1.Name);
                            listFinalJT.add(obj11);
                        }else{
                            Job_Task__c obj11 = new Job_Task__c();
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){obj11.Revised_Due_Date__c = null;}
                            if(Schema.sObjectType.Job_Task__c.fields.Name.isUpdateable()){obj11.Name = '--';}
                            listFinalJT.add(obj11);
                        }
                    
                    }
                    }
                  }  
                taskListMapwithjob.put(obj.Id,listFinalJT);
                system.debug('Map with Final  ;( ;)'+taskListMapwithjob);
                
           } 
            
        }
         
         
        
        
       string strscheduleNew;
       string strClientNew; 
       
      //Wrapper construcion starts here 
      list<Schedule_Task__c> tskST = new list<Schedule_Task__c>();
        for(Job__c aa:tempJobs)
        {  
            if (strClientNew != aa.JS_Client__r.Name )
            {
                if (strClientNew != null)
                {                                
                    tmpschedulewrapper.jWrapper= JW;
                    SW.add(tmpschedulewrapper);                 
                    tmpclientwrapper.sWrapper = SW;
                    cWrapper.add(tmpclientwrapper);
                    system.debug('cWrapper :::::::::'+cWrapper);                                                                      
                }
                tmpschedulewrapper = new ScheduleWrapper();
                tmpclientwrapper = new ClientWrapper();
                
                tmpclientwrapper.strClient = strClientNew = aa.JS_Client__r.Name;
                tmpschedulewrapper.strschedule= strscheduleNew= aa.Schedule_Template__r.Name;
                tmpschedulewrapper.tskST = mapTaskListST.get(aa.Schedule_Template__r.Id);
                
                SW = new List<ScheduleWrapper>();
                JW = new List<JobWrapper>();                
            }   
            else  
            {
                System.debug(' Client '+strClientNew);
                System.debug(' Client from db '+aa.JS_Client__r.Name);
                System.debug(' Job Wrapper JW '+ JW);
                if (strscheduleNew != aa.Schedule_Template__r.Name) 
                { 
                    system.debug('Wrap sizee:::'+JW);
                    if(JW.size() > 0)
                    {
                        system.debug('JW::::'+JW);
                        tmpschedulewrapper.jWrapper= JW;
                        SW.add(tmpschedulewrapper);   
                        tmpschedulewrapper = new ScheduleWrapper();
                        tmpschedulewrapper.strschedule =   strscheduleNew = aa.Schedule_Template__r.Name;
                        tmpschedulewrapper.tskST = mapTaskListST.get(aa.Schedule_Template__r.Id);
                        strClientNew = aa.JS_Client__r.Name; 
                    }                  
                    JW = new List<JobWrapper>();                       
                }    
            }   
            
            JobWrapper objWrapper = new JobWrapper();
            objWrapper.job = aa;              
            objWrapper.jobTags =mapTag.get(aa.id);
            objWrapper.jobTasks = taskListMapwithjob.get(aa.id);
            objWrapper.lstStaff = STmap.get(aa.id);
            //objWrapper.jobTasks =mapTaskListJob.get(aa.id);
            system.debug('Job Wrapper;;;;;'+objWrapper);
            JW.add(objWrapper); 
        }
        if (strClientNew != null) 
        {            
            tmpschedulewrapper.jWrapper= JW;
            SW.add(tmpschedulewrapper);  
            tmpclientwrapper.sWrapper=SW;
            system.debug('::::::'+tmpschedulewrapper);
            cWrapper.add(tmpclientwrapper);
        } 
        
        //system.debug('Schedule wrapper'+clWrapper);   
        return null;
    }
    
    public PageReference clearForm() {
        return null;
    } 
    
     public pagereference exportToPDF()
    {    
  
         
         //PageReference pageRef = Page.statusReportPrint;
         PageReference pageRef=new PageReference('/apex/statusReportPrint');
         pageRef.getParameters().put('jobStatus',strStatus );
         pageRef.getParameters().put('CampaignList',strCampName );
         pageRef.getParameters().put('clientList',strClient );
         pageRef.getParameters().put('pageName','statusReportPrint');         
         pageRef.getParameters().put('startdt1',startDate1);
         pageRef.getParameters().put('startdt2',startDate2);  
         pageRef.setRedirect(false);          
         return pageRef;
          
        
      } 
        
  }