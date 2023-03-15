public with sharing class CreateBillboardInvoicePaymentExt {

  /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    private final BB_Invoice_Payment__c bbili;
    public String bbiid{get;set;}
    public String BillboardInvoicename{get;set;}
   
    // Start Constructor
    public CreateBillboardInvoicePaymentExt(ApexPages.StandardController controller) {
    
        this.bbili=(BB_Invoice_Payment__c)controller.getRecord();
        bbiid=ApexPages.CurrentPage().getParameters().get('bbiid');
        Billboard_Invoice__c objBBI=[Select id,name from Billboard_Invoice__c where id=:bbiid];
        BillboardInvoicename=objBBI.Name;
        bbili.Billboard_Invoice__c = bbiid;
        
    }
    
      
      // Save Method
        public PageReference saveme() 
        { 
                try
                {
                    insert bbili;
                }
                catch(DMLException e)
                {
                    return null;
                }
                    
                
                 PageReference p;   
                 if(isLtng)
                 {
                    p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+bbiid+'&section=BBLP');
                 }
                
                else
                 {
                   p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
                 }
                
                
                // PageReference pageRef = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
                  p.setRedirect(true);
                  return p;
                 
        }
            // End of Save Method

        // Cancel Method
        Public PageReference cancelme()
        {    
                
             PageReference p;   
             if(isLtng)
             {
                p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+bbiid+'&section=BBLP');
             }
            
            else
             {
               p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
             }
                
                   
            //PageReference p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
            p.setRedirect(true);
            return p;   
            
       }
        // Cancel Method        
        
*/
}