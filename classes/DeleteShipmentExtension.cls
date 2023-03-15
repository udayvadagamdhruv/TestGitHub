public with sharing class DeleteShipmentExtension {

    /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
            
       
    public Id JobId;
    private final Shipment__c objShp; 
    // End of Global variables
    
    // Start Constructor 
    public DeleteShipmentExtension (ApexPages.StandardController controller) 
    {
       this.objShp=(Shipment__c)controller.getrecord();
       JobId = [Select Id, Job__c from Shipment__c where Id =:objShp.Id limit 1].Job__c;
    }
    // End Constructor 

    // Method called on to Delete Estimate Line Item
     public PageReference checkDelete()
     {
        try
        {
            if(Shipment__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objShp);  
            }   
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deleting PEstimate Line Item navigate to PEstimates Tab
        
         PageReference p;
        if(isLtng)
        {
             p = new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&tab=Jobcost'+'&section=shipment');
        }
        else
        {
              p = new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=16');
        }
        
      //  PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=14');
        p.setRedirect(true);
        return p;
     }
     // End Delete Method
*/



}