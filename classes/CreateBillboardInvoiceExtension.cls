public with sharing class CreateBillboardInvoiceExtension {

   /*
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
   
    private final Billboard_Invoice__c bbi;
    public String bbid{get;set;}
    public String BillboardName{get;set;}
    public String VendorName;
    
    public String getVendorName() { return VendorName; }
    public void setVendorName(String s) {  this.VendorName = s; }
    
    
    // Start Constructor
    public CreateBillboardInvoiceExtension(ApexPages.StandardController controller) {
    
     this.bbi=(Billboard_Invoice__c)controller.getRecord();
        bbid=ApexPages.CurrentPage().getParameters().get('bbid');
        Billboard__c objBB=[Select id,name from Billboard__c where id=:bbid];
        BillboardName=objBB.Name;
        bbi.Billboard__c= bbid;
        
    }
    
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

            
          // Save Method
            public PageReference saveme() 
                { 
                
                   
                    string strbbiId;
                    try
                    {
                        if(schema.SobjectType.Billboard_Invoice__c.Fields.Billboard_Vendor__c.isCreateable()){ 
                            bbi.Billboard_Vendor__c=VendorName;
                        }
                        if(Schema.sObjectType.Billboard_Invoice__c.isCreateable()){
                            insert bbi;
                        }
                        strbbiId =bbi.id;
                    }
                    catch(DMLException e)
                    {
                        return null;
                    }
                    
                
                PageReference p;   
                 if(isLtng)
                 {
                    p = new Pagereference('/apex/BillboardDetailPageLightning?id='+bbid+'&section=BBI');
                 }
                
                else
                 {
                   p = new Pagereference('/apex/BillboardDetailPage?id='+bbid);
                 }
                
                
             //    PageReference pageRef = new PageReference('/apex/BillboardDetailPage?id='+bbid);
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
                p = new Pagereference('/apex/BillboardDetailPageLightning?id='+bbid+'&section=BBI');
             }
            
            else
             {
               p = new Pagereference('/apex/BillboardDetailPage?id='+bbid);
             }
            
            
            
          //  PageReference p = new PageReference('/apex/BillboardDetailPage?id='+bbid);
            p.setRedirect(true);
            return p;   
            
        }
        // Cancel Method        
        
*/


}