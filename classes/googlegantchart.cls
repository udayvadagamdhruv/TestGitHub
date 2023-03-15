global with sharing class googlegantchart 
{
   
    public string JobName{get;set;}
    public string recordId{get;set;}
    Public Job__c JobRecord{get;set;} 
    Public Job__c Job{get;set;} 
    public string valueSelectedCmp{get;set;}
   public List<campaign__C> cmpTemp = new List<campaign__C>();
    public List<SelectOption> campList
    {
        get
        {
            cmpTemp = [Select name from campaign__C limit 500];
            
            campList = new List<SelectOption>();
            
            for(campaign__C con : cmpTemp)
            {
                campList.add(new SelectOption(con.name, con.name));
            }
            return campList;
        }
        set;
    }
    @RemoteAction
    global static list<Job__c> getjobs(){
	 return [Select Name, Id, Start_Date__c, Due_Date__c FROM Job__c where status__c='Active' order by createddate desc limit 20];
    }
    public googlegantchart() 
    {
      // this.JobRecord=(Job__c)st.getRecord();
       //recordId= JobRecord.id; 
       
       //Job=[select id,name,Job_Auto_Number__c from Job__c where id=:recordId];
       //JobName= Job.Name +' - '+ Job.Job_Auto_Number__c; 
    }

    @RemoteAction
    global static list<Job_Task__c> loadrecords(string recordId) 
    {
        return [Select ID,Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Task_Name__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c,Task_Order__c from Job_Task__c where Job__c =:recordId];
    }
      @RemoteAction
     global static list<Job__c> loadrecordsJobs(string cmpname) 
    {
        system.debug('cmpname--'+cmpname);
        if(string.isNotBlank(cmpname)){
            String newSearchText = '%'+cmpname+'%';
            return [Select Name, Id, Start_Date__c, Due_Date__c FROM Job__c where campaign__r.Name like:newSearchText and status__c='Active' order by createddate desc limit 100];  
        }else{
        return [Select Name, Id, Start_Date__c, Due_Date__c FROM Job__c where status__c='Active' order by createddate desc limit 20];  
       }
       
    }
    public void test(){
        system.debug('valueSelectedCmp--'+valueSelectedCmp);
    }
    @AuraEnabled
    public static list<Job_Task__c> loadrecordsTasks() {
      return [Select ID,Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Task_Name__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c,Task_Order__c from Job_Task__c where Job__c ='a042K00001J0fNXQAZ'];
    }
}