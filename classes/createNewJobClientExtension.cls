// This class is used to create New Job for Client
public with sharing class createNewJobClientExtension 
{
    // Global variables 
  /*  String MTName,ClientName,CCName,ScheduleTemp,CampaignName,SpecTempName;
    private final Job__c objJob;
    String strid;
    
    public String getMTName(){ return MTName; }
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
    
    // End of Global variables 
    
    // Start Constructor
    public createNewJobClientExtension(ApexPages.StandardController controller) 
    {
        this.objJob=(Job__c)controller.getRecord();
    }
    // End Conctructor
    
    // This method called on to populate Media Types
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
    // End method getMediaTypes
    
    public List<selectOption> getScheduleTemplates()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Schedule_Template__c r : [SELECT Id,Name FROM Schedule_Template__c where Media_Types__c=: MTName order by Name]) 
        {     
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    
    public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Account a : [SELECT Id, name FROM Account order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
    public List<selectOption> getClientContacts()
    {    
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Contact r : [SELECT Id,Name FROM Contact where AccountId=: Clientname order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    
    
    
    public List<selectOption> getCampaigns() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c order by Name]) 
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
    
    // Method called on to Save New Job
    public PageReference saveme()
    {
        try
        {
            if(schema.SobjectType.Job__c.Fields.Media_Types__c.isCreateable()){ 
                objJob.Media_Types__c=MTName;
            }
            if(schema.SobjectType.Job__c.Fields.Schedule_Template__c.isCreateable()){ 
                objJob.Schedule_Template__c=ScheduleTemp;
            }
            if(schema.SobjectType.Job__c.Fields.Campaign__c.isCreateable()){
                objJob.Campaign__c=CampaignName;
            }
            if(schema.SobjectType.Job__c.Fields.Specification_Template__c.isCreateable()){
                objJob.Specification_Template__c=SpecTempName;
            }
            
            String strClientContact=UserInfo.getName();
            System.debug('Client Contact is :'+strClientContact);
            Contact objCC=[Select Id,Name,AccountId from Contact where Name=:strClientContact LIMIT 1];
            String strClient=objCC.AccountId;
            if(schema.SobjectType.Job__c.Fields.Client__c.isCreateable()){
                objJob.Client__c=strClient;
            }
            if(schema.SobjectType.Job__c.Fields.Client_Contact__c.isCreateable()){
                objJob.Client_Contact__c=objCC.Id;
            }
            
            if(MTName == null)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Media Type: You must select a Media Type.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            
            if(ScheduleTemp == null)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Job Type: You must select a Job Type.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            else
            {
                if(Schema.sObjectType.Job__c.isCreateable()){
                    insert objJob;
                }
                strid=objJob.Id;
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }
        PageReference p=new PageReference('/home/home.jsp');
        p.setRedirect(true);
        return p;
    }
    // End Save method
    
    // Start Test Coverage
    
    static testMethod void Test_createNewJobClient()
    {
        
        Profile p1=[Select Id, Name From Profile where Name=: 'System Administrator' LIMIT 1]; 
        
        // Set up User
        
        User u1 = [SELECT Id,FirstName,LastName FROM User WHERE ISActive =: True and ProfileId=: p1.Id limit 1];
        
        // Run As u1
        
        System.runAs(u1)
        {
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1010');
            insert testMedia;
            
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1010',Media_Types__c=testMedia.Id);
            insert testST;
            
            Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1010');
            insert testSpec;
            
            Campaign__c testCamp=new Campaign__c(Name='Test Camp 1010');    
            insert testCamp;  
            
            Account testClient=new Account(Name='Test Account 1010');
            insert testClient;
            
            Contact testContact=new Contact(FirstName=u1.FirstName,LastName=u1.LastName,AccountId=testClient.id,Email='test1010@SFDC.com');
            insert testContact;    
            
            Job__c testJob1=new Job__c(Name='Test Job 1010',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,Client__c=testClient.id,Client_Contact__c=testContact.id);
            
            ApexPages.currentPage().getParameters().put('id',testJob1.id);
            ApexPages.StandardController con=new ApexPages.StandardController(testJob1);  
            createNewJobClientExtension ext=new createNewJobClientExtension(con);
            
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
            
            ext.ClientName = testClient.id;
            String ClientName = ext.getClientName();
            ext.setClientName(ClientName);
            List<SelectOption> options2 = ext.getClients(); 
            
            ext.CCName = testContact.Id;
            String CCName = ext.getCCName();
            ext.setCCName(CCName);
            List<SelectOption> options3 = ext.getClientContacts();
            
            
            ext.ScheduleTemp = testST.id;
            String ScheduleTemp = ext.getScheduleTemp();
            ext.setScheduleTemp(ScheduleTemp);
            List<SelectOption> options4 = ext.getScheduleTemplates(); 
            
            ext.CampaignName = testCamp.id;
            String CampaignName = ext.getCampaignName();
            ext.setCampaignName(CampaignName);
            List<SelectOption> options5 = ext.getCampaigns(); 
            
            ext.SpecTempName = testSpec.Id;
            String SpecTempName = ext.getSpecTempName();
            ext.setSpecTempName(SpecTempName);
            List<SelectOption> options6 = ext.getSpecificationTemplates();
            
            result=ext.saveme();  
            
            System.assertEquals('Test Job 1010',testJob1.Name);
            
            // Delete Job Tasks
            List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob1.Id];
            delete lstTask;
            
            // Delete Job Specs
            
            List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob1.Id];
            delete lstSpecs;
            
            Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Test Job 1010'];
            obj1.Status__c='Cancelled';
            update obj1;
            
            Job__c obj2=[Select id from Job__c where Name=: 'Test Job 1010'];
            delete obj2;
            
            result=ext.saveme();
        }// Run As u1
    }*/
    // End Test Coverage Code
}
// End of Class