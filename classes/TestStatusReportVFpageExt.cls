public class TestStatusReportVFpageExt {
    
    public List<ClientWrapper> ClientWrapperList{get;set;}
    public List<ScheduleWrapper> ScheduleWrapperList{get;set;}
    public List<JobWrapper> JobWrapperList{get;set;}
    public ScheduleWrapper tmpschedulewrapper;
    public ClientWrapper tmpclientwrapper;
    public List<JobWrapper>  JW;
    public List<ScheduleWrapper>  SW;
    public List<Job__c> tempJobs;
    public String soql{get;set;}
    String strMakeList, strCampName,strClientName, strStatus, strMediaType, strScheduleTemplate, strPriority, startDate1,startDate2, compDate1, strClient, promoStartDate1, promoDueDate1,promoDueDate2,strProperty1,strJobTeam  ;
    
    public TestStatusReportVFpageExt(){
        ClientWrapperList = new List<ClientWrapper>();
        ScheduleWrapperList = new List<ScheduleWrapper>();
        JobWrapperList = new List<JobWrapper>();
         if(ApexPages.CurrentPage().getParameters().get('statusList') == 'statusReportPrint'){
         searchJobs();
       }
    }
    
    public class ClientWrapper{
        public string ClientName{get;set;}
        public List<ScheduleWrapper> SchWrapper{get;set;}
        
        public ClientWrapper(){
            if(SchWrapper==null){
                SchWrapper=new List<ScheduleWrapper>();
            }
        }
    }
    public class ScheduleWrapper{
        public String ScheduleName{get;set;}
        public List<JobWrapper> JobWrapper{get;set;}
        public list<Schedule_Task__c> tskST{get; set;}
        public ScheduleWrapper(){
            if(JobWrapper == Null){
                JobWrapper = New List<JobWrapper>();
            }
            
        }
    }
    public class JobWrapper{
        public job__c job{get;set;}
        public List<string> Staff{get;set;}
        public List<Job_Task__c> JobTasks{get;set;}
        public List<Tag__c> JobTag{get;set;}
        
        public JobWrapper(){
            
        }        
    }
    
    public List<String> CampList{
        get{
            if(CampList == Null){
                CampList = new List<String>();
                
                CampList.add('');
                for(Campaign__c lstCamp : [Select Id, Name from Campaign__c where Active__c =: true WITH SECURITY_ENFORCED order by name LIMIT 1000])
                {
                    CampList.add(lstCamp.Name);
                }
            }
            return CampList;
        }
        set;
    }
    
    Public List<String> ClientList{
        get{
            if(ClientList == Null){
                ClientList = new List<String>();
                
                ClientList.add('');
                for(Client__c lstClients : [Select Id, Name from Client__c  where Active__c =: true WITH SECURITY_ENFORCED order by name limit 1000])
                {
                    ClientList.add(lstClients.Name);
                }
            }
            return ClientList;
        }
        set;
    }
    public List<string> JobStatus{
        get{
            if(JobStatus == Null){
                JobStatus = new List<String>();
                schema.DescribeFieldResult fields= Job__c.Status__c.getDescribe();
                for(schema.PicklistEntry f:fields.getPicklistValues()){
                    jobStatus.add(f.getLabel());
                }
            }
            return JobStatus;
        }   
        set;
    }
    
    
    public pagereference searchJobs()
    {
        tempJobs = new List<Job__c>();
        
        JW = new List<JobWrapper>();
        ClientWrapperList = new List<ClientWrapper>();
      
       
        tempJobs = new List<Job__c>();
        strStatus = ApexPages.CurrentPage().getParameters().get('statusList');
        strCampName = ApexPages.CurrentPage().getParameters().get('CampaignList');
        strClientName = ApexPages.CurrentPage().getParameters().get('clientList');
        
        soql = 'select id,name,(select Id from Job_Team__r),  (select Id from Job_Task__r),Status_Notes__c,Job_Auto_Number__c,CreatedDate ,Job_Description__c, Dummy_Text_3__c,Schedule_Template__r.Name, Due_Date__c,Campaign__r.Name, Start_Date__c, JS_Client__r.Name,Media_Types__r.Name,Creative_Overview__c from Job__c where JS_Client__c != Null and Schedule_Template__c != Null and';
        if(!strStatus.equals(''))
            soql += ' Status__c LIKE \''+String.escapeSingleQuotes(strStatus)+'\'';       
        if(!strCampName.equals(''))
            soql += ' and Campaign__r.Name  LIKE \''+String.escapeSingleQuotes(strCampName)+'\'';               
        if (!strClientName.equals(''))
            soql += ' and JS_Client__r.Name LIKE \''+String.escapeSingleQuotes(strClientName)+'\'';   
        
        soql +=' WITH SECURITY_ENFORCED order by JS_Client__r.Name, Schedule_Template__r.Name '; 
        
        tempJobs = Database.query(soql);
        
        ScheduleWrapperList = new List<ScheduleWrapper>();
        set<String> JobIds = new set<String>();
        set<Id> schtempIds = new set<Id>();
        
        for(Job__c aa : tempJobs){
            JobIds.add(aa.Id);
            schtempIds.add(aa.Schedule_Template__c);
        }
        
        List<Job_Team__c> JobteamList=[select id,name,Job__r.id,Staff__c,Role__c from Job_Team__c where Job__c =: JobIds WITH SECURITY_ENFORCED];
        
        Map<Id,List<Job_Team__c>> MapJobTeam=new Map<Id,List<Job_Team__c>>();
        
        for(Job_Team__c JobTeam:JobteamList){
            if(MapJobTeam.containskey(JobTeam.Job__r.id)){
                List<Job_Team__c> Jobtlist=MapJobTeam.get(JobTeam.Job__r.id);
                Jobtlist.add(JobTeam);
                MapJobTeam.put(JobTeam.Job__r.id,Jobtlist);
            }
            else{
                MapJobTeam.put(JobTeam.Job__r.id,new List<Job_Team__c>{JobTeam});
            }
        }
        
        Map<Id,List<String>> MapTeamStaff = new Map<Id,List<String>>();
        for(Job__c Job: tempJobs){
            if(Job.Job_Team__r.size()>0)
            {
                List<Job_Team__c> JobTeamStaffList = MapJobTeam.get(Job.id);
                List<String> StaffNames=new List<String>();
                for(Job_Team__c Staff:JobTeamStaffList){
                    if(Staff.Staff__c != null) 
                    {
                        string tName= ((Staff.Staff__c).substringBefore(' ')).left(1)+((Staff.Staff__c).substringAfter(' ')).left(1);
                        StaffNames.add(tName);
                    }
                }
                MapTeamStaff.put(Job.Id,StaffNames);
            }
        }
        
        
        list<Schedule_Task__c> sechtskList = [select Name,Schedule_Template__c, Schedule_Template__r.Id from Schedule_Task__c where Schedule_Template__c =: schtempIds and Report__c =:true WITH SECURITY_ENFORCED order by Task_Order__c];
        Map <Id,List<Schedule_Task__c>> mapSchTsk = new Map<Id,List<Schedule_Task__c>>();
        for(Schedule_Task__c SchTsk :sechtskList){
            if(mapSchTsk.containsKey(SchTsk.Id)){
                List<Schedule_Task__c>  SchTskList = mapSchTsk.get(SchTsk.Id);
                SchTskList.add(SchTsk);
                mapSchTsk.put(SchTsk.Id, SchTskList);
            }
            else{
                mapSchTsk.put(SchTsk.Id, new List<Schedule_Task__c>{SchTsk});
            }
        }
        
        List<string> SchNames = new List<String>();
        for(Schedule_Task__c st:sechtskList)
        {
            SchNames.add(st.Name);
        }
        
        List <Job_Task__c> jTask = [select id,Name,Revised_Due_Date__c,Job__r.Name,Job__r.id from Job_Task__c where Job__c =: JobIds and Name =: SchNames WITH SECURITY_ENFORCED];
        Map<Id,List<Job_Task__c>> MapJobTask = new Map<Id,List<Job_Task__c>>();
        for(Job_Task__c JobTask:jTask){
            if(MapJobTask.containskey(JobTask.Job__r.id)){
                List<Job_Task__c> JobTskList = MapJobTask.get(JobTask.Job__r.id) ;
                JobTskList.add(JobTask);
                MapJobTask.put(JobTask.Job__r.id,JobTskList);
            }
            else{
                MapJobTask.put(JobTask.Job__r.id,new List<Job_Task__c>{JobTask});
            }
        }
        
        
        //Map for job task with job id (job task name same as schedule task name ) 
        map<Id,List<Job_Task__c>> MapJobSchTsk = new map<Id,List<Job_Task__c>>();
        List<Job_Task__c> jobtsklist= new List<Job_Task__c> ();
        List<Schedule_Task__c> Schtsklist= new List<Schedule_Task__c>();
        for(Job__c Job: tempJobs){
            if(Job.Job_Task__r.size()>0){
                if(mapSchTsk.containsKey(Job.Schedule_Template__r.Id)){
                    Schtsklist = mapSchTsk.get( Job.Schedule_Template__r.Id);
                }
                if(MapJobTask.get(Job.Id).size()>0){
                    jobtsklist =  MapJobTask.get(Job.Id);
                }
                list<Job_Task__c> listFinalJT = new list<Job_Task__c>();
                map<string, Job_Task__c > taskMapwithName = new map<string, Job_Task__c >();
                if(jobtsklist.size()>0){
                    for(Job_Task__c JobTsk:jobtsklist)
                    {
                        taskMapwithName.put(JobTsk.Name, JobTsk);
                    }
                    if(Schtsklist.size()>0){
                        for(Schedule_Task__c SchTask: Schtsklist){
                            if(taskMapwithName.containsKey(SchTask.Name))
                            {
                                Job_Task__c JTFinal = taskMapwithName.get(SchTask.Name);
                                listFinalJT.add(JTFinal);
                            }
                            else{
                                Job_Task__c JTFinal = new Job_Task__c();
                                if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){JTFinal.Revised_Due_Date__c = null;}
                                if(Schema.sObjectType.Job_Task__c.fields.Name.isUpdateable()){JTFinal.Name = '--';}
                                listFinalJT.add(JTFinal);
                            }
                        }
                    }
                }
                MapJobSchTsk.put(Job.Id,listFinalJT);
            }
            
        }    
        
        
        List <Tag__c> jTag = [select id,Name,Job__r.id,Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c from Tag__c where Job__c =: JobIds WITH SECURITY_ENFORCED];        
        Map <Id, List <Tag__c>> mapTag = new Map<Id, List <Tag__c>>();
        for(Tag__c TagList:jTag){
            if(mapTag.containskey(TagList.Job__r.id)){
                list<Tag__c> tglst = mapTag.get(TagList.Job__r.id);
                tglst.add(TagList);
                mapTag.put(TagList.Job__r.id,tglst);
            }
            else{
                mapTag.put(TagList.Job__r.id, new List <Tag__c>{TagList});
            }
        }
        
        string strClientNew,strSchedNew;
        for(Job__c aa:tempJobs)
        { 
            if(strClientNew !=aa.JS_Client__r.Name) //null != abc first time
            {
                if(strClientNew!=null) // null != null first time
                {
                    tmpschedulewrapper.JobWrapper= JW;
                    SW.add(tmpschedulewrapper);                 
                    tmpclientwrapper.SchWrapper = SW;
                    ClientWrapperList.add(tmpclientwrapper);
                }
                tmpschedulewrapper = new ScheduleWrapper();
                tmpclientwrapper = new ClientWrapper();
                
                tmpclientwrapper.ClientName = strClientNew = aa.JS_Client__r.Name;
                tmpschedulewrapper.ScheduleName = strSchedNew= aa.Schedule_Template__r.Name;
                tmpschedulewrapper.tskST = mapSchTsk.get(aa.Schedule_Template__r.Id);
                
                SW = new List<ScheduleWrapper>();
                JW = new List<JobWrapper>();  
            }
            else{
                if (strSchedNew != aa.Schedule_Template__r.Name) 
                { 
                    if(JW.size() > 0)
                    {
                        tmpschedulewrapper.JobWrapper= JW;
                        SW.add(tmpschedulewrapper);   
                        tmpschedulewrapper = new ScheduleWrapper();
                        tmpschedulewrapper.ScheduleName =   strSchedNew = aa.Schedule_Template__r.Name;
                        tmpschedulewrapper.tskST = mapSchTsk.get(aa.Schedule_Template__r.Id);
                        strClientNew = aa.JS_Client__r.Name; 
                    }
                    JW = new List<JobWrapper>();  
                }
            }
            
            JobWrapper objWrapper = new JobWrapper();
            objWrapper.job = aa;              
            objWrapper.JobTag = mapTag.get(aa.id);
            objWrapper.JobTasks = MapJobSchTsk.get(aa.id);
            objWrapper.Staff = MapTeamStaff.get(aa.id);
            JW.add(objWrapper); 
        }
        
        return null;        
    }
    
}