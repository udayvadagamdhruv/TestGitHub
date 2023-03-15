public with sharing class CampaignStatusReportController {


    Public Transient list<Job__c> joblist{get;set;}
    public Transient List<JobWrapper>  JW;
    public Transient List<CampaignNameWrapper>  CNWrapper{get;set;}
    
    public Transient  CampaignNameWrapper tmpCNWrapper;
    
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
     
    
    Public CampaignStatusReportController (){
         
         // Code to display Subsriber Organization Logo
          
          // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
         
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
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

        // End of code to display Subscriber Organization Logo
    
         CNWrapper = new List<CampaignNameWrapper>();
         JW= new List<JobWrapper>();
        

          joblist=[select id,name,(select id,name,Revised_Due_Date__c,Completion_Date__c,Due_Date__c,Job__c from Job_Task__r),(select id,name,Description__c ,Job__c from Job_Specs__r),(Select id,name,Role__c,Staff__c from Job_Team__r),Job_Auto_Number__c,Campaign__c,Due_Date__c,Status_Notes__c,Status__c,Campaign__r.name,Creative_Overview__c from Job__c where Status__c='active' and Campaign__c!=null WITH SECURITY_ENFORCED order by Campaign__r.name,Due_Date__c,name];
          Set<string> JobIds = new Set<string>();
         
          
          for(Job__c aa : joblist)
          {
          system.debug('JObName first'+aa.Name);
          
          if(aa.Job_Specs__r.size()>0 || aa.Job_Team__r.size()>0 || aa.Job_Task__r.size()>0 ){
              JobIds.add(aa.id);
          }  
          
        }
        //get the list of job Spec  for every job;
        List<Job_Spec__c > jSpec = [select id,Name,Description__c ,Job__c,Job__r.name from Job_Spec__c where Job__c =: JobIds WITH SECURITY_ENFORCED];   
         
         Map <Id, List <Job_Spec__c >> mapJSpec = new Map<Id, List <Job_Spec__c >>();
         
         
         
           //get the job Spec for the job
         
           for(Job_Spec__c  js:jSpec)
            {
              if(mapJSpec.containsKey(js.Job__r.id))
               {
                  List <Job_Spec__c > jSpeclist =  mapJSpec.get(js.Job__r.id);
                  jSpeclist .add(js);
                  mapJSpec.put(js.Job__r.id,jSpeclist );  
                }
                else
                {
                  mapJSpec.put(js.Job__r.id , new List<Job_Spec__c >{js}) ;
                }        
           
           }
           
           
           //get the list of job Team  for every job;
        List<Job_Team__c > jTeam = [Select id,name,Role__c,staff__c,Job__r.name  from Job_Team__c where Job__c =: JobIds WITH SECURITY_ENFORCED];   
         
         Map <Id, List <Job_Team__c >> mapJTeam = new Map<Id, List <Job_Team__c >>();
         
           
           
           //get the job Team for the job
         
           for(Job_Team__c  jT:jTeam )
            {
              if(mapJTeam.containsKey(jT.Job__r.id))
               {
                  List <Job_Team__c > jTeamlist =  mapJTeam.get(jT.Job__r.id);
                  jTeamlist .add(jT);
                  mapJTeam.put(jT.Job__r.id,jTeamlist );  
                }
                else
                {
                  mapJTeam.put(jT.Job__r.id , new List<Job_Team__c >{jT}) ;
                }        
           
           }
           
           
            //get the list of first letters first Name and Last name for every job;
          Map<Id,list<String>> STmap = new Map<Id, List<string>>();
            for(Job__c obj : joblist)
            {              
                if(obj.Job_Team__r.size()>0)
                {
                    List<string> stName = new List<string>();
                    List<Job_Team__c> lst1 = mapJTeam.get(obj.Id);
                    for(Job_Team__c objT:lst1)
                    {
                       if(objT.Staff__c != null) 
                          {
                            string tName= objT.Role__c +'('+ ((objT.Staff__c).substringBefore(' ')).left(1)+((objT.Staff__c).substringAfter(' ')).left(1)+')';
                            stName.add(tName);
                          }
                    }
                    STmap.put(obj.Id,stName);
                }
            
            }
           
           
           
           
           
           
            //get the list of job Scedule Tasks  for every job;
        List<Job_Task__c > jSTask = [select id,name,Revised_Due_Date__c,Completion_Date__c,Job__r.name,Due_Date__c,Job__c from Job_Task__c where Job__c =: JobIds WITH SECURITY_ENFORCED];   
         
         Map <Id, List <Job_Task__c >> mapJSTask = new Map<Id, List <Job_Task__c >>();
         
           
           
           //get the job Scedule Tasks for the job
         
           for(Job_Task__c  jST:jSTask  )
            {
              if(mapJSTask.containsKey(jST.Job__r.id))
               {
                  List <Job_Task__c> jStasklist =  mapJSTask.get(jST.Job__r.id);
                  jStasklist .add(jST);
                  mapJSTask.put(jST.Job__r.id,jStasklist );  
                }
                else
                {
                  mapJSTask.put(jST.Job__r.id , new List<Job_Task__c> {jST}) ;
                }        
           
           }
           
           
           
           
           string strCampaignNameNew;
           
          for(Job__c aa:joblist)
         {
           if (strCampaignNameNew!= aa.Campaign__r.Name)
            {
            
            
               
                 if (strCampaignNameNew!= null)
               {     
               
                    system.debug('JW::::'+JW);                           
                    tmpCNWrapper.jWrapper= JW;
                    CNWrapper.add(tmpCNWrapper);
                    
                    system.debug('cWrapper :::::::::'+CNWrapper);                                                                      
               }  
                
                  
               tmpCNWrapper= new CampaignNameWrapper();     
                    
                
                tmpCNWrapper.strCampaignName = strCampaignNameNew= aa.Campaign__r.Name ;
                
               
               JW = new List<JobWrapper>();
                
            }   
           
            JobWrapper objWrapper = new JobWrapper();
            objWrapper.job = aa;              
            
            objWrapper.jobTeams= STmap.get(aa.id);
            objWrapper.jobSpecs= mapJSpec.get(aa.id);
            objWrapper.jobStasks=mapJSTask.get(aa.id);
            
            JW.add(objWrapper); 
        }
       if (strCampaignNameNew!= null){
           
                    tmpCNWrapper.jWrapper= JW;
                    CNWrapper.add(tmpCNWrapper);
                   system.debug('cWrapper :::::::::'+CNWrapper);
                    
       }
          
     }

    public class CampaignNameWrapper
    {
       public List<JobWrapper> jWrapper{get;set;}
       public string strCampaignName {get;set;} 
        public CampaignNameWrapper()
        {
          if(jWrapper== NULL) {jWrapper= new List<JobWrapper>();}
        }
     }
    
     

     public class JobWrapper
        {              
           public Job__c job {get;set;}
           public List<string> jobTeams{get;set;}
           public List<Job_Task__c> jobStasks{get;set;}
           
           public List<Job_Spec__c> jobSpecs{get;set;}
           public JobWrapper()
            {
                 
            }


   }


}