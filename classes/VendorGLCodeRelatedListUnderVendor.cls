public with sharing class VendorGLCodeRelatedListUnderVendor {
/*public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     }  
            
            
     public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
    
    
    
   // public boolean displayPopup {get; set;}
    // Global variables
    public List<Vendor_GL_Code__c> q{get;set;}
   // public List<Vendor_GL_Code__c> q2{get;set;}
    public String theID {get;set;}
    public string strPEID{get;set;}
    Public Boolean ShowProductionEstimate{get;set;}
   
    // End Global Variables 
    
    // Start constructor
    public VendorGLCodeRelatedListUnderVendor () 
    {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        theID = ApexPages.CurrentPage().getParameters().get('id');
        //q=[SELECT GL_Code__c,GL_Code__r.Name, Vendor__c, Name, Id FROM Vendor_GL_Code__c where Vendor__c = : theID limit 4];
        q=[SELECT GL_Code__c,GL_Code__r.Name,  Vendor__c, Name, Id FROM Vendor_GL_Code__c where Vendor__c = : theID];
        
    }
    // End Constructor
    
    // show All Contacts for View All Link
    public void ViewAll(){
        q=[SELECT GL_Code__c,GL_Code__r.Name,  Vendor__c, Name, Id FROM Vendor_GL_Code__c where Vendor__c = : theID];
      
    }
    
     public void Showless(){
      
      q=[SELECT GL_Code__c,GL_Code__r.Name,  Vendor__c, Name, Id FROM Vendor_GL_Code__c where Vendor__c = : theID limit 4];
    }
    
    
  
    
   // Method calles on to create Quote
   
    // This method is called on to handle Create Quote button
  
  
    public PageReference CreateQuote() 
    {
       
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       
              PageReference p = Page.createNewVendorGLCodeLightning;
              p.setredirect(true);
              p.getParameters().put('vid',theID); 
              return p;
        
       
     
      
    }
 /*   
    // End createQuote method
   
    // Method called on to save Quote
   public PageReference save()
    {
     try
     {
          update q;
     }
    catch(System.DMLException e)
     {
          return null;
     }
         // AFter updating Quote navigate to Quote Tab under Jobs Tab
       
       if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theID+'&tab=Jobcost');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                // After inserting Job Spec, navigate to Creative Brief Tab        
                PageReference p =  new Pagereference('/apex/JobListView?id='+theID+'&intFocus=4');
                p.setRedirect(true);
                return p;
        }
       
       
       
        
    }
    // End save method
    
    // Method called on to handle Cancel button 
     Public PageReference cancelme()
     {
    
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theID+'&tab=Jobcost');
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                    // After inserting Job Spec, navigate to Creative Brief Tab        
                    PageReference p =  new Pagereference('/apex/JobListView?id='+theID+'&intFocus=4');
                    p.setRedirect(true);
                    return p;
            }
    
    
    
              
     } 

   */

}