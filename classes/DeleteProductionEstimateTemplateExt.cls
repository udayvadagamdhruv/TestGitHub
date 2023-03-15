public with sharing class DeleteProductionEstimateTemplateExt{

    // Global Variables
   /* 
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string PETempprefix {set;get;}
    
    private final Production_Estimate_Template__c objIAT;
    public Boolean isError{get;set;}
    // End of Global Variables 
    
    // Standard Controller Constructor 
    public DeleteProductionEstimateTemplateExt(ApexPages.StandardController con) 
    {
        isError = False;
        this.objIAT=(Production_Estimate_Template__c)con.getrecord();
        PETempprefix = Production_Estimate_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor 
    
    // Method called on to Delete 
     public PageReference checkDelete()
     {
        try
        {
            if(Production_Estimate_Template__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objIAT);  
            }
        }
        catch(System.DMLException e)
        {
           isError = True;
           return null;
        }
        
        
         PageReference p;   
             if(isLtng)
             {
                p =  new Pagereference('/'+PETempprefix+'/o');
             }
            
            else
             {
               p = new Pagereference('/apex/AdminListView?intFocus=13');
             }
               p.setRedirect(true);
               return p; 
        

     /*   PageReference p =  new Pagereference('/apex/AdminListView?intFocus=13');
        p.setRedirect(true);
        return p;*/
   //  }
     // End of Delete Method

}