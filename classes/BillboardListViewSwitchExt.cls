public with sharing class BillboardListViewSwitchExt {

  /*  public boolean isLtng{get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          } set;
            }  
   
   
    public string BBINVid{get;set;}
    public Billboard_Invoice__c BBINV{get;set;}
  
    public BillboardListViewSwitchExt (ApexPages.StandardController controller) {
          BBINVid= controller.getRecord().id;
        
        BBINV=[select id,name,Billboard__c from Billboard_Invoice__c where id=:BBINVid];
    }
    
    Public PageReference pagedir()
    {
         String BBid;
         BBid = BBINV.Billboard__c;
        PageReference p;
        if(isLtng)
        {
              p =  new Pagereference('/apex/BillboardDetailPageLightning?id='+BBid);
           
        }
        else
        {
              p =  new Pagereference('/apex/BillboardDetailPage?id='+BBid);
                
        } 
          p.setRedirect(true);
          return p; 
    }*/


}