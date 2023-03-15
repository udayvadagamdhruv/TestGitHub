// This controller is used to handle navigation between second level tabs under Job Tab 
public with sharing class testTabController 
{

   

    // Global variables 
    public String tabInFocus{get;set;}
    String intTabFocus;
    public String graphicsValue{get;set;}
    public String sessionValue{get;set;}
    public String tagValue{get;set;}
    public String musicValue{get;set;}
    public boolean checkedSFUser{get;set;}
//orgID added by Rahul
    public String orgId{get; set;}
    public String strOrganizationName{get; set;}
    public boolean ShowProductionEstimate{get;set;}
    public boolean ShowEmailListviewSection{get;set;}
    public boolean spClientChatterFeedCheck{get;set;}
    public boolean spClientChatterFeedCheckVF{get;set;}  
    public boolean ShowoldTimesheetflow{get;set;}
    public boolean ShowJobTimeTab{get;set;}
    Public boolean ShowShipmentTab{get;set;}
    // Start Constructor 
    public testTabController(ApexPages.StandardController con) 
    {
        intTabFocus = ESAPI.encoder().SFDC_HTMLENCODE(System.currentPageReference().getParameters().get('intFocus'));
      //intTabFocus = System.currentPageReference().getParameters().get('intFocus');
       // To display Music Usage Tab 
       
       // If Custom Setting record for Music Usage is not found then musicValue is set to YES and Music Usage tab will be displayed to User
       
     ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
     ShowProductionEstimate =activeSettings.Active__c;
     ShowEmailListviewSection=activeSettings.Email_Functionality__c;
     spClientChatterFeedCheck = activeSettings.DisableJobChatterforSPClientContac__c;
     ShowJobTimeTab= activeSettings.TS_Entry_Button__c;
     ShowShipmentTab=activeSettings.Shipment_Tab__c;
     
     id id1 = userinfo.getProfileId();
     profile p = [select Name from profile where id = :id1];
     System.debug('<<<<<<<<<<<<<<<Profile Nme>>>>>>>>>>>'+p.name);
     
     if(spClientChatterFeedCheck)
     {
         if(p.name == 'SP Client Contact')
         {
             spClientChatterFeedCheckVF = FALSE;
             System.debug('<<<<<<<<in if if>>>>....<<<<<<<spClientChatterFeedCheckVF >>>>>>>>>>>'+spClientChatterFeedCheckVF);
         }
         else
         {
             spClientChatterFeedCheckVF = TRUE;
             System.debug('<<<<<<<<in if else>>>>....<<<<<<<spClientChatterFeedCheckVF >>>>>>>>>>>'+spClientChatterFeedCheckVF);
          }
     }
     else
     {
         spClientChatterFeedCheckVF = TRUE;
         System.debug('<<<<<<<<in else>>>>....<<<<<<<spClientChatterFeedCheckVF >>>>>>>>>>>'+spClientChatterFeedCheckVF);
     }
     
     
        List<Music_Usage_Setting__c> mu = Music_Usage_Setting__c.getAll().values();
        if(!mu.isEmpty())
        {
            System.debug('Custom Setting for Music Usage is Found');
            musicValue = mu[0].Name;
        }
        else
        {
            System.debug('Custom Setting for Music is Not Found');
            musicValue = 'YES';
        }
        
        System.debug('Music @@@ : '+musicValue);
        

        List<Graphics_Setting__c> g=Graphics_Setting__c.getAll().values();
        if(!g.isEmpty())
        {
            System.debug('Custom Setting for Graphics Deliverable is Found');
            graphicsValue = g[0].Name;    
        }
        else
        {
            System.debug('Custom Setting for Graphics Deliverable is Not Found');
            graphicsValue = 'YES';
        }
        
        
        System.debug('Graphics : '+graphicsValue);
        
        
        List<Session_Setting__c> s=Session_Setting__c.getAll().values();
        if(!s.isEmpty())
        {
            System.debug('Custom Setting for Session is Found');
            sessionValue = s[0].Name;
        }
        else
        {
            System.debug('Custom Setting for Session is Not Found'); 
            sessionValue = 'YES';
        }
        System.debug('Session : '+sessionValue);


         List<Tag_Setting__c> t=Tag_Setting__c.getAll().values();
         if(!t.isEmpty())
         {   
            System.debug('Custom Setting for Tag is Found');
            tagValue=t[0].Name;
         }   
         else
         {
             System.debug('Custom Setting for Tag is Not Found');   
             tagValue = 'YES';
         }
        
        System.debug('Tag : '+tagValue);

        if(intTabFocus=='1')
        {
         tabInFocus = 'Details';
        }
        if(intTabFocus=='2')
        {
            tabInFocus = 'Schedules';
        }
        if(intTabFocus=='3')
        {
            tabInFocus = 'Creative Brief';
        }
         if(intTabFocus=='4')
        {
            tabInFocus = 'Quotes';
        }
         if(intTabFocus=='5')
        {
            tabInFocus = 'Estimates';
        }
         if(intTabFocus=='6')
        {
            tabInFocus = 'Purchase Orders';
        }
          if(intTabFocus=='7')
        {
            tabInFocus = 'Invoices';
        }
         if(intTabFocus=='8')
        {
            tabInFocus = 'Notes';
        }
         if(intTabFocus=='9')
        {
            tabInFocus = 'Tags';
        }
         if(intTabFocus=='10')
        {
            tabInFocus = 'Sessions';
        }
        if(intTabFocus=='11')
        {
            tabInFocus = 'Deliverables';
        }
        if(intTabFocus=='12')
        {
            tabInFocus='Music Usage';
        }
        
        if(intTabFocus=='13')
        {
            tabInFocus='Client Invoices';
        }
        if(intTabFocus=='14')
        {
            tabInFocus = 'Production Estimates';
        }
        if(intTabFocus=='15')
        {
            tabInFocus = 'Job Time';
        }
        if(intTabFocus=='16')
        {
            tabInFocus = 'Shipment';
        }

        

       //this line is added by Rahul to check for org id
       orgId = UserInfo.getOrganizationId();
       system.debug('org id --------->'+orgId);        
       
        // Check for Client Contact
       // User u = [Select Id, Name from User where Username =: UserInfo.getUsername() LIMIT 1];
       //code added to check if this is hd org as we want to displsy notes and attachments for the client contacts for that org
       
        strOrganizationName = UserInfo.getOrganizationName();
  
   List<Client_Contact__c>  lstCC = new List<Client_Contact__c>();     
   if(strOrganizationName  != 'Healthy Directions')
   {     
      lstCC = [Select Id, Salesforce_User__c, Email__c from Client_Contact__c where UserName__c =: UserInfo.getUserName() And Salesforce_User__c =: True LIMIT 1];
   }
// List<Client_Contact__c>  lstCC= [Select Id, Salesforce_User__c, Email__c from Client_Contact__c where Email__c =: UserInfo.getUserName() And Salesforce_User__c =: True LIMIT 1];
       
        if(!lstCC.isEmpty())
        {
            checkedSFUser = True;
        } 
        else
        {
            checkedSFUser = False;
        }
        System.debug('CheckedSFUser@@@ : '+checkedSFUser);
        
    }
    // End of Constructor
  
}
// End of Class