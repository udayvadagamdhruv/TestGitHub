global class CalendarExample_Controller {
 
  /*  public Boolean includeMyJobs {get;set;}
    public list<calEvent> events {get;set;}
    Public String strCampaignName{get;set;}
    Public string strClientName{get;set;}
    Public string StatusString {get;set;}
    Public string JobStatusString {get;set;}
    Public list<Campaign__c> camplist{get;set;}
    Public list<Job__C> joblist{get;set;}
    Public list<Job__C> joblistcal{get;set;}
    Public string  soql{get;set;}
    Public string  soqlJob{get;set;}
    Public string  soqlJobcal{get;set;}
    Public map<integer,string> colormap{get;set;}
    public boolean Jscampaign{get;set;}
    public boolean Jobs{get;set;}
     
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
     
    //constructor
    public CalendarExample_Controller() 
    {
    
        colormap=new map<integer,string>();
        
        includeMyJobs = false;
    }
    
    // This method is used to retrieve all Campaigns into dropdown list
     public List<selectOption> getCampaigns() 
     {    
         
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Campaign__c  a : [SELECT Id, name FROM Campaign__c order by Name]) 
          {  
            optionList.add(new selectOption(a.name, a.Name ));    
          }
          return optionList;  
     }   
     // End of method getCampaigns
     
    // This method is used to retrieve all Clients into dropdown list
    public List<selectOption> getClients() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Client__c a : [SELECT Id, name,Client_Code__c FROM Client__c order by Name]) 
          {  
            optionList.add(new selectOption(a.name, a.Name ));    
          }
          return optionList;  
     }   
     // End of method getClients
    
    // This method is used to get Campaign Status Picklist values 
    public List<SelectOption> getCampStatus()
    {
        List<SelectOption> CampstatusoptionList = new List<selectOption>();
       
        for(schema.picklistEntry p : Campaign__c.Status__c.getDescribe().getPicklistValues())
        {
               CampstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return CampstatusoptionList;
    } 
    
    
    // This method is used to get JobStatus picklist Values
    public List<SelectOption> getjobStatus()
    {
        List<SelectOption> jobstatusoptionList = new List<selectOption>();
       
        for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues())
        {
               jobstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return jobstatusoptionList;
    } 
    
    
     
    public PageReference JSCampaignRender() 
    {
         Jscampaign=true;
         Jobs=false;
         return null;
    }
    
    public PageReference JobRender() 
    {
         Jscampaign=false;
         Jobs=true;
         return null;
    }
     
    public PageReference JSCampaign() 
    {
         
        events = new list<calEvent>();
          
        camplist= new List<Campaign__c>();
      
        soql='select Id, Name, Start_Date__c, End_Date__c from Campaign__c where Name!=null and Start_Date__c!=null and End_Date__c!=null';
       
        if(StatusString!=Null)
            soql +=' And Status__c =:StatusString';
            
        if(strCampaignName!=Null)
            soql +=' And name =:strCampaignName';
            
        camplist=Database.query(soql);
      
        //Get Campaigns
        for(Campaign__c camp : camplist)
        {
            DateTime startDT = camp.Start_Date__c+1;
            DateTime endDT = camp.End_Date__c+2;
          
            calEvent campEvent = new calEvent();
             
            campEvent.title = 'campaign'+' : '+camp.Name;
            campEvent.allDay = True;
            campEvent.startString = startDT.format(dtFormat);
            campEvent.endString = endDT.format(dtFormat);
            campEvent.url = '/' + camp.Id;
            campEvent.className = 'event-JSCampaign';
            events.add(campEvent);
        }
       
        
      if(includeMyJobs)
      {
      
             colormap.put(0,'#00FFFF');colormap.put(1,'#008080');colormap.put(2,'#3104B4');colormap.put(3,'#0B3B39');colormap.put(4,'#4B0082');colormap.put(5,'#6A5ACD');colormap.put(6,'#6B8E23');colormap.put(7,'#708090');colormap.put(8,'#800000');colormap.put(9,'#800080');
             colormap.put(10,'##808000');colormap.put(11,'#002147');colormap.put(12,'#9FA91F');colormap.put(13,'#C71585');colormap.put(14,'#DA70D6');colormap.put(15,'#006400');colormap.put(16,'#FF8C00');colormap.put(17,'#4B0082');colormap.put(18,'#808000');colormap.put(19,'#D8BFD8');
             colormap.put(20,'##FF6347');colormap.put(21,'#FAFAD2');colormap.put(22,'#2E8B57');colormap.put(23,'#008B8B');colormap.put(24,'#3399FF');
              
             joblist= new List<Job__c>();
          
             soqlJob='select Id, Name, Job_Auto_Number__c,Start_Date__c,Due_Date__c from Job__c where Start_Date__c != null and Due_Date__c != null';
           
             if(strCampaignName!=Null)
                soqlJob+=' And Campaign__r.name=:strCampaignName';
                
             joblist=Database.query(soqlJob);
             integer i=0;
             
             for(Job__c Jo : joblist)
             {
                DateTime startDT = Jo.Start_Date__c+1;
                DateTime endDT = Jo.Due_Date__c+2 ;
              
                calEvent campEvent = new calEvent();
                 
                campEvent.title = 'Job :'+' '+Jo.Name +' #'+Jo.Job_Auto_Number__c;
                campEvent.allDay = True;
                campEvent.startString = startDT.format(dtFormat);
                campEvent.endString = endDT.format(dtFormat);
                campEvent.url = '/' + jo.Id;
                campEvent.color=colormap.get(i);
                campEvent.className = 'event-JSCampaign';
                events.add(campEvent);
                i++;
            }
      }
       
         return null;
    }
    
    
    //Get Jobs
    public PageReference Job() 
    {
         Jscampaign=false;
         Jobs=true;
        
         colormap.put(0,'#FE2E64');colormap.put(1,'#008080');colormap.put(2,'#00BFFF');colormap.put(3,'#00FA9A');colormap.put(4,'#4B0082');colormap.put(5,'#6A5ACD');colormap.put(6,'#6B8E23');colormap.put(7,'#708090');colormap.put(8,'#800000');colormap.put(9,'#800080');
         colormap.put(10,'##808000');colormap.put(11,'#87CEFA');colormap.put(12,'#90EE90');colormap.put(13,'#C71585');colormap.put(14,'#DA70D6');colormap.put(15,'#006400');colormap.put(16,'#FF8C00');colormap.put(17,'#4B0082');colormap.put(18,'#808000');colormap.put(19,'#D8BFD8');
         colormap.put(20,'##FF6347');colormap.put(21,'#FAFAD2');colormap.put(22,'#2E8B57');colormap.put(23,'#008B8B');colormap.put(24,'#3399FF');
                
         events = new list<calEvent>();
         
         
         joblistcal= new List<Job__c>();
          
             soqlJobcal='select Id, Name,Job_Auto_Number__c, Start_Date__c,Due_Date__c from Job__c where Start_Date__c != null and Due_Date__c != null';
           
             if(strCampaignName!=Null)
                soqlJobcal+=' And Campaign__r.name=:strCampaignName';
                
             if(JobStatusString !=Null)
                soqlJobcal+=' And Status__c =:JobStatusString ';
            
             if(strClientName !=Null)
               soqlJobcal+=' And JS_Client__r.name =:strClientName';  
                
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>'+strClientName); 
                
             joblistcal=Database.query(soqlJobcal);
         
         
         
         integer i=0;
        
         for(Job__c job: joblistcal)
         {
                DateTime startDT = job.Start_Date__c+1;
                DateTime endDT = job.Due_Date__c+2 ;
                
                    calEvent J= new calEvent();
                
                    J.title = 'Job :'+' '+Job.Name +' # :'+' '+Job.Job_Auto_Number__c;
                    J.allDay = true;
                    J.startString = startDT.format(dtFormat);
                    J.endString = endDT.format(dtFormat);
                    J.url = '/' + job.Id;
                    j.color=colormap.get(i);
                    J.className = 'event-Jobs';
                    events.add(J);
                    i++;  
        }
        
        return null;
    }
     
   public PageReference toggleMyJobs() 
   {
        if(includeMyJobs)
        {
            includeMyJobs = false;
        }
        else
        {
            includeMyJobs = true;
        }
        JSCampaign();
        
        return null;
    }
 
 
 @RemoteAction
    global static boolean updateJSCampaign(String name, String cntid, String endate, String stdate) 
    {
       
       list<Campaign__c> campList = new list<Campaign__c>();
       list<job__c> jobList = new  list<job__c>();
       String soqlcamp='select Id, Name, Start_Date__c, End_Date__c from Campaign__c where  Name!=null and Start_Date__c!=null and End_Date__c!=null';
       String soqlJob1='select Id, Name, Start_Date__c,Due_Date__c from Job__c where Start_Date__c != null and Due_Date__c != null';
       campList = Database.query(soqlcamp);
       jobList = Database.query(soqlJob1);
       String id1 = cntid.Substring(cntid.length()-18,cntid.length());
       String name2 = name.Substring(0,2);
      //contact con = new Contact();
          Campaign__c cam = new Campaign__c();
       String name1 = '%'+name2+'%';
       integer eyear = integer.valueof(endate.substring(0,4));
       integer emonth = integer.valueof(endate.substring(5,7));
      integer eday = integer.valueof(endate.substring(8,10));
      
      integer syear = integer.valueof(stdate.substring(0,4));
       integer smonth = integer.valueof(stdate.substring(5,7));
      integer sday = integer.valueof(stdate.substring(8,10));
     //  Date ed = Date.newInstance(eyear,emonth,eday-1);
      // Date sd = Date.newInstance(syear,smonth,sday-1);
       
      //if(name.Substring(name.length()-8,name.length()) == 'campaign' )
       if(name.Substring(0,8) == 'campaign')
       {
           Date ed = Date.newInstance(eyear,emonth,eday-1);
           Date sd = Date.newInstance(syear,smonth,sday);
           
           cam = [select Id, Name, Start_Date__c, End_Date__c from Campaign__c where id = :id1];
           if(schema.SobjectType.Campaign__c.Fields.End_Date__c.isUpdateable()){
               cam.End_Date__c = ed;
           }
           if(schema.SobjectType.Campaign__c.Fields.Start_Date__c.isUpdateable()){
               cam.Start_Date__c = sd;
           }
           //  upsert cam;
           
           
           if(Schema.sObjectType.Campaign__c.isUpdateable()){
               update cam; 
           }

           
           
         /*  cam.End_Date__c = ed;
           cam.Start_Date__c = sd;
           upsert cam;*/
      /* }
       else
       {
           Date ed = Date.newInstance(eyear,emonth,eday-1);
           Date sd = Date.newInstance(syear,smonth,sday);
       
           Job__c job = new Job__C();
           job = [select Id, Name, Job_Description__c,Start_Date__c,Due_Date__c from Job__c where id = :id1];
           
           if(schema.SobjectType.Job__c.Fields.Start_Date__c.isUpdateable()){
               job.Start_Date__c = sd;
           }
           if(schema.SobjectType.Job__c.Fields.Due_Date__c.isUpdateable() ){
               job.Due_Date__c = ed;
           }
           //  upsert job; 
           
           if(Schema.sObjectType.Job__c.isUpdateable()){
               update job; 
           }
            
           
          /* job.Start_Date__c = sd;
            job.Due_Date__c = ed;
            upsert job; */
      /* }
       
           return true;
       
    }
     
    //Class to hold calendar event data
    public class calEvent
    {
        public String title {get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public string color{get;set;}
        public String className {get;set;}
    }*/
}