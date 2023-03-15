public class calendarCmpController {
    
    // This method is used to get field labels
    @AuraEnabled 
    public static string getObjectFieldLabels(list<String> ObjNames){
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
    }
    
    // This method is used to get object labels  
    @AuraEnabled 
    public static List<string> getLabelsforObject()
    {
        List<string> ObjLabels=new List<string>();
        ObjLabels.add(Schema.getGlobalDescribe().get('Campaign__c').getDescribe().getLabel());            
        ObjLabels.add(Schema.getGlobalDescribe().get('Job__c').getDescribe().getLabel());
        ObjLabels.add(Schema.getGlobalDescribe().get('Job_Task__c').getDescribe().getLabel());
        system.debug('>>>>>>>>>> Object Labels  >>>>>>>>>>>>'+ObjLabels);
        return ObjLabels;
    }
    
    // This method is used to get Active Campaign values  
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
    
    // This method is used to get Media type values     
    @AuraEnabled
    public static list<Media_Type__c> getMediatype() 
    {    
        List<Media_Type__c> mediatypeList = new List<Media_Type__c>();
        mediatypeList=[SELECT Id, name FROM Media_Type__c  WITH SECURITY_ENFORCED order by Name limit 600]; 
        return mediatypeList;  
    }   
    
    // This method is used to get active schedule template values    
    @AuraEnabled
    public static list<Schedule_Template__c> getscheduletemp(String mediatyp) 
    {    
        List<Schedule_Template__c> schedTempList = new List<Schedule_Template__c>();
        schedTempList=[SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True and Media_Types__r.Name=:mediatyp WITH SECURITY_ENFORCED order by Name limit 600];
        return schedTempList;  
    }   
    
    // This method is used to get job Status picklist values
    @AuraEnabled
    public static list<String> fetchJobStatusPicklistval(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Job__c.Status__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    } 
    
    //  This method is used to get all job Names based on status value
    @AuraEnabled
    public static List<Job__c> getJobs(string status){
        List<Job__c> result = [Select Id, Name,Job_Auto_Number__c,Media_Types__c,Schedule_Template__c,Due_Date__c,Start_Date__c,Status__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Campaign__r.Name from Job__c where Name!=null and Status__c=:status WITH SECURITY_ENFORCED order by Job_Auto_Number__c desc limit 600];
        return result ; 
    } 
    
    @AuraEnabled
    public static list<Dates__mdt> getCustomMetadata(){
        list<Dates__mdt> CMdata = [select id,MasterLabel,Dates__c from Dates__mdt];
        system.debug('CMdata==== '+CMdata);
        return CMdata;
    }
    
    
    // This method is used to display the job records based upon the search criteria 
    @AuraEnabled
    public static List<Job__c> getCalJobs(string status, String Campaign, String Client, String Mediatype, String ScheduleTemp,String Name){
        List<Job__c> result = new List<Job__c>();
        
        string soql= 'Select Id, Name,Job_Auto_Number__c,Schedule_Calc__c,Media_Types__c,Schedule_Template__c,Due_Date__c,Start_Date__c,Status__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Campaign__r.Name from Job__c where Name!=null and Status__c=:status';
        
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
        
        if(String.isNotBlank(Name)){
            soql+=' And Name=: Name';
        }
        
        
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+soql);
        
        soql+=' WITH SECURITY_ENFORCED order by Job_Auto_Number__c desc Limit 500';
        result =(Database.query(soql));
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+result);
        
        return result ; 
        
    } 
    
    // This method is used to update the Job records
    @AuraEnabled
    public static void updateJob(string eventid,string starteventdate,string endeventdate, boolean reschedule){
        system.debug(eventid);
        system.debug('>>updateJob Method start date Params>>'+starteventdate);
        system.debug('>>updateJob Method end date Params>>'+endeventdate);
        system.debug('>>updateJob Method reschedule Params>>'+reschedule);
        string endeventdatelist;
        string Starteventdatelist; 
        
        if(starteventdate!=null){
            Starteventdatelist= starteventdate.replace('T',' ');
        }
        if(endeventdate!=null){
            endeventdatelist = endeventdate.replace('T',' ');     
        }
        system.debug(Starteventdatelist);
        system.debug(endeventdatelist);
        Job__c e= new Job__c(id = eventid);
        if(Starteventdatelist!=null){
            if(Schema.sObjectType.Job__c.fields.Start_Date__c.isUpdateable()){
                e.Start_Date__c = Date.valueof(Starteventdatelist);
            }
        }
        
        if(endeventdatelist!=null){
             if(Schema.sObjectType.Job__c.fields.Due_Date__c.isUpdateable()){
                 e.Due_Date__c = Date.valueof(endeventdatelist);
             }
        }
        if(Schema.sObjectType.Job__c.fields.UpdateSchedDateFieldCheck__c.isUpdateable()){
            e.UpdateSchedDateFieldCheck__c=reschedule;
        }
        
        if(Schema.sObjectType.Job__c.isUpdateable()){
            update e;
        }
        
    }
    
    
    
    /***************************************************Campaign Calendar related Methods*****************************************************************/
    
    
    // This method is used to get Campaign Status picklist values
    @AuraEnabled
    public static list<String> fetchCampStatusPicklistval(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Campaign__c.Status__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    } 
    
    //  This method is used to get all Campaign Names
    @AuraEnabled
    public static List<Campaign__c> getCampaignNames(string status){
        List<Campaign__c> result = [Select Id, name,Status__c FROM Campaign__c where Name!=null and Status__c=:status WITH SECURITY_ENFORCED order by name limit 600];
        return result ; 
    }
    
    //  This method is used to get all active users 
    @AuraEnabled
    public static List<user> getuserNames(){
        boolean act=true;
        List<user> result = [Select Id, name,IsActive FROM user where IsActive=:act  order by name limit 1300];//WITH SECURITY_ENFORCED
        return result ; 
    }
    
    // This method is used to display the campaign records based upon the search criteria 
    @AuraEnabled
    public static List<Campaign__c> getCalCamp(string status, String Name, String cmpCreatedby){
        List<Campaign__c> result = new List<Campaign__c>();
        
        string soql= 'select Id, Name, Start_Date__c, End_Date__c,Campaign_Description__c from Campaign__c where Name!=null and Start_Date__c!=null and End_Date__c!=null';
        
        if(String.isNotBlank(status)){
            soql +=' And Status__c =:status';
        }
        
        if(String.isNotBlank(Name)){
            soql +=' And name =:Name';
        }
        
        if(String.isNotBlank(cmpCreatedby)){
            soql +=' And CreatedById =:cmpCreatedby';
        }
        
        soql+=' WITH SECURITY_ENFORCED order by CreatedDate desc Limit 500';
        result =(Database.query(soql));
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+result);
        
        return result ; 
        
    } 
    
    // This method is used to update the campaign records
    @AuraEnabled
    public static void updateCamp(string eventid,string starteventdate,string endeventdate){
        system.debug(eventid);
        system.debug('>>updateCamp Method start date Params>>'+starteventdate);
        system.debug('>>updateCamp Method end date Params>>'+endeventdate);
        string endeventdatelist;
        string Starteventdatelist; 
        
        if(starteventdate!=null){
            Starteventdatelist= starteventdate.replace('T',' ');
        }
        if(endeventdate!=null){
            endeventdatelist = endeventdate.replace('T',' '); 
        }
        
        Campaign__c e= new Campaign__c(id = eventid);
        if(Starteventdatelist!=null){
            if(Schema.sObjectType.Campaign__c.fields.Start_Date__c.isUpdateable()){
                e.Start_Date__c = Date.valueof(Starteventdatelist);
            }
        }
        
        if(endeventdatelist!=null){
            if(Schema.sObjectType.Campaign__c.fields.End_Date__c.isUpdateable()){
                e.End_Date__c = Date.valueof(endeventdatelist);
            }
        }
        if(Schema.sObjectType.Campaign__c.isUpdateable()){
            update e;
        }
        
    }
    
    /***************************************************Tasks Calendar related Methods*****************************************************************/
    // This method is used to retrieve all Task into dropdown list
    
    @AuraEnabled
    public static list<string> getTasks()
    {      
        set<string> tasknames=new set<string>();
        list<Schedule_Task__c> tasksList=[SELECT Id, name,Schedule_Template__r.name ,Schedule_Template__r.Active__c FROM Schedule_Task__c where Schedule_Template__r.Active__c=:True WITH SECURITY_ENFORCED order by Name limit 1000];    
        for(Schedule_Task__c jt:tasksList){
            tasknames.add(jt.name);
        }
        list<string> tasknamelist=new list<string>(tasknames);
        return tasknamelist;  
    }
    
    // End of method getTask
    
    // This method is used to get Staff Records 
    @AuraEnabled
    public static List<string> getStaff()
    {
        List<string> StaffoptionList = new List<string>();        
        
        for (Staff__c a : [SELECT Id, name FROM Staff__c where Active__c=:true WITH SECURITY_ENFORCED limit 1000 ] ) 
        {  
            StaffoptionList.add(a.Name);    
        }
        
        for (Vendor_Contact__c a : [SELECT Id, name FROM Vendor_Contact__c where Active__c=:true WITH SECURITY_ENFORCED limit 1000]) 
        {  
            StaffoptionList.add(a.Name);       
        }
        
        for (Client_Contact__c a : [SELECT Id, name FROM Client_Contact__c where Active__c=:true WITH SECURITY_ENFORCED limit 1000]) 
        {  
            StaffoptionList.add(a.Name);        
        }
        
        StaffoptionList.sort();
        
        return StaffoptionList;  
    }   
    // End of method getStaff
    
    // This method is used to get Roles Records 
    @AuraEnabled
    public static List<UserRole> getRole()
    {
        List<UserRole> RoleoptionList =[SELECT Id, name FROM UserRole  order by Name limit 500];//WITH SECURITY_ENFORCED
        return RoleoptionList;  
    }   
    // End of method getRloes
    
    
    @AuraEnabled
    public static List<Job__c> getCalTasks(string Jobstatus, String Campaign, String Client, String Mediatype, String ScheduleTemp,String JobName,string taskName,string taskRole,string staff){
        List<Job__c> result = new List<Job__c>();
        system.debug('>>>>>>>>>>>Staff>>>>>>>>>>>>>'+staff);
        
        string assignedstaff='%'+staff+'%';
        system.debug('>>>>>>>>>>>Staff>>>>>>>>>>>>>'+assignedstaff);
        
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
        
        if(String.isNotBlank(JobName)){
            soqlJobTask+=' And Job__r.Name=: JobName';
            soqlJobTaskForJobs+=' And Job__r.Name=: JobName';
        }
        if(String.isNotBlank(Jobstatus)){
            soqlJobTask+=' And Job__r.status__c=: Jobstatus';
            soqlJobTaskForJobs+=' And Job__r.status__c=: Jobstatus';
        }
        if(String.isNotBlank(taskName)){
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
         }
        system.debug('>>>>>>>>soqlJobTask>>>>>>>>>>>>>>'+soqlJobTask);        
        String qStr = 'select id,Dummy_Text_6__c,status__c,('+String.escapeSingleQuotes(soqlJobTask)+') from job__C where status__C =:Jobstatus and id in ('+String.escapeSingleQuotes(soqlJobTaskForJobs)+') WITH SECURITY_ENFORCED order by Job_Auto_Number__c desc limit 50';
        
        result =(Database.query(qStr));
        system.debug('>>>>>>>>result>>>>>>>>>>>>>>'+result);
        
        return result ; 
        
    } 
    
    @AuraEnabled
    public static string updateTask(string eventid,string starteventdate,string endeventdate,string isUpdateAll){
        try{
            system.debug(eventid);
            system.debug('>>updateTask start date Params>>'+starteventdate);
            system.debug('>>updateTask Method end date Params>>'+endeventdate);
            
            integer syear = integer.valueof(starteventdate.substring(0,4));
            integer smonth = integer.valueof(starteventdate.substring(5,7));
            integer sday = integer.valueof(starteventdate.substring(8,10));
            
            Date sd = Date.newInstance(syear,smonth,sday);          
            
            Set<Date> holidaysNew= new Set<Date>();
            for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
            {
                holidaysNew.add(hc.Date__c);
            } 
            DateTime NextTaskStartDate;
            //code for the update of the current schedule 
            Job_Task__c jobTask1,jobTask2,objJobTask,jobTaskForJobId;
            
            jobTask1= new Job_Task__c();
            jobTask1.id=eventid;
            jobTaskForJobId=[Select Id,Job__c from Job_Task__c where id = :eventid WITH SECURITY_ENFORCED];
            if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
                jobTask1.Revised_Due_Date__c = sd;
            }
            
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update jobTask1; 
            }
            objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: jobTask1.Id WITH SECURITY_ENFORCED LIMIT 1];
            Boolean blnFroward = true;
            if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }  
            if(!blnFroward )
            {
                System.debug('Job Name is : '+ objJobTask.Job__r.Name);
                //code for updating the start date of the current task
                Integer jCount = 0;
                //Integer newDaysValue = objJobTask.Days__c;
                Datetime dtStartDate=DateTime.newInstance(syear,smonth,sday);
                System.debug('jCount value '+jCount);
                
                while(true)
                {
                    System.debug('jCount value in while '+jCount);
                    Date d3=Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                    if(dtStartDate.format('E')!='Sat' && dtStartDate.format('E')!= 'Sun'&& (!holidaysNew.contains(d3)))
                    {
                        jCount = jCount + 1;
                        if(jCount > objJobTask.Days__c)
                        {
                            break;
                        }
                        dtStartDate = dtStartDate.addDays(-1);
                        
                    }
                    else
                    {
                        dtStartDate = dtStartDate.addDays(-1);
                        System.debug('=====dtStartDate ===='+dtStartDate);                                          
                        continue;
                    }
                }
                Date afterDaysUpdate = Date.newInstance(dtStartDate .Year(), dtStartDate .Month(), dtStartDate .Day());
                system.debug('=========afterDaysUpdate =========='+afterDaysUpdate);
                if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                    objJobTask.Start_Date__c = afterDaysUpdate;}
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update objJobTask;}
            } 
            
            System.debug('Update current Job Task : '+jobTask1);
            if(String.valueOf(isUpdateAll)=='true')
            {                        
                // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current job
                Date startDateForNextTask ;
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.month(),objJobTask.Revised_Due_Date__c.Day());
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Start_Date__c.Year(),objJobTask.Start_Date__c.month(),objJobTask.Start_Date__c.Day());
                }
                
                List<Job_Task__c> lstJobTasks ;//= [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                
                if(blnFroward)
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobTaskForJobId.Job__c and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
                }
                else
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTask.Task_Order__c and Job__c =: jobTaskForJobId.Job__c and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c DESC];
                }
                System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                
                System.debug('Size of Update Tasks : '+lstJobTasks.size());
                
                for(Integer i = 0; i <lstJobTasks.size(); i++)
                {
                    System.debug('Value of i' +i);
                    DateTime dtStartDate3;
                    if(i == 0)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                        if(blnFroward)
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                            dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;}
                            dtStartDate3= DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = d4;}
                            dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = d4;}
                            dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                        }
                    }
                    
                    System.debug('Day is:'+dtStartDate3.format('E'));
                    
                    System.debug('Start Date is : ' +dtStartDate3);
                    if(Schema.sObjectType.Job_Task__c.fields.Days__c.isUpdateable()){
                        lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;}
                    
                    Integer jCount=0;
                    
                    // To calculate Due Date, Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                        
                        // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                        if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount=jCount+1;
                            if(jCount>lstJobTasks[i].Days__c)
                            {
                                break;
                            }
                            system.debug('jCount======' + jCount);
                            system.debug('==========' + dtStartDate3);
                            
                            system.debug('===========' + dtStartDate3.format('E'));
                            
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }                                   
                            system.debug('After adding 1 day : ' +dtStartDate3);
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate3);                                     
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }  
                            continue;
                        }
                    }
                    system.debug('Calculation============' +dtStartDate3);
                    
                    Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                    system.debug('D1============' +dtStartDate3);
                    
                    if(blnFroward)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstJobTasks[i].Revised_Due_Date__c=d1;}
                        system.debug('Revise due============' +lstJobTasks[i].Revised_Due_Date__c); 
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstJobTasks[i].Start_Date__c=d1;}
                    }    
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update lstJobTasks;}
                System.debug('Updated List : '+lstJobTasks);
            }
        }
        Catch(Exception e){
            return e.getMessage();
        }
        return 'OK';
        /*string endeventdatelist;
string Starteventdatelist; 

if(starteventdate!=null){
Starteventdatelist= starteventdate.replace('T',' ');
}
if(endeventdate!=null){
endeventdatelist = endeventdate.replace('T',' '); 
}

Job_Task__c e= new Job_Task__c(id = eventid);
if(Starteventdatelist!=null){
e.Revised_Due_Date__c = Date.valueof(Starteventdatelist);
}       

update e;*/
        
    }
    
}