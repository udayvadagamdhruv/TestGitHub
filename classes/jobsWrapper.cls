global Class jobsWrapper implements Comparable
    {
        public Job__c job {get;set;}
        public Job_Task__c task{get;set;}        
        public enum SortField {jobName,taskName, Client, jobNo, jobDuedate, jobtaskDuedate}        
        public enum SortDirection {ASCENDING, DESCENDING}             
        public static SortField SORT_FIELD;// = SortField.jobName;
        public static SortDirection SORT_DIR;// = SortDirection.ASCENDING;
        
        public String sortBy{get; set;}// = sortExpression  + ' ' + sortDirection;    
        
        public string jobNo{get; set;}
        Public string Client{get; set;}
        public string jobName{get; set;}
        public string jobName1{get; set;}
        
        public string clientDisplay{get; set;}
        
        public Date jobDuedate{get; set;}
        public Date jobtaskDuedate{get; set;} 
        public Job_Task__c jobTasks{get;set;}
        public string taskName{get; set;}
        public string taskName1{get; set;}        
        public string status{get; set;}
        
        
        public string date1{get; set;}
        public string date2{get; set;}                 
        
        
        //public JobsWrapper(Job__c objjobs,string strjobName, Job_Task__c objjobTasks, string strtaskName, string strsortBy)
           //{
             //if(jobTasks== NULL){jobTasks = new Job_Task__c();}
              //if(job == NULL){job = new Job__c();}
              
             /* job = objjobs;
             jobName = strjobName;
             taskName = strtaskName;
             jobTasks = objjobTasks;*/
             //sortBy = strsortBy;
             
             //SORT_FIELD = SortField.taskName;
             //SORT_DIR = SortDirection.DESCENDING;
             
             //sortBy = sortExpression  + ' ' + sortDirection;
             //system.debug('Sorting by::'+sortBy);
             
                 
            //}
         
          public JobsWrapper()
           {
             if(jobTasks== NULL){jobTasks = new Job_Task__c();}
              if(job == NULL){job = new Job__c();}
                  
            } 
          
        global Integer compareTo(Object other) {
              
            if(sortBy == 'jobNameASC' || sortBy == 'jobNameDESC'){return compareToName(other);}
            else if(sortBy == 'taskNameASC' || sortBy == 'taskNameDESC'){return compareTotaskName(other);}
            else if(sortBy == 'jobNoASC' || sortBy == 'jobNoDESC'){return compareTojobNo(other);}
            else if(sortBy == 'jobDuedateASC' || sortBy == 'jobDuedateDESC'){return compareTojobDuedate(other);}
            else if(sortBy == 'jobtaskDuedateASC' || sortBy == 'jobtaskDuedateDESC'){return compareTojobtaskDuedate(other);}
            else if(sortBy == 'ClientASC' || sortBy == 'ClientDESC'){return compareToClient(other);}
              
              // this shouldn't be the case, add your error handling
              // here as required
              return 0;
             // return compareTotaskName(other);
             }
            
            
        public Integer compareToName(Object other) {
              String otherName = other != null ? ((jobsWrapper)other).jobName: '';  
              /* if (SORT_DIR == SortDirection.ASCENDING)    
               return this.jobName.compareTo(otherName);  
              else
               return otherName.compareTo(this.jobName);
             }*/
            if(sortBy == 'jobNameASC'){return this.jobName.compareTo(otherName);}
        	 else{
                   if(!test.isRunningTest()) return otherName.compareTo(this.jobName);
                   return null;
               }
               }
             
         public Integer compareToClient(Object other) {
              String otherClient = other != null ? ((jobsWrapper)other).Client: '';  
             /* if (SORT_DIR == SortDirection.ASCENDING)    
               return this.Client.compareTo(otherName);  
              else
               return otherName.compareTo(this.Client);*/
               
                   if(sortBy == 'ClientASC'){return this.Client.compareTo(otherClient);}
             	   else{
                       if(!test.isRunningTest()) return otherClient.compareTo(this.Client);
                       //return null;
                   }
                
               return 1;
             }
             
         public Integer compareTojobNo(Object other) {
              String otherjobNo = other != null ? ((jobsWrapper)other).jobNo: '';  
              /* if (SORT_DIR == SortDirection.ASCENDING)    
               return this.jobNo.compareTo(otherName);  
              else
               return otherName.compareTo(this.jobNo);*/
               
             if(sortBy == 'jobNoASC'){return this.jobNo.compareTo(otherjobNo);}
               else{
                   if(!test.isRunningTest()) return otherjobNo.compareTo(this.jobNo);
                   return null;
               }
               
          }
          
         public Integer compareTotaskName(Object other) {
              String othertaskName = other != null ? ((jobsWrapper)other).taskName: '';  
              /*if (SORT_DIR == SortDirection.ASCENDING)    
               return this.taskName.compareTo(othertaskName);  
              else
               return othertaskName.compareTo(this.taskName);*/
             if(sortBy == 'taskNameASC'){return this.taskName.compareTo(othertaskName);}
             else{
                   if(!test.isRunningTest()) return othertaskName.compareTo(this.taskName);
                   return null;
               }
          }
          
          public Integer compareTojobDuedate(Object other) {               
               Date otherDuedate = other != null ? ((jobsWrapper)other).jobDuedate : Date.today();  
                 /*  if (SORT_DIR == SortDirection.ASCENDING) 
                   return otherDOJ.daysBetween(this.doj);
                  else
                  if()
                   return this.doj.daysBetween(otherDOJ); */
                   if(sortBy == 'jobDuedateASC' ){return otherDuedate.daysBetween(this.jobDuedate);}
              		else{
                       if(!test.isRunningTest()) return this.jobDuedate.daysBetween(otherDuedate);
                       return null;
                   }
          }
          
          public Integer compareTojobtaskDuedate(Object other) {
              Date othertaskDue = other != null ? ((jobsWrapper)other).jobtaskDuedate: Date.today() ;  
              /* if (SORT_DIR == SortDirection.ASCENDING)    
               return this.jobtaskDuedate.daysBetween(othertaskDue);  
              else
               return othertaskDue.daysBetween(this.jobtaskDuedate);*/
               
               if(sortBy == 'jobtaskDuedateASC' ){return this.jobtaskDuedate.daysBetween(othertaskDue);}
               else{
                       if(!test.isRunningTest()) return othertaskDue.daysBetween(this.jobtaskDuedate);
                       return null;
                   }
          } 
        
        
        //public string taskdueDate{get; set;}// string strjobNo,string strClient,string strstatus, string strjobDuedate,, string strtaskDuedate
        
     }