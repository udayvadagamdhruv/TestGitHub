public with sharing class editcampaigntemplateExt 
{
      // Global Variables
     /*     private final Campaign_Template__c objCT;
          
           public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string CmpTempprefix {set;get;}
          
      // End of Global Variables
    
    // Standard Controller Constructor
    public editcampaigntemplateExt (ApexPages.StandardController controller) 
    {
         this.objCT=(Campaign_Template__c)controller.getrecord();
         
          CmpTempprefix = Campaign_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor

    // Method Called on to Update Media Type
     Public PageReference saveme()
    {
        try
        {
            update objCT;
            System.debug('CT updated successfully@@@ '+objCT);
        }
        catch(System.DMLException e) { return null;}
    
        PageReference p;   
             if(isLtng)
             {
                p =  new Pagereference('/'+CmpTempprefix +'/o');
             }
            
            else
             {
               p =  new Pagereference('/apex/AdminListView?intFocus=15');
             }
       
     //   PageReference p =  new Pagereference('/apex/AdminListView?intFocus=15');
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
                p =  new Pagereference('/'+CmpTempprefix +'/o');
             }
            
            else
             {
               p =  new Pagereference('/apex/AdminListView?intFocus=15');
             }
               p.setRedirect(true);
               return p; 
             
      }*/
    //End of cancel method
}