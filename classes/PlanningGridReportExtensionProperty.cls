public with sharing class PlanningGridReportExtensionProperty
{/*
    // Global variables
    private String soql{get;set;}  
    private List<Job__c> tempJobs;  
    public List<PropertyWrapper> pWrapper {get;set;}
    String strMakeList, strCampName, strStatus, strMediaType, strScheduleTemplate, strPriority, startDate1, compDate1, strClient, promoStartDate1, promoDueDate1,strProperty1 ;    
    Date dtStartDt1, dtCompDt1, dtPromoStartDt1, dtPromoDueDt1;
    public List<Job__c>  t2;
    public PropertyWrapper tmpwrapper;
    public Job__c twrap2;
    public boolean isTrue{get;set;}
    // End of Global variables
    
    // Start constructor
    public PlanningGridReportExtensionProperty()
    {
        isTrue = False; 
        pWrapper = new List<PropertyWrapper>();
    }  
    // End of constructor
       
    // This wrapper class is used to hold the property of searched Jobs
    class PropertyWrapper
    {
        public string strProperty{get;set;}
        public List<Job__c> jobWrapper{get;set;}
        public PropertyWrapper()
        {
            if(jobWrapper == NULL) {jobWrapper = new List<Job__c>();}
        }
    }
    // End of wrapper class PropertyWrapper
    
     
      // List to populate Schedule Templates
    public List<String> scheduleTempList
    {
        get{
            if(scheduleTempList == NULL)
            {
                scheduleTempList =  new List<String>();
                scheduleTempList.add('');
                for(Schedule_Template__c lstTemp : [Select Id, Name from Schedule_Template__c])
                {
                    scheduleTempList.add(lstTemp.Name);
                }
            }
            return scheduleTempList;
        }
        set;
    }
    // End of code to populate Schedule Templates
    
    // List to populate Campaigns
    public List<String> CampaignList
    {
        get{
            if(CampaignList == NULL)
            {
               CampaignList =  new List<String>();
               CampaignList.add('');
               for(Campaign__c lstCamp : [Select Id, Name from Campaign__c LIMIT 100])
                {
                    CampaignList.add(lstCamp.Name);
                }
            }
            return CampaignList;
        }
        set;
    }
    // End of code to populate Campaign
    
    
    
    
     // List to populate Status values for Jobs
    public List<String> jobStatus{
        get{
            if(jobStatus == NULL)
            {
                jobStatus = new List<String>();
                Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
             //   jobStatus.add('');
                for(Schema.PicklistEntry f : field.getPicklistValues())
                {
                    jobStatus.add(f.getLabel());
                }
            }
            return jobStatus;
        }
        set;
    }
    // End of code for populating Job Status values
    
    // List to populate Property values for Jobs
    public List<String> jobProperty{
        get{
            if(jobProperty== NULL)
            {
                jobProperty= new List<String>();
                Schema.DescribeFieldResult field = Job__c.Dummy_Picklist_1__c.getDescribe();
                jobProperty.add('');
                for(Schema.PicklistEntry f : field.getPicklistValues())
                {
                    jobProperty.add(f.getLabel());
                }
            }
            return jobProperty;
        }
        set;
    }
    // End of code for populating Job Property values
    
     // List to populate all Clients
    public List<String> clientList
    {
        get{
            if(clientList == NULL)
            {
                clientList = new List<String>();
                clientList.add('');
                for(Client__c lstClients : [Select Id, Name from Client__c Order BY Name])
                {
                    clientList.add(lstClients.Name);
                }
            }
            return clientList;
        }
        set;
    }
    // End of code to retrieve clientList
    
    // This method is called on to handle Search button
    public pagereference searchJobs()
    {
          isTrue = True;
          
          tempJobs = new List<Job__c>();
          pWrapper = new List<PropertyWrapper>();
         
        
          String s1, s2, s3, s4, strStartDt1, strCompDt1, strStartPromoDt1, strPromoDueDt1;
       
          strStatus = ApexPages.CurrentPage().getParameters().get('statusList');
          strProperty1 = ApexPages.CurrentPage().getParameters().get('PropertyList');
          strCampName = ApexPages.CurrentPage().getParameters().get('CampaignList');
          strClient = ApexPages.CurrentPage().getParameters().get('clientList');          
          strScheduleTemplate = ApexPages.CurrentPage().getParameters().get('scheduleTempList');
          startDate1 = ApexPages.currentPage().getParameters().get('startdt1');
          compDate1 = ApexPages.currentPage().getParameters().get('compdt1');
          promoStartDate1 = ApexPages.CurrentPage().getParameters().get('promoStartDt1');
          promoDueDate1 = ApexPages.CurrentPage().getParameters().get('promoDueDt1');
        
          System.debug('Campaign : '+strCampName);
          System.debug('Job Status : '+strStatus);
          System.debug('Schedule Template : '+strScheduleTemplate);
          System.debug('Client Name : '+strClient);
          System.debug('Start Date : '+startDate1);
          System.debug('Comp Date : '+compDate1);
          System.debug('Comp Date : '+promoDueDate1);
      System.debug('Property : '+strProperty1);
    
         Set<String> TaskName = new Set<String>();
         //TaskName.add('Submitted');
         TaskName.add('Brief');
         TaskName.add('Concept Review');
         TaskName.add('Script Review');
         TaskName.add('Rough Review 1');         
         TaskName.add('Final Approval');
         TaskName.add('Start Date');
    
        soql = 'Select Id, Name, Job_Description__c,Dummy_Text_5__c, Dummy_Text_4__c, Campaign__c, Start_Date__c, JS_Client__r.Name, Schedule_Template__r.Name, Status__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Date_1__c,Dummy_Date_2__c, Dummy_Picklist_2__c,Dummy_Picklist_1__c ,(Select Id,Name,Job__c,Start_Date__c,Revised_Due_Date__c from Job_Task__r where Name IN: TaskName Limit 5000) from Job__c where ';  
        
         if(!strStatus.equals(''))
              soql += ' Status__c LIKE \''+String.escapeSingleQuotes(strStatus)+'\'';       
         if(!strCampName.equals(''))
              soql += ' and Campaign__r.Name  LIKE \''+String.escapeSingleQuotes(strCampName)+'\'';               
         if(!strClient.equals(''))
              soql += ' and JS_Client__r.Name LIKE \''+String.escapeSingleQuotes(strClient)+'\'';           
         if (!strScheduleTemplate.equals(''))
              soql += ' and Schedule_Template__r.Name LIKE \''+String.escapeSingleQuotes(strScheduleTemplate)+'\'';   
        if(!strProperty1.equals(''))
              soql += ' and Dummy_Picklist_1__c LIKE \''+String.escapeSingleQuotes(strProperty1)+'\'';    
         if(!startdate1.equals('') && startdate1.length() >=8)
         {
              String[] st1=startdate1.split('/');
              Integer m1=Integer.valueOf(st1[0]);
              Integer d1=Integer.valueOf(st1[1]);
              Integer y1=Integer.valueOf(st1[2]);
              s1= y1 +'-'+ m1 +'-'+d1;
              dtStartDt1=Date.newInstance(y1,m1,d1);
              strStartDt1=String.valueOf(dtStartDt1);
              soql += ' and Start_Date__c = '+ String.valueOf(dtStartDt1)+' ';   
        }    
        if(!compdate1.equals('') && compdate1.length() >=8)
         {
              String[] st2=compdate1.split('/');
              Integer m1=Integer.valueOf(st2[0]);
              Integer d1=Integer.valueOf(st2[1]);
              Integer y1=Integer.valueOf(st2[2]);
              s2= y1 +'-'+ m1 +'-'+d1;
              dtCompDt1=Date.newInstance(y1,m1,d1);
              strCompDt1=String.valueOf(dtCompDt1);
              soql += ' and Completion_Date__c = '+ String.valueOf(dtCompDt1)+' ';   
        }    
        if(!promoStartDate1.equals('') && promoStartDate1.length() >=8)
         {
              String[] st3 = promoStartDate1.split('/');
              Integer m1=Integer.valueOf(st3[0]);
              Integer d1=Integer.valueOf(st3[1]);
              Integer y1=Integer.valueOf(st3[2]);
              s3= y1 +'-'+ m1 +'-'+d1;
              dtPromoStartDt1=Date.newInstance(y1,m1,d1);
              strStartPromoDt1=String.valueOf(dtPromoStartDt1);
              soql += ' and Dummy_Date_1__c = '+ String.valueOf(dtPromoStartDt1)+' ';   
        }    
        if(!promoDueDate1.equals('') && promoDueDate1.length() >=8)
         {
              String[] st4 = promoDueDate1.split('/');
              Integer m1=Integer.valueOf(st4[0]);
              Integer d1=Integer.valueOf(st4[1]);
              Integer y1=Integer.valueOf(st4[2]);
              s4= y1 +'-'+ m1 +'-'+d1;
              dtPromoDueDt1=Date.newInstance(y1,m1,d1);
              strPromoDueDt1=String.valueOf(dtPromoDueDt1);
              soql += ' and Due_Date__c = '+ String.valueOf(dtPromoDueDt1)+' ';   
        } 
       // soql +=' order by Dummy_Picklist_1__c, Name '; 
        soql +=' order by Dummy_Picklist_1__c, Dummy_Date_2__c '; 
        System.debug('Query is : ' + soql);  
        
     tempJobs = Database.query(soql);
     System.debug('Count = ' + tempjobs);
     string strPropertyNew;
     pWrapper = new List<PropertyWrapper>();
     t2 = new List<Job__c>();
     for(Job__c aa:tempjobs)
        {

        if (strPropertyNew != aa.Dummy_Picklist_1__c)
        {
            if (strPropertyNew != null)
            {                
                tmpwrapper.jobWrapper=t2;
                pWrapper.add(tmpwrapper);
            }
            tmpwrapper = new PropertyWrapper();
            tmpwrapper.strProperty= strPropertyNew = aa.Dummy_Picklist_1__c;
            t2 = new List<Job__c>();
        }        
        t2.add(aa);          
       }
        if (strPropertyNew != null)
        {
        tmpwrapper.jobWrapper=t2;
        pWrapper.add(tmpwrapper);
        }
        System.debug('pWraper : '+pWrapper);
        return NULL;
    }
    // End of search method
    
    // This method is called on to handle clearForm
        public pagereference clearForm()
        {
            isTrue = False;
            pWrapper = new List<PropertyWrapper>();
            return NULL;
        }
    // End of method clearForm
    
     // This method is called on to pass filter criterias to generate PDF for this Report
    public pagereference exportToPDF()
    {
         PageReference pageRef = Page.ExportPlanningGridReportNew;
         pageRef.getParameters().put('jobStatus',strStatus);
         pageRef.getParameters().put('CampName',strCampName);
         pageRef.getParameters().put('strClient',strClient);
         pageRef.getParameters().put('startdate',startDate1);
         pageRef.getParameters().put('compdate',CompDate1);        
         pageRef.getParameters().put('strScheduleTemplate',strScheduleTemplate);
         pageRef.getParameters().put('logforairdate',promoStartDate1);
         pageRef.getParameters().put('DueDate',promoDueDate1);
         pageRef.getParameters().put('Property',strProperty1);
         return PageRef;
     }  
     
     // End of method exportToPDF
   
   //Test Method 
   static testMethod void Test_PlanningGridReportExtensionProperty()
   {
      Media_Type__c objMedia = new Media_Type__c (Name = 'Test Media type-00001');
      insert objMedia;
      
      Schedule_Template__c objSchedule = new Schedule_Template__c(Name = 'Test Schedule Template-00001', Media_Types__c = objMedia.id);
      insert objSchedule;
      
      Campaign__c objCampaign = new Campaign__c(Name = 'Test Campaign -00001');
      insert objCampaign;
      
      GL_Department__c objGLDept = new GL_Department__c(Name = 'Test GL dept - 00001');
      insert objGLDept;
      
      GL_Code__c objGLCode = new GL_Code__c(Name = 'Test GL Code - 00001', GL_Department__c  = objGLDept.id, GL_ID__c = '00001');
      insert objGLCode ;
      
            
      Client__c objClient=new Client__c(Name='Test Client 0001');
      insert objClient;
               
      Client_Contact__c objClientContact=new Client_Contact__c(Name='Test Client Contact',First_Name__c='Test Client Contact',Last_Name__c='00001',Client__c= objClient.id,Email__c='test0001@SFDC.com');
      insert objClientContact;    
      
      
      Job__c objJob1 = new Job__c(Name= 'Test Job - 00001', Media_Types__c= objMedia.Id, Schedule_Template__c = objSchedule.id, Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,JS_Client_Contact__c =objClientContact.id,Start_Date__c = System.Today(),Job_Auto_Number__c = '00001');
      insert objJob1 ;
               
      System.assertEquals('Test Job - 00001',objJob1.Name);   
      
      Job_Task__c objTask1 = new  Job_Task__c(Name = 'Test Job Task1 - 00001', GL_Code__c = objGLCode.id, Days__c = 2,Job__c = objJob1.id);
      insert objTask1;
      
      Job_Task__c objTask2 = new  Job_Task__c(Name = 'Test JobTask2 - 00001', GL_Code__c = objGLCode.id, Days__c = 4,Job__c = objJob1.id);
      insert objTask2;      
      
      
      PlanningGridReportExtensionProperty ext = new PlanningGridReportExtensionProperty();
      List<String> lstCampaign = ext.CampaignList;
      List<String> lstActive = ext.jobStatus;
      List<String> lstClient = ext.clientList;
      List<String> lstScheduleTemplate = ext.scheduleTempList;
      List<String> lstProperty = ext.jobProperty;
      
      Schema.DescribeFieldResult field = Job__c.Dummy_Picklist_1__c.getDescribe();
                
      for(Schema.PicklistEntry f : field.getPicklistValues())
     {
          lstProperty.add(f.getLabel());
     }
     string  strselectedProperty = lstProperty[0];
    // string strDate = zConvert.ToString(System.Today());
          ApexPages.CurrentPage().getParameters().put('CampaignList',objCampaign.Name);
          ApexPages.CurrentPage().getParameters().put('PropertyList',strselectedProperty );
          ApexPages.CurrentPage().getParameters().put('clientList',objClient.Name);
          ApexPages.CurrentPage().getParameters().put('statusList','Active');
          ApexPages.CurrentPage().getParameters().put('scheduleTempList',objSchedule.Name);
          ApexPages.currentPage().getParameters().put('startdt1',Datetime.now().format('MM/dd/yyyy'));
          ApexPages.currentPage().getParameters().put('compdt1', Datetime.now().format('MM/dd/yyyy'));
          ApexPages.CurrentPage().getParameters().put('promoStartDt1',Datetime.now().format('MM/dd/yyyy'));
          ApexPages.CurrentPage().getParameters().put('promoDueDt1',Datetime.now().format('MM/dd/yyyy'));
      
         ApexPages.Pagereference result1 = ext.searchJobs();
          
         result1 = ext.exportTOPDF();
         
    
      
      List<Job__c> objJobs = new List<Job__c>();
      objJobs.add(objJob1); 
      PropertyWrapper pWrapper = new PropertyWrapper ();
      pWrapper.strProperty=strselectedProperty ;
      pWrapper.jobWrapper = objJobs;
      
       ApexPages.Pagereference result2 =ext.clearForm();
      
   }*/
    
} // End of class