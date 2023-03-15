public with sharing class DeleteClientInvoiceExtension {
// Global variables   
    public Id JobId;
    private final Client_Invoice__c objCI; 
    // End of Global variables
    
    // Constructor
    public DeleteClientInvoiceExtension (ApexPages.StandardController controller) 
    {
        this.objCI=(Client_Invoice__c)controller.getrecord();
        JobId = [Select Id, Job__c from Client_Invoice__c where Id =:objCI.Id limit 1].Job__c;
    }
    // End of Constructor 
    
    // CheckDelete Method 
    public PageReference checkDelete()
     {
       try
        {
            Database.delete(objCI);        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deletion navigate to PO Tab
        
      /*  PageReference p =  new Pagereference('/apex/JobListViewSwitchPage?id='+Jobid+'&intFocus=13');
        p.setRedirect(true);
        return p;*/
        
         String th = userinfo.getUiTheme();
       PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&section=CLI');
       else
          p =  new Pagereference('/apex/JobListViewSwitchPage?id='+Jobid+'&intFocus=13');
       p.setRedirect(true);
       return p;
        
        
        
     }
    // End of CheckDelete Method 

}