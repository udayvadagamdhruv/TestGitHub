// Extension class to edit Job
public with sharing class EditJobExtension 
{
    // Global variables
  /*  String MTName,ClientName,CCName,ScheduleTemp,CampaignName,SpecTempName,strId1,strId2,jobid;
    private final Job__c objJob;
    public  boolean isError{get;set;}

    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }

    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }

    public String getCampaignName() { return CampaignName; }
    public void setCampaignName(String s) {  this.CampaignName = s; }

    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }

    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }

    public String getCCName() {  return CCName; }
    public void setCCName(String s) {  this.CCName = s; }
     public boolean displayClient_Contact{get;set;}
    // End of Global variables

    // Standard Controller Constructor
    public EditJobExtension(ApexPages.StandardController con) 
    {
        isError=False;
        this.objJob=(Job__c)con.getrecord();
        jobid = ApexPages.currentpage().getParameters().get('id');
     
        Job__c abc = [select id,Name,Media_Types__c,Schedule_Template__c,JS_Client__c,Campaign__c,JS_Client_Contact__c,Specification_Template__c from Job__c  where id =: objJob.id Limit 1];
        
        MTName = abc.Media_Types__c;
        ScheduleTemp = abc.Schedule_Template__c;
        ClientName = abc.JS_Client__c;
        CCName = abc.JS_Client_Contact__c;
        CampaignName = abc.Campaign__c; 
        SpecTempName = abc.Specification_Template__c;
        
        
        // Code to hide Client and Client Contact field from Logged in User who is client contact
        Id profileId = UserInfo.getProfileId();

        Profile p = [Select Id, Name from Profile where Id =: profileId];

        if(p.Name == 'Client Contact' || p.Name == 'SP Client Contact')
        {
            displayClient_contact = False;
        }
        else
        {
            displayclient_contact = True;
        }
        // End hide Client and Client Contact field from Logged in User who is client contact
    }
    // End of Standard Controller Constructor 
    
    // Populate Media TYpe into Dropdown List
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getMediaTypes

      // Populate Schedule Template into Dropdown List
    public List<selectOption> getScheduleTemplates()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Schedule_Template__c r : [SELECT Id,Name FROM Schedule_Template__c where Media_Types__c=: MTName and Active__c=True order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    // ENd of method getScheduleTemplates
    
      // Populate Clients into Dropdown List
    public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getClients
    
      // Populate Client Contacts into Dropdown List
     public List<selectOption> getClientContacts()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Client_Contact__c r : [SELECT Id,Name,Client__c FROM Client_Contact__c where Client__c =: Clientname and Active__c =: true order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    // End of method getClientContacts


      // Populate Campaigns into Dropdown List
    public List<selectOption> getCampaigns() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c a : [SELECT Id, Name FROM Campaign__c where Status__c=:'Active' order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getCampaigns

      // Populate Specification Templates into Dropdown List
     public List<selectOption> getSpecificationTemplates() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Specification_Template__c a : [SELECT Id, Name FROM Specification_Template__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getSpecificationTemplates    
    
    // Method called to update Job 
    Public PageReference saveme()
    {
        try
        {
          if(MTName == null)
            {
                String stringMTName = Schema.Job__c.fields.Media_Types__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMTName+' : You must select a '+stringMTName+'.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            if(ScheduleTemp == null)
            {
                String strSchedule = Schema.Job__c.fields.Schedule_Template__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select a '+strSchedule);
                ApexPages.addMessage(myMsg);
                return null;
            }         
            else
            {
                Media_Type__c mt1 = [SELECT Id, name FROM Media_Type__c where id =: MTName];
                Schedule_Template__c st1 = [SELECT Id,Name FROM Schedule_Template__c where id =: ScheduleTemp];
                if(ClientName != null)
                {
                    Client__c a1 = [SELECT Id, name FROM Client__c where id =: ClientName];
                    if(schema.SobjectType.Job__c.Fields.JS_Client__c.isUpdateable()){ 
                        objJob.JS_Client__c = a1.id;
                    }
                } 
                if(ClientName == null)
                {
                    if(schema.SobjectType.Job__c.Fields.JS_Client__c.isUpdateable()){ 
                        objJob.JS_Client__c = null; 
                    }
                }
                if(CCName != null)
                {
                    Client_Contact__c c1 = [SELECT Id,Name FROM Client_Contact__c where id =: CCName];
                    if(schema.SobjectType.Job__c.Fields.JS_Client_Contact__c.isUpdateable()){ 
                        objJob.JS_Client_Contact__c = c1.id;
                    }
                }
                if(CCName == null)
                {
                    if(schema.SobjectType.Job__c.Fields.JS_Client_Contact__c.isUpdateable()){ 
                        objJob.JS_Client_Contact__c = null;
                    }
                }            
                if(CampaignName != null)
                {
                    Campaign__c camp1 = [SELECT Id, Name FROM Campaign__c where id =: CampaignName];
                    if(schema.SobjectType.Job__c.Fields.Campaign__c.isUpdateable()){ 
                        objJob.Campaign__c = camp1.id;
                    }
                }
                if(CampaignName == null)
                {
                    if(schema.SobjectType.Job__c.Fields.Campaign__c.isUpdateable()){ 
                    objJob.Campaign__c = null;
                    }
                }
                if(SpectempName != null)
                {
                    Specification_Template__c spectemp1 = [SELECT Id, Name FROM Specification_Template__c where id =: SpectempName];
                     if(schema.SobjectType.Job__c.Fields.Specification_Template__c.isUpdateable()){ 
                    objJob.Specification_Template__c = spectemp1.id;
                    }
                }
                if(SpectempName == null)
                {
                     if(schema.SobjectType.Job__c.Fields.Specification_Template__c.isUpdateable()){ 
                       objJob.Specification_Template__c = null;
                    }
                }        
                if(schema.SobjectType.Job__c.Fields.Media_Types__c .isUpdateable()){    
                objJob.Media_Types__c = mt1.id;
                }
                 if(schema.SobjectType.Job__c.Fields.Schedule_Template__c .isUpdateable()){ 
                objJob.Schedule_Template__c = st1.id;
                }
                if(Schema.sObjectType.Job__c.isUpdateable()){
                update objJob;
                }
            }
           } 
        catch(Exception e)
        {
           isError = true;
           return null;
        }        
        // Naviagtion after editing a Job
        PageReference p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=1');
        p.setRedirect(true);
        return p; 
    }
    // End method save
        
     // Method called to Handle Cancel button opeartion 
    public PageReference cancelme()
     {
           PageReference p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=1');
           p.setRedirect(true);
           return p;
     } 
    // End of Cancel method 
    */
   
}// End of Class