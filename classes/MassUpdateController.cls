public with sharing class MassUpdateController{

 /* public string Jobprefix{set;get;} 
    public MassUpdateController(ApexPages.StandardSetController controller) {
    
         Jobprefix=job__c.SobjectType.getDescribe().getKeyPrefix();
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
       
        ShowPELI=activeSettings.Active__c;
        
        StatusString='Active';
        completeItems = FALSE;
        updatejob();
    }


   

    
    CustomIterable obj;
    @TestVisible public list<JobInner> jobsInnerObj {get;set;}
    @TestVisible  public set<jobinner> jobsSelected {get;set;}
    public string active='active';
    public integer count{get;set;}
    public boolean load{get;set;}
    public integer size{get;set;}
    public Map<id,list<Job_Task__c>> jobwithtaksmap{get;set;}
    public Map<id,list<Production_Estimate__c>> JobwithPeMap{get;set;}
    public list<Job_Task__c> taskslist{get;set;}
    public List<Production_Estimate__c> PEList{get;set;}
    public list<job__c> joblist{get;set;}
    
    Public string StatusString {get;set;}
    public List<string> strCampaignName{get;set;}
    transient public List<string> strClientName{get;set;}
    public List<string> strmediatype{get;set;}
    public List<string> strscheduletemp{get;set;}
    Public string  soqlJob{get;set;}
    Public list<string> sQuery{get;set;}
    public boolean ShowPELI{get;set;}
    public string ApprovePe{get;set;}
    public boolean completeItems {get; set;} 
    
    
     // This method is used to retrieve all Campaigns into dropdown list
     public List<selectOption> getCampaigns() 
     {    
         system.debug('-----------selected value----------------->'+StatusString );
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Campaign__c  a : [SELECT Id, name FROM Campaign__c where status__c=:StatusString order by Name]) 
          {  
            optionList.add(new selectOption(a.name, a.Name ));    
          }
          return optionList;  
     }   
     // End of method getCampaigns
     
     
      // This method is used to retrieve all Mediatype into dropdown list
     public List<selectOption> getMediatype() 
     {    
         system.debug('-----------selected value----------------->'+StatusString );
          List<selectOption> optionListmedia = new List<selectOption>();
          optionListmedia.add(new selectOption('', '- None -'));  
          for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c  order by Name]) 
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
          for (Schedule_Template__c a : [SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True order by Name]) 
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
         // optionList.add(new selectOption('', '- None -'));  
          for (Client__c a : [SELECT Id, name,Client_Code__c FROM Client__c where Active__c=:true order by Name]) 
          {  
            optionList.add(new selectOption(a.name, a.Name ));    
          }
          return optionList;  
     }   
     // End of method getClients
    
    
    
    
    
    
    public MassUpdateController()
    { 
         ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
       
        ShowPELI=activeSettings.Active__c;
        
        StatusString='Active';
        completeItems = FALSE;
        updatejob();
    }
    
    
    Public void updatejob()
    {
    
    
         JobwithPeMap = new Map<id,list<Production_Estimate__c>>();
         PEList = [select Approved__c,Name,Job__c,job__r.id from Production_Estimate__c where Job__r.status__c=:Active and Approved__c =: False];
        
         taskslist = [Select Id,Marked_Done__c,Completion_Date__c,job__c,job__r.id from Job_Task__c where Job__r.status__c=:Active and Marked_Done__c!=true];
         joblist = [select id,name,Status__c,Completion_Date__c,Job_Auto_Number__c from job__c where Status__c=:Active order by Job_Auto_Number__c];
         jobwithtaksmap = new Map<id,list<Job_Task__c>>();
        
         for(job__c jb : joblist)
         {
            list<Job_Task__c> jtlist1 = new list<Job_Task__c>();
            jobwithtaksmap.put(jb.id,jtlist1);
            
            list<Production_Estimate__c> jpelist1 = new list<Production_Estimate__c>();
            JobwithPeMap.put(jb.id,jpelist1);
         }
         for(Job_Task__c jtask : taskslist)
         {
              if(jobwithtaksmap.containsKey(jtask.job__r.id))
              {
                  list<Job_Task__c> jtlist = jobwithtaksmap.get(jtask.job__r.id);
                  jtlist.add(jtask);
                  jobwithtaksmap.put(jtask.job__r.id, jtlist);
              }
              else
              {
                  list<Job_Task__c> jtlist = new list<Job_Task__c>();
                  jtlist.add(jtask);
                  jobwithtaksmap.put(jtask.job__r.id, jtlist);
              }
          } 
          
          
        
         for(Production_Estimate__c jpe : PEList)
         {
                 if(JobwithPeMap.containskey(jpe.job__r.id))
                 {
                     list<Production_Estimate__c> jpelist = JobwithPeMap.get(jpe.job__r.id);
                     jpelist.add(jpe);
                     JobwithPeMap.put(jpe.job__r.id,jpelist);
                 }
                 else
                 {
                     list<Production_Estimate__c> jpelist = new list<Production_Estimate__c>();
                     jpelist.add(jpe);
                     JobwithPeMap.put(jpe.job__r.id,jpelist);
                 }
         } 
          
          
          
          
            
        string sQuery = 'select id,name,Job_Auto_Number__c, Start_Date__c,Due_Date__c,Campaign__r.name,JS_Client__r.name,Media_Types__r.name,Schedule_Template__r.name from job__c where Status__c=:Active';
        
         system.debug('>>>>>>>>>>>>>strCampaignName>>>>>>>>>>>>>'+strCampaignName);
         
          system.debug('>>>>>>>>>>>>>strmediatype>>>>>>>>>>>>>'+strmediatype);
        
            if(strCampaignName!=Null && strCampaignName.size()>0)
           // system.debug('>>>>>>>>>>>>>strCampaignName>>>>>>>>>>>>>2'+strCampaignName);
               sQuery+=' And Campaign__r.name=:strCampaignName';
             
             if(strmediatype!=null && strmediatype.size()>0)
                sQuery +=' And Media_Types__r.name=:strmediatype';    
           
             if(strscheduletemp!=null && strscheduletemp.size()>0)
                sQuery +=' And Schedule_Template__r.name=:strscheduletemp';          
            
             if(strClientName !=Null && strClientName.size()>0)
               sQuery +=' And JS_Client__r.name =:strClientName';
        
        
        
        
        count = [select count() from job__c where Status__c=:Active];
        obj = new CustomIterable(sQuery,strCampaignName,strmediatype,strscheduletemp,strClientName );
        if(System.Test.isRunningTest())
            obj.setPageSize = 1; else obj.setPageSize = 15;
        jobsSelected = new set<jobinner>();
        next();

    }
    
    
     public PageReference Reset() {
    
        if(strCampaignName!=null && strCampaignName.size()>0)
        {
            strCampaignName.clear();
            updatejob();
        }
        if(strmediatype!=null && strmediatype.size()>0)
        {
            strmediatype.clear();
            updatejob();
        }
        if(strscheduletemp!=null && strscheduletemp.size()>0)
        {
            strscheduletemp.clear();
            updatejob();
        }
        if(strClientName!=null && strClientName.size()>0)
        {
            strClientName.clear();
            updatejob();
        }
    
        return null;
    }
    
    
    public void Complete()
    {
         //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' '+completeItems ));
            List<job__c> selectedjobs = new List<job__c>();
            
            List<Job_Task__c> jobTask= new List<Job_Task__c>();
            
             if(jobsInnerObj != NULL)
            {
                 for(JobInner w: jobsInnerObj) 
                {
                    if(w.isSelected == true) 
                    {
                        jobsSelected.add(w);}   else  jobsSelected.remove(w);
                }
             }
            
            for(JobInner w: jobsSelected ) 
            {
                if(w.isSelected == true) 
                {
                    selectedjobs.add(w.jobs);
                }
            }

            
            list<Job_Task__c > taksupd = new list<Job_Task__c >();
            list<Production_Estimate__c> PEupdat = new list<Production_Estimate__c>();
            
           for(job__c jobb: selectedjobs)
            {
               // system.debug('---------------------------------------------------------------------------<<<<<<<<<<'+jobb);
                jobb.Status__c ='Completed';
                
                
                if(completeItems && ShowPELI)
                {
                 jobb.Approve_PE__c= True;
                }
                else
                {
                  jobb.Approve_PE__c= False;
                }     
              
                
                list<Production_Estimate__c> PEupdate = new list<Production_Estimate__c>();
                PEupdate = JobwithPeMap.get(jobb.id);
                
                list<Job_Task__c > taksupdate = new list<Job_Task__c >();
                taksupdate = jobwithtaksmap.get(jobb.Id);
                if(taksupdate.size() > 0)
                {
                    for(Job_Task__c jt : taksupdate )
                    {
                           jt.Marked_Done__c=true;
                           jt.Completion_Date__c=system.today(); 
                           taksupd.add(jt);
                    }
                }
                
                
                if(PEupdate.size() > 0)
                {
                    for(Production_Estimate__c objPE : PEupdate)
                    {
                            objPE.Approved__c = true;
                            PEUpdat.add(objPE); 
                    }
                }
                
                 
            }
             //update taksupd ;
             MassUpdateBatchController mbc = new MassUpdateBatchController(taksupd);
             database.executebatch(mbc,45);
            
            
           
       //     update PEUpdat;
            update selectedjobs;
            size = selectedjobs.size();
            load = true;
          
       // return page.JobsTabOverride;
    }
    
   public pageReference CancelBut()
   {
      
       PageReference p;
       p =  new Pagereference('/'+Jobprefix+'/o');
       p.setRedirect(true);
       return p;
      
     //  return page.JobsTabOverride;
   }
    
    
    public Boolean hasNext {      get {    return obj.hasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {  get {   return obj.hasPrevious();
        }
        set;
    }
    
    public void next() 
    {
        
        if(jobsInnerObj != NULL)
        {
         for(JobInner w: jobsInnerObj) 
            {
                if(w.isSelected == true)  {jobsSelected.add(w);  }   else jobsSelected.remove(w);
            }
         }
        jobsInnerObj = obj.next();
    }
    
    public void previous() 
    {
         if(jobsInnerObj != NULL)
        {
         for(JobInner w: jobsInnerObj) 
            {
                if(w.isSelected == true) { jobsSelected.add(w);
                }
                else
                    jobsSelected.remove(w);
            }
         }
        
        
        jobsInnerObj = obj.previous();
    }
    
    @TestVisible public Class JobInner
    {
        public boolean isSelected {get;set;}
        public job__c jobs {get;set;}
        
        public JobInner(boolean isSelected, job__c jobs)
        {
            this.isSelected = isSelected;
            this.jobs = jobs;
        }
    }
    
    
    
  @TestVisible Public class CustomIterable{ 

   List<job__c> jobs {get; set;} 
   list<JobInner> jobInnerList {get; set;} 
   list<JobInner> jobInnerListRequested {get; set;} 
   JobInner jobsInnerObj;
   public Integer i {get; set;} 
   public Integer setPageSize {get; set;} 
   public string active='active';
    Public string StatusString {get;set;}
    public List<string> strCampaignName{get;set;}
    transient public List<string> strClientName{get;set;}
    public List<string> strmediatype{get;set;}
    public List<string> strscheduletemp{get;set;}
    

   public CustomIterable(string sQuery,list<string> strCampaignName,list<string> strmediatype,list<string> strscheduletemp,list<string> strClientName){ 
   system.debug('>>>>>>>>>>>>>>>>sQuery>>>>>>>>>>>>>>>>>>>>'+sQuery);
    system.debug('>>>>>>>>>>>>>strClientName>>>>>>>>>>>>>'+strClientName);
    system.debug('>>>>>>>>>>>>>strmediatype>>>>>>>>>>>>>'+strmediatype);
       jobs = Database.Query(sQuery);
       system.debug('>>>>>>>>>>>>>>>>jobs>>>>>>>>>>>>>>>>>>>>'+jobs );
       
        system.debug('>>>>>>>>>>>>>strClientName>>>>jobs>>>>>>>>>'+strClientName);
    system.debug('>>>>>>>>>>>>>strmediatype>>>>>>>>jobs>>>>>'+strmediatype);
       
       jobInnerList = new list<JobInner>(); 
       jobInnerListRequested = new list<JobInner>();     
       for(job__c a : jobs) {
            jobsInnerObj = new JobInner(false, a);
            jobInnerList.add(jobsInnerObj);
       } 
       setPageSize = 15;
       i = 0; 
   }   

   Public boolean hasNext(){ 
       if(i >= jobInnerList.size()) {           return false; 
       } else {
           return true; 
       }
   } 
   
   Public boolean hasPrevious(){ 
       system.debug('I am in hasPrevious' + i);
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

   Public list<JobInner> next(){       
       system.debug('i value is ' + i);
       jobInnerListRequested = new list<JobInner>(); 
       integer startNumber;
       integer size = jobInnerList.size();
       if(hasNext())
       {  
           if(size <= (i + setPageSize))
           {
               startNumber = i;
               i = size;
           }
           else
           {
               i = (i + setPageSize);
               startNumber = (i - setPageSize);
           }
           
           system.debug('i value is =====' + i);
           system.debug('i value is 2==== ' + (i - setPageSize));
           
           for(integer start = startNumber; start < i; start++)
           {
               jobInnerListRequested.add(jobInnerList[start]);
           }
       } 
       return jobInnerListRequested;
   } 
   
   Public list<JobInner> previous(){      
       jobInnerListRequested = new list<JobInner>(); 
       system.debug('i value is previous before =====' + i);
       integer size = jobInnerList.size(); 
       if(i == size)
       {
           if(math.mod(size, setPageSize) > 0)          {             i = size - math.mod(size, setPageSize);
           }
           else
           {
               i = (size - setPageSize);
           } 
       }
       else
       {
           i = (i - setPageSize);
       }
       
       system.debug('i value is previous =====' + i);
       system.debug('i value is 2previous ==== ' + (i - setPageSize));
       
       for(integer start = (i - setPageSize); start < i; ++start)
       {
           jobInnerListRequested.add(jobInnerList[start]);
       } 
       return jobInnerListRequested;
   }   
}
*/
    
    
    
}