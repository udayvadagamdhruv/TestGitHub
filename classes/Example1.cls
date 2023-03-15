public with sharing class Example1 {
    
  /*  CustomIterable obj;
    public list<JobInner> jobsInnerObj {get;set;}
    public set<jobinner> jobsSelected {get;set;}
    public string active='active';
    public integer count{get;set;}
    public boolean load{get;set;}
    public integer size{get;set;}
    
    public Example1 () { 
    
             
        string sQuery = 'select id,name,Status__c,Completion_Date__c,Job_Auto_Number__c from job__c where Status__c=:Active order by Job_Auto_Number__c';
        count = [select count() from job__c where Status__c=:Active];
        obj = new CustomIterable(sQuery); 
        obj.setPageSize = 15;
        jobsSelected = new set<jobinner>();
        next();
    }
    
    public void Complete()
    {
            List<job__c> selectedjobs = new List<job__c>();
            
            List<Job_Task__c> jobTask= new List<Job_Task__c>();
            
             if(jobsInnerObj != NULL)
            {
                 for(JobInner w: jobsInnerObj) 
                {
                    if(w.isSelected == true) 
                    {
                        jobsSelected.add(w);
                    }
                    else
                        jobsSelected.remove(w);
                }
             }
            
            for(JobInner w: jobsSelected ) 
            {
                if(w.isSelected == true) 
                {
                    selectedjobs.add(w.jobs);
                }
            }

            
            
            for(job__c jobb: selectedjobs)
            {
               // system.debug('---------------------------------------------------------------------------<<<<<<<<<<'+jobb);
                jobb.Status__c ='Completed';
                
                jobTask = [Select Id,Name,Status__c,Job__c,Marked_Done__c,Completion_Date__c from Job_Task__c where Job__r.status__c=:Active and Job__c =:jobb.id];
                
                for(Job_Task__c jt : jobTask )
                {
                   //  jt .Status__c = 'Completed';
                       jt.Marked_Done__c=true;
                       jt.Completion_Date__c=system.today(); 
                }
                  update jobTask;
            }
            update selectedjobs;
            size = selectedjobs.size();
            load = true;
          
       // return page.JobsTabOverride;
    }
    
   public pageReference CancelBut()
   {
       return page.JobsTabOverride;
   }
    
    
    public Boolean hasNext {
        get {
            return obj.hasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            return obj.hasPrevious();
        }
        set;
    }
    
    public void next() 
    {
        
        if(jobsInnerObj != NULL)
        {
         for(JobInner w: jobsInnerObj) 
            {
                if(w.isSelected == true) 
                {
                    jobsSelected.add(w);
                }
                else
                    jobsSelected.remove(w);
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
                if(w.isSelected == true) 
                {
                    jobsSelected.add(w);
                }
                else
                    jobsSelected.remove(w);
            }
         }
        
        
        jobsInnerObj = obj.previous();
    }
    
    public Class JobInner
    {
        public boolean isSelected {get;set;}
        public job__c jobs {get;set;}
        
        public JobInner(boolean isSelected, job__c jobs)
        {
            this.isSelected = isSelected;
            this.jobs = jobs;
        }
    }
    
    
    
   Public class CustomIterable{ 

   List<job__c> jobs {get; set;} 
   list<JobInner> jobInnerList {get; set;} 
   list<JobInner> jobInnerListRequested {get; set;} 
   JobInner jobsInnerObj;
   public Integer i {get; set;} 
   public Integer setPageSize {get; set;} 
   public string active='active';
    

   public CustomIterable(string sQuery){ 
       jobs = Database.Query(sQuery);
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
       if(i >= jobInnerList.size()) {
           return false; 
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
           if(math.mod(size, setPageSize) > 0)
           {    
               i = size - math.mod(size, setPageSize);
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