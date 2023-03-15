public with sharing class EditBillboardInvoiceExtension {

   // Global Variables
   /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
   
    private final Billboard_Invoice__c objBBI;
    Public string strid;
    public String Billboardname{get;set;} 
    public Billboard_Invoice__c objBBI1{get;set;}
    public String VendorName;
    public String getVendorName() { return VendorName; }
    public void setVendorName(String s) {  this.VendorName = s; }
    
    // End of Global variables 

    // Standard Controller Constructor
    public EditBillboardInvoiceExtension(ApexPages.StandardController con) 
    {
       this.objBBI=(Billboard_Invoice__c )con.getrecord();
       strid = objBBI.id;
       objBBI1 = [SELECT id, name,BB_Invoice_Amount__c,BB_Invoice_Due_Date__c,Location__c,Billboard__c,Billboard__r.name,Billboard_Vendor__c FROM Billboard_Invoice__c WHERE id =: objBBI.id];
        Billboardname=objBBI1.Billboard__r.name;
        String st1 = objBBI1.Billboard_Vendor__c ;
        
        system.debug('st1 -----> ' + st1);
        
        
        if(String.isNotBlank(st1))
        {
            Vendor__c v=[Select id,Name from Vendor__c where id=: st1];
            VendorName= v.id; 
        }
        
    }
    // End of Standard Controller Constructor 
    
    

    public List<selectOption> getVendors() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Vendor__c v : [SELECT Id, name FROM Vendor__c order by Name]) 
        {  
            optionList.add(new selectOption(v.Id, v.Name));  
        }
        return optionList;  
    }
    
    
   
    // Method called on to Update Vendor 
    Public PageReference saveme()
    {
        try
        {
            if(schema.SobjectType.Billboard_Invoice__c.Fields.Billboard_Vendor__c.isUpdateable()){
                objBBI.Billboard_Vendor__c =VendorName;
            }
            if(Schema.sObjectType.Billboard_Invoice__c.isUpdateable()) { 
                update objBBI;
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }
         // After updating the Vendor navigate to the Vendor Detail Page 
         
          PageReference p;   
         if(isLtng)
         {
            p = new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+strid);
         }
        
         else
         {
           p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+strid);
         }
                  
        // PageReference p =  new Pagereference('/apex/BillboardInvoiceDetailpage?id='+strid);
        p.setRedirect(true);
        return p; 
    }  
    // End of Method Update Vendor 
  
    // Method called on to handle Cancel button 
    Public PageReference cancelme()
    {
    
             PageReference p;   
             if(isLtng)
             {
                p = new Pagereference('/apex/BillboardInvoiceDetailpageLightning?id='+strid);
             }
            
             else
             {
               p = new Pagereference('/apex/BillboardInvoiceDetailpage?id='+strid);
             }
    
    
    //   PageReference p =  new Pagereference('/apex/BillboardInvoiceDetailpage?id='+strid);
       p.setRedirect(true);
       return p;
    } */

}