public with sharing class EditBillboardExtension {

    // Global Variables
  /*  
      public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string Billboardprefix {set;get;}
    
    private final Billboard__c objBB;
    Public string strid;
     
    public Billboard__c objBB1{get;set;}
    public String VendorName, ClientName;
    
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    public String getVendorName() { return VendorName; }
    public void setVendorName(String s) {  this.VendorName = s; }
    
     
     
    // End of Global variables 

    // Standard Controller Constructor
    public EditBillboardExtension(ApexPages.StandardController con) 
    {
       this.objBB=(Billboard__c)con.getrecord();
       Billboardprefix = Billboard__c.SobjectType.getDescribe().getKeyPrefix();
       
       objBB1 = [SELECT id, name,BB_Vendor__c,Client_Name__c FROM Billboard__c WHERE id =: objBB.id];
        String st1 = objBB1.BB_Vendor__c;
        String st2 = objBB1.Client_Name__c ;
        system.debug('st1 -----> ' + st1);
        system.debug('st2 -----> ' + st2);
        
        if(String.isNotBlank(st1))
        {
            Vendor__c v=[Select id,Name from Vendor__c where id=: st1];
            VendorName= v.id; 
        }
        if(String.isNotBlank(st2))
        {
            Client__c c=[Select id,Name from Client__c where id=: st2];
            ClientName= c.id; 
        }
        
        
       
       
    }
    // End of Standard Controller Constructor 
    
    
    public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c c : [SELECT Id, name FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name));  
        }
        return optionList;  
    }

    public List<selectOption> getVendors() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Vendor__c v : [SELECT Id, name FROM Vendor__c  where Vendor_Type__c ='Outdoor' order by Name]) 
        {  
            optionList.add(new selectOption(v.Id, v.Name));  
        }
        return optionList;  
    }
    
    
    
    
    
   
    // Method called on to Update Vendor/ 
  Public PageReference saveme()
    {
        try
        {
            if(schema.SobjectType.Billboard__c.Fields.Client_Name__c.isUpdateable()){
                objBB.Client_Name__c=ClientName;
            }
            if(schema.SobjectType.Billboard__c.Fields.BB_Vendor__c.isUpdateable()){
                objBB.BB_Vendor__c=VendorName;
            }
            
            if(Schema.sObjectType.Billboard__c.isUpdateable()) {
                update objBB;
            }
            strid = objBB.id;
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
        
          PageReference p;   
         if(isLtng)
         {
            p = new Pagereference('/apex/BillboardDetailPageLightning?id='+strid);
         }
        
        else
         {
           p = new Pagereference('/apex/BillboardDetailPage?id='+strid);
         }
        
        
      //  PageReference p =  new Pagereference('/apex/BillboardDetailPage?id='+strid);
        p.setRedirect(true);
        return p; 
    }  
    // End of Method Update Vendor 
  
    // Method called on to handle Cancel button 
    Public PageReference cancelme()
    {
    
         strid = objBB.id;
         PageReference p;   
         if(isLtng)
         {
            p = new Pagereference('/apex/BillboardDetailPageLightning?id='+strid);
         }
        
        else
         {
           p = new Pagereference('/apex/BillboardDetailPage?id='+strid);
         }
        
        
      //  PageReference p =  new Pagereference('/apex/BillboardDetailPage?id='+strid);
        p.setRedirect(true);
        return p; 
    } */

}