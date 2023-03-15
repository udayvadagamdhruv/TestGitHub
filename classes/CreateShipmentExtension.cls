public with sharing class CreateShipmentExtension {

  /*  @testVisible   public boolean isLtng{set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    } 
    
  private final Shipment__c SP;
    public String ClientName,shipid,JobName;
  //  public String getClientName() { return JobName; }
  //  public void setClientName(String s) {  this.JobName= s; }
    public String getJobName() { return JobName; }
    public void setJobName(String s) {  this.JobName= s; }
  
   // Start of Constructor
    public CreateShipmentExtension (ApexPages.StandardController controller) 
     {
         this.SP=(Shipment__c)controller.getRecord();
        
     }
   // End of Constructor 
   
  /*  public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c c : [SELECT Id, name FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name));  
        }
        return optionList;  
    }   
    
    
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
        
      // Save Method
        public PageReference saveme(){ 
                 
                 try{
                       // sp.Client__c=ClientName;
                         if (Schema.sObjectType.Shipment__c.fields.job__c.isCreateable()) {
                             sp.job__c=JobName;}
                     if(Schema.sObjectType.Shipment__c.isCreateable()){ insert SP;}
                        shipid=sp.id;
                        
                    }
                    catch(DMLException e)
                    {
                        system.debug('error'+e.getMessage());
                        return null;
                    }
                    
                   PageReference pageRef ;
                    if(isLtng)
                    {
                         pageRef  = new PageReference('/apex/ShipmentDetailPageLightning?id='+shipid);
                    }
                    else
                    {
                          pageRef  = new PageReference('/apex/ShipmentDetailPage?id='+shipid);
                    } 
                    
                    
               //  PageReference pageRef = new PageReference('/apex/ShipmentDetailPage?id='+shipid);
                  pageRef.setRedirect(true);
                  return pageRef;
                  
                 }
            // End of Save Method

        // Cancel Method
        Public PageReference cancelme()
                {       
                    PageReference p = new PageReference('/apex/ShipmentTabOverride');
                    p.setRedirect(true);
                    return p;   
                    
                    
                    //return null;
                  }
        // Cancel Method         
 */

}