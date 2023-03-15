public with sharing class QuoteSpecViewSwitchExt{
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
   
   
    public string QuoteSpecId{get;set;}
    public Quote_Spec_Item__c Qus{get;set;}
    
    public QuoteSpecViewSwitchExt(ApexPages.StandardController controller) 
    {
        QuoteSpecId= controller.getRecord().id;
        
        Qus=[select id,name,Quote__c from Quote_Spec_Item__c where id=:QuoteSpecId];
        
    }
    
    Public PageReference pagedir()
    {
         String Quoteid;
         Quoteid =  Qus.Quote__c;
         if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+Quoteid);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+Quoteid);
                p.setRedirect(true);
                return p;
        } 
    }
    

}