public with sharing class TestAmcTvReportpdfExt
{

    public PageReference print() {
        return null;
    }


    Public list<Campaign__c> Camplist{get;set;}
    Public list<Job__c> joblist{get;set;}
    public List<string> strCampaignName{get;set;}
    Public List<string> strJobName{get;set;}
    Public string strTaskName{get;set;}
    Public string  soqlJob{get;set;}
    Public string  soqlCamp{get;set;}
    public string Status{get;set;}
    
    public map<Date,list<Campaign__c>> CampMap{get;set;}
    public map<string,list<Job_Task__c>> TaskMap{get;set;}
    
    
    public list<selectoption> getcampaigns()
    {
        list<selectoption> optionList= new list<selectoption>();
       
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c where status__c=:Status order by Name limit 10000]) 
        {  
            optionList.add(new selectOption(a.name, a.Name ));    
        }
        return optionList;  
    }
    
    
    public list<selectoption> getjobs()
    {
        list<selectoption> optionlist = new list<selectoption>();
         for (Job__c a : [SELECT Id, name,Campaign__c FROM Job__c where status__c=:Status order by Name limit 10000]) 
          {  
            optionlist .add(new selectOption(a.name, a.Name ));
          }
          return optionlist;  
    }
    
    
    public TestAmcTvReportpdfExt()
    {
          
        //  Status='active';
    }
    
    public PageReference search() 
    {
       
        joblist=new list<Job__c>();
        Camplist=new list<Campaign__c>();
        
        
        CampMap= new map<Date,list<Campaign__c>>();
        TaskMap = new map<string,list<Job_Task__c>> ();
    
        if(strJobName!=null && strJobName.size()>0)
    
            soqlCamp= 'select id,name,(select id,name from Jobs__r where name=:strJobName),Dummy_Date_1__c from Campaign__c where Status__c=:Status';
             
         else       
        
            soqlCamp= 'select id,name,(select id,name from Jobs__r),Dummy_Date_1__c from Campaign__c where Status__c=:Status';
        
                if(strCampaignName!=Null && strCampaignName.size()>0)
                    soqlCamp+=' And name=:strCampaignName';
          
              /*  if(strJobName!=null && strJobName.size()>0)
                    soqlCamp +=' And jobs__r.name=:strJobName';  */
          
        //    soqlCamp +='order by name Limit 1000'; 
          
            Camplist=Database.query(soqlCamp);
          string strTaskName1 = '%'+strTaskName+'%';
     if(strTaskName!=Null)
     
           soqlJob = 'select id,name,(select id,name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Completion_Date__c,Due_Date__c,Job__c from Job_Task__r where name like: strTaskName1),Job_Auto_Number__c,Campaign__c,Due_Date__c,Status__c,Campaign__r.name from Job__c where  id != null';  
           
         else     
             soqlJob = 'select id,name,(select id,name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Completion_Date__c,Due_Date__c,Job__c from Job_Task__r),Job_Auto_Number__c,Campaign__c,Due_Date__c,Status__c,Campaign__r.name from Job__c where  id != null';  
              
               if(strCampaignName!=Null && strCampaignName.size()>0)
                    soqlJob +=' And Campaign__r.name=:strCampaignName';
              
               if(strJobName!=null && strJobName.size()>0)
                    soqlJob +=' And name=:strJobName';  
           
          
         //   soqlJob+='order by Campaign__r.name Limit 1000'; 
          
            joblist=Database.query(soqlJob);
            
            
            
            for(Campaign__c camp:Camplist)
            {
                  if(camp.Dummy_Date_1__c!=null)
                  {
                  
                        if(CampMap.containsKey(camp.Dummy_Date_1__c))
                        {
                          List <Campaign__c> Campaignlist =  CampMap.get(camp.Dummy_Date_1__c );
                          Campaignlist.add(camp);
                          if(camp.Jobs__r.size() != 0)
                          CampMap.put(camp.Dummy_Date_1__c,Campaignlist);  
                        }
                        else
                        {
                           if(camp.Jobs__r.size() != 0)
                           CampMap.put(camp.Dummy_Date_1__c , new List<Campaign__c>{camp}) ;
                        }
                  }        
           
             }
             
             
            for(Job__c Job:joblist)
            {
                 if(Job.Job_Task__r.size()>0)       
                 TaskMap.put(job.name, Job.Job_Task__r) ;
                          
            }
             
            
           
          
        
        return null;
    }
    
    public PageReference clear() 
    {
        
        
        
        if(strCampaignName!=null && strCampaignName.size()>0)
        {
            strCampaignName.clear();
        }
        
        
        if(strJobname!=null && strJobname.size()>0)
        {
            strJobname.clear();
        }
          
        return null;
    } 
    
    
    public pagereference printpdf() 
    {
        PageReference pageRef = Page.TestAmcTvReportPDF;
        
        return pageRef;
    }
    
    
    
    
    
    
   

}