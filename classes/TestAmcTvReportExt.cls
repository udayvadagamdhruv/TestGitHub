public with sharing class TestAmcTvReportExt 
{


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
    public map<string,String> JobTaskMap{get;set;}
    public map<string,list<Job__c>> CampJobMap{get;set;}
    public map<Date,set<string>> MapCampaign{get;set;}
    public map<string,String> CampNames{get;set;}
    
    
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    
    
    
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
    
    
    public TestAmcTvReportExt()
    {
          
          Status='active';
          
            imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }

          
    }
    
    public PageReference search() 
    {
    
        joblist=new list<Job__c>();
        Camplist=new list<Campaign__c>();
        
        JobTaskMap = new map<string,String>();
        
        set<Id> CampId = new set<Id>();
        
        
        
        CampMap= new map<Date,list<Campaign__c>>();
        TaskMap = new map<String,list<Job_Task__c>> ();
        CampJobMap = new map<string,list<Job__c>>();
        MapCampaign = new map<Date,set<string>>();
        CampNames = new map<string,String>();
    
        if(strJobName!=null && strJobName.size()>0)
    
            soqlCamp= 'select id,name,(select id,name,Due_Date__c,Job_Auto_Number__c from Jobs__r where name=:strJobName and Status__c=:Status order by Due_Date__c,name),Dummy_Date_1__c from Campaign__c where Status__c=:Status';
             
         else       
        
            soqlCamp= 'select id,name,(select id,name,Due_Date__c,Job_Auto_Number__c from Jobs__r where Status__c=:Status order by Due_Date__c,name),Dummy_Date_1__c from Campaign__c where Status__c=:Status';
        
                if(strCampaignName!=Null && strCampaignName.size()>0)
                    soqlCamp+=' And name=:strCampaignName';
          
              /*  if(strJobName!=null && strJobName.size()>0)
                    soqlCamp +=' And jobs__r.name=:strJobName';  */
          
             soqlCamp +=' order by name'; 
          
          Camplist=Database.query(soqlCamp);
          
          string strTaskName1 = '%'+strTaskName+'%';
          
          for(Campaign__c camp:Camplist)
          {
          
                  CampJobMap.put(camp.id, camp.Jobs__r);
                  CampNames.put(camp.id, camp.name);
                  if(camp.Dummy_Date_1__c!=null)
                  {
                  
                        if(CampMap.containsKey(camp.Dummy_Date_1__c))
                        {
                          List <Campaign__c> Campaignlist =  CampMap.get(camp.Dummy_Date_1__c );
                          //for(Job__c cj : camp.Jobs__r){
                              Campaignlist.add(camp);
                         // }
                          if(camp.Jobs__r.size() != 0){
                          CampMap.put(camp.Dummy_Date_1__c,Campaignlist); 
                          CampId.add(camp.id);
                          } 
                        }
                        else
                        {
                           if(camp.Jobs__r.size() != 0){
                           CampMap.put(camp.Dummy_Date_1__c , new List<Campaign__c>{camp}) ;
                           CampId.add(camp.id);
                           }
                        }
                  }        
           
           }
             
          
          
     if(strTaskName!=Null)
     
         soqlJob = 'select id,name,Campaign__r.Dummy_Date_1__c,(select id,name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Completion_Date__c,Due_Date__c,Job__c from Job_Task__r where name like: strTaskName1 order by Revised_Due_Date__c,name),Job_Auto_Number__c,Campaign__c,Due_Date__c,Status__c,Campaign__r.name from Job__c where Status__c=:Status and Campaign__c IN : CampId';  
           
         else     
             soqlJob = 'select id,name,Campaign__r.Dummy_Date_1__c,(select id,name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Completion_Date__c,Due_Date__c,Job__c from Job_Task__r order by Revised_Due_Date__c,name),Job_Auto_Number__c,Campaign__c,Due_Date__c,Status__c,Campaign__r.name from Job__c where Status__c=:Status and Campaign__c IN : CampId';  
              
               if(strCampaignName!=Null && strCampaignName.size()>0)
                    soqlJob +=' And Campaign__r.name=:strCampaignName';
              
               if(strJobName!=null && strJobName.size()>0)
                    soqlJob +=' And name=:strJobName';  
           
          
            soqlJob+=' order by Campaign__r.Dummy_Date_1__c desc,Campaign__r.name'; 
          
            joblist=Database.query(soqlJob);
            
            for(Job__c Job:joblist)
            {
                  if(job.Campaign__r.Dummy_Date_1__c!=null)
                  {
                  
                        if(MapCampaign.containsKey(Job.Campaign__r.Dummy_Date_1__c))
                        {
                              set<string> Campaignlist =  MapCampaign.get(Job.Campaign__r.Dummy_Date_1__c);
                            
                              Campaignlist.add(job.Campaign__c);
                            
                              if(Job.Job_Task__r.size() != 0)
                              {
                                  MapCampaign.put(Job.Campaign__r.Dummy_Date_1__c,Campaignlist); 
                                  //CampId.add(camp.id);
                              } 
                        }
                        else
                        {
                           if(Job.Job_Task__r.size() != 0)
                           {
                               MapCampaign.put(Job.Campaign__r.Dummy_Date_1__c, new set<string>{job.Campaign__c}) ;
                               //CampId.add(camp.id);
                           }
                        }
                  }     
            
                   
               //  if(Job.Job_Task__r.size()>0)      
                     TaskMap.put(job.id, Job.Job_Task__r);
                     JobTaskMap.put(job.id, string.valueof(Job.Job_Task__r.size()));
                 
                 system.debug('>>>>>>>>>>>>>>>>>>>TaskMap>>>>>>>>>>>>>'+TaskMap);
                          
            }
             
            
        
        return null;
    }
    
    public PageReference clear() 
    {
        
        
        strTaskName='';
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