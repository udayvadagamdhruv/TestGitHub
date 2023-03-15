// This class is used to create New Job
public with sharing class createNewJobExtensionNew 
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
    public String SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid,ScheduleType,ScheduleCalc;
    
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
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
    
    private final Job__c vq;
    public boolean displayClient_Contact{get;set;}
    
    public string strCampaignName{get;set;}
    public string cmpName{get;set;}
    public Id idCampaign;
//added by rahul on 30th April 2014    
    public String orgId{get; set;}
    
    public boolean ShowNotrequiredJob{get;set;}
    public boolean ShowNotReScheduleJob{get;set;}
    
    public Campaign__c CampCreate{get;set;}
//Addd code ends here    

    // Start Constructor
    
    
    public String startDate{get; set;}
    public String calDate{get; set;}
    public createNewJobExtensionNew(ApexPages.StandardController controller) 
    {
        //added this code by rahul on 30th April 2014 
        orgId = UserInfo.getOrganizationId();
        system.debug('org id --------->'+orgId);
       // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.info,''+orgId ));
        //Added code ends here
      
       
       ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
       ShowNotrequiredJob =activeSettings.Remove_Required_of_Job_name__c;
       ShowNotReScheduleJob=activeSettings.Recalculate_Schedule_Job__c;
       // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.info,''+activeSettings ));
       
        this.vq=(Job__c)controller.getRecord();
    
    
    //added this code by rahul on 30th April 2014         
        if(orgId == '00DG0000000k48JMAQ' || orgId == '00DJ000000371J9MAI'){
            this.vq.name = string.valueof(system.today());
        }
    //Added code ends here
        
        system.debug('In constructor');
        
        // Code to hide Client and Client Contact field from Logged in User who is client contact
        Id profileId = UserInfo.getProfileId();
       
        //code sction added by sushma 26 july for setting the campaign id to the list of the selected campaign
        idCampaign = ApexPages.CurrentPage().getParameters().get('Campaign');
        CampaignName = idCampaign ;
        system.debug('Campaing is....'+campaignName);
        if(CampaignName != null)
        {
              Campaign__c obj =  [SELECT Id, name FROM Campaign__c where Id =:CampaignName];
              cmpName = obj.Name;
        }
        
     
        Profile p = [Select Id, Name from Profile where Id =: profileId];

        if(p.Name == 'Client Contact' || p.Name == 'SP Client Contact')
        {
            displayClient_contact = False;
        //code only if the org is hd    
        if(UserInfo.getOrganizationName() == 'Healthy Directions')   
         this.vq.Schedule_Calc__c = 'End Date';
        }
        else
        {
        
            displayclient_contact = True;
        }
        // End hide Client and Client Contact field from Logged in User who is client contact
        
        
         if(ShowNotReScheduleJob==true)
        {
            vq.UpdateSchedDateFieldCheck__c=true;
            System.debug('>>>>>>>>>>>>>>>>>>>UpdateSchedDateFieldCheck__c>>>>>>>>>>>>>'+vq.UpdateSchedDateFieldCheck__c);
        }
        else
        {
             vq.UpdateSchedDateFieldCheck__c=false;
             
              System.debug('****************************UpdateSchedDateFieldCheck__c******************************'+vq.UpdateSchedDateFieldCheck__c);
        }
        
        
        startDate = ApexPages.CurrentPage().getParameters().get('startDate');
        calDate = ApexPages.CurrentPage().getParameters().get('CalDate');
        if(startDate != null && startDate != ''){
            this.vq.Schedule_Calc__c = 'Start Date';
            this.vq.Start_Date__c = date.parse(startDate.replace('-','/'));
            //this.vq.Start_Date__c = Date.valueof(DateTime.newInstance(Integer.valueof(startDate.split('-')[2]),Integer.valueof(startDate.split('-')[1]),Integer.valueof(startDate.split('-')[0])).format('dd/MM/YYYY'));
        }
    }
    // End of Constructor

    // This method is called on to handle cancel button
    public pagereference cancel()
    {
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
         Pagereference pg1;
        if(usrProfileName.toLowerCase() == 'sp client contact')
        {
           pg1 = new Pagereference('/home/home.jsp');
        }
        else
        {
           //pg1 = new Pagereference('/apex/JobsTabOverride');
           Schema.DescribeSObjectResult r = Job__c.sObjectType.getDescribe();
           String keyPrefix = r.getKeyPrefix();
           pg1 = new Pagereference('/'+keyPrefix);
          // pg1= new Pagereference('/lightning/page/home');
        }
       // Pagereference pg1=new Pagereference('/apex/JobsTabOverride');
       
        pg1.setRedirect(true);
        return pg1;
    }
    public pagereference cancelCal()
    {
        Pagereference pg1;
        pg1 = new Pagereference('/apex/Calendars?calDate='+caldate);   
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
       // && (orgId == '00DE0000000ZEOuMAO' || orgId == '00D0U0000000Q7wUAE') for NBC CC 
      
           if(isLtng || orgId == '00DE0000000ZEOuMAO' || orgId == '00D0U0000000Q7wUAE' || orgId == '00D3F0000004b48UAA')
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
         optionList.add(new selectOption('CreateNewRecord', 'Create New Campaign'));  
        
      /*  if(isLtng)
        {
           
              
        } */
        
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c where Status__c='Active' order by Name]) 
        {         
            optionList.add(new selectOption(a.Id, a.Name)); 
            
        }
     
        return optionList;  
    }
    public boolean isPopup {set;get;}
    
    public void campaignnew()
    {
      CampCreate = new Campaign__c();
      if(CampaignName=='CreateNewRecord'){
      isPopup=true;
      CampCreate.Status__c='Active';
      }
      else{
      isPopup=false;
      }
    }
    
    
    public void cmpcancel()
    {
        isPopup=false;
    }
    public void cmpsave()
    {
       try
       {
           if(CampCreate.Name==null)
           {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must Enter Campaign Name');
              ApexPages.addMessage(myMsg);      
           
           }
           else
           {
              insert CampCreate;
              
              CampaignName=CampCreate.id;
              isPopup=false;
           }
       }
        
      catch(System.DMLException e)
      {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
         ApexPages.addMessage(myMsg);
          //return null;
      }
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
       /*** if(MTName == null)
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
        }****/
        
         System.debug('Start Date ' + this.vq.Start_Date__c);
         System.debug('Start Date ' + ScheduleCalc );
         
           if(this.vq.Schedule_Calc__c == null)
            {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must select the Schedule Calculation value ');
              ApexPages.addMessage(myMsg);              return null;
            }
        //condition added if the start date is selected and the start date value is blank
         if(this.vq.Schedule_Calc__c == 'Start Date' && this.vq.Start_Date__c == null)
            {
              System.debug('in error 1');
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Start Date Value');
              ApexPages.addMessage(myMsg);               return null;
            }
            
            System.debug('End Date' + this.vq.Due_Date__c);
        //condition added if the end date is selected and the due date value is blank
         if(this.vq.Schedule_Calc__c == 'End Date' && this.vq.Due_Date__c == null)
            {
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Due Date Value');
               ApexPages.addMessage(myMsg);                return null;
            }
             if(this.vq.Schedule_Calc__c == 'End Date' && this.vq.Due_Date__c == null)
            {
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Due Date Value');
               ApexPages.addMessage(myMsg);                return null;
            }
            
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
            Id profileId = UserInfo.getProfileId();
            Profile p=[Select Id,Name from Profile where Id=: profileId LIMIT 1];
            if(p.Name=='Client Contact' || p.Name=='SP Client Contact')
            {
                  Client_Contact__c c=[Select Id, Name, Client__c, Email__c From Client_Contact__c where UserName__c =: UserInfo.getUserName() LIMIT 1]  ;
                 // Client_Contact__c c=[Select Id, Name, Client__c, Email__c From Client_Contact__c where Email__c =: UserInfo.getUserName() LIMIT 1]  ;
                  vq.JS_Client__c=c.Client__c;
                  vq.JS_Client_Contact__c=c.Id;
            }
            else
            {
                vq.JS_Client__c=ClientName;
                vq.JS_Client_Contact__c=CCName;
           
            }
            //    vq.Client__c=ClientName;
            //    vq.Client_Contact__c=CCName;
           vq.Media_Types__c=MTName;
           vq.Schedule_Template__c=ScheduleTemp;
           vq.Campaign__c=CampaignName;
           vq.Specification_Template__c=SpecTempName;
           String jbName;
           if(orgId == '00DG0000000k48JMAQ' || orgId == '00DJ000000371J9MAI')
           {
               jbName = '';
               if(CampaignName != null){
                   Campaign__c objCmp =  [SELECT Id, name FROM Campaign__c WHERE Id =: CampaignName];
                   jbName += objCmp.Name + ' ';
               }
               if(ScheduleTemp != null){
                   Schedule_Template__c objST = [SELECT Id,Name FROM Schedule_Template__c WHERE Id =: ScheduleTemp];
                   jbName += objST.Name + ' ';
               }
               jbName += String.valueOf(System.today().year());
               vq.name = jbName;
           }
           
           system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+vq.name);
           insert vq;
           strid=vq.Id;
           
           
       
           
           
           
       }
     }
      catch(System.DMLException e)
      {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
         ApexPages.addMessage(myMsg);
          return null;
      }
      PageReference p;
      
            if(isMob)
            {
                 p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+strid);
                 
            }
            
            else if(isLtng)
            {
                 p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strid);
                  
            }
            else
            {
                p =  new Pagereference('/apex/jobListView?id='+strid+'&intFocus=1');
                    
            }
      
      
      if(cmpName != null)
      {
          system.debug('Id IZZZZZZZZ'+idCampaign);
          p = new PageReference('/apex/DetailCampaignSwitch?id='+idCampaign);
      }
      p.setRedirect(true);
      return p;
}




public PageReference savemecal()
    {
    try
      {
       /*** if(MTName == null)
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
        }****/
        
         System.debug('Start Date ' + this.vq.Start_Date__c);
         System.debug('Start Date ' + ScheduleCalc );
         
           if(this.vq.Schedule_Calc__c == null)
            {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must select the Schedule Calculation value ');
              ApexPages.addMessage(myMsg);
              return null;
            }
        //condition added if the start date is selected and the start date value is blank
         if(this.vq.Schedule_Calc__c == 'Start Date' && this.vq.Start_Date__c == null)
            {
              System.debug('in error 1');
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Start Date Value');
              ApexPages.addMessage(myMsg);               return null;
            }
            
            System.debug('End Date' + this.vq.Due_Date__c);
        //condition added if the end date is selected and the due date value is blank
         if(this.vq.Schedule_Calc__c == 'End Date' && this.vq.Due_Date__c == null)
            {
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Due Date Value');
               ApexPages.addMessage(myMsg);                return null;
            }
             if(this.vq.Schedule_Calc__c == 'End Date' && this.vq.Due_Date__c == null)
            {
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Due Date Value');
               ApexPages.addMessage(myMsg);                return null;
            }
            
            if(MTName == null)
            {
                String stringMTName = Schema.Job__c.fields.Media_Types__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMTName+' : You must select a '+stringMTName+'.');
                ApexPages.addMessage(myMsg);                return null;
            }
            if(ScheduleTemp == null)
            {
                String strSchedule = Schema.Job__c.fields.Schedule_Template__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select a '+strSchedule);
                ApexPages.addMessage(myMsg);                return null;
            }
            
       else
       {  
            Id profileId = UserInfo.getProfileId();
            Profile p=[Select Id,Name from Profile where Id=: profileId LIMIT 1];
            if(p.Name=='Client Contact' || p.Name=='SP Client Contact')
            {
                  Client_Contact__c c=[Select Id, Name, Client__c, Email__c From Client_Contact__c where UserName__c =: UserInfo.getUserName() LIMIT 1]  ;
                 // Client_Contact__c c=[Select Id, Name, Client__c, Email__c From Client_Contact__c where Email__c =: UserInfo.getUserName() LIMIT 1]  ;
                  vq.JS_Client__c=c.Client__c;
                  vq.JS_Client_Contact__c=c.Id;
            }
            else
            {
                vq.JS_Client__c=ClientName;
                vq.JS_Client_Contact__c=CCName;
           
            }
            //    vq.Client__c=ClientName;
            //    vq.Client_Contact__c=CCName;
           vq.Media_Types__c=MTName;
           vq.Schedule_Template__c=ScheduleTemp;
           vq.Campaign__c=CampaignName;
           vq.Specification_Template__c=SpecTempName;
           String jbName;
           if(orgId == '00DG0000000k48JMAQ' || orgId == '00DJ000000371J9MAI')
           {
               jbName = '';
               if(CampaignName != null){
                   Campaign__c objCmp =  [SELECT Id, name FROM Campaign__c WHERE Id =: CampaignName];
                   jbName += objCmp.Name + ' ';
               }
               if(ScheduleTemp != null){
                   Schedule_Template__c objST = [SELECT Id,Name FROM Schedule_Template__c WHERE Id =: ScheduleTemp];
                   jbName += objST.Name + ' ';
               }
               jbName += String.valueOf(System.today().year());
               vq.name = jbName;
           }
           
           system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+vq.name);
           insert vq;
           strid=vq.Id;
           
           
       
           
           
           
       }
     }
      catch(System.DMLException e)
      {
         // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
         // ApexPages.addMessage(myMsg);
          return null;
      }
      PageReference p;
      
            
                 p =  new Pagereference('/apex/Calendars?calDate='+caldate);
                 
          
      p.setRedirect(true);
      return p;
}


 /* // Test Method for Job 
 static testMethod void Test_createNewJobExtensionNew()
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
                
          Job__c testJob1=new Job__c(Name='Job002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
             
          ApexPages.StandardController con=new ApexPages.StandardController(testjob1);
          createNewJobExtensionNew ext=new createNewJobExtensionNew(con);
 
          ext.MTName = NULL; // To check MediaType as NULL
          String MTName2 = ext.getMTName();
          ext.setMTName(MTName2);
          List<SelectOption> options7 = ext.getMediaTypes(); 
          
          ext.ScheduleTemp = testST.id;
          String ScheduleTemp1 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp1);
          List<SelectOption> options8 = ext.getScheduleTemplates();  
          
          
          String ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
          List<SelectOption> options11 = ext.getScheduleCalcList();
          
          ApexPages.Pagereference result=ext.saveme();
          
          ext.MTName = testMedia.id;
          String MTName1 = ext.getMTName();
          ext.setMTName(MTName1);
          List<SelectOption> options9 = ext.getMediaTypes(); 
          
          ext.ScheduleTemp = NULL; // To Check Schedule Template as NULL
          String ScheduleTemp2 = ext.getScheduleTemp();
          ext.setScheduleTemp(ScheduleTemp2);
          List<SelectOption> options10 = ext.getScheduleTemplates();  
          
          ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
          List<SelectOption> options12 = ext.getScheduleCalcList();
            
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
          
          
          ScheduleCalc1= ext.getScheduleCalc();
          ext.setScheduleCalc(ScheduleCalc1);
           options11 = ext.getScheduleCalcList();
          
          result=ext.saveme();  
          
          System.assertEquals('Job002',testJob1.Name);
          
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
        
         Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Job002'];
         obj1.Status__c='Cancelled';
         update obj1;

         Job__c obj2=[Select id from Job__c where Name=: 'Job002'];
         delete obj2;
         result=ext.saveme();
         result=ext.cancel();
       }     
       // End of Test Method */
}
// End of Class