public with sharing class DeleteSpecItemUndertheEstLIExt {

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
            
   // Global variables
      public Id EstLIId ;
      private final Estimate_Spec_Item__c  objspec; 
   // End Global variables
   
   // Start Constructor   
    public DeleteSpecItemUndertheEstLIExt(ApexPages.StandardController controller) 
    {
       this.objspec=(Estimate_Spec_Item__c)controller.getrecord();
       EstLIId = [Select Id, Estimates__c from Estimate_Spec_Item__c where Id =:objspec.Id limit 1].Estimates__c;
    }
    // End Constructor
    
     public PageReference checkDelete()
     {
        try
        {
            Database.delete(objspec);        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/EstimatedetailpageLightning?id='+EstLIId+'&section=estimatespecitems');
             p.setRedirect(true);
             return p; 
        }
        else
        {
            PageReference p = new Pagereference('/apex/Estimatedetailpage?id='+EstLIId);
            p.setRedirect(true);
            return p;
        }
        
      
     }


   
}