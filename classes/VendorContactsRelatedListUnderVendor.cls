public with sharing class VendorContactsRelatedListUnderVendor {
       /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     }  
            
            
     public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
    
    
    
    //public boolean displayPopup {get; set;}
    // Global variables
    public List<Vendor_Contact__c> q{get;set;}
   // public List<Vendor_Contact__c> q2{get;set;}
    public String theID {get;set;}
    public string strPEID{get;set;}
    Public Boolean ShowProductionEstimate{get;set;}
    
    // End Global Variables 
    
    // Start constructor
    public VendorContactsRelatedListUnderVendor() 
    {
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        theID = ApexPages.CurrentPage().getParameters().get('id');
       // q=[SELECT Id,Name, Vendor__c, Active__c, Email__c, Phone_1__c, Phone_2__c FROM Vendor_Contact__c where Vendor__c = : theID limit 4];
        q=[SELECT Id,Name, Vendor__c, Active__c, Email__c, Phone_1__c, Phone_2__c FROM Vendor_Contact__c where Vendor__c = : theID];
        
        
    }
    // End Constructor
    
    // show All Contacts for View All Link
    
    
   
 /*    
    public void ViewAll(){
        q=[SELECT Id,Name, Vendor__c, Active__c, Email__c, Phone_1__c, Phone_2__c FROM Vendor_Contact__c where Vendor__c = : theID];
      
    }
     
     public void Showless(){
      
      q=[SELECT Id,Name, Vendor__c, Active__c, Email__c, Phone_1__c, Phone_2__c FROM Vendor_Contact__c where Vendor__c = : theID limit 4];
    }
    
  
    
  
    public PageReference CreateQuote() 
    {
       
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       
       
              PageReference p = Page.CreateNewVendorContactLightning;
              p.setredirect(true);
              p.getParameters().put('vid',theID); 
              return p;
        
    }
    */ 
      
}