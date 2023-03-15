public with sharing class Job_Search_Controller {
    
    @AuraEnabled 
    public static Object getCustomSettingdata(){
         ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        return activeSettings;
    }

	 @AuraEnabled 
    public static boolean showProductionEstimate() {
        Boolean ShowProductionEstimate=false;
        ProductionEstimate__c activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate= activeSettings.Active__c;
        return ShowProductionEstimate;
    }    
    
    @AuraEnabled
    public static list<Job__c> getJobs(Integer intOffSet){
        System.debug('====Intger allocated Offest==='+intOffSet);
        list<Job__c> jobslist=Database.query('SELECT Id,Name,Job_Auto_Number__c,Status__c,Job_Description__c , JS_Client__r.Name,JS_Client__r.Id,Campaign__r.Id,Campaign__r.Name, Start_Date__c, Due_Date__c, Completion_Date__c, Job_Id__c from Job__c Where Name!=null WITH SECURITY_ENFORCED Order by Job_Auto_Number__c desc  LIMIT 50 OFFSET :intOffSet');
        System.debug('=====jobslist==='+jobslist);
        return jobslist;
    }
    
    
   
    
    @AuraEnabled
    public static Integer getTotalNoOfJobs(){
        AggregateResult results=[SELECT Count(Id)TotalJobs From Job__c Where Name!=null WITH SECURITY_ENFORCED];
        Integer totalJobs=(Integer)results.get('TotalJobs');
        return totalJobs;
    }
    
    
    @AuraEnabled
    public static List<String> getStatusList() 
    {
        List<String> optionList = new  List<String>();
        Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(a.getLabel());  
        }
        
        return optionList;  
    }
    
    @AuraEnabled
    public static list<Job__c> runSearch(String JN,String CN,String CampN,String ST,String JD,String SD1,String SD2,String DD1,String DD2,String CD1,String CD2) 
  {
      String soql;
      soql = 'SELECT Id,Name,Job_Auto_Number__c,Status__c,Job_Description__c , JS_Client__r.Name,JS_Client__r.Id,Campaign__r.Id,Campaign__r.Name, Start_Date__c, Due_Date__c, Completion_Date__c, Job_Id__c from Job__c where Name != null';
      
      if (!JN.equals(''))
          soql += ' and name LIKE \''+String.escapeSingleQuotes(JN)+'%\'';
      
      if (!JD.equals(''))
          soql += ' and Job_Description__c LIKE \''+String.escapeSingleQuotes(JD)+'%\'';
      
      if (!CN.equals(''))
          soql += ' and JS_Client__r.Name LIKE \''+String.escapeSingleQuotes(CN)+'%\'';
      
      if (!CampN.equals(''))
          soql += ' and Campaign__r.Name LIKE \''+String.escapeSingleQuotes(CampN)+'%\'';  
      
      if (!ST.equals(''))
          soql += ' and Status__c LIKE \''+String.escapeSingleQuotes(ST)+'\'';
      
      if(SD1!=null){
          if(!SD1.equals(''))
              soql += ' and Start_Date__c >= '+ SD1+' '; 
      }
      if(SD2!=null){
          if(!SD2.equals(''))
              soql += ' and Start_Date__c <= '+SD2+' '; 
      }
      if(DD1!=null){
          if(!DD1.equals(''))
              soql+= ' and Due_Date__c >= '+DD1+' ';
      }
      if(DD2!=null){
          if(!DD2.equals(''))
              soql+= ' and Due_Date__c <= '+DD2+' ';
      }
      if(CD1!=null){
          if(!CD1.equals(''))
              soql+= ' and Completion_Date__c >= '+CD1+' ';
      }
      if(CD2!=null){
          if(!CD2.equals(''))
              soql+= ' and Completion_Date__c <= '+CD2+' ';
      }
      soql+=' WITH SECURITY_ENFORCED Order by Job_Auto_Number__c desc limit 400';
     
      System.debug('======soql========='+soql);
      list<Job__c> jobslist=Database.query(soql);
      return jobslist;
      
  }
    
    @AuraEnabled
    public static Integer getTotalNoOfActiveJobs(){
        AggregateResult results=[SELECT Count(Id)TotalActiveJobs From Job__c Where Name!=null and Status__c='Active' WITH SECURITY_ENFORCED] ;
        Integer totalActiveJobs=(Integer)results.get('TotalActiveJobs');
        return totalActiveJobs;
    }
    
    @AuraEnabled
    public static list<Job__c> getJobsForMassUpdate(Integer offsetLimit){
        list<Job__c> jobslist=[SELECT Id,Name,Job_Auto_Number__c, Start_Date__c,Due_Date__c,Campaign__r.Name,JS_Client__r.Name,Media_Types__r.Name,Schedule_Template__r.Name from job__c where Status__c='Active' WITH SECURITY_ENFORCED Order by Job_Auto_Number__c desc  LIMIT 50 OFFSET:offsetLimit];
        return jobslist;
    }
    
    @AuraEnabled
    public static list<Object> getFiltersData(){ 
       list<Object> Filerlist=new  list<Object>();
       // {Id=a051R00000tk3rQQAQ, Name=06:29:55 2019-01-28: Campaign Classic test}, Campaign__c:{Id=a051R00000tkcHJQAY, Name=09:28:42 2019-04-04: Supreme}, Campaign__c:{Id=a051R00000tkcHYQAY, Name=11:09:11 2019-04-04: Brand Re-Launch 2017}, Campaign__c:{Id=a051R00000tkcHdQAI, Name=11:10:35 2019-04-04: March 26th Fund Raiser}
       // Filerlist.add('{Name:""}');
        List<Campaign__c> Camplist = [SELECT Id, Name FROM Campaign__c where status__c='Active' WITH SECURITY_ENFORCED order by Name ];
        List<Media_Type__c>  MediaList =[SELECT Id, Name FROM Media_Type__c  WITH SECURITY_ENFORCED order by Name];
        List<Schedule_Template__c> STemplist=[SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True WITH SECURITY_ENFORCED order by Name];
        List<Client__c> Clientlist=[SELECT Id, name,Client_Code__c FROM Client__c where Active__c=:true WITH SECURITY_ENFORCED order by Name]; 
         Filerlist.add(Camplist);
         Filerlist.add(MediaList);
         Filerlist.add(STemplist);
         Filerlist.add(Clientlist);
        System.debug(Filerlist);
        
        return Filerlist;
     }  
    
    
     @AuraEnabled
    public static list<Job__c> FilterChangesJobs(List<string> strCampaignName,List<string> strmediatype,List<string> strscheduletemp,List<string> strClientName){
    
        string sQuery = 'select id,name,Job_Auto_Number__c,Approve_PE__c, Start_Date__c,Due_Date__c,Campaign__r.name,JS_Client__r.name,Media_Types__r.name,Schedule_Template__r.name from job__c where Status__c=\'Active\'';
        
         system.debug('>>>>>>>>>>>>>strCampaignName>>>>>>>>>>>>>'+strCampaignName);
         
          system.debug('>>>>>>>>>>>>>strmediatype>>>>>>>>>>>>>'+strmediatype);
        
            if(strCampaignName!=Null && strCampaignName.size()>0)
           // system.debug('>>>>>>>>>>>>>strCampaignName>>>>>>>>>>>>>2'+strCampaignName);
               sQuery+=' And Campaign__r.name=: strCampaignName';
             
             if(strmediatype!=null && strmediatype.size()>0)
                sQuery +=' And Media_Types__r.name=:strmediatype';    
           
             if(strscheduletemp!=null && strscheduletemp.size()>0)
                sQuery +=' And Schedule_Template__r.name=:strscheduletemp';          
            
             if(strClientName !=Null && strClientName.size()>0)
               sQuery +=' And JS_Client__r.name =:strClientName';
        
               sQuery +=' WITH SECURITY_ENFORCED Order by Job_Auto_Number__c desc limit 1000';
      
          List<Job__c> returnJoblist=Database.query(sQuery);
         return returnJoblist;

    }
    
    
    @AuraEnabled
    public static String MarkDoneCompleteJobs(List<Job__c> selJobs ,boolean completePEItems,boolean completeTaskItems)
    {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();  
        boolean ShowPELI=activeSettings.Active__c; 
        
        Map<Id,list<Production_Estimate__c>> JobwithPeMap = new Map<Id,list<Production_Estimate__c>>();
        Map<Id,list<Job_Task__c>> jobwithtaksmap = new Map<Id,list<Job_Task__c>>();
        
        list<Production_Estimate__c> PEList = [select Approved__c,Name,Job__c,job__r.id from Production_Estimate__c where Job__r.status__c='Active' and Approved__c =: False WITH SECURITY_ENFORCED];
        List<Job_Task__c>  taskslist = [Select Id,Marked_Done__c,Completion_Date__c,job__c,job__r.id from Job_Task__c where Job__r.status__c='Active' and Marked_Done__c!=true WITH SECURITY_ENFORCED];
        list<job__c> joblist = [select id,name,Status__c,Completion_Date__c,Job_Auto_Number__c from job__c where Status__c='Active' WITH SECURITY_ENFORCED order by Job_Auto_Number__c];
        
        
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
        
        
        List<job__c> selectedjobs = selJobs;
        List<Job_Task__c> jobTask= new List<Job_Task__c>();
        
        list<Job_Task__c > taksupd = new list<Job_Task__c >();
        list<Production_Estimate__c> PEupdat = new list<Production_Estimate__c>();
        
        for(job__c jobb: selectedjobs)
        {
            // system.debug('---------------------------------------------------------------------------<<<<<<<<<<'+jobb);
            if(Schema.sObjectType.job__c.fields.Status__c.isUpdateable()){
                jobb.Status__c ='Completed';}
           
            if(completePEItems && ShowPELI)
            {
                  if(Schema.sObjectType.job__c.fields.Approve_PE__c.isUpdateable()){
                      jobb.Approve_PE__c= True;}
            }
            else
            {
                if(Schema.sObjectType.job__c.fields.Approve_PE__c.isUpdateable()){ jobb.Approve_PE__c= False;}
            }     
            
            
            //list<Production_Estimate__c> PEupdate = new list<Production_Estimate__c>();
            //PEupdate = JobwithPeMap.get(jobb.id);
            if(completeTaskItems){                
           
            list<Job_Task__c > taksupdate = new list<Job_Task__c >();
            taksupdate = jobwithtaksmap.get(jobb.Id);
            if(taksupdate.size() > 0)
            {
                for(Job_Task__c jt : taksupdate )
                {
                    if(Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()){jt.Marked_Done__c=true;}
                    if(Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()){jt.Completion_Date__c=system.today(); }
                    taksupd.add(jt);
                }
            }
            }
            
                /*  if(PEupdate.size() > 0)
                    {
                    for(Production_Estimate__c objPE : PEupdate)
                    {
                    objPE.Approved__c = true;
                    PEUpdat.add(objPE); 
                    }
                    }
                */ 
            
        }
        //update taksupd ;
        if(completeTaskItems && !taksupd.isEmpty()){
            MassUpdateBatchController mbc = new MassUpdateBatchController(taksupd);
            database.executebatch(mbc,45);
        }
      
        
        try{
           if(Schema.sObjectType.job__c.isUpdateable()){
              
               update selectedjobs;return 'OK';  }
            else{
                return 'Job has insufficient access to update';
            }
        }
        Catch(System.DmlException e){
            return ''+e.getMessage();
        }
        
    }
    

    
}