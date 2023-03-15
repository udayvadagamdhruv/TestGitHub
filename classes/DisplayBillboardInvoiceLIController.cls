public with sharing class DisplayBillboardInvoiceLIController {
// Global variables 

      /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
        String theID;
        public List<Billboard_Invoice_Line_Item__c> BBILI{get;set;} 
        public id strBBILI{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayBillboardInvoiceLIController () 
        {
             theID = ApexPages.CurrentPage().getParameters().get('id');
             BBILI=[select id,Name,Amount__c,GL_Code_No__c,Unit_Type__c,Billboard_Invoice__c,GL_Department__c,GL_Code__c,Quantity__c from Billboard_Invoice_Line_Item__c where Billboard_Invoice__c=: theID ORDER BY Name];
        }
        // End Constructor
        
        Sobject sumCash; 
        Sobject sumQuant; 

   // This method is called on to calculate Total Allocation Amount of  Invoice Allocation Line Items
  /* public double getSumCash()
   { 
        sumCash = [SELECT SUM(Allocation_Amount__c) sum FROM Invoice_Allocation_Line_Item__c WHERE Client_Invoice__c =: [Select id from Client_Invoice__c where id =: theID]];   
        return double.valueOf(sumCash.get('sum')); 
    }  
    // End of method getSumCash
   // This method is called on to calculate Total Allocation Qty of  Invoice Allocation Line Items
   public Integer getSumQuant()
   { 
        sumQuant = [SELECT SUM(Allocation_Qty__c) sum FROM Invoice_Allocation_Line_Item__c WHERE Client_Invoice__c =: [Select id from Client_Invoice__c where id =: theID]];   
        return Integer.valueOf(sumQuant.get('sum')); 
    }  
    // End of method getsumQuant     
        
        
        
        // THis methos is called on to Create Invoice Allocation Line Item
        public PageReference createIALI()
        {
            PageReference p;   
             if(isLtng)
             {
                p =  Page.CreateBillboardInvoiceLILightning;
             }
            
             else
             {
                 p = Page.CreateBillboardInvoiceLI;
             }
            
            
            
          //  PageReference p =  Page.CreateBillboardInvoiceLI;
            p.setRedirect(true);
            p.getParameters().put('bbiid',theID);
            return p;
        }
        // End method 
        
         // This method is called on to handle Edit button
           public Pagereference EditBBIL()
           {
                  system.debug('BBILIEdit ' + strBBILI);
                 
                 PageReference p;   
                 if(isLtng)
                 {
                    p = new Pagereference('/apex/EditBillboardInvoiceLILightning?id='+strBBILI);
                 }
                
                 else
                 {
                     p = new Pagereference('/apex/EditBillboardInvoiceLI?id='+strBBILI);
                 }
                 
                 
                 
                //  Pagereference p=new Pagereference('/apex/EditBillboardInvoiceLI?id='+strBBILI);
                  p.setRedirect(true);
                  return p;
           }
   // End of Method Edit
        
        
        
        
        // This method is called on to handle delete Billboard Invoice Line Item
         public pagereference deleteIALI()
         {
            system.debug('BBILIDelete ' + strBBILI);
         
             Billboard_Invoice_Line_Item__c objBBILI=[Select id,Billboard_Invoice__c  from Billboard_Invoice_Line_Item__c where id=:strBBILI];
               Id BBIid=objBBILI.Billboard_Invoice__c;
               
             if(Billboard_Invoice_Line_Item__c.sObjectType.getDescribe().isDeletable()){
                 Database.Delete(objBBILI);
             }
          
           
               // After deletion, navigate to BB Detail Page
              
             PageReference p;   
             if(isLtng)
             {
                p = new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+BBIid+'&section=BBLI');
             }
            
             else
             {
                 p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+BBIid);
             }
              
              
              // Pagereference p=new Pagereference('/apex/BillboardInvoiceDetailpage?id='+BBIid);
               p.setRedirect(true);
               return p;
         }
         // End of method deleteBBILI
        
        
        
        
        
        
    public PageReference save()
    {
          try
          {
               update BBILI;
          }
         catch(System.DMLException e){return null;}
          
          // After updating AI, navigate
          
            PageReference p;   
             if(isLtng)
             {
                p = new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+theID+'&section=BBLI');
             }
            
             else
             {
               p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
             }
          
          
        //  PageReference p =  new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
          p.setRedirect(true);
          return p; 
    }
    //End Of Save Method  
    
    //Method For Cancel button    
     public PageReference cancelme()
     {
             PageReference p;   
             if(isLtng)
             {
                p = new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+theID+'&section=BBLI');
             }
            
             else
             {
               p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
             }
       
           // PageReference p =  new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
            p.setRedirect(true);
            return p;     
       }
    //End Of Cancel Buttons method  
        */
        
        
        

}