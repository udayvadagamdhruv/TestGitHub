public with sharing class EditProductionEstimateTemplateExt {

   // Global Variables
   /*
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string PETempprefix {set;get;}
   
    private final Production_Estimate_Template__c objPET;
      // End of Global Variables
    
    // Standard Controller Constructor
    public EditProductionEstimateTemplateExt(ApexPages.StandardController controller) 
    {
         this.objPET=(Production_Estimate_Template__c )controller.getrecord();
         
         PETempprefix = Production_Estimate_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor

    // Method Called on to Update Media Type
     Public PageReference saveme()
    {
        try
        {
            update objPET;
            System.debug('Media Type updated successfully@@@ '+objPET);
        }
        catch(System.DMLException e) { return null;}
        
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
        
        
    
      /*  PageReference p =  new Pagereference('/apex/AdminListView?intFocus=13');
        p.setRedirect(true);
        return p;*/
   // }
    // End of Method Update Media Type
    
    //Cancel Method
     /* public PageReference cancelme()
      {
      
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
      
        /*  PageReference p =  new Pagereference('/apex/AdminListView?intFocus=13');
          p.setRedirect(true);
          return p; 
      }*/
    //End of cancel method

}