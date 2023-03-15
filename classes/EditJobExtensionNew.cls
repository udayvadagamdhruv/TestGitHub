// Extension class to edit Job
public with sharing class EditJobExtensionNew
{

    public boolean isLtng{private set; get{
                                    String theme = UserInfo.getUITheme();
                                    return (theme=='Theme4d')?true:false;
                                  }
    }  
    
    
     public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  

    // Global variables
    Public String MTName,ClientName,CCName,ScheduleTemp,CampaignName,SpecTempName,strId1,strId2,jobid,ScheduleCalc;
    public boolean UpdateSchedDateFieldCheck;
    public final Job__c objJob;
    public  boolean isError{get;set;}

    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
    //UpdateSchedDateFieldCheck__c
    public boolean getUpdateSchedDateFieldCheck() { return UpdateSchedDateFieldCheck; }
    public void setUpdateSchedDateFieldCheck(boolean s) {  this.UpdateSchedDateFieldCheck= s; }
    
    public String getScheduleCalc() { return ScheduleCalc; }
    public void setScheduleCalc(String s) {  this.ScheduleCalc = s; }

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
    public string markDone{get;set;} 
    public string ApprovePe{get;set;} 
    public boolean ShowNotrequiredJob{get;set;}
    public boolean ShowNotReScheduleJob{get;set;}
     public boolean ShowPELI{get;set;}
     
      public String orgId{get; set;}
    //public string HDorg{get;set;}
    // End of Global variables


  public pagereference revertMediaType()
    {
        PageReference p =  new Pagereference('/apex/EditJobNew?id='+jobId+'&intFocus=2');
       // p.setRedirect(true);
        return p; 
    }
    // Standard Controller Constructor
    public EditJobExtensionNew(ApexPages.StandardController con) 
    {
        
        list<string> FSetFields = new list<string>();
        for(Schema.FieldSetMember f:sObjectType.Job__c.FieldSets.getMap().get('Job_Field_sets').getFields()){
            FSetFields.add(f.getFieldPath());
        }
        if (!Test.isRunningTest()) con.addFields(FSetFields);
        
       /* isError=False;
        if(UserInfo.getOrganizationId()=='00DE0000000Z7vWMAS')
        {
            HDorg = 'True';
        }
        else
        {
            HDorg = 'False';
        }*/
        this.objJob=(Job__c)con.getrecord();
        jobid = ApexPages.currentpage().getParameters().get('id');
     
        Job__c abc = [select id,Name,Media_Types__c,Schedule_Template__c,JS_Client__c,Campaign__c,JS_Client_Contact__c,Specification_Template__c,UpdateSchedDateFieldCheck__c from Job__c  where id =: jobid  Limit 1];
        
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowNotrequiredJob =activeSettings.Remove_Required_of_Job_name__c;
        ShowNotReScheduleJob=activeSettings.Recalculate_Schedule_Job__c;
        ShowPELI=activeSettings.Active__c;
        System.debug('>>>>>>>>>>>>>>>>>>>ShowNotReScheduleJob>>>>>>>>>>>>>'+ShowNotReScheduleJob);
        
        MTName = abc.Media_Types__c;
        ScheduleTemp = abc.Schedule_Template__c;
        ClientName = abc.JS_Client__c;
        CCName = abc.JS_Client_Contact__c;
        CampaignName = abc.Campaign__c; 
        SpecTempName = abc.Specification_Template__c;
        UpdateSchedDateFieldCheck = abc.UpdateSchedDateFieldCheck__c ;
        
        
        // Code to hide Client and Client Contact field from Logged in User who is client contact
        Id profileId = UserInfo.getProfileId();
        orgId = UserInfo.getOrganizationId();

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
        
        if(ShowNotReScheduleJob==true)
        {
            abc.UpdateSchedDateFieldCheck__c=true;
            System.debug('>>>>>>>>>>>>>>>>>>>UpdateSchedDateFieldCheck__c>>>>>>>>>>>>>'+abc.UpdateSchedDateFieldCheck__c);
        }
        else
        {
             abc.UpdateSchedDateFieldCheck__c=false;
             
              System.debug('****************************UpdateSchedDateFieldCheck__c******************************'+abc.UpdateSchedDateFieldCheck__c);
        }
        
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
       // && (orgId == '00DE0000000ZEOuMAO' || orgId == '00D0U0000000Q7wUAE') for NBC CC 
      
           if(isLtng || orgId == '00DE0000000ZEOuMAO' || orgId == '00D0U0000000Q7wUAE')
           {
                for (Client__c a : [SELECT Id, name,client_code__c,Active__c FROM Client__c where Active__c=:true order by Name]) 
                { 
                 
                    optionList.add(new selectOption(a.Id, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));    
                }
           }
           else
           {
                for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c order by Name]) 
                { 
                 
                    optionList.add(new selectOption(a.Id, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));    
                }
           }
       
      
        return optionList;  
    }
    // End of method getClients
    
    
     public List<selectOption> getScheduleCalcList() 
    {
        List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Job__c.Schedule_Calc__c.getDescribe();
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
               
        return optionList;  
    }
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
          boolean b = markDone.equals('TRUE');
          system.debug('Boooooooooooooooooleannnnnnnnnnn'+markDone);
          boolean bb = ApprovePe.equals('TRUE');
          
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
                ApexPages.addMessage(myMsg);                return null;
            }
             if(objJob.Schedule_Calc__c == null)
            {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must select the Schedule Calculation value ');
              ApexPages.addMessage(myMsg);              return null;
            }
           if(objJob.Schedule_Calc__c == 'Start Date' && this.objJob.Start_Date__c == null)
            {
              System.debug('in error 1');
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Start Date Value');
              ApexPages.addMessage(myMsg);               return null;
            }
            
            System.debug('Schedule calc : ' + objJob.Schedule_Calc__c);
        //condition added if the end date is selected and the due date value is blank
           if(objJob.Schedule_Calc__c == 'End Date' && this.objJob.Due_Date__c == null)
            {
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Due Date Value');
               ApexPages.addMessage(myMsg);                return null;
            }         
            else
            {
                Media_Type__c mt1 = [SELECT Id, name FROM Media_Type__c where id =: MTName];
                Schedule_Template__c st1 = [SELECT Id,Name FROM Schedule_Template__c where id =: ScheduleTemp];
                if(ClientName != null)
                {
                    Client__c a1 = [SELECT Id, name FROM Client__c where id =: ClientName];
                    objJob.JS_Client__c = a1.id;
                } 
                if(ClientName == null)
                {
                    objJob.JS_Client__c = null; 
                }
                if(CCName != null)
                {
                    Client_Contact__c c1 = [SELECT Id,Name FROM Client_Contact__c where id =: CCName];
                    objJob.JS_Client_Contact__c = c1.id;
                }
                if(CCName == null)
                {
                    objJob.JS_Client_Contact__c = null;
                }            
                if(CampaignName != null)
                {
                    Campaign__c camp1 = [SELECT Id, Name FROM Campaign__c where id =: CampaignName];
                    objJob.Campaign__c = camp1.id;
                }
                if(CampaignName == null)
                {
                    objJob.Campaign__c = null;
                }
                if(SpectempName != null)
                {
                    Specification_Template__c spectemp1 = [SELECT Id, Name FROM Specification_Template__c where id =: SpectempName];
                    objJob.Specification_Template__c = spectemp1.id;
                }
                if(SpectempName == null)
                {
                    objJob.Specification_Template__c = null;
                }        
                if(st1.Name != null)
                {   
                objJob.Media_Types__c = mt1.id;         objJob.Schedule_Template__c = st1.id;
                
                }
                else
                {
                    objJob.Media_Types__c = MTName;     objJob.Schedule_Template__c = ScheduleTemp;
                }
                if(markDone == 'True' )//&& UserInfo.getOrganizationId()=='00DE0000000Z7vWMAS' )
                    {
                        objJob.marked_Done__c = True;
                     }
                     else
                     {
                      objJob.marked_Done__c = False;
                     }
                     
                     
                if(ApprovePe == 'True' && ShowPELI == true)
                {
                    objJob.Approve_PE__c= True;
                }
                else
                {
                  objJob.Approve_PE__c= False;
                }     
                     
            /*      if(ShowNotReScheduleJob == True )
                    {
                        objJob.UpdateSchedDateFieldCheck__c = True;
                     }*/
                    
                update objJob;
            }
           } 
        catch(Exception e)
        {
           isError = true;
           return null;
        }        
        // Naviagtion after editing a Job
        PageReference p;
        
            if(isMob)
            {
                 p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid);
                 
            }
            
            else if(isLtng)
            {
                 p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid);
                  
            }
            else
            {
                p =  new Pagereference('/apex/jobListView?id='+jobid+'&intFocus=1');
                    
            }
        
        
        
        p.setRedirect(true);  return p; 
    }
    // End method save
        
     // Method called to Handle Cancel button opeartion 
    public PageReference cancelme()
     {
           PageReference p;
        
            if(isMob)
            {
                 p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid);
                 
            }
            
            else if(isLtng)
            {
                 p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid);
                  
            }
            else
            {
                p =  new Pagereference('/apex/jobListView?id='+jobid+'&intFocus=1');
                    
            }
        
           p.setRedirect(true);
           return p;
     } 
    // End of Cancel method 
    
  /*  // Start Test Coverage

    Static testMethod void Test_EditJobExtensionNew()
     {
     Job_Number_Setting__c customSetting998 = new  Job_Number_Setting__c(Name= 'yy');
             insert customSetting998;
          
          Media_Type__c testMedia=new Media_Type__c(Name='MT011');
              insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST011',Media_Types__c=testMedia.Id);
              insert testST;
          
          Schedule_Task__c testSchedule1=new Schedule_Task__c(Name='Test Schedule Task 011',Days__c=2,Schedule_Template__c=testST.id);
              insert testSChedule1;   
           
          Schedule_Task__c testSchedule2=new Schedule_Task__c(Name='Test Schedule Task 012',Days__c=2,Schedule_Template__c=testST.id);
              insert testSChedule2;   
   
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT011');
              insert testSpec;
         
          Spec_Item__c testSPI1=new Spec_Item__c(Name='Test Spec Item 0011',Specification_Template__c=testSpec.id);
              insert testSPI1;
         
          Spec_Item__c testSPI2=new Spec_Item__c(Name='Test Spec Item 0012',Specification_Template__c=testSpec.id);
              insert testSPI2;
        
          Campaign__c testCampaign1=new Campaign__c(Name='C011',Active__c=True,Status__c='Active');
              insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account011');
              insert a;
              
          Client__c b=new Client__c(Name='Client1001');
              insert b;    
              
          Client__c a1=new Client__c(Name='Account011');
             try
              {
               insert a1;     
              }
             catch(System.DMLException e)
              {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
              }
            
          Client__c a2 = [select id,Name from Client__c where id =: a.id];
            a2.Name = 'Client1001';
            try
             {
             update a2;
             }
            catch(System.DMLException e)
             {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
             }
            
         
          Client_Contact__c c=new Client_Contact__c(Name='Contact 011 LN011',First_Name__c='Contact 011',Last_Name__c='LN011',Client__c=a.id,Email__c='testC011@SFDC.com');
              insert c;
                
          Job__c testJob1=new Job__c(Name='Job011',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
           try
            {
                insert testJob1;
            }
           catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
          System.assertEquals('Job011',testJob1.Name);  
                  
         // Instantiate the standard controller with the Job
          ApexPages.StandardController con=new ApexPages.StandardController(testjob1);
          
          // Instantiate the extention instance with the standard controller
          
          EditJobExtensionNew ext=new EditJobExtensionNew(con);
          
          // Invoke the primary method on the extension 
          ApexPages.Pagereference result=ext.saveme();
          
        Specification_Template__c testSpec1=new Specification_Template__c(Name='SPT012');
              insert testSpec1;
         
          Spec_Item__c testSPI3=new Spec_Item__c(Name='Test Spec Item 0013',Specification_Template__c=testSpec1.id);
              insert testSPI3;
         
          Spec_Item__c testSPI4=new Spec_Item__c(Name='Test Spec Item 0014',Specification_Template__c=testSpec1.id);
              insert testSPI4;
         
          Schedule_Template__c testST1=new Schedule_Template__c(Name='ST014',Media_Types__c=testMedia.Id);
              insert testST1;
          
          Schedule_Task__c testSchedule3=new Schedule_Task__c(Name='Test Schedule Task 014',Days__c=2,Schedule_Template__c=testST1.id);
              insert testSChedule3;   
           
          Schedule_Task__c testSchedule4=new Schedule_Task__c(Name='Test Schedule Task 015',Days__c=2,Schedule_Template__c=testST1.id);
              insert testSChedule4; 
           
          Job__c objJob=[Select id from Job__c where id=:testJob1.id];
             
          objJob.Specification_Template__c=testSpec1.id;
          objJob.Schedule_Template__c=testST1.id;
          objJob.Campaign__c = null;
          update objJob; 
    
         Delete testCampaign1;
          
         // ext.MTName = NULL;
          String MTName1 = ext.getMTName();
          ext.setMTName(MTName1);
          List<SelectOption> options6 = ext.getMediaTypes();
          result=ext.saveme();
          
          ext.ScheduleTemp = NULL;
          String ScheduleTemp1 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp1);
          List<SelectOption> options7 = ext.getScheduleTemplates();   
          result=ext.saveme();
          
          ext.MTName = testMedia.id;
          String MTName = ext.getMTName();
          ext.setMTName(MTName);
          List<SelectOption> options = ext.getMediaTypes(); 
          
         ext.ClientName = a.id;
          String ClientName = ext.getClientName();
          ext.setClientName(ClientName);
          List<SelectOption> options1 = ext.getClients(); 
          
          ext.CCName = c.Id;
          String CCName = ext.getCCName();
          ext.setCCName(CCName);
          List<SelectOption> options2 = ext.getClientContacts();
          
          ext.ScheduleTemp = testST.id;
          String ScheduleTemp = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp);
          List<SelectOption> options3 = ext.getScheduleTemplates(); 
          
         ext.CampaignName = testCampaign1.id;
          String CampaignName = ext.getCampaignName();
          ext.setCampaignName(CampaignName);
          List<SelectOption> options4 = ext.getCampaigns(); 
          
          ext.SpecTempName = testSpec.Id;
          String SpecTempName = ext.getSpecTempName();
          ext.setSpecTempName(SpecTempName);
          List<SelectOption> options5 = ext.getSpecificationTemplates();
     
          ext.ScheduleCalc= NULL;
          String ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
          List<SelectOption> options8 = ext.getScheduleCalcList();
          result=ext.saveme();
     
          result=ext.saveme();
          result=ext.saveme();
          result=ext.cancelme();
          
   
      }// End of Test Method */
}// End of Class