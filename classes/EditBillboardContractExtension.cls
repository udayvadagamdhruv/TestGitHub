public with sharing class EditBillboardContractExtension {

   // Global Variables
   
   /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
   
    private final Billboard_Contract__c objBBC;
    public Billboard_Contract__c objBBC1{get;set;}
    public String VendorName;
    public String getVendorName() { return VendorName; }
    public void setVendorName(String s) {  this.VendorName = s; }
    public String strid;
    // End of Global variables 
 
    // Standard Controller Extension
    public EditBillboardContractExtension(ApexPages.StandardController con) 
    {
        this.objBBC=(Billboard_Contract__c)con.getrecord();
        
        
        objBBC1 = [SELECT id, name,BB_Vendor_Name__c,Billboard__c FROM Billboard_Contract__c WHERE id =: objBBC.id];
        String st1 = objBBC1.BB_Vendor_Name__c;
        system.debug('st1 -----> ' + st1);
        if(String.isNotBlank(st1))
        {
            Vendor__c v=[Select id,Name from Vendor__c where id=: st1];
            VendorName= v.id; 
        }
        
        
        
        strid=objBBC1.Billboard__c;
        
        
    }
    // End of Standard Controller Extension 

   
    public List<selectOption> getVendors() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Vendor__c v : [SELECT Id, name,Vendor_Type__c FROM Vendor__c where Vendor_Type__c ='Outdoor' order by Name]) 
        {  
            optionList.add(new selectOption(v.Id, v.Name));  
        }
        return optionList;  
    }
   
     Public PageReference saveme()
    {
        
        
        try 
        {   
            if(schema.SobjectType.Billboard_Contract__c.Fields.BB_Vendor_Name__c.isUpdateable()){
                objBBC.BB_Vendor_Name__c=VendorName;
            }
            if(Schema.sObjectType.Billboard_Contract__c.isUpdateable()) { 
                update objBBC;
            }
        }
        catch(System.DMLException e){return null; }
         
         
         PageReference p;
         if(isLtng)
         {
            p = new Pagereference('/apex/BillboardDetailPageLightning?id='+strid+'&section=BBC');
         }
        
         else
         {
           p = new Pagereference('/apex/BillboardDetailPage?id='+strid);
         }
        
         
         
    //    PageReference p =  new Pagereference('/apex/BillboardDetailPage?id='+strid);
        p.setRedirect(true);
        return p;
    }
    
    Public PageReference cancelme()
    {
       
         PageReference p;
         if(isLtng)
         {
            p = new Pagereference('/apex/BillboardDetailPageLightning?id='+strid+'&section=BBC');
         }
        
         else
         {
           p = new Pagereference('/apex/BillboardDetailPage?id='+strid);
         }
        
         
         
    //    PageReference p =  new Pagereference('/apex/BillboardDetailPage?id='+strid);
        p.setRedirect(true);
        return p;
    }*/
}