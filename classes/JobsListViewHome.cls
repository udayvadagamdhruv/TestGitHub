public with sharing class JobsListViewHome {

   /* TRANSIENT public list<Job__c> joblist{get;set;}
    TRANSIENT public list<Job_Task__c> TaskList{get;set;}
    TRANSIENT Public List <Job_Task__c> jobTasks{get; set;}
    TRANSIENT public list<Job_Task_Role__c> RoleList{get;set;}
    TRANSIENT public list<Job_Team__c> TeamList{get;set;}
    TRANSIENT public list<jobsWrapper> jWrapper {get;set;}
    
     TRANSIENT public list<HomeWrapper> HMWrapper {get;set;}
    public String JobStatus {get;set;}
    public String JobStatusString {get;set;}
    public string userName;
    public Set <Id> stJobId=new Set<Id>();
    
    private String sortDirection = 'ASC';
    private String sortExp = 'taskName';        
        
    public string getSortDirection()
    {
        // if not columns is selected
        if(sortExpression==NULL || sortExpression=='')
        {
            return 'ASC';
        }
        else
        {
            return sortDirection;
        }
    }
    
     public List<SelectOption> getjobStatuslist()
   {
       List<SelectOption> jobstatusoptionList = new List<selectOption>();
      
       for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues())
       {
              jobstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
       }
       
       return jobstatusoptionList;
   } 
        
    public void setSortDirection(String value)
    {
        sortDirection=value;
    }
        
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            // if the columns is clicked on then switch between ascending and descending modes
            if( value == sortExp)
            {
                sortDirection = (sortDirection== 'ASC')?'DESC' : 'ASC';
            }
            else
            {
                sortDirection='ASC';
            } 
            sortExp=value;
        }
    }
    
    class HomeWrapper{
    
       public Job__c Homejob {get;set;}
       public string HomeTask_Name {set;get;}
       public string HomeTask_Due {set;get;}
       
       HomeWrapper(Job__c jb, String tskname,string taskdue){
       Homejob=jb;
       HomeTask_Name=tskname!=null?tskname:'';
       HomeTask_Due =taskdue!=null?taskdue:'';
       }
         
    }
    
     
    public JobsListViewHome()
    {
       jobstatusstring = 'Active';
       ViewData();
       
    }
    public void ViewData(){ 
      userName=UserInfo.getname();
      
      //staff__c st1test= [select id from staff__c where username__c =: userName];
      //String id = st1test.id;
     // system.debug('<<<<<<<<<<< id from >>>>>>>>>>>>>>'+id);
      system.debug('********'+userName);
      string sortFullExp = sortExpression  + sortDirection;
      system.debug('Sort exp :::::'+sortFullExp);
      
      /*joblist = [select Name,Job_Auto_Number__c,JS_Client__c, Status__c,Due_Date__c from Job__c  where Status__c =:'active'];
       for(Job__c j: joblist )
        {
           stJobId.add(j.id);
        }
      TaskList =[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where Job__c in : stJobId and Status__c=:'Active'];
   
     for(Job_Task__c jt: TaskList)
       {
           stJobTaskId.add(jt.id);
       } 
      RoleList=[Select Id,Name,Job_Task__r.Name,Job_Task__r.Job__r.Name,Job_Task__r.Revised_Due_Date__c,Job_Task__r.Status__c,Job_Task__r.Job__r.Job_Auto_Number__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =:userName ];*/
      
     
    /*  TeamList = [select Name, Staff__c,Job__c from Job_Team__c where Staff__c = : userName and job__r.status__C = : jobstatusstring WITH SECURITY_ENFORCED];
      
       
      for( Job_Team__c jteam : TeamList)
      {
          stJobId.add(jteam.Job__c);
          system.debug('***job******'+stJobId);
      }
      
      joblist = [select Name,Job_Auto_Number__c,JS_Client__c, Status__c,Due_Date__c,Start_Date__c,JS_Client__r.Name from Job__c  where Id IN:stJobId and status__C = : jobstatusstring WITH SECURITY_ENFORCED];
      //joblist = [select Name, Job_Auto_Number__c,JS_Client__c, Status__c,Due_Date__c,(Select Name  from Job_Task__r  order by Revised_Due_Date__c limit 1 ) from Job__c where Id IN:stJobId and Status__c=:'Active' ];
      
   system.debug('***job list count ******'+joblist.size());
     /* List <Job_Task__c> jobTasks = [select id,Name,Revised_Due_Date__c,Job__r.Name from Job_Task__c where Job__r.Id IN: stJobId ];
      system.debug('@@@@@@@@@'+jobTasks);
      */
      
       /***   List<Job__c> jobl = [select Name,Job_Auto_Number__c,JS_Client__c, Status__c,Due_Date__c from Job__c  where Id IN:stJobId and Status__c=:'Active' ];
       jWrapper = new List<jobsWrapper>();
       for(Job__c jb:joblist  )
       {
           jWrapper.add(new jobsWrapper(jobl,jobTasks) );
       }
     **************** *****/ 
      

     /* jWrapper = new List<jobsWrapper>();
      Map <Id,Job_Task__c> mapTask = new Map<Id,Job_Task__c>();
      List <Job_Task__c> jTask = [select id,Name,Revised_Due_Date__c,Job__r.Name, (SELECT Id, Name, Job_Task__c, User__c, Email__c, Task_Final_Due__c FROM Job_Task_Roles__r where User__c=:userName ) from Job_Task__c where Job__r.Id IN: stJobId and Marked_Done__c =: false WITH SECURITY_ENFORCED order by  Job__r.id, Revised_Due_Date__c,Task_order__c ];
      system.debug('******JTask********'+jTask);
      integer cnt;
      id vjobId; 
      for(Job_Task__c objobtask:jTask)
        {
          system.debug('***Role of the Tasks***'+objobtask.Job_Task_Roles__r);
          system.debug('***mapTask***'+objobtask.Job__r.id);
           if(!mapTask.containskey(objobtask.Job__r.id))
           {
             if(objobtask.Job_Task_Roles__r.size()>0){
               mapTask.put(objobtask.Job__r.id,objobtask);
              }
            
         
             //vjobId = objobtask.Job__r.Id;
           }  
        }
      
        // cnt = mapTask.size();
         //jWrapper.jobTasks= mapTask.get(objobtask.id); 
         cnt = mapTask.size();
         system.debug('***Mapsize**'+cnt);
      
      
       jWrapper = new List<jobsWrapper>();
       HMWrapper=new list<HomeWrapper>();
       for(Job__c jb:joblist)
       {
          //add the job and the task to the wrapper;
          
          Job_Task__c tsk = new Job_Task__c(); 
          
          tsk= (mapTask.get(jb.id));
          if(tsk != null){
          
          if(tsk.Revised_Due_Date__c != null){
          
           system.debug('Sort exp :::::'+sortFullExp);
           JobsWrapper jobWrap = new JobsWrapper();
           jobWrap.job = jb;
           jobWrap.task = tsk;
           jobWrap.jobTasks= mapTask.get(jb.id);         
           
           jobWrap.jobName = jb.Name.toLowerCase();
           jobWrap.jobName1 = jb.Name;//.toLowerCase();
           jobWrap.jobNo = jb.Job_Auto_Number__c;
           
           if(jb.JS_Client__r.Name != null){
               jobWrap.Client = jb.JS_Client__r.Name;
               jobWrap.clientDisplay = jb.JS_Client__r.Name;
           }else{
               jobWrap.Client = 'zzzzz';
               jobWrap.clientDisplay = '';  
           }
           jobWrap.status = jb.Status__c;
           if(jb.Due_Date__c != null){
               jobWrap.jobDuedate = jb.Due_Date__c;
               //jobWrap.jobDuedate1 = jb.Due_Date__c;
            }else{
                jobWrap.jobDuedate = jb.Start_Date__c.addYears(10);
            }       
           jobWrap.taskName = tsk.Name.toLowerCase();
           jobWrap.taskName1 = tsk.Name;
           jobWrap.jobtaskDuedate = mapTask.get(jb.id).Revised_Due_Date__c;//tsk.Revised_Due_Date__c;
           jobWrap.date2 =  zConvert.ToString(mapTask.get(jb.id).Revised_Due_Date__c+1,'MM/dd/yyyy');
           
           jobWrap.sortBy = sortFullExp;
           system.debug('sortBy is---'+jobWrap.sortBy);
            
           
           
           //jobWrap.jobtaskDuedate = mapTask.get(jb.id).Revised_Due_Date__c;//tsk.Revised_Due_Date__c;
           jobWrap.jobTasks= mapTask.get(jb.id);
           
           if(jb.Due_Date__c != null)
           {
               jobWrap.date1 =  zConvert.ToString(jb.Due_Date__c+1,'MM/dd/yyyy');
           }           
           jWrapper.add(jobWrap );
           }
       }
        else{
          
           JobsWrapper jobWrap = new JobsWrapper();
           jobWrap.job = jb;
          // jobWrap.task = 'No Task';
          // jobWrap.jobTasks= mapTask.get(jb.id);         
           
           jobWrap.jobName = jb.Name.toLowerCase();
           jobWrap.jobName1 = jb.Name;//.toLowerCase();
           jobWrap.jobNo = jb.Job_Auto_Number__c;
           
           if(jb.JS_Client__r.Name != null){
               jobWrap.Client = jb.JS_Client__r.Name;
               jobWrap.clientDisplay = jb.JS_Client__r.Name;
           }else{
               jobWrap.Client = 'zzzzz';
               jobWrap.clientDisplay = '';  
           }
           jobWrap.status = jb.Status__c;
           if(jb.Due_Date__c != null){
               jobWrap.jobDuedate = jb.Due_Date__c;
               //jobWrap.jobDuedate1 = jb.Due_Date__c;
            }else{
                jobWrap.jobDuedate = jb.Start_Date__c.addYears(10);
            }       
           jobWrap.taskName ='No Task';
           //jobWrap.taskName1 ='No Task';
           //jobWrap.jobtaskDuedate =null; //tsk.Revised_Due_Date__c;
           //jobWrap.date2 =null;
           
           jobWrap.sortBy = sortFullExp;
           system.debug('sortBy is---'+jobWrap.sortBy);
            
           
           
           //jobWrap.jobtaskDuedate = mapTask.get(jb.id).Revised_Due_Date__c;//tsk.Revised_Due_Date__c;
          // jobWrap.jobTasks= mapTask.get(jb.id);
           
           if(jb.Due_Date__c != null)
           {
               jobWrap.date1 =  zConvert.ToString(jb.Due_Date__c+1,'MM/dd/yyyy');
           }           
           jWrapper.add(jobWrap );
           
        
        }
       
      }
       jWrapper.sort();
       //return null;
       } 
       
       //what is this used for?
       public void test1()
      {
         list<Job__c> joblist1 = new List <Job__c>();  
         list<Job__c>  joblistNew1 = new List <Job__c>();
         list<Job_Task__c> TaskList1= new List <Job_Task__c>();
         List <Job_Task__c> jobTasks1=new List <Job_Task__c>();
         list<Job_Task_Role__c> RoleList1= new list<Job_Task_Role__c>();
         list<Job_Team__c> TeamList1 = new list<Job_Team__c>();
         
      }

       
          */ 

  }