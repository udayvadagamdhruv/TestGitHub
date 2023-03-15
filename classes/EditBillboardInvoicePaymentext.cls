public with sharing class EditBillboardInvoicePaymentext {

 /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
   
   
   private final BB_Invoice_Payment__c objBBILI;
   public String BBIID{get;set;}
   public String BillboardInvoicename{get;set;}  
   public BB_Invoice_Payment__c objBBILI1{get;set;}
   
   
   
     // End of Global variables 

    // Standard Controller Constructor
    public EditBillboardInvoicePaymentext (ApexPages.StandardController con) 
    {
        this.objBBILI=(BB_Invoice_Payment__c )con.getRecord();
        
        
        objBBILI1= [select id,Name,Check_New__c,Check_Amount__c,Billboard_Invoice__r.name,Check_Date__c ,Vendor__c,Billboard_Invoice__c from BB_Invoice_Payment__c WHERE id =:objBBILI.id];
        BillboardInvoicename=objBBILI1.Billboard_Invoice__r.name;
        BBIID=objBBILI1.Billboard_Invoice__c;
        
    }
    // End of Standard Controller Constructor 
    
    
    
    
    // Save Method
        public PageReference saveme() 
        {         
                try
                {
                    
                    
                    update objBBILI;
                    
                }
                catch(DMLException e)
                {
                    return null;
                }
                    
                 PageReference p;   
                 if(isLtng)
                 {
                    p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+BBIID+'&section=BBLP');
                 }
                
                else
                 {
                   p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
                 }  
                    
                    
                    
               //  PageReference pageRef = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
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
                p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+BBIID+'&section=BBLP');
             }
            
            else
             {
               p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
             }
                 
           // PageReference p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
            p.setRedirect(true);
            return p;   
                    
         }
        // Cancel Method     
    */
    
}