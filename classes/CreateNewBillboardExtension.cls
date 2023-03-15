public with sharing class CreateNewBillboardExtension {

 /* // Global variables
  
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string Billboardprefix {set;get;}
  
  
    public String ClientName,VendorName,Strid;
    private final Billboard__c BB;
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
    public String getVendorName() { return VendorName; }
    public void setVendorName(String s) {  this.VendorName = s; }
       
    public String orgId{get; set;}
    
    
    public CreateNewBillboardExtension(ApexPages.StandardController controller) 
    {
        this.BB=(Billboard__c )controller.getRecord();
        Billboardprefix = Billboard__c.SobjectType.getDescribe().getKeyPrefix();
        orgId = UserInfo.getOrganizationId();
        system.debug('org id --------->'+orgId);
        Id profileId = UserInfo.getProfileId();
        Profile p = [Select Id, Name from Profile where Id =: profileId];
    }

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
        for (Vendor__c v : [SELECT Id, name FROM Vendor__c  where Vendor_Type__c ='Outdoor'  order by Name]) 
        {  
            optionList.add(new selectOption(v.Id, v.Name));  
        }
        return optionList;  
   }
   
   public PageReference saveme(){
      try{
          if(schema.SobjectType.Billboard__c.Fields.Client_Name__c.isCreateable()){ 
               BB.Client_Name__c=ClientName;
           }
           if(schema.SobjectType.Billboard__c.Fields.BB_Vendor__c.isCreateable()){ 
               BB.BB_Vendor__c=VendorName;
           }
           if(Schema.sObjectType.Billboard__c.isCreateable()){
               insert BB;
           }
           Strid=BB.id;
      
      }
      
        catch(System.DMLException e){return null;}
      
      PageReference p;   
         if(isLtng)
         {
            p = new Pagereference('/apex/BillboardDetailPageLightning?id='+strid);
         }
        
        else
         {
           p = new Pagereference('/apex/BillboardDetailPage?id='+strid);
         }
        
     
   /*
      PageReference p;
          p = new PageReference('/apex/BillboardDetailPage?id='+strid);
      
      p.setRedirect(true);
      return p;

   } 
   
   public pagereference cancel()
   {
       PageReference p =  new Pagereference('/'+Billboardprefix+'/o');
       p.setRedirect(true);
       return p;
   }
   */
   
}