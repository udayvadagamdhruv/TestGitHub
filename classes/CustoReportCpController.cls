public class CustoReportCpController {
    String strMakeList, strCampName,strClientName, strStatus, strMediaType, strScheduleTemplate, strPriority, startDate1,startDate2, compDate1, strClient, promoStartDate1, promoDueDate1,promoDueDate2,strProperty1,strJobTeam  ;
    Date dtStartDt1, dtCompDt1, dtPromoStartDt1, dtPromoDueDt1,dtstrDueDate,dtPromoDueDt2;
    
    
    @AuraEnabled
    public static list<Campaign__c> getCampaigns() 
    {    
        list<Campaign__c> CampList = new list<Campaign__c>();
        CampList= [SELECT Id, name FROM Campaign__c where status__c='Active' WITH SECURITY_ENFORCED order by Name limit 600]; 
        return CampList;  
    }
    
    // This method is used to get Active Client values  
    @AuraEnabled
    public static list<Client__c> getClients() 
    {    
        List<Client__c> ClientList = new List<Client__c>();
        ClientList=[SELECT Id, name,Client_Code__c FROM Client__c where Active__c=:true WITH SECURITY_ENFORCED order by Name limit 600]; 
        return ClientList;  
    }  
    @AuraEnabled
    public static list<String> fetchJobStatusPicklistval(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Job__c.Status__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    }
    
    
    @AuraEnabled
    public static list<object>getJobs( String Campaign, String Client,string status,String promoDueDate1,String promoDueDate2 )
    {      
        List<JobWrapper> JW = new List<JobWrapper>();
        List<ClientWrapper> CWrapper = new List<ClientWrapper>();
        List<ScheduleWrapper> SW = new List<ScheduleWrapper>();
        ScheduleWrapper tmpschedulewrapper = new ScheduleWrapper();
        ClientWrapper tmpclientwrapper = new ClientWrapper();
       // JobWrapper objWrapper = new JobWrapper();
        
        
        List<Job__c> tempJobs = new List<Job__c>();
        String soql;
        System.debug('status---'+status);
        
        soql = 'Select Id,(select Id from Job_Team__r),(select Id from Job_Task__r  ),Job__c.Name,Status_Notes__c,Job_Auto_Number__c,CreatedDate ,Job_Description__c, Dummy_Text_3__c,Schedule_Template__r.Name, Due_Date__c,Campaign__r.Name, Start_Date__c, JS_Client__r.Name,Media_Types__r.Name,Creative_Overview__c from Job__c   where JS_Client__c != Null and Schedule_Template__c != Null';
        if(String.isNotBlank(Campaign)){
            soql+=' And Campaign__r.Name=: Campaign';
        }
        
        if(String.isNotBlank(Client)){
            soql+=' And JS_Client__r.Name=: Client';
        }
        if(String.isNotBlank(status)){
            soql+=' And Status__c=: status';
        }
         if(!promoDueDate1 .equals('') && promoDueDate1 .length() >=8)
         {
              String[] st4 = promoDueDate1 .split('-');
              Integer y1=Integer.valueOf(st4[0]);
              Integer m1=Integer.valueOf(st4[1]);
              Integer d1=Integer.valueOf(st4[2]);
              string s4= y1 +'-'+ m1 +'-'+d1;
               Date dtstrDueDate=Date.newInstance(y1,m1,d1);
              promoDueDate1 =String.valueOf(dtstrDueDate);
             system.debug('--st44-'+st4);
             system.debug('--m1--'+m1);
             system.debug('--d1-'+d1);
             system.debug('--y1--'+y1);
             system.debug('--dtstrDueDate--'+dtstrDueDate);
              soql += ' And Due_Date__c > '+ String.valueOf(dtstrDueDate)+' ';   
        }
        if(!promoDueDate2 .equals('') && promoDueDate2 .length() >=8)
         {
              String[] st4 = promoDueDate2 .split('-');
              Integer y1=Integer.valueOf(st4[0]);
              Integer m1=Integer.valueOf(st4[1]);
              Integer d1=Integer.valueOf(st4[2]);
              string s4= y1 +'-'+ m1 +'-'+d1;
              Date dtstrDueDate=Date.newInstance(y1,m1,d1);
              promoDueDate2 =String.valueOf(dtstrDueDate);
              soql += ' and Due_Date__c < '+ String.valueOf(dtstrDueDate)+' ';   
        } 
          
        soql +=' WITH SECURITY_ENFORCED order by JS_Client__r.Name, Schedule_Template__r.Name '; 
        
        tempJobs = Database.query(soql);
        
        List<Job__c> jobList = new List<Job__c>();
        Set<string> JobIds = new Set<string>();
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
        system.debug('--jTeam--'+jTeam);
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
                //JW.add(new JobWrapper(obj,stName,listFinalJT)); 
                system.debug('Map with Final  ;( ;)'+taskListMapwithjob);
                
            } 
            
        }
        
        string strscheduleNew;
        string strClientNew; 
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
            CWrapper.add(tmpclientwrapper);
        } 
        
        //system.debug('Schedule wrapper'+clWrapper);   
        
        return CWrapper;
    }
    
    public class ClientWrapper    
    { 
        @AuraEnabled public string strClient{get;set;}
        @AuraEnabled public List<ScheduleWrapper> sWrapper{get;set;}
        public ClientWrapper()
        {
            if(sWrapper == NULL) {sWrapper = new List<ScheduleWrapper>();}
        }  
    }
    
    public class ScheduleWrapper
    {
        @AuraEnabled public string strschedule{get;set;}
        @AuraEnabled public List<JobWrapper> jWrapper{get;set;}
        @AuraEnabled public list<Schedule_Task__c> tskST{get; set;}
        public ScheduleWrapper()
        {
            if(jWrapper== NULL) {jWrapper= new List<JobWrapper>();}
        }
        
    }
    
    public class JobWrapper
    {              
        @AuraEnabled public Job__c job {get;set;}
        @AuraEnabled public List<Tag__c> jobTags{get;set;}
        @AuraEnabled public List<string> lstStaff{get; set;}
        @AuraEnabled public List<Job_Task__c> jobTasks{get;set;}
        public JobWrapper()
        {
            
        }
    }
    
    
}