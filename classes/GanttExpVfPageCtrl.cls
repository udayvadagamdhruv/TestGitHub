global class GanttExpVfPageCtrl {
    
  
    transient Public string strJobName{get;set;}
    public string strCampaignName{get;set;}
    public string strcmptype{get;set;}
    transient public string strClientName{get;set;}
    Public string StatusString {get;set;}
    public string strmediatype{get;set;}
    public string strscheduletemp{get;set;}
    Public string JobStatusString {get;set;}
    Public string CampaignStatusString {get;set;}
   
    
    public GanttExpVfPageCtrl() 
    {
        StatusString='Active';
        JobStatusString ='Active';
        CampaignStatusString ='Active';
        strcmptype='';
    }
    
    
    // This method is used to retrieve all Campaigns into dropdown list
    public list<selectOption> getCampaigns() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        transient list<selectOption> optionList = new list<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c  a : [SELECT Id, name FROM Campaign__c where status__c=:StatusString order by Name limit 10000]) 
        {  
            optionList.add(new selectOption(a.name, a.Name ));    
        }
        return optionList;  
    }   
    // End of method getCampaigns
    public list<selectOption> getCampaignnames() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        transient list<selectOption> optionList = new list<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c  a : [SELECT Id, name FROM Campaign__c where status__c=:CampaignStatusString order by Name limit 10000]) 
        {  
            optionList.add(new selectOption(a.name, a.Name ));    
        }
        return optionList;  
    }   
    // 
   
    
    // This method is used to retrieve all Mediatype into dropdown list
    public List<selectOption> getMediatype() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        List<selectOption> optionListmedia = new List<selectOption>();
        optionListmedia.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c order by Name limit 10000]) 
        {  
            optionListmedia.add(new selectOption(a.name, a.Name ));    
        }
        return optionListmedia;  
    }   
    // End of method Mediatype
    
    // This method is used to retrieve all scheduletemp into dropdown list
    public List<selectOption> getscheduletemp() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        List<selectOption> optionListsched = new List<selectOption>();
        optionListsched.add(new selectOption('', '- None -'));  
        for (Schedule_Template__c a : [SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True order by Name limit 10000]) 
        {  
            optionListsched.add(new selectOption(a.name, a.Name ));    
        }
        return optionListsched;  
    }   
    // End of method scheduletemp
    
    
    // This method is used to retrieve all Clients into dropdown list
    public List<selectOption> getClients() 
    {    
        List<selectOption> optionList = new List<selectOption>();
         optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name,Client_Code__c FROM Client__c where Active__c=:true order by Name limit 10000]) 
        {  
            optionList.add(new selectOption(a.name, a.Name ));    
        }
        return optionList;  
    }   
    // End of method getClients
    
    // This method is used to get Campaign Status Picklist values 
    public List<SelectOption> getCampStatus()
    {
        List<SelectOption> CampstatusoptionList = new List<selectOption>();
        
        for(schema.picklistEntry p : Campaign__c.Status__c.getDescribe().getPicklistValues())
        {
            CampstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return CampstatusoptionList;
    } 
    
    // This method is used to get Campaign type Picklist values 
    public List<SelectOption> getCampType()
    {
        List<SelectOption> CampstatusoptionList = new List<selectOption>();
        CampstatusoptionList.add(new selectOption('', '- None -'));
        for(schema.picklistEntry p : Campaign__c.Campaign_Type__c.getDescribe().getPicklistValues())
        {
            CampstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return CampstatusoptionList;
    } 
    
    // This method is used to get Job Records 
    public List<SelectOption> getJobNames()
    {
        List<SelectOption> JoboptionList = new List<selectOption>();
        
        //   JoboptionList.add(new selectOption('', '- None -'));
        //   JoboptionList.add(new selectOption('', '-None-'));  
        for (Job__c a : [SELECT Id, name FROM Job__c where Status__c=:JobStatusString  order by Name limit 1000]) 
        {  
            JoboptionList.add(new selectOption(a.name, a.Name ));
            // mts.add(a.Name);
            // System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+mts);    
        }
        return JoboptionList;  
    }   
    // End of method 
    
    
    // This method is used to get JobStatus picklist Values
    public List<SelectOption> getjobStatus()
    {
        List<SelectOption> jobstatusoptionList = new List<selectOption>();
        
        for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues())
        {
            jobstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return jobstatusoptionList;
    } 
    
    
    public string valueSelectedCmp{get;set;}
    public List<campaign__C> cmpTemp = new List<campaign__C>();
/*
    public List<SelectOption> campList
    {
        get
        {
            cmpTemp = [Select name from campaign__C limit 500];
            
            campList = new List<SelectOption>();
            campList.add(new SelectOption('','--None--'));
            for(campaign__C con : cmpTemp)
            {
                campList.add(new SelectOption(con.name, con.name));
            }
            return campList;
        }
        set;
    }*/
     public void test(){
        system.debug('valueSelectedCmp--'+valueSelectedCmp);
    }
      @RemoteAction
     global static list<Job__c> loadrecordsJobs(String Campaign, String Client, String Mediatype, String ScheduleTemp,string status) 
    {
       /* system.debug('cmpname--'+cmpname);
        system.debug('clientName--'+clientName);
        if(string.isNotBlank(cmpname)){
            String newSearchText = '%'+cmpname+'%';
            return [Select Name, Id, Start_Date__c, Due_Date__c,Job_Auto_Number__c,Schedule_Calc__c FROM Job__c where campaign__r.Name like:newSearchText and status__c='Active' order by createddate desc limit 100];  
        }else{
        return [Select Name, Id, Start_Date__c, Due_Date__c,Job_Auto_Number__c,Schedule_Calc__c FROM Job__c where status__c='Active' order by createddate desc limit 20];  
       }*/
         system.debug('job status --'+status);
        List<Job__c> result = new List<Job__c>();
        
        string soql= 'Select Id, Name,Job_Auto_Number__c,Schedule_Calc__c,Media_Types__c,Schedule_Template__c,Due_Date__c,Start_Date__c,Status__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Campaign__r.Name,Campaign__r.id from Job__c where Name!=null and Status__c=:status';
        
        if(String.isNotBlank(Campaign)){
            soql+=' And Campaign__r.Name=: Campaign';
        }
        
        if(String.isNotBlank(Client)){
            soql+=' And JS_Client__r.Name=: Client';
        }
        
        if(String.isNotBlank(Mediatype)){
            soql+=' And Media_Types__r.Name=: Mediatype';
        }
        
        if(String.isNotBlank(ScheduleTemp)){
            soql+=' And Schedule_Template__r.Name=: ScheduleTemp';
        }
        
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+soql);
        
        soql+=' WITH SECURITY_ENFORCED order by Job_Auto_Number__c desc Limit 500';
        result =(Database.query(soql));
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+result);
        
        return result ; 
       
    }
    @RemoteAction
     global static list<Campaign__c> loadrecordsJobcampaigns(string status,String Campaign,string typess) 
    {
        system.debug('type===='+typess);
       /* system.debug('cmpname--'+cmpname);
        system.debug('clientName--'+clientName);
        if(string.isNotBlank(cmpname)){
            String newSearchText = '%'+cmpname+'%';
            return [Select Name, Id, Start_Date__c, Due_Date__c,Job_Auto_Number__c,Schedule_Calc__c FROM Job__c where campaign__r.Name like:newSearchText and status__c='Active' order by createddate desc limit 100];  
        }else{
        return [Select Name, Id, Start_Date__c, Due_Date__c,Job_Auto_Number__c,Schedule_Calc__c FROM Job__c where status__c='Active' order by createddate desc limit 20];  
       }*/
        List<Campaign__c> result = new List<Campaign__c>();
        
        
       string soql= 'Select Id, Name,Start_Date__c,End_Date__c from Campaign__c where Status__c=:status';
       
        if(String.isNotBlank(Campaign)){
            soql+=' And Name=: Campaign';
        }
        if(String.isNotBlank(typess)){
            soql+=' And Campaign_Type__c=: typess';
        }
        
        
                
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+soql);
        
        soql+=' WITH SECURITY_ENFORCED Limit 500';
        result =(Database.query(soql));
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+result);
        
        return result ; 
       
    }
    @RemoteAction
     
    global static  string updateJobRec(id jobid,string stDate,string endDate,boolean reSchedule){
        integer eyear = integer.valueof(endDate.substring(0,4));
        integer emonth = integer.valueof(endDate.substring(5,7));
        integer eday = integer.valueof(endDate.substring(8,10));
        integer syear = integer.valueof(stDate.substring(0,4));
        integer smonth = integer.valueof(stDate.substring(5,7));
        integer sday = integer.valueof(stDate.substring(8,10));
        Date ed = Date.newInstance(eyear,emonth,eday);
        Date sd = Date.newInstance(syear,smonth,sday);
        job__c j=new job__c();
        j.id=jobid;
        j.Start_Date__c=sd;
        j.Due_Date__c=ed;
        j.UpdateSchedDateFieldCheck__c=reSchedule;
        update j;
        return 'ok';
    }
    public pageReference redirect(){
        pageReference p=new pageReference('https://jsbaseorg-dev-ed--jobsuite.na94.visual.force.com/apex/GanntExpVfpage');
        p.setRedirect(true);
        return p;
    }
    @RemoteAction
     
    global static  string updateJobCampaigns(id jsCampaignid,string stDate,string endDate){
        integer eyear = integer.valueof(endDate.substring(0,4));
        integer emonth = integer.valueof(endDate.substring(5,7));
        integer eday = integer.valueof(endDate.substring(8,10));
        integer syear = integer.valueof(stDate.substring(0,4));
        integer smonth = integer.valueof(stDate.substring(5,7));
        integer sday = integer.valueof(stDate.substring(8,10));
        Date ed = Date.newInstance(eyear,emonth,eday);
        Date sd = Date.newInstance(syear,smonth,sday);
        Campaign__c jc=new Campaign__c();
        jc.id=jsCampaignid;
        jc.Start_Date__c=sd;
        jc.End_Date__c=ed;
     
        update jc;
        return 'ok';
    }
    @RemoteAction
    global static List<Job__c> getGanttTasks(String Campaign, String Client, String Mediatype, String ScheduleTemp, string Jobstatus){ // String JobName,string taskName,string taskRole,string staff){
       system.debug('gantt tasks called');
        List<Job__c> result = new List<Job__c>();
        /*system.debug('>>>>>>>>>>>Staff>>>>>>>>>>>>>'+staff);
        
        string assignedstaff='%'+staff+'%';
        system.debug('>>>>>>>>>>>Staff>>>>>>>>>>>>>'+assignedstaff);*/
        
        string soqlJobTask= 'Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.Media_Types__r.name,Job__r.Schedule_Template__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__r where marked_done__c=false';
        string soqlJobTaskForJobs='Select Job__c from Job_Task__c where marked_done__c=false';
        if(String.isNotBlank(Campaign)){
            soqlJobTask+=' And Job__r.campaign__r.name=: Campaign';
            soqlJobTaskForJobs+=' And Job__r.campaign__r.name=: Campaign';
        }
        
        if(String.isNotBlank(Client)){
            soqlJobTask+=' And Job__r.JS_Client__r.name=: Client';
            soqlJobTaskForJobs+=' And Job__r.JS_Client__r.name=: Client';
        }
        
        if(String.isNotBlank(Mediatype)){
            soqlJobTask+=' And Job__r.Media_Types__r.name=: Mediatype';
            soqlJobTaskForJobs+=' And Job__r.Media_Types__r.name=: Mediatype';
        }
        
        if(String.isNotBlank(ScheduleTemp)){
            soqlJobTask+=' And Job__r.Schedule_Template__r.name=: ScheduleTemp';
            soqlJobTaskForJobs+=' And Job__r.Schedule_Template__r.name=: ScheduleTemp';
        }
        
       /* if(String.isNotBlank(JobName)){
            soqlJobTask+=' And Job__r.Name=: JobName';
            soqlJobTaskForJobs+=' And Job__r.Name=: JobName';
        }*/
        if(String.isNotBlank(Jobstatus)){
            soqlJobTask+=' And Job__r.status__c=: Jobstatus';
            soqlJobTaskForJobs+=' And Job__r.status__c=: Jobstatus';
        }
       /* if(String.isNotBlank(taskName)){
            soqlJobTask+=' And Name=: taskName';
            soqlJobTaskForJobs+=' And Name=: taskName';
        }
        if(String.isNotBlank(taskRole)){
            soqlJobTask+=' And Schedule_Roles__c Includes(:taskRole)';
            soqlJobTaskForJobs+=' And Schedule_Roles__c Includes(:taskRole)';
        } 
        if(String.isNotBlank(staff)){
            soqlJobTask+=' And Assigned_Users__c  like :assignedstaff';
            soqlJobTaskForJobs+=' And Assigned_Users__c  like :assignedstaff';
        }*/
        system.debug('>>>>>>>>soqlJobTask>>>>>>>>>>>>>>'+soqlJobTask);        
        String qStr = 'select id,Dummy_Text_6__c,status__c,('+String.escapeSingleQuotes(soqlJobTask)+') from job__C where status__C =:Jobstatus and id in ('+String.escapeSingleQuotes(soqlJobTaskForJobs)+') WITH SECURITY_ENFORCED order by Job_Auto_Number__c desc limit 25';
        
        result =(Database.query(qStr));
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+result);
        
        return result ; 
        
    } 
    
  
    
}