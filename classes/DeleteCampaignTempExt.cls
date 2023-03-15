public with sharing class DeleteCampaignTempExt {
     // Global Variables
/*    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string CmpTempprefix {set;get;}
    
    
    private final Campaign_Template__c objCT;
    public Boolean isError{get;set;}
    // End of Global Variables 
    
    // Standard Controller Constructor 
    public DeleteCampaignTempExt (ApexPages.StandardController con) 
    {
        isError = False;
        this.objCT=(Campaign_Template__c)con.getrecord();
        CmpTempprefix  = Campaign_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor 
    
    // Method called on to Delete Media Type
     public PageReference checkDelete()
     {
        try
        {
            if(Campaign_Template__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objCT); 
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
              p =  new Pagereference('/'+CmpTempprefix  +'/o');
         }
         else
         {
             p =  new Pagereference('/apex/AdminListView?intFocus=15');
         }
         p.setRedirect(true);
         return p; 
     }*/
     // End of Delete Method
}