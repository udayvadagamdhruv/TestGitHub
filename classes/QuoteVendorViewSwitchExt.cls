public with sharing class QuoteVendorViewSwitchExt{
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
   
   
    public string QuoteVenId{get;set;}
    public Vendor_Quote__c Qus{get;set;}
    
    public QuoteVendorViewSwitchExt(ApexPages.StandardController controller) 
    {
        QuoteVenId= controller.getRecord().id;
        
        Qus=[select id,name,Quote__c from Vendor_Quote__c where id=:QuoteVenId];
        
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