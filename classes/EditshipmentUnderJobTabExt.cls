public with sharing class EditshipmentUnderJobTabExt{
   
   /*
   // Global Variables
   
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    } 
   
    private final Shipment__c objSp;
    Public string strid;
     
    public Shipment__c objsp1{get;set;}
    public String  ClientName,JobName;
    
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
     public String getJobName() { return JobName; }
    public void setJobName(String s) {  this.JobName= s; }
    
     public Id jobId{get;set;}
    
    // End of Global variables 

    // Standard Controller Constructor
    public EditshipmentUnderJobTabExt(ApexPages.StandardController con) 
    {
       this.objSp=(Shipment__c)con.getrecord();
       
         jobId = ApexPages.currentPage().getParameters().get('jobId');
        
           Job__c objJob=[Select id,name,JS_Client__r.name,Job_Auto_Number__c  from Job__c where id=:jobId ];
           JobName=objJob.id;
           objSp.Job__c = jobid;
       
       
     /*   objsp1 = [SELECT id, name,Client__c,job__c FROM Shipment__c WHERE id =: objSp.id];
        
        strid=objsp1.id;
        
        String st1 = objSp1.job__c ;
        
        system.debug('st2 -----> ' + st1);
        
        
        if(String.isNotBlank(st1))
        {
            job__c c=[Select id,Name from job__c where id=: st1];
            jobName= c.id; 
        }*/
        
        
       
       
  //  }
    // End of Standard Controller Constructor 
    
    
    /*public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c c : [SELECT Id, name FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name));  
        }
        return optionList;  
    }*/

/*
    public List<selectOption> getjobs() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (job__c c : [SELECT Id, name FROM job__c where status__c!='completed' order by Name]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name));  
        }
        return optionList;  
    }
    
   
    // Method called on to Update Vendor */ 
  /*Public PageReference saveme()
    {
        try
        {
              if(schema.SobjectType.Shipment__c.Fields.job__c.isUpdateable()){ objSp.job__c=JobName;}
                if(Schema.sObjectType.Shipment__c.isUpdateable()){ update objSp;}
            
        }
        catch(System.DMLException e)
        {
            return null;
        }
         
           PageReference p;
            if(isLtng)
            {
                p = new Pagereference('/apex/JobdetailpageLightening07?id='+JobName+'&tab=Jobcost'+'&section=shipment'); 
            }
            else
            {
                p =  new Pagereference('/apex/JobListView?id='+JobName+'&intFocus=16'); 
            }
                  
              
            p.setRedirect(true);
            return p;   
    }  
    // End of Method Update Vendor 
  
    // Method called on to handle Cancel button 
    Public PageReference cancelme()
    {
        PageReference p;
            if(isLtng)
            {
                p = new Pagereference('/apex/JobdetailpageLightening07?id='+JobName+'&tab=Jobcost'+'&section=shipment'); 
            }
            else
            {
                p =  new Pagereference('/apex/JobListView?id='+JobName+'&intFocus=16'); 
            }
                  
              
            p.setRedirect(true);
            return p;   
    } 
*/
}