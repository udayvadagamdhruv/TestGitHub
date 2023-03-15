public with sharing class EditInvAllocationTempExt {

  /* // Global Variables
          private final Invoice_Allocation_Template__c objIAT;
          
           public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string InvTempprefix {set;get;}
          
      // End of Global Variables
    
    // Standard Controller Constructor
    public EditInvAllocationTempExt (ApexPages.StandardController controller) 
    {
         this.objIAT=(Invoice_Allocation_Template__c)controller.getrecord();
         
          InvTempprefix = Invoice_Allocation_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor

    // Method Called on to Update Media Type
     Public PageReference saveme()
    {
        try
        {
            update objIAT;
            System.debug('Media Type updated successfully@@@ '+objIAT);
        }
        catch(System.DMLException e) { return null;}
    
        PageReference p;   
             if(isLtng)
             {
                p =  new Pagereference('/'+InvTempprefix+'/o');
             }
            
            else
             {
               p =  new Pagereference('/apex/AdminListView?intFocus=12');
             }
       
     //   PageReference p =  new Pagereference('/apex/AdminListView?intFocus=12');
        p.setRedirect(true);
        return p;
    }
    // End of Method Update Media Type
    
    //Cancel Method
      public PageReference cancelme()
      {
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
    //End of cancel method*/

}