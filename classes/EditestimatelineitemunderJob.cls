public with sharing class EditestimatelineitemunderJob {

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    
    
    // Global variables
    private final Estimate_Spec_Item__c objESI;
    public Id EstLIId{get;set;}
    // End of Global variables

    // Start Constructor
    public EditestimatelineitemunderJob (ApexPages.StandardController controller) 
    {
        this.objESI = (Estimate_Spec_Item__c)controller.getRecord(); 
      
    }
    // End of Constructor
    
    // Method to update Estimate Line Item 
    Public PageReference saveme()
     {
        String strid;
        strid = objESI.Estimates__c;
         PageReference p;
        try
        {
            update objESI;
        }
        catch(System.DMLException e)
        {
            return null;
        } 
        
        
        if(isLtng)
        {
              p = new Pagereference('/apex/EstimatedetailpageLightning?id='+strid+'&section=estimatespecitems');
        }
        else
        {
              p =  new Pagereference('/apex/estimatedetailpage?id='+strid);
              
        }
         p.setRedirect(true);                return p;
       
     }
    // End of saveme method
     
     
     Public PageReference cancelme()
     {
     
        String strid;
        strid = objESI.Estimates__c;
        PageReference p; 
        if(isLtng)
        {
              p = new Pagereference('/apex/EstimatedetailpageLightning?id='+strid+'&section=estimatespecitems');
             
        }
        else
        {
             p =  new Pagereference('/apex/estimatedetailpage?id='+strid);
               
        }
        p.setRedirect(true);     return p; 
     }
     
}