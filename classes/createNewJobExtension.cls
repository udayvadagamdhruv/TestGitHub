// This class is used to create New Job
public with sharing class createNewJobExtension 
{
  /*  
    // Global variables
    String SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid;

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
    
    private final Job__c vq;
    public boolean displayClient_Contact{get;set;}
    
    public string strCampaignName{get;set;}
//following code added by yogini
//        public string strCampaignName
//        {
//            get
//            {
//                 return strCampaignName = ApexPages.CurrentPage().getParameters().get('Campaign'); 
//            }
//            set;
//        }
    // End of Global variables
    
    // Start Constructor
    
    public createNewJobExtension(ApexPages.StandardController controller) 
    {
        this.vq=(Job__c)controller.getRecord();
        
        system.debug('In constructor');
        
        // Code to hide Client and Client Contact field from Logged in User who is client contact
        Id profileId = UserInfo.getProfileId();
       
        //code sction added by sushma 26 july for setting the campaign id to the list of the selected campaign
        Id idCampaign = ApexPages.CurrentPage().getParameters().get('Campaign');
        CampaignName = idCampaign ;
     
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
    // End of Constructor
    
    // This method is called on to handle cancel button
    public pagereference cancel()
    {
        Pagereference pg1=new Pagereference('/apex/JobsTabOverride');
        pg1.setRedirect(true);
        return pg1;
    }
    
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

    public List<selectOption> getClientContacts()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Client_Contact__c r : [SELECT Id,Name FROM Client_Contact__c where Client__c =: Clientname and Active__c =:true order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }

    public List<selectOption> getCampaigns() 
    {   
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c where Status__c='Active' order by Name]) 
        {         
            optionList.add(new selectOption(a.Id, a.Name));  
        }
     
        return optionList;  
    }

    public List<selectOption> getSpecificationTemplates() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Specification_Template__c a : [SELECT Id, name FROM Specification_Template__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }

    public PageReference saveme()
    {
    try
      {
        if(MTName == null)
        {
            String stringMediaType = Schema.Job__c.fields.Media_Types__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must select a '+stringMediaType+'.');
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
            Id profileId = UserInfo.getProfileId();
            Profile p=[Select Id,Name from Profile where Id=: profileId LIMIT 1];
            if(p.Name=='Client Contact' || p.Name=='SP Client Contact')
            {
                  Client_Contact__c c=[Select Id, Name, Client__c, Email__c From Client_Contact__c where Email__c =: UserInfo.getUserName() LIMIT 1]  ;
                if(schema.SobjectType.Job__c.Fields.JS_Client__c.isCreateable()){ 
                    vq.JS_Client__c=c.Client__c;
                }
                if(schema.SobjectType.Job__c.Fields.JS_Client_Contact__c.isCreateable()){ 
                    vq.JS_Client_Contact__c=c.Id;
                }
            }
            else
            {
                if(schema.SobjectType.Job__c.Fields.JS_Client__c.isCreateable()){ 
                    vq.JS_Client__c=ClientName;
                }
                if(schema.SobjectType.Job__c.Fields.JS_Client_Contact__c.isCreateable()){ 
                    vq.JS_Client_Contact__c=CCName;
                }
           
            }
//         vq.Client__c=ClientName;
//           vq.Client_Contact__c=CCName;
           if(schema.SobjectType.Job__c.Fields.Media_Types__c.isCreateable()){ 
               vq.Media_Types__c=MTName;
           }
           if(schema.SobjectType.Job__c.Fields.Schedule_Template__c.isCreateable()){ 
               vq.Schedule_Template__c=ScheduleTemp;
           }
           if(schema.SobjectType.Job__c.Fields.Campaign__c.isCreateable()){ 
               vq.Campaign__c=CampaignName;
           }
           if(schema.SobjectType.Job__c.Fields.Specification_Template__c.isCreateable()){ 
               vq.Specification_Template__c=SpecTempName;
           }
           if(Schema.sObjectType.Job__c.isCreateable()){
               insert vq;
           }
           strid=vq.Id;
       }
     }
      catch(System.DMLException e)
      {
         // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
         // ApexPages.addMessage(myMsg);
          return null;
      }
      PageReference p=new PageReference('/apex/JobListView?id='+strid);
      p.setRedirect(true);
      return p;
}


 // Test Method for Job 
 static testMethod void Test_createNewJobExtension()
 {
          Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting001;
            
          Media_Type__c testMedia=new Media_Type__c(Name='TM001');
          insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST001',Media_Types__c=testMedia.Id);
          insert testST;
   
          Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST001',Schedule_Template__c=testST.Id);
          insert testSCT1;
                 
          Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST002',Schedule_Template__c=testST.Id);
          insert testSCT2;
                 
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='R001',Schedule_Task__c=testSCT1.Id);
          insert testSTR1;
                 
          ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='R002',Schedule_Task__c=testSCT2.Id);
          insert testSTR2;            
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT001');
          insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='SI001',Specification_Template__c=testSpec.Id); 
          insert testSPI;
         
          Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account001');
          insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 001',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
          insert c;
                
          Job__c testJob1=new Job__c(Name='Job001',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
             
          ApexPages.StandardController con=new ApexPages.StandardController(testjob1);
          createNewJobExtension ext=new createNewJobExtension(con);
 
          ext.MTName = NULL; // To check MediaType as NULL
          String MTName2 = ext.getMTName();
          ext.setMTName(MTName2);
          List<SelectOption> options7 = ext.getMediaTypes(); 
          
          ext.ScheduleTemp = testST.id;
          String ScheduleTemp1 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp1);
          List<SelectOption> options8 = ext.getScheduleTemplates();  
          
          ApexPages.Pagereference result=ext.saveme();
          
          ext.MTName = testMedia.id;
          String MTName1 = ext.getMTName();
          ext.setMTName(MTName1);
          List<SelectOption> options9 = ext.getMediaTypes(); 
          
          ext.ScheduleTemp = NULL; // To Check Schedule Template as NULL
          String ScheduleTemp2 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp2);
          List<SelectOption> options10 = ext.getScheduleTemplates();  
          
            
          result=ext.saveme();
          
          ext.MTName = testMedia.id;
          String MTName = ext.getMTName();
          ext.setMTName(MTName);
          List<SelectOption> options1 = ext.getMediaTypes(); 
          
          ext.ClientName = a.id;
          String ClientName = ext.getClientName();
          ext.setClientName(ClientName);
          List<SelectOption> options2 = ext.getClients(); 
          
          ext.CCName = c.Id;
          String CCName = ext.getCCName();
          ext.setCCName(CCName);
          List<SelectOption> options3 = ext.getClientContacts();
        
          
          ext.ScheduleTemp = testST.id;
          String ScheduleTemp = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp);
          List<SelectOption> options4 = ext.getScheduleTemplates(); 
          
          ext.CampaignName = testCampaign1.id;
          String CampaignName = ext.getCampaignName();
          ext.setCampaignName(CampaignName);
          List<SelectOption> options5 = ext.getCampaigns(); 
          
          ext.SpecTempName = testSpec.Id;
          String SpecTempName = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName);
          List<SelectOption> options6 = ext.getSpecificationTemplates();
          
          result=ext.saveme();  
          
          System.assertEquals('Job001',testJob1.Name);
          
           // Delete Job Tasks
         List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob1.Id];
         delete lstTask;
         
         // Delete Job Specs
         
         List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob1.Id];
         delete lstSpecs;
         
         // Delete Estimates
         List<Estimate_Line_Items__c> lstELI=[select id from Estimate_Line_Items__c where Job__c=:testJob1.Id];
         delete lstELI;
        
         // Delete PO's
         List<Purchase_Order__c> lstPO=[select id from Purchase_Order__c where Job__c=:testJob1.Id];
         delete lstPO;

         // Delete Quotes
        List<Quote__c> lstQ=[select id from Quote__c where Job__c=:testJob1.Id];
         delete lstQ;
        
         Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Job001'];
         obj1.Status__c='Cancelled';
         update obj1;

         Job__c obj2=[Select id from Job__c where Name=: 'Job001'];
         delete obj2;
         result=ext.saveme();
         result=ext.cancel();
       }     
       // End of Test Method*/
}
// End of Class