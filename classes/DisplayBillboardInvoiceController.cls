public with sharing class DisplayBillboardInvoiceController {

    /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
     
        String theid;
        public List<Billboard_Invoice__c> BBI{get;set;} 
        public String strBBI{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayBillboardInvoiceController () 
        {
             theid= ApexPages.CurrentPage().getParameters().get('id');
             BBI=[select id,Name,BB_Invoice_Due_Date__c,Billboard_Vendor__c,Location__c,Billboard__c from Billboard_Invoice__c where Billboard__c =: theid];
        }
        // End Const

        
         
        // THis methos is called on to Create Billboard Contract
       public PageReference createBBI()
       {
             PageReference p;   
             if(isLtng)
             {
                p = Page.CreateBillboardInvoiceLightning;
             }
            
             else
             {
               p = Page.CreateBillboardInvoice;
             }
            
          //  PageReference p =  Page.CreateBillboardInvoice;
            p.setRedirect(true);
            p.getParameters().put('bbid',theid);
            return p;
        }
        // End method 
        
        
         // This method is called on to handle delete Billboard Contract
         public pagereference deleteBBI()
         {
             Billboard_Invoice__c objBBI=[Select id,Billboard__c from Billboard_Invoice__c where id=:strBBI];
               Id BID=objBBI.Billboard__c ;
               
             if(Billboard_Invoice__c.sObjectType.getDescribe().isDeletable()){
                 Database.Delete(objBBI);
             }
          
           
               // After deletion, navigate to BB Detail Page
               
                PageReference p;   
               if(isLtng)
               {
                  p = new Pagereference('/apex/BillboardDetailPageLightning?id='+BID+'&section=BBI');
               }
            
               else
               {
                   p = new Pagereference('/apex/BillboardDetailPage?id='+BID);
               }
             
               
               
          //     Pagereference p=new Pagereference('/apex/BillboardDetailPage?id='+BID);
               p.setRedirect(true);
               return p;
         }
         // End of method deleteBBC        
         */
            
}