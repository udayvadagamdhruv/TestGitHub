// Extension class to edit Job for Client
public with sharing class EditJobClientExtension 
{
     // Global variables
   /* public String MTName,CampaignName,ScheduleTemp,SpecTempName,strId1,strId2,jobid;
    private final Job__c objJob;
    public  boolean isError{get;set;}
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }

    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }

    public String getCampaignName() { return CampaignName; }
    public void setCampaignName(String s) {  this.CampaignName = s; }

    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    // End of Global variables

    // Standard Controller Constructor 
    public EditJobClientExtension(ApexPages.StandardController con) 
    {
        isError=False;
        this.objJob=(Job__c)con.getrecord();
        jobid = ApexPages.currentpage().getParameters().get('id');
     
        Job__c abc = [select id,Name,Media_Types__c,Schedule_Template__c,Client__c,Campaign__c,Client_Contact__c,Specification_Template__c from Job__c  where id =: objJob.id Limit 1];
        
        MTName = abc.Media_Types__c;
        ScheduleTemp = abc.Schedule_Template__c;
        CampaignName = abc.Campaign__c; 
        SpecTempName = abc.Specification_Template__c;
    }
    // End of Standard Controller Constructor 
    
    // Populate all MediaTypes in picklist
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c order by Name Limit 1000]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getMediaTypes

   // Populate all Schedule Templates in picklist
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
    // End of method getScheduleTemplates

     // Populate all Campaigns in picklist
    public List<selectOption> getCampaigns() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c order by Name Limit 1000]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getCampaigns
    
     // Populate all Specification Templates in picklist
    public List<selectOption> getSpecificationTemplates() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Specification_Template__c a : [SELECT Id, name FROM Specification_Template__c order by Name Limit 1000]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }    
    // End of method getSpecificatonTemplates
    
    // Method called to update Job
    Public PageReference saveme()
    {
        try
        {
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
                Media_Type__c mt1 = [SELECT Id, name FROM Media_Type__c where id =: MTName];
                Schedule_Template__c st1 = [SELECT Id,Name FROM Schedule_Template__c where id =: ScheduleTemp];
            
                String strClientContact=UserInfo.getName();
                System.debug('Client Contact is :'+strClientContact);
                Contact objCC;
                if(!test.isRunningTest()) objCC=[Select Id,Name,AccountId from Contact where Name=:strClientContact];
                else objCC=[Select Id,Name,AccountId from Contact limit 1];
                String strClient=objCC.AccountId;
                if(schema.SobjectType.Job__c.Fields.Client__c.isUpdateable()){
                    objJob.Client__c=strClient;
                }
                if(schema.SobjectType.Job__c.Fields.Client_Contact__c.isUpdateable()){
                    objJob.Client_Contact__c=objCC.Id;
                }
                if(CampaignName != null)
                {
                    Campaign__c camp1 = [SELECT Id, name FROM Campaign__c where id =: CampaignName];
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
                    Specification_Template__c spectemp1 = [SELECT Id, name FROM Specification_Template__c where id =: SpectempName];
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
                if(schema.SobjectType.Job__c.Fields.Media_Types__c.isUpdateable()){  
                    objJob.Media_Types__c = mt1.id;
                }
                if(schema.SobjectType.Job__c.Fields.Schedule_Template__c.isUpdateable()){
                    objJob.Schedule_Template__c = st1.id;
                }
                if(Schema.sObjectType.Job__c.isUpdateable()) {
                    update objJob;
                }
            }
           } 
            catch(Exception e)
           {
              isError = true;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
               return null;
           }        
           
        PageReference p =  new Pagereference('/apex/JobListViewClient?id='+jobid);
        p.setRedirect(true);
        return p; 
    }
    // End of method Save
    
     // Method called to Handle Cancel button
     Public PageReference cancelme()
    {
       PageReference p =  new Pagereference('/apex/JobListViewClient?id='+jobid);
       p.setRedirect(true);
       return p;
    } 
    // End of Cancel method 
    
        
    // Test Coverage
    static testMethod void Test_EditJobClientExtension()
    {
     /*   Profile p= [Select Id, Name from Profile where Name =: 'System Administrator' LIMIT 1];
        User u = [Select Id, Name from User where IsActive =: True and ProfileId =: p.Id LIMIT 1];
        System.runAs(u)
        {
            
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 627');
                insert testMedia;
                
         Campaign__c testCampaign1=new Campaign__c(Name='Test Campaign 627');
                insert testCampaign1;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 627',Media_Types__c=testMedia.Id);
                insert testST;
                 
         Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 1',Schedule_Template__c=testST.Id);
                 insert testSCT1;
                 
         Schedule_Task__c testSCT2=new Schedule_Task__c(Name='Test Schedule Task 2',Schedule_Template__c=testST.Id);
                 insert testSCT2;
                 
         ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Test Designer',Schedule_Task__c=testSCT1.Id);
                 insert testSTR1;
                 
         ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='Test Designer',Schedule_Task__c=testSCT2.Id);
                 insert testSTR2;     
                 
         ScheduleTaskRole__c testSTR3=new ScheduleTaskRole__c(Name='Test Designer',Schedule_Task__c=testSCT2.Id);
         try
         {
                insert testSTR3;               
         }
          catch(System.DMLException e)
          {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
        
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 627');
                 insert testSpec;
                
         Spec_Item__c testSPI=new Spec_Item__c(Name='Test Spec Item 627',Specification_Template__c=testSpec.Id); 
                 insert testSPI;
                
         Job__c testJob1=new Job__c(Name='Test Job 627',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id, Campaign__c = testCampaign1.Id, Budgeted_Cost__c=100);
                  try
                   {
                        insert testJob1;
                   }
                  catch(System.DMLException e)
                   {
                        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
                   }
                 System.assertEquals('Test Job 627',testJob1.Name);  
                  // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
        account a = new account(Name='TestAcc');
        insert a;
        Contact conw = new Contact(LastName='Test');
        insert conw;
        
         // Instantiate the extention instance with the standardcontroller
              EditJobClientExtension ext=new EditJobClientExtension(con);
              ApexPages.PageReference result = ext.saveme();
                   result = ext.cancelme();
                   ext.getSpecificationTemplates();
                    ext.getCampaigns();
                    ext.getMediaTypes();
                    ext.getScheduleTemplates();
                ext.getMTName();
        ext.getSpecTempName();
        ext.getCampaignName();
        ext.getScheduleTemp();
       }  
 //  }*/
// ENd Test Coverage 
}
// End of Class