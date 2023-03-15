public with sharing class enterJsTsDetailCon {
    //public String JobNameStr{get; set;}
    public string hours;
    public string minutes;
    public boolean error {get{
    string s =calcTimeDiff ;
    if(s!='0'){
           if(s=='0:00') return true;
           else return false;
       }
       return this.error;
    }set;}
    
    public decimal stime ;
    Public string calcTimeDiff{get{
        If(objTSDetail.Start_Watch__c !=null && objTSDetail.End_Watch__c!= null){
         if(objTSDetail.Start_Watch__c.getTime() <= objTSDetail.End_Watch__c.getTime() ){
            decimal var = ((objTSDetail.End_Watch__c.getTime() - objTSDetail.Start_Watch__c.getTime()) / (1000.0*60.0*60.0));
            stime=(var-Math.Floor(var))*60;
            hours= string.valueof(Math.Floor(var));
            minutes =string.valueof(stime.setScale(0,System.RoundingMode.HALF_EVEN));
            If(integer.valueof(minutes) == 60){
            hours = string.valueof(integer.valueof(hours)+1);
            minutes='00';
            
            }
            
            return hours+':'+minutes ;
        }
        else{
            
            return '0:00';
         }
         }
         else return '0';
    }set;}
    
    Public Boolean ShowProductionEstimate{get;set;}
    public String JobTaskNameStr{get;set;}
    private Id GLCodeId;
    private String GLCodeVal; 
    private Decimal TaskTotalHr;
    private List<Estimate_Line_Items__c> objES;
    private List<Production_Estimate__c> objPES;
    private List<Job_Task__c> objTask;
    public JS_TS_Details__c objTSDetail{get;set;}
    //added string and Id by Rahul on 7th march 2014 for dev item 684
    public String strJobName; 
    public Id jobId{get;set;}
          
    public string JobNameStr
    {
        get
        {
            if(jobId != null)
            {
                JobNameStr = jobId;
                system.debug('Jobid'+JobNameStr );
                jobId = null;
                return JobNameStr;
            }
            else{
                return JobNameStr;
            } 
        }
        set;
    }          
        
        Public Pagereference start(){
        objTSDetail.Start_Watch__c=system.now();
        return null;
        }
         Public Pagereference End(){
        objTSDetail.End_Watch__c=system.now();
        return null;
        }
        
        
          
    List<JS_Time_Sheet__c> objTsHead;
    ApexPages.standardController m_sc = null;
                
    public enterJsTsDetailCon(ApexPages.StandardController controller) {  
    
       hours='0';    
       minutes='0';
        objTSDetail = new JS_TS_Details__c();
        objTsHead = new List<JS_Time_Sheet__c>();
        //Added by rahul on 7th March 2014 for dev item 684
        objTSDetail.Date__c = Date.today();
        objTSDetail.User__c = UserInfo.getUserId();

        jobId = ApexPages.currentPage().getParameters().get('jobId');
        
        m_sc = controller;
        System.debug('jobId value --> ' + jobId);
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
    }    
    
    public List<selectOption> getJobName(){
        List<selectOption> jobList= new List<selectOption>();
        
        jobList.add(new SelectOption('','--None--'));
        for(Job__c objJobTemp:[Select Id, Name, Job_Auto_Number__c from Job__c where (Name <> '' or Name <> Null) and Status__c='Active' order by Job_Auto_Number__c]){
            //added this code by Rahul on 7th March 2014 for dev item 684
            strJobName = objJobTemp.Job_Auto_Number__c + ' ' + objJobTemp.Name + '';
            jobList.add(new SelectOption(objJobTemp.Id,strJobName));
            system.debug('Joblist'+jobList );
        } 
         
        GLCodeVal = '';   
        return jobList;
    }
    
    public List<selectOption> getTaskName(){
        List<selectOption> jobTaskList= new List<selectOption>();
        jobTaskList.add(new SelectOption('','--None--'));
        system.debug('inside get task' + JobNameStr );
        //Sorted by CreatedDate by rahul on 7th March 2014 for dev item 684
        for(Job_Task__c objJobTaskTemp:[Select Id, Name, CreatedDate,Task_Order__c from Job_Task__c where Job__c =:JobNameStr order by Task_Order__c,CreatedDate]){
            jobTaskList.add(new SelectOption(objJobTaskTemp.Id,objJobTaskTemp.Name));
        }
        return jobTaskList;  
    } 
    
    public String getGLCodeOfTask(){  
   
        if(string.valueof(JobTaskNameStr) <> ''){
            objTask = [Select GL_Code__c, GL_Code__r.Name from Job_Task__c  where Id=:JobTaskNameStr and Job__c=:JobNameStr limit 1];
            for(Job_Task__c objTemp:objTask){
                if(objTask.size()>0){
                    if(string.valueof(objTemp.GL_Code__c)<>'' || string.valueof(objTemp.GL_Code__c)<>null){
                        GLCodeId = objTemp.GL_Code__c;
                        GLCodeVal = string.valueof(objTemp.GL_Code__r.Name);
                    }
                    else{
                        GLCodeVal='';
                    }
                }
                else{
                        GLCodeVal='';            
                }            
            }
        }
        else{
            GLCodeVal = '';
        }
        return GLCodeVal;
    }
    
    public Decimal getTotalHours(){  
        system.debug('gl code id -- '+GLCodeid);
        system.debug('job value -- '+JobNameStr );
        system.debug('task value -- '+JobTaskNameStr );
        TaskTotalHr = 0.00;
        if(ShowProductionEstimate ){
        if(String.valueof(GLCodeVal)<>'' || String.valueof(GLCodeVal)<>null){            
            objPES= [select Quantity__c from Production_Estimate__c  where Job__c=:JobNameStr and GL_Code__c=:GLCodeId ];
            system.debug('Production estimate -- '+ objPES);
            if(objPES.size()>0)
            {
                for(Production_Estimate__c  objTemp:objPES){
                    if(objTemp.Quantity__c <> null ){
                        TaskTotalHr = TaskTotalHr + objTemp.Quantity__c; 
                    }
                    else{
                        TaskTotalHr = 0.00; 
                    }
                }
            }
            else{
                TaskTotalHr=0.00;
            }
        }
        else{
            TaskTotalHr=0.00;
        }
             
        return TaskTotalHr;
        
      }
      else{
      
      if(String.valueof(GLCodeVal)<>'' || String.valueof(GLCodeVal)<>null){            
            objES = [select Quantity__c from Estimate_Line_Items__c where Job__c=:JobNameStr and GL_Code__c=:GLCodeId ];
            system.debug('estimate -- '+ objES);
            if(objES.size()>0)
            {
                for(Estimate_Line_Items__c objTemp:objES){
                    if(objTemp.Quantity__c <> null ){
                        TaskTotalHr = TaskTotalHr + objTemp.Quantity__c; 
                    }
                    else{
                        TaskTotalHr = 0.00; 
                    }
                }
            }
            else{
                TaskTotalHr=0.00;
            }
        }
        else{
            TaskTotalHr=0.00;
        }
             
        return TaskTotalHr;
      
      
      
      }  
        
        
        
    }
    
    public Decimal getRemainHours(){ 
        Decimal dHrsRem;              
        objTsHead = new List<JS_Time_Sheet__c>();
        objTsHead  = [select Remaining_Hours__c from JS_Time_Sheet__c where Job__c =:JobNameStr and GL_Code__c =:GLCodeId limit 1];
        
        if(objTsHead.size()>0) {
            for(JS_Time_Sheet__c objTemp:objTsHead){
                dHrsRem = objTemp.Remaining_Hours__c;
            }
        }
        else{
            dHrsRem = 0.00;
        }
        
        return dHrsRem;
    }    
    
    public pagereference Save(){
        pagereference pg;
        Database.SaveResult srDetail;  
        
        If(objTSDetail.Hours_Worked__c == null){
         
           objTSDetail.Hours_Worked__c =  decimal.valueof(hours)+(decimal.valueof(minutes)/100); }
        
        system.debug('job name--->'+JobNameStr );
        system.debug('task name--->'+JobTaskNameStr );
        system.debug('glcode name n id---->'+GLCodeVal +' '+GLCodeId );
        system.debug('Object detail--->'+objTSDetail);                
        system.debug('total hrs--->'+TaskTotalHr);
        
        if(JobNameStr =='' || JobNameStr == Null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must select the Job Name ');
            ApexPages.addMessage(myMsg);
            return null;        
        }
        
        if(JobTaskNameStr == '' || JobTaskNameStr == Null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must select Task Name ');
            ApexPages.addMessage(myMsg);
            return null;                
        }
        
        if(objTSDetail.Date__c== Null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' Please enter date ');
            ApexPages.addMessage(myMsg);
            return null;                
        }
        
       /* if(objTSDetail.Hours_Worked__c == 0.00 || objTSDetail.Hours_Worked__c == Null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' Total Hours Worked Should not be null ');
            ApexPages.addMessage(myMsg);
            return null;                
        }*/
        
        Profile p = [Select Id, Name from Profile where Id =: UserInfo.getProfileId()];
        if(p.Name == 'System Administrator'){
            if(objTSDetail.User__c == Null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' User can not be left blank. ');
                ApexPages.addMessage(myMsg);
                return null;                
            }                        
        } 
        
        try
        {            
        if(objTsHead.size()==0)
        {   
            objTsHead = new List<JS_Time_Sheet__c>{ new JS_Time_Sheet__c(
            GL_Code__c = GLCodeId,
            Job__c = JobNameStr,
            Estimated_Hours__c = TaskTotalHr
            )};
           
            Database.SaveResult[] srHeader = Database.insert(objTsHead, false); 
            
            system.debug('end of insert');
            
            for(Database.SaveResult objTemp:srHeader){
                if(objTemp.isSuccess()== False){
                    return null;
                }
            }
            system.debug('object data--->'+objTsHead);
            
            //following code is to skip 0000 auto number.
            JS_Time_Sheet__c objTH2 = new JS_Time_Sheet__c();            
            JS_Time_Sheet__c objTH3 = new JS_Time_Sheet__c();            
            
            for(JS_Time_Sheet__c objTDTest:objTsHead){
                objTH3 = [select Name,GL_Code__c, Job__c,Estimated_Hours__c from JS_Time_Sheet__c where Id=:objTDTest.Id];        
            }         
            system.debug('data to print-->'+objTH3);
            Integer aNumber;      
            aNumber = integer.ValueOf(objTH3.Name);
            if(aNumber == 0000)
            {
                objTH2.GL_Code__c = objTH3.GL_Code__c; 
                objTH2.Job__c = objTH3.Job__c;
                objTH2.Estimated_Hours__c = objTH3.Estimated_Hours__c;
                delete objTsHead; 
                insert objTH2;                           
                objTsHead = [Select ID, Name from JS_Time_Sheet__c where Id=:objTH2.Id limit 1];                                  
            }
       }
       system.debug('detail entering---');
       for(JS_Time_Sheet__c objTemp:objTsHead){
            objTSDetail.Job_Timesheet__c= objTemp.Id;
            objTSDetail.Task__c = JobTaskNameStr;
            if(objTSDetail.User__c == null){
                objTSDetail.User__c = UserInfo.getUserId();
            }
        }
        srDetail = Database.insert(objTSDetail, false);   
    
        if(srDetail.isSuccess()){
            //below code is to skip 0000 auto number
            JS_TS_Details__c objTD2 = new JS_TS_Details__c();            
            JS_TS_Details__c objTD3 = new JS_TS_Details__c();            
            
            objTD3 = [select Name,Job_Timesheet__c, Task__c,User__c,Date__c,Start_Watch__c,End_Watch__c,Hours_Worked__c,Notes__c from JS_TS_Details__c where Id=:objTSDetail.Id];        
            
            system.debug('details@@@--->'+objTD3 );                    
            
            Integer aNumber2;      
            aNumber2 = integer.ValueOf(objTD3.Name);
            if(aNumber2 == 0000)
            {
                system.debug('inside 0000');
                objTD2.Job_Timesheet__c = objTD3.Job_Timesheet__c;
                objTD2.Task__c = objTD3.Task__c;
                objTD2.User__c = objTD3.User__c;
                objTD2.Date__c = objTD3.Date__c;
                objTD2.Hours_Worked__c = objTD3.Hours_Worked__c;
                objTD2.Notes__c =objTD3.Notes__c;
                
                 
                insert objTD2;                           
                objTSDetail = [Select ID, Name from JS_TS_Details__c where Id=:objTD2.Id limit 1];    
                delete objTSDetail;                              
            }            
            
            pg = new pagereference('/'+objTSDetail.Id);
            pg.setRedirect(true);
            return pg;
        }
        else{ ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' Transaction unsuccessful. ');ApexPages.addMessage(myMsg);return null;
        }
        }
        Catch(Exception e){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+e.getMessage()); ApexPages.addMessage(myMsg);
            system.debug('error--->'+e);return null;            
        }      
    }
    
    public pagereference Cancel(){        
      /*      pagereference pg;
            pg = new pagereference('/a0q/o');
            pg.setRedirect(true);
            return pg;        
        return null; */
        return m_sc.cancel();
        
    }   
}