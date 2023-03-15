public with sharing class TimesheetEntriesExt {

    /* public boolean isMobile{ set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }
    
     public string TSprefix{set;get;}

    Public string CompUser{set;get;}
    Public String UserWhrCondi{Set;Get;}
    Public list<string> UFields{set;get;}


   //public String JobNameStr{get; set;}
    public String orgId{get; set;}
    public string hours;
    public string minutes;
    public boolean watchRender{get;set;}
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
    public Timesheet_Entries__c objTSDetail{get;set;}
    //added string and Id by Rahul on 7th march 2014 for dev item 684
    public String strJobName; 
    public Id jobId{get;set;}
    Public  List<Timesheet_Entries__c> objTsHead;
           
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
            if (Schema.sObjectType.Timesheet_Entries__c.fields.Start_Watch__c.isCreateable()) {objTSDetail.Start_Watch__c=system.now();}
        return null;
        }
         Public Pagereference End(){
             if (Schema.sObjectType.Timesheet_Entries__c.fields.End_Watch__c.isCreateable()) {objTSDetail.End_Watch__c=system.now();}
        return null;
        }
        
        
          
   
    ApexPages.standardController m_sc = null;
    Public Map<id,string> taskmap {get;set;} 
    
    
         
    public TimesheetEntriesExt(ApexPages.StandardController controller) { 
    
    TSprefix=Timesheet_Entries__c.SobjectType.getDescribe().getKeyPrefix();
    
    String tId = ApexPages.currentPage().getParameters().get('taskId');
    if(tId != null && tId != '')
        JobTaskNameStr = tid;
    
    UserWhrCondi = ' Where IsActive=true ';
    
    UFields=new list<String>{'email'};
     orgId = UserInfo.getOrganizationId();
       system.debug('org id --------->'+orgId); 
       
       if(orgId == '00D3B000000D5M2UAK' || orgId =='00D61000000JhWCEA0')
        watchRender = false;
       else
        watchRender = true;
       
    taskmap=new Map<id,string>();
       hours='0';    
       minutes='0';
        this.objTSDetail = (Timesheet_Entries__c)controller.getrecord();
        //objTsHead = new List<Timesheet_Entries__c>();
        //Added by rahul on 7th March 2014 for dev item 684
        if (Schema.sObjectType.Timesheet_Entries__c.fields.Date__c.isCreateable()) {objTSDetail.Date__c = Date.today();}
        if (Schema.sObjectType.Timesheet_Entries__c.fields.User__c.isCreateable()) {objTSDetail.User__c = UserInfo.getUserId();}

        jobId = ApexPages.currentPage().getParameters().get('jobId');
        
        m_sc = controller;
        System.debug('jobId value --> ' + jobId);
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        List<Job_Task__c> objJobTasklist=[Select Id, Name from Job_Task__c where Job__c =:JobNameStr order by Task_Order__c,CreatedDate];
        
        for(Job_Task__c obj : objJobTasklist){
        
         taskmap.put(obj.id,obj.name);
        
        
        
        }
        
        system.debug('task map -- '+taskmap);
        
        
        User u=[Select Id, Name from User where id=:UserInfo.getUserID()]; 
        if (Schema.sObjectType.Timesheet_Entries__c.fields.User__c.isCreateable()) {objTSDetail.User__c = u.Id;}
    CompUser = u.Name;
        
        
    }    
    
    public List<selectOption> getJobName(){
    
      
       
     List<selectOption> jobList= new List<selectOption>();
     
     /* Mobile version criteria */
     
       /*  if(isMobile)
         {
               User u=[Select Id, Name from User where id=:UserInfo.getUserID()]; 
               String strId=u.id;
               string username= '%' + u.Name + '%';

       
           List<Job_Task__c> objJobTasklist=[Select Id, Name,Assigned_Users__c,Job__c from Job_Task__c where Assigned_Users__c like : username ];
           set<id> setjodid = new set<id>();
           
            for(Job_Task__c obj : objJobTasklist){
            
                 setjodid.add(obj.Job__c);
           
            }
            system.debug('>>>>>>>>>>>>>>>>>>> size >>>>>>>>>>>>>>>>>>>>>>>>>>'+setjodid.size());
           system.debug('>>>>>>>>>>>>>>>>>>> setjodid >>>>>>>>>>>>>>>>>>>>>>>>>>'+setjodid);
           
            jobList.add(new SelectOption('','--None--'));
            for(Job__c objJobTemp:[Select Id, Name, Job_Auto_Number__c from Job__c where (Name <> '' or Name <> Null) and Status__c='Active' and  (CreatedById=:strId or Id In : setjodid) order by Job_Auto_Number__c desc]){
               
                strJobName = objJobTemp.Job_Auto_Number__c + ' ' + objJobTemp.Name + '';
                jobList.add(new SelectOption(objJobTemp.Id,strJobName));
                system.debug('Joblist'+jobList );
             }
            
               system.debug('>>>>>>>>>>>>>>>>>>> Joblist size >>>>>>>>>>>>>>>>>>>>>>>>>>'+Joblist.size());
                system.debug('Joblist'+jobList );
               
         }
         // ends
         else
         {
            
            jobList.add(new SelectOption('','--None--'));
            for(Job__c objJobTemp:[Select Id, Name, Job_Auto_Number__c from Job__c where (Name <> '' or Name <> Null) and Status__c='Active' order by Job_Auto_Number__c desc]){
                //added this code by Rahul on 7th March 2014 for dev item 684
                strJobName = objJobTemp.Job_Auto_Number__c + ' ' + objJobTemp.Name + '';
                jobList.add(new SelectOption(objJobTemp.Id,strJobName));
                system.debug('Joblist'+jobList );
            }
         } 
             
            GLCodeVal = '';   
            return jobList;
    }
    
    public List<selectOption> getTaskName()
    {
       
       List<Job_Task__c> objJobTasklist=[Select Id, Name from Job_Task__c where Job__c =:JobNameStr order by Task_Order__c,CreatedDate];
        
        for(Job_Task__c obj : objJobTasklist)
        {
           taskmap.put(obj.id,obj.name);
        }
        
        system.debug('task map -- '+taskmap);
    
        List<selectOption> jobTaskList= new List<selectOption>();
        
        
         if(isMobile)
         {
                User u=[Select Id, Name from User where id=:UserInfo.getUserID()]; 
                String strId=u.id;
                string username= '%' + u.Name + '%';

                jobTaskList.add(new SelectOption('','--None--'));
                for(Job_Task__c objJobTaskTemp:[Select Id, Name, CreatedDate,Task_Order__c from Job_Task__c where Job__c =:JobNameStr and Assigned_Users__c like : username order by Task_Order__c,CreatedDate])
                {
                   
                    jobTaskList.add(new SelectOption(objJobTaskTemp.Id,objJobTaskTemp.Name));
                }
            
            
         }
        
        else
        {
            jobTaskList.add(new SelectOption('','--None--'));
            system.debug('inside get task' + JobNameStr );
            //Sorted by CreatedDate by rahul on 7th March 2014 for dev item 684
            for(Job_Task__c objJobTaskTemp:[Select Id, Name, CreatedDate,Task_Order__c from Job_Task__c where Job__c =:JobNameStr order by Task_Order__c,CreatedDate])
            {
                jobTaskList.add(new SelectOption(objJobTaskTemp.Id,objJobTaskTemp.Name));
            }
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
        decimal remaininghours;
        system.debug('gl code'+GLCodeId);
        dHrsRem  = 0.00;
        objTsHead  = [select id,Hours_Worked__c,GL_Code__c from Timesheet_Entries__c where Job__c =:JobNameStr and GL_Code__c=:GLCodeId];
        
        system.debug('timesheet size'+objTsHead);
        
        if(objTsHead.size()>0 && TaskTotalHr!=0.00) {
            for(Timesheet_Entries__c  objTemp:objTsHead){
            
            if(objTemp.Hours_Worked__c<> null  ){
            
                   dHrsRem = dHrsRem +objTemp.Hours_Worked__c; 
                   
               }
                    else{
                        dHrsRem  = 0.00; 
                    }
                
            }
        }
        else{
            dHrsRem = 0.00;
        }
        
        if(dHrsRem!=0.00){
                remaininghours=TaskTotalHr-dHrsRem;
                return remaininghours;
                }
          else{
                remaininghours=dHrsRem;
                return remaininghours;
     }       }  
    
   public pagereference Save(){
        pagereference pg;
        Database.SaveResult srDetail;  
        
        If(objTSDetail.Hours_Worked__c == null){
         
            if (Schema.sObjectType.Timesheet_Entries__c.fields.Hours_Worked__c.isCreateable()) {objTSDetail.Hours_Worked__c =  decimal.valueof(hours)+(decimal.valueof(minutes)/60); }}
        
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
     
        
      /*  Profile p = [Select Id, Name from Profile where Id =: UserInfo.getProfileId()];
        if(p.Name == 'System Administrator'){
            if(objTSDetail.User__c == Null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' User can not be left blank. ');
                ApexPages.addMessage(myMsg);
                return null;                
            }                        
        } 
        */
        
        
      /*  else{
            if (Schema.sObjectType.Timesheet_Entries__c.fields.Job__c.isCreateable()) {objTSDetail.Job__c=JobNameStr;}
            if (Schema.sObjectType.Timesheet_Entries__c.fields.Task_Name__c.isCreateable()) { objTSDetail.Task_Name__c=taskmap.get(JobTaskNameStr);}
            if (Schema.sObjectType.Timesheet_Entries__c.fields.GL_Code__c.isCreateable()) { objTSDetail.GL_Code__c=GLCodeId;}
            
            if (Schema.sObjectType.Timesheet_Entries__c.isCreateable()) {insert objTSDetail;}
           //pagereference pg;
            string page = apexpages.currentpage().getparameters().get('page');
            if(isMobile)
             {
                   
               if(page=='TimesheetListTab')
                {
                    pg = new pagereference('/apex/TimesheetTabOverrideMobile');
                }
                else if(page=='Jobdetailpage')
                {
                    string Jid= apexpages.currentpage().getparameters().get('jobId');
                    pg = new pagereference('/apex/JobRequestFormdetailpageMobile?id='+Jid+'&tab=RelatedList'+'&section=timesheet');
                }
                else{
                  pg= new Pagereference('/'+TSprefix+'/o');
                }
               
             }     
    
           else{
            String th = userinfo.getUiTheme();
          //PageReference p;
           if(th == 'Theme4d'){
              if(page=='HomePage')
                 pg=new Pagereference('/lightning/page/home');
              else
                 pg=  new Pagereference('/apex/JobdetailpageLightening07?id='+JobNameStr+'&section=schedules');
               }
               
           else{
             if(page=='HomePage')
               pg=  new Pagereference('/home/home.jsp');
            else
               pg= new Pagereference('/apex/JobListView?id='+JobNameStr+'&intFocus=2');
             } 
           }
           
         pg.setRedirect(true);
         return pg;
        }
        
        return null;
    }
    
    public pagereference Cancel(){   
    
    pagereference pg;
     string page = apexpages.currentpage().getparameters().get('page');
    if(isMobile)
     {
           
           if(page=='TimesheetListTab')
            {
                pg = new pagereference('/apex/TimesheetTabOverrideMobile');
            }
            else if(page=='Jobdetailpage')
            {
                string Jid= apexpages.currentpage().getparameters().get('jobId');
                pg = new pagereference('/apex/JobRequestFormdetailpageMobile?id='+Jid+'&tab=RelatedList'+'&section=timesheet');
            }
            else{
              pg= new Pagereference('/'+TSprefix+'/o');
            }
       
     }     
    
    else{
        String th = userinfo.getUiTheme();
      //PageReference p;
       if(th == 'Theme4d'){
          if(page=='HomePage')
             pg=new Pagereference('/lightning/page/home');
          else
             pg=  new Pagereference('/apex/JobdetailpageLightening07?id='+JobNameStr+'&section=schedules');
           }
           
       else{
         if(page=='HomePage')
           pg=  new Pagereference('/home/home.jsp');
        else
           pg= new Pagereference('/apex/JobListView?id='+JobNameStr+'&intFocus=2');
        } 
           
       }
       pg.setRedirect(true);
       return pg;
    } 
*/
}