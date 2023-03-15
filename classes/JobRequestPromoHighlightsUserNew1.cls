public with sharing class JobRequestPromoHighlightsUserNew1
{
    // Global variables
    Media_Type__c MType = new Media_Type__c();
    public List<JobWrapper> wrappers{get;set;}
    public List<JobWrapper> wrappers2{get;set;}
    public List<JobWrapper> wrappers3{get;set;}
    public static Integer toDelIdent {get;set;}
    public static Integer addCount{get;set;}
    private Integer nextIdent = 0;
    
    String MTName, ScheduleTemp,ClientName,CCName, SpecTempName, strClientContact, CampaignName, makeListName, priorityListName;
    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
 /*   public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
    public String getCCName() {  return CCName; }
    public void setCCName(String s) {  this.CCName = s; } */
    
    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }
    
    public String getCampaignName() { return CampaignName; }
    public void setCampaignName(String s) {  this.CampaignName = s; }
    
    public String getMakeListName() {return makeListName;}
    public void setMakeListName(String s) {this.makeListName = s;}
    
    public String getpriorityListName() {return priorityListName;}
    public void setpriorityListName(String s) {this.priorityListName = s;}
    
    public String message{get;set;}
  
    // End of Global variables
    
    
    // Wrapper class
    public class JobWrapper
    {
        public Job__c objJob{get;set;}
        public boolean isSelected {get;set;}
        public Integer ident{get;set;}
        public String media{get;set;}
        public String specificationTemplate{get;set;}
  //      public String client{get;set;}
        public String priority{get;set;}
        public String mediaError{get;set;}
        public String nameError{get;set;}
        public String startDateError{get;set;}  
         
         private Media_Type__c MType = new Media_Type__c();
 //      public JobWrapper(Integer indent, String m1, String s1, String c1, String p1)
        public JobWrapper(Integer indent, String m1, String s1, String p1)
        {    
            ident = indent;
            isSelected = false;
            //media = m1;
          //code commented by sushma for setting the media type 26 july
          //media = 'On Air';
          MType = [select id,Name from Media_Type__c where Name =: 'On Air' Limit 1];
          media = MType.Id;
        
            
            specificationTemplate = s1;
 //           client = c1;
            priority = p1;
           
            mediaError='';
            nameError ='';
            startDateError = '';
         
  //          objJob = new Job__c(Media_Types__c = media, Specification_Template__c = specificationTemplate, Client__c = client, Dummy_Picklist_2__c = priority);
            objJob = new Job__c(Media_Types__c = media, Specification_Template__c = specificationTemplate, Dummy_Picklist_2__c = priority);
        }
        public JobWrapper(Integer indent)
        {
            System.debug('In constructor');
            ident = indent;
            objJob = new Job__c();
         //code added by sushma for setting the media type 26 july  
          MType = [select id,Name from Media_Type__c where Name =: 'On Air' Limit 1];
          media = MType.Id;
         
        }
       
  //      public JobWrapper(Integer indent,Job__c j, String me, String mError, String nError, String cli, String pri)
        public JobWrapper(Integer indent,Job__c j, String me, String mError, String nError, String pri)
        {
           ident = indent; 
           objJob = j;
           
           nameError = nError;
           if(me!=NULL)
           {
               mediaError ='';
           }
           else
           { 
               mediaError = mError;
           }
           priority = pri;
   //        client = cli;
        
           
           //   media = me;
          MType = [select id,Name from Media_Type__c where Name =: 'On Air' Limit 1];
          media = MType.Id;
    
           
        }
    }
    // End of Wrapper class
    
    // Start constructor
    Client_contact__c cc = new Client_Contact__c();
    public JobRequestPromoHighlightsUserNew1()
    {
        wrappers = new List<JobWrapper>();
        wrappers2 = new List<JobWrapper>();
        wrappers3 = new List<JobWrapper>(); 
        
        cc=[Select Id, Name, Client__c, Email__c From Client_Contact__c where Email__c =: UserInfo.getUserName() LIMIT 1];
        
       // MType = [select id,Name from Media_Type__c where Name =: 'On Air' Limit 1];
       //MTName = MType.id;
        
       /*
        for(Integer idx = 0; idx <1 ; idx++)
        {
            wrappers.add(new JobWrapper(nextIdent++));
        }
        */
    }
    // End of constructor
    
    // This method is used to add one Job row
     public void addRows()
    {
        message ='';
       for(Integer idx = 0; idx < addCount ; idx++)
        {
            wrappers.add(new JobWrapper(nextIdent++));
        }
    }
    // End of method addRows
    
   // This method is used to delete Job row 
   public void delWrapper()
   {
        message = '';
        System.debug('toDelIdent@@@'+toDelIdent);
        
        Integer toDelPos = -1;
        for(Integer idx = 0; idx < wrappers.size() ; idx++)
        {
            if(wrappers[idx].ident == toDelIdent)
            {
                toDelPos = idx;
            }
        }
        if(-1 != toDelPos)
        {
            wrappers.remove(toDelPos);
        }
    }
    // End of method delWrapper
    
   // This method is called on to save each Job request
    public pagereference saveJobs()
    {
       
       message = 'Created Jobs:';
       wrappers2 = new List<JobWrapper>();
       for (JobWrapper wrap : wrappers)
        {
               List<Job__c> lstJob = new List<Job__c>(); 
             //Commented by vrushali - 23/Jul/2012  wrappers3 = new List<JobWrapper>(); 
           
               if(wrap.media == NULL || wrap.media == null)
               {
                   wrap.mediaError = 'Please select Media Type';
                   wrap.objJob.Media_Types__c = wrap.media;
                   System.debug('@@@@@@@@@@@ : '+wrap.media);
                   wrap.isSelected = False;
               }
               else
               {
                   wrap.objJob.Media_Types__c = wrap.media;
                   System.debug('@@@@@@@@@@@ : '+wrap.media);
                   wrap.objJob.Specification_Template__c = wrap.specificationTemplate;
             //      wrap.objJob.JS_Client__c = wrap.client;
                   wrap.objJob.Campaign__c = CampaignName;
                   wrap.objJob.Dummy_Picklist_1__c = makeListName;
            //       wrap.objJob.Dummy_Picklist_2__c = priorityListName;
                   
                   if(cc != null)
                   {
                   wrap.objJob.JS_Client__c = cc.Client__c;
                   wrap.objJob.JS_Client_Contact__c = cc.id;
                   }
                   
                   wrap.objJob.Dummy_Picklist_2__c = wrap.priority;
                 //Commented by Vrushali - 23/Jul/2012  lstJob.add(wrap.objJob);
                   try
                    {
                    System.debug('wrapper data '+wrap.objJob);
//Commented by Vrushali - 23/Jul/2012                         insert lstJob; 
                        insert wrap.objJob; 
                        delayMethod();                   
                        message += wrap.objJob.Name+', ';                                     
                        wrap.isSelected = True;
                        
                    }
                   catch(Exception e)
                   {
                     System.debug('err '+e);
                       wrap.isSelected = False;
                       wrappers2.add(new JobWrapper(wrap.ident,wrap.objJob,wrap.media,wrap.mediaError,wrap.nameError,wrap.priority));
                        ApexPages.addMessages(e);
                         message += e +', '; 
                       // str = 'Whoops! An error occurred -- ' + e.getMessage();      
                   }
               }    
               System.debug('Job@@@ '+lstJob);
                
               
        }
        
        //Commented by Vrushali - 23/Jul/2012 - start
      /*  wrappers2 = new List<JobWrapper>();
       
        for (JobWrapper wrap1 : wrappers)
        {    
             if(wrap1.isSelected == False)
             {
                     //  wrappers2.add(new JobWrapper(wrap1.ident,wrap1.objJob,wrap1.media,wrap1.mediaError,wrap1.nameError,wrap1.Client, wrap1.priority));
                     wrappers2.add(new JobWrapper(wrap1.ident,wrap1.objJob,wrap1.media,wrap1.mediaError,wrap1.nameError,wrap1.priority));
             }
             else if(wrap1.isSelected = True)
             {            
                        message += wrap1.objJob.Name+', ';                                     
           }


        } */
        wrappers = new List<JobWrapper>();
        wrappers = wrappers2;
                //Commented by Vrushali - 23/Jul/2012 - End
        System.debug('wrappers @@@@ '+wrappers);
        return NULL;
    }
    // End of method save
    
    //function for the delay in the function
    public void delayMethod()
    {
    Integer start = System.Now().millisecond();
     // while(System.Now().millisecond()< start+20){ 
     //                   }
     for (Integer i=0; i <10; i++)
     {
     }
    }
    
    // This method is called on to handle Cancel button
    public pagereference cancel()
    {
        Pagereference pg = new Pagereference('/home/home.jsp');
        pg.setRedirect(true);
        return pg;
    }
    // End of method Cancel
    
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
   //     optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, Name FROM Media_Type__c order by Name]) 
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
    
        // This method is called on to retrieve All the Clients
 /*     public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }  */
    // End of method getClients
    
     // This method is called on to retrieve Client Contacts
     public List<selectOption> getClientContacts()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Client_Contact__c r : [SELECT Id,Name FROM Client_Contact__c where Client__c =: Clientname order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    // End of method getClientContacts
    
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
    
       public List<selectOption> getCampaigns() 
    {
        List<selectOption> optionList = new List<selectOption>();
    //    optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c a : [SELECT Id, Name FROM Campaign__c where Status__c='Active' order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
      // List to populate Make List values for Jobs
    public List<SelectOption> getMakeList()
    {
        List<SelectOption> optionList = new List<SelectOption>();
   //     optionList.add(new selectOption('','- None -'));
        Schema.DescribeFieldResult field = Job__c.Dummy_Picklist_1__c.getDescribe();
                
                for(Schema.PicklistEntry f : field.getPicklistValues())
                {
                    optionList.add(new selectOption(f.getLabel(),f.getLabel()));
                }
                return optionList;
     }
     
    // End of code for populating Make List values
    
      // List to populate Make List values for Jobs
    public List<SelectOption> getPriorityList()
    {
        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new selectOption('','- None -'));
        Schema.DescribeFieldResult field = Job__c.Dummy_Picklist_2__c.getDescribe();
                
                for(Schema.PicklistEntry f : field.getPicklistValues())
                {
                    optionList.add(new selectOption(f.getLabel(),f.getLabel()));
                }
                return optionList;
     }
    // End of code for populating Make List values
    
    
    //test method added by sushma 26 july
   static testMethod void Test_JobRequestPromoHighlightsUserNew1()
    {                
           Media_Type__c testMedia=new Media_Type__c(Name='On Air');
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
          
     // Profile p = [SELECT Id FROM Profile WHERE Name='SP Client Contact']; 
    //  User u = new User(Alias = 'standt', Email='testEmail001@sfdc.com', 
     // EmailEncodingKey='UTF-8', LastName='LN001', LanguageLocaleKey='en_US', 
     // LocaleSidKey='en_US', ProfileId = p.Id, 
     // TimeZoneSidKey='America/Los_Angeles', UserName='testEmail001@sfdc.com');
User u = [select id,name from User where username =: c.UserName__c limit 1];
//code that runs as the client contact
      System.runAs(u)
    {         
         // ApexPages.StandardController con=new ApexPages.StandardController();
          JobRequestPromoHighlightsUserNew1 ext=new JobRequestPromoHighlightsUserNew1();
           System.assertEquals('Job001',testJob1.Name);
           ext.saveJobs();
         
         
      List<SelectOption> lstMediaTypes = ext.getMediaTypes();
      List<SelectOption> lsScheduleTemplates = ext.getScheduleTemplates();
      List<SelectOption> lstClientContacts = ext.getClientContacts();
      List<SelectOption> lstSpecificationTemplates = ext.getSpecificationTemplates();
      List<SelectOption> lstCampaigns = ext.getCampaigns();
      List<SelectOption> lstMakeList = ext.getMakeList();
      List<SelectOption> lstPriorityList = ext.getPriorityList();
      
 ext.setMTName('On Air');
 ext.setpriorityListName('A');
 ext.setMakeListName('May 2012');
 ext.setSpecTempName(testSpec.Name);
 ext.setSpecTempName(testSpec.Name);
 //ext.setCampaignName(testCampaign1.Name);
 
 String MediaName =  ext.getMTName();
 String priorityListName =  ext.getpriorityListName() ;
 String MakeListName =  ext.getMakeListName() ;
 String SpecTempName =  ext.getSpecTempName() ;
  String CampaignName =  ext.getCampaignName() ;
  String ScheduleTemp = ext.getScheduleTemp();
 //ext.CampaignName = testCampaign1.Name;
 
 Specification_Template__c  JSpec = [Select id,Name from Specification_Template__c limit 1];

         addCount  = 1;
         ext.addRows();
         ApexPages.Pagereference result1 = ext.cancel();
         addCount  = 5;
         ext.addRows();
         toDelIdent =1;
         ext.delWrapper();
         
           Job__c testJob2=new Job__c(Name='Job002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
           Job__c testJob3=new Job__c(Name='Job003',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
   
    Schema.DescribeFieldResult field = Job__c.Dummy_Picklist_2__c.getDescribe();
                
      for(Schema.PicklistEntry f : field.getPicklistValues())
     {
          lstPriorityList .add(new selectOption(f.getLabel(),f.getLabel()));
     }
   //string  strselectedPriority = ;

         
      
           JobWrapper jbWrapper2 = new JobWrapper(2,testJob2,'','','','');
            ext.saveJobs();
            ext.delayMethod();
           JobWrapper jbWrapper1 = new JobWrapper(1,'',JSpec.Id,priorityListName);
              ext.saveJobs();
          // JobWrapper jbWrapper3 = new JobWrapper(2,testJob3,'','','','');
        // List<JobWrapper> lstWrapper = new List<JobWrapper>();
        // lstWrapper.add(jbWrapper2);
         //lstWrapper.add(jbWrapper3);
        
   }
          
          //result1 = ext.searchJobsandTags();          
          //result1 = ext.exportToPdf();
          
          /*  for(Campaign__c camp : [select id,Name from Campaign__c Order By Name Limit 100])
                 {
                 ext.campaignList.add(camp.Name);     
                 } */    
         
    }
    
    
}// End of class