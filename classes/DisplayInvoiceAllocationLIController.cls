public with sharing class DisplayInvoiceAllocationLIController {

/*
 public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
   

// Global variables 
        String theID;
        public List<Invoice_Allocation_Line_Item__c> IALI{get;set;} 
        public String strIALI{get;set;}
        public String InvAllocationTempName{get;set;}
        // End Global variables 
        public integer Quantity {set;get;}
        public integer rowIndex {set;get;}
        public boolean isEdit {set;get;}
        // Start Constructor 
        public DisplayInvoiceAllocationLIController () 
        {
           isEdit=false;
            IALI=new list<Invoice_Allocation_Line_Item__c>();
             theID = ApexPages.CurrentPage().getParameters().get('id');
             IALI=[select id,Name,Client_Invoice__c,Allocation_Qty__c,Allocation_Amount__c,Client_Name__c,GL_Department__c,GL_Code__c,GL_Code_No__c from Invoice_Allocation_Line_Item__c where Client_Invoice__c =: theID ORDER BY Name];
        }
        // End Constructor
        
        Sobject sumCash; 
        Sobject sumQuant;
        
        
     
     public void inlineInAllTemp(){
        isEdit=true;
     }
         

   // This method is called on to calculate Total Allocation Amount of  Invoice Allocation Line Items
   public double getSumCash()
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
        
          if(isLtng){
             p=Page.CreateInvoiceAllocationLILightning;
             }
          else{
             p=Page.CreateInvoiceAllocationLI;
           }
             p.setRedirect(true);
             p.getParameters().put('id',theID);
             return p;
        }
        // End method 
        
        // This method is called on to handle delete Invoice Allocation Line Item
         public PageReference deleteIALI()
         {
             Invoice_Allocation_Line_Item__c objIALI=[Select id,Client_Invoice__c from Invoice_Allocation_Line_Item__c where id=:strIALI];
               Id CIid=objIALI.Client_Invoice__c;
               
                if(Invoice_Allocation_Line_Item__c.sObjectType.getDescribe().isDeletable()){
                    Database.Delete(objIALI);}
          
       PageReference p;
        if(isLtng)
        p =new Pagereference('/apex/ClientInvoiceDetailPageLightning?id='+theID+'&section=invoiceallocationlineitem');
        else
        p= new Pagereference('/apex/ClientInvoiceDetailPage?id='+theID);
        p.setRedirect(true);
        return p;
         }
         // End of method deleteIALI
        
        
        // This method is called on to populate all InvAllocationTemplates into drop down list
        
    public List<selectOption> getInvAllocationTemplates() 
    {
       
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new SelectOption('','-None-'));
        for (Invoice_Allocation_Template__c a : [SELECT Id, name FROM Invoice_Allocation_Template__c  ORDER BY Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getInvAllocationTemplates
        
        
        
        
        
     // This method is called on to Import Allocation Template
   public PageReference importIATLI()
    {
        List<Invoice_Allocation_Line_Item__c> insertClientInvAllocation=new List<Invoice_Allocation_Line_Item__c>();    
        
        if(InvAllocationTempName==NULL || InvAllocationTempName=='-None-')
        {
           ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Invoice Allocation Template : You must select a Template.');
           ApexPages.addMessage(msg1);
        }
        else
        {
            try
            {
                List<Invoice_Allocation_Template_Line_Item__c> lstIATLI=[Select id,Name,Allocation_Qty__c,Client__c from Invoice_Allocation_Template_Line_Item__c where Invoice_Allocation_Template__c=:InvAllocationTempName Order By CreatedDate ];
                for(Invoice_Allocation_Template_Line_Item__c sp:lstIATLI)
                {
                    Invoice_Allocation_Line_Item__c js=new Invoice_Allocation_Line_Item__c();
                    if(schema.SobjectType.Invoice_Allocation_Line_Item__c.Fields.Allocation_Qty__c.isCreateable()){ 
                        js.Allocation_Qty__c=sp.Allocation_Qty__c;
                    }
                    if(schema.SobjectType.Invoice_Allocation_Line_Item__c.Fields.Client_Name__c.isCreateable()){ 
                        js.Client_Name__c=sp.Client__c ;
                    }
                    if(schema.SobjectType.Invoice_Allocation_Line_Item__c.Fields.Client_Invoice__c.isCreateable()){ 
                        js.Client_Invoice__c=theID;
                    }
                    
                    insertClientInvAllocation.add(js);
                }
                if(Schema.sObjectType.Invoice_Allocation_Line_Item__c.isCreateable()){ 
                    insert insertClientInvAllocation;
                }
                // InvAllocationTempName='';
            }
            catch(System.DMLException e)
            {
              return NULL;
            }
        }   
        
        PageReference p;
        if(isLtng)
        p =new Pagereference('/apex/ClientInvoiceDetailPageLightning?id='+theID+'&section=invoiceallocationlineitem');
        else
        p= new Pagereference('/apex/ClientInvoiceDetailPage?id='+theID);
        p.setRedirect(true);
        return p;
       // return null;
       
        //IALI.clear();
       // IALI=[select id,Name,Client_Invoice__c,Allocation_Qty__c,Allocation_Amount__c,Client_Name__c,GL_Department__c,GL_Code__c,GL_Code_No__c from Invoice_Allocation_Line_Item__c where Client_Invoice__c =: theID ORDER BY Name];
    }
    // End of method Import Allocation Template 
        
        
        
        
        
        
    public PageReference save()
    {
     try
      {
        update IALI;
      }
     catch(System.DMLException e){
     Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
     return null;
     }
      
      // After updating AI, navigate to Client Invoice Tab
     PageReference p;
     if(isLtng)
     p=new Pagereference('/apex/ClientInvoiceDetailPageLightning?id='+theID+'&section=invoiceallocationlineitem');
     else
     p=new Pagereference('/apex/ClientInvoiceDetailPage?id='+theID);
     p.setRedirect(true);
     return p; 
     
   }
    //End Of Save Method  
    
    public void inlineSave(){
   
    try{
     
   update IALI[rowIndex];
       IALI.clear();
       IALI=[select id,Name,Client_Invoice__c,Allocation_Qty__c,Allocation_Amount__c,Client_Name__c,GL_Department__c,GL_Code__c,GL_Code_No__c from Invoice_Allocation_Line_Item__c where Client_Invoice__c =: theID ORDER BY Name];
       isEdit=false;
      }
    catch(System.DMLException e){
     Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
     }
    
    }
    
    //Method For Cancel button    
     public PageReference cancelme()
       {
       // PageReference p =  new Pagereference('/apex/ClientInvoiceDetailPage?id='+theID);
       // p.setRedirect(true);
       // return p;   
       return null;  
       }
    //End Of Cancel Buttons method  
        
        */
        
        

}