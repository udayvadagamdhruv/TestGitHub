public with sharing class DeleteProductionEstimateExtension {

   // Global variables
   
 /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
            
            
    public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
    public Id JobId;
    private final Production_Estimate__c objELI; 
    // End of Global variables
    
    // Start Constructor 
    public DeleteProductionEstimateExtension (ApexPages.StandardController controller) 
    {
       this.objELI=(Production_Estimate__c)controller.getrecord();
       JobId = [Select Id, Job__c from Production_Estimate__c where Id =:objELI.Id limit 1].Job__c;
    }
    // End Constructor 

    // Method called on to Delete Estimate Line Item
     public PageReference checkDelete()
     {
        try
        {
             if(Production_Estimate__c.sObjectType.getDescribe().isDeletable()){
                 Database.delete(objELI); 
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
             p = new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&tab=Jobcost'+'&section=PE');
        }
        else
        {
              p = new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=14');
        }
        
      //  PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=14');
        p.setRedirect(true);
        return p;
     }*/
     // End Delete Method

}