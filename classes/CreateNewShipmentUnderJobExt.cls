public with sharing class CreateNewShipmentUnderJobExt{

  /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
   
    private final Shipment__c SP;
    public String ClientName,shipid,JobName,jobn;
  //  public String getClientName() { return JobName; }
   // public void setClientName(String s) {  this.JobName= s; }
    public String getJobName() { return JobName; }
    public void setJobName(String s) {  this.JobName= s; }
     public String getjobn() { return jobn; }
    public void setjobn(String s) {  this.jobn= s; }
    public String jobid{get;set;}

  
   // Start of Constructor
    public CreateNewShipmentUnderJobExt(ApexPages.StandardController controller) 
     {
          this.SP=(Shipment__c)controller.getRecord();
          jobId = ApexPages.currentPage().getParameters().get('jobId');
        
           Job__c objJob=[Select id,name,JS_Client__r.name,Job_Auto_Number__c  from Job__c where id=:jobId ];
           JobName=objJob.id;
           jobn=objJob.name;
           SP.Job__c = jobid;
     
         
        
     }
   // End of Constructor 
   
 
    
    
    public List<selectOption> getjobs() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (job__c c : [SELECT Id, name FROM job__c where status__c!='completed' order by Name limit 1000]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name));  
        }
        return optionList;  
    }
        
      // Save Method
        public PageReference saveme()
        { 
                 
                 try{
                        if (Schema.sObjectType.Shipment__c.fields.job__c.isCreateable()) {
                            sp.job__c=JobName;}
                     if(Schema.sObjectType.Shipment__c.isCreateable()){insert SP;}
                        shipid=sp.id;
                        
                    }
                    catch(DMLException e)
                    {
                        return null;
                    }
                    
                    
                    
                    PageReference pageRef;
                    if(isLtng)
                    {
                         pageRef =  new Pagereference('/apex/ShipmentDetailPageLightning?id='+shipid); 
                    }
                    else
                    {
                        pageRef =  new Pagereference('/apex/ShipmentDetailPage?id='+shipid); 
                    }
                  
              
                  pageRef.setRedirect(true);
                  return pageRef;
                  
         }
            // End of Save Method

        // Cancel Method
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
        // Cancel Method         

*/
}