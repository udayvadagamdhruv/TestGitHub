// This class is used to create Work Order for selected Campaign
public with sharing class CampaignWorkorderExt
{
    // Global variables  
    String Cmpid;
    public String Status{get;set;}
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public List<Document> lstDoc;
    public boolean imageNotFound{get;set;}
    public String queryString{get;set;}
    public List<Job__c> lstJob{get;set;} 
    //  public String lstStaff{get;set;} 
    public Map <Id, list <String>> FLNamemap{get;set;} 
    public List<Jobwrapper> jobWrapperList{get;set;}
    
    // public Map < Id, List <Job_Team__c>> mapTeam{get;set;}
    // End Global variables
    
    // Start Constructor
    public CampaignWorkorderExt(ApexPages.StandardController controller) 
    {
        // To display Subscriber Organization Logo
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1 ];
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
        
        Cmpid= ApexPages.currentpage().getParameters().get('id');
        Status= ApexPages.currentpage().getParameters().get('Status');
        jobWrapperList=new List<Jobwrapper>();
        
        lstJob=[Select Id,Name,(select Id from Job_Team__r),(select Id from Job_Task__r),Job_Auto_Number__c,Job_Description__c,Creative_Overview__c,Status__c,JS_Client__c,JS_Client__r.name,JS_Client_Contact__c,JS_Client_Contact__r.name from Job__c where Campaign__c=:Cmpid and Status__c = :Status WITH SECURITY_ENFORCED  ORDER BY JOB_Auto_NUmber__c desc  LIMIT 1000];
        Set<Id> JobIds = new Set<Id> ();
        Set<Id> JobIdsTsk = new Set<Id> ();
        
        for (Job__c aa: lstJob) 
        {
            system.debug('JObName first' + aa.Name);
            if (aa.Job_Task__r.size() == 0) 
            {
                JobIdsTsk.add(string.valueOf(aa.id).substring(0, 15));
                system.debug(aa.Name + ' .. Job Task Count...' + aa.Job_Task__r.size());
            }
            JobIdsTsk.add(aa.id);
            if (aa.Job_Team__r.size() > 0) 
            {
                JobIds.add(aa.id);
            }
        }
        
        //get the list of job Team for every job;
        List < Job_Team__c > jTeam = [select id, Name, Job__r.id, Staff__c, Role__c from Job_Team__c where Job__c = : JobIds WITH SECURITY_ENFORCED];
        
        Map <Id, List <Job_Team__c>> mapTeam = new Map < Id, List <Job_Team__c>> (); //job id and job team list
        
        //get the job team for the job
        
        for (Job_Team__c jt: jTeam) 
        {
            
            if (mapTeam.containsKey(jt.Job__r.id)) 
            {
                List <Job_Team__c> jTeamlist = mapTeam.get(jt.Job__r.id);
                jTeamlist.add(jt);
                mapTeam.put(jt.Job__r.id, jTeamlist);
            } 
            else 
            {
                mapTeam.put(jt.Job__r.id, new List <Job_Team__c> {jt});
            }
            
            system.debug('>>>>>>>>>>>>>mapTeam>>>>>>>>>>>>'+mapTeam);
        }
        
        //get the list of first letters first Name and Last name for every job;
        FLNamemap = new Map <Id, List <string>> ();
        for (Job__c obj: lstJob) 
        {
            if (obj.Job_Team__r.size() > 0) 
            {
                List <string> stName = new List <string> ();
                List <Job_Team__c> lst1 = mapTeam.get(obj.Id);
                for (Job_Team__c objT: lst1) 
                {
                    if (objT.Staff__c != null) 
                    {
                        string tName = ((objT.Staff__c).substringBefore(' ')).left(1) + ((objT.Staff__c).substringAfter(' ')).left(1);
                        stName.add(tName);
                        system.debug('>>>>>>>>>>>>>stName>>>>>>>>>>>>'+stName);
                    }
                }
                FLNamemap.put(obj.Id, stName);
                system.debug('>>>>>>>>>>>>>FLNamemap>>>>>>>>>>>>'+FLNamemap);
            }
            
        }
        
        Map < Id, List <Job_Task__c >> mapTask = new Map < Id, List <Job_Task__c >> (); //job id and job task list
        
        List<Job_Task__c > jobTasklist = [select id, Name,Revised_Due_Date__c,Job__r.Name, Job__r.id from Job_Task__c where Job__c = : JobIdsTsk WITH SECURITY_ENFORCED order by Task_Order__c];
        
        for (Job_Task__c tk: jobTasklist) 
        {
            if((tk.name == 'Internal Review')||(tk.name == 'Client Review')||(tk.name == 'Due Date'))
            {
                if (mapTask.containsKey(tk.Job__r.id)) 
                {
                    List <Job_Task__c> tasklist = mapTask.get(tk.Job__r.id);
                    tasklist.add(tk);
                    mapTask.put(tk.Job__r.id, tasklist);
                } 
                else 
                {
                    mapTask.put(tk.Job__r.id, new List <Job_Task__c > {tk});
                }
                system.debug('>>>>>>>>>>>>>mapTask>>>>>>>>>>>>'+mapTask);
            }
        }
        
        
        for (Job__c aa: lstJob) 
        {
            
            JobWrapper objWrapper = new JobWrapper();
            objWrapper.job = aa;
            objWrapper.jobTasks = mapTask.get(aa.id);
            if(FLNamemap.containsKey(aa.id) && FLNamemap.get(aa.id) != NULL){
                objWrapper.lstStaff =string.join(FLNamemap.get(aa.id),', ');
            }
            system.debug('Job Wrapper;;;;;' + objWrapper);
            jobWrapperList.add(objWrapper);
            
            // jobWrapperList.add(new Jobwrapper(obj,FLNamemap.containskey(obj.id)?string.join(FLNamemap.get(obj.id),', '):null,mapTask.containskey(obj.id)?mapTask.get(obj.id):null));
            // jobWrapperList.add(new Jobwrapper(obj,FLNamemap.containskey(obj.id)?string.join(FLNamemap.get(obj.id),', '):null,new list<Job_Task__c>()));
        }
        
        
    }
    // End Constructor 
    
    
    public class Jobwrapper
    {
        public Job__c job {get;set;}
        public string lstStaff {get;set;}
        public List < Job_Task__c > jobTasks {get;set;}
        public JobWrapper() 
        {
            /* this.job=job;
lstStaff=string.isNotBlank(JT)?JT:null;
if(!jTsk.isEmpty()){
jobTasks.addALL(jTsk);
}*/
        }
    }
}
// End of Class