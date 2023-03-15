public with sharing class ClientContactsRelatedListUnderClient {
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
    public List<Client_Contact__c> q{get;set;}
    public List<Client_Contact__c> q2{get;set;}
    public String theID {get;set;}
    public string strPEID{get;set;}
    Public Boolean ShowProductionEstimate{get;set;}
   
    // End Global Variables 
    
    // Start constructor
    public ClientContactsRelatedListUnderClient() 
    {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        theID = ApexPages.CurrentPage().getParameters().get('id');
        q=[SELECT Id,Name, Client__c , Active__c, Email__c, Mobile_Phone__c, Fax__c, UserName__c, Department__c, Salesforce_User__c FROM Client_Contact__c where Client__c = : theID limit 4];
        q2=[SELECT Id,Name, Client__c , Active__c, Email__c, Mobile_Phone__c, Fax__c, UserName__c, Department__c, Salesforce_User__c FROM Client_Contact__c where Client__c = : theID];
        
    }
    // End Constructor
    
    // show All Contacts for View All Link
    public void ViewAll(){
        q=[SELECT Id,Name, Client__c , Active__c, Email__c, Mobile_Phone__c, Fax__c, UserName__c, Department__c, Salesforce_User__c FROM Client_Contact__c where Client__c = : theID];
      
    }
    
     public void Showless(){
      
      q=[SELECT Id,Name, Client__c , Active__c, Email__c, Mobile_Phone__c, Fax__c, UserName__c, Department__c, Salesforce_User__c FROM Client_Contact__c where Client__c = : theID limit 4];
    }
    
    
    
    
    
    
 /*   public void closePopup() {
        displayPopup = false;
    }

    public void showPopup() {
        displayPopup = true;
    }
    
    
    
   // Method calles on to create Quote
   
    // This method is called on to handle Create Quote button
  */
  /*
    public PageReference CreateQuote() 
    {
       
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       
       
       
        
              PageReference p = Page.CreateNewClientContactLightning;
              p.setredirect(true);
              p.getParameters().put('cid',theID); 
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