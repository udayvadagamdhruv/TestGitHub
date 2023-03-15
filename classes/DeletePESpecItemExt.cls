public with sharing class DeletePESpecItemExt
{
    // Start Global variables
   /* 
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    public Id JobId;
    private final Production_Estimate_Temp_Line_Items__c objSI;
    // End of Global variables
    
    // Start Constructor
    public DeletePESpecItemExt(ApexPages.StandardController con) 
    {
        this.objSI=(Production_Estimate_Temp_Line_Items__c)con.getrecord();
        JobId = [Select Id, Production_Estimate_Template__c  from Production_Estimate_Temp_Line_Items__c where Id =:objSI.Id limit 1].Production_Estimate_Template__c;
    }
    // End of Constructor
    
    // This method is called on to delete Spec Item    
     public PageReference checkDelete()
     {
        try
        {
            if(Production_Estimate_Temp_Line_Items__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objSI); 
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deletion of Spec Item, navigate to Specification Detail Page
        
        
        
          PageReference p;
            if(isLtng)
            {
                 p = new Pagereference('/apex/PETempDetailpageLightning?id='+JobId);
            }
            else
            {
                  p = new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+JobId);
            }
        
        
        
      //   PageReference p =  new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+JobId);
         p.setRedirect(true);
         return p;
     }*/
     // End of delete method
}