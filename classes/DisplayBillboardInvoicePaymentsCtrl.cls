public with sharing class DisplayBillboardInvoicePaymentsCtrl {



      // Global variables 
     /* 
       public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
      
        String theID;
        public List<BB_Invoice_Payment__c> BBILI{get;set;} 
        public id strBBILI{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayBillboardInvoicePaymentsCtrl () 
        {
             theID = ApexPages.CurrentPage().getParameters().get('id');
             BBILI=[select id,Name,Check_New__c,Check_Amount__c,Check_Date__c ,Vendor__c,Billboard_Invoice__c from BB_Invoice_Payment__c where Billboard_Invoice__c=: theID ORDER BY Name];
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
    }  */
    // End of method getsumQuant     
        
        
        
        // THis methos is called on to Create Invoice Allocation Line Item
     /*   public PageReference createIALI()
        {
             PageReference p;   
             if(isLtng)
             {
               p =  Page.CreateBillboardInvoicePaymentLightning;
             }
            
             else
             {
               p =  Page.CreateBillboardInvoicePayment;
             }
           
           
           // PageReference p =  Page.CreateBillboardInvoicePayment;
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
                   p=new Pagereference('/apex/EditBillboardInvoicePaymentLightning?id='+strBBILI);
                 }
                
                 else
                 {
                    p=new Pagereference('/apex/EditBillboardInvoicePayment?id='+strBBILI);
                 }
                   
                 
                 
                 // Pagereference p=new Pagereference('/apex/EditBillboardInvoicePayment?id='+strBBILI);
                  p.setRedirect(true);
                  return p;
           }
   // End of Method Edit
        
        
        
        // This method is called on to handle delete Billboard Invoice Line Item
         public pagereference deleteIALI()
         
         {
            system.debug('BBILIDelete ' + strBBILI);
         
             BB_Invoice_Payment__c objBBILI=[Select id,Billboard_Invoice__c  from BB_Invoice_Payment__c where id=:strBBILI];
               Id BBIid=objBBILI.Billboard_Invoice__c;
               
                if(BB_Invoice_Payment__c.sObjectType.getDescribe().isDeletable()){
                    Database.Delete(objBBILI);}
          
           
               // After deletion, navigate to CI Detail Page
               
                PageReference p;   
             if(isLtng)
             {
                p =  new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+BBIid+'&section=BBLP');
             }
            
            else
             {
               p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+BBIid);
             }
               
               
             //  Pagereference p=new Pagereference('/apex/BillboardInvoiceDetailpage?id='+BBIid);
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
      
      // After updating AI, navigate to Client Invoice Tab
      
       PageReference p;   
             if(isLtng)
             {
                p =  new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+theID+'&section=BBLP');
             }
            
            else
             {
               p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
             }
      
      
      
     // PageReference p =  new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
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
                p =  new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+theID+'&section=BBLP');
             }
            
            else
             {
               p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
             }
        
        
     //   PageReference p =  new Pagereference('/apex/BillboardInvoiceDetailpage?id='+theID);
        p.setRedirect(true);
        return p;     
       }
    //End Of Cancel Buttons method  
     */
}