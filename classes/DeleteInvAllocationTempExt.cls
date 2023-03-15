public with sharing class DeleteInvAllocationTempExt {

    // Global Variables
    
/*    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string InvTempprefix {set;get;}
    
    
    private final Invoice_Allocation_Template__c objIAT;
    public Boolean isError{get;set;}
    // End of Global Variables 
    
    // Standard Controller Constructor 
    public DeleteInvAllocationTempExt (ApexPages.StandardController con) 
    {
        isError = False;
        this.objIAT=(Invoice_Allocation_Template__c)con.getrecord();
        InvTempprefix = Invoice_Allocation_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor 
    
    // Method called on to Delete Media Type
     public PageReference checkDelete()
     {
        try
        {
            if(Invoice_Allocation_Template__c.sObjectType.getDescribe().isDeletable()){
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
              p =  new Pagereference('/'+InvTempprefix+'/o');
         }
         else
         {
             p =  new Pagereference('/apex/AdminListView?intFocus=12');
         }
         p.setRedirect(true);
         return p; 
     }
     // End of Delete Method*/

}