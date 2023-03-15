public with sharing class JobdetailpageLightening07Extension {
    Public job__c jj{get;set;}
    public Boolean isNotesEditable {get;set;}
    public void editNotes(){
        isNotesEditable=true;
    }
    
    public pagereference saveNotes(){
        update jj;
        isNotesEditable =false;
       pagereference p = new pagereference('/apex/JobdetailpageLightening07?id='+jj.id+'&section=JobNotes&status=true');
       p.setredirect(true);
       return p;
      
      
    }
    
    public PageReference CancelNotes(){
    isNotesEditable = false;
    pagereference p = new pagereference('/apex/JobdetailpageLightening07?id='+jj.id+'&status=true');
    p.setredirect(true);
    return p;
      
    }
    
    //public string errormsgid {get;set;}
    //public string errormsg {get;set;}
  
    
    public String orgId{get; set;}
    public List<Job_Team__c> lstJobTeam{get;set;}
    public String jobId{get;set;}
    public string tab {get;set;}
    public string section {get;set;}
    public Integer count {get;set;}
    public decimal count1 {get;set;}
    public Decimal CC{get;set;}
    public Decimal TC{get;set;}
    public String strOrganizationName{get; set;}
    public boolean ShowProductionEstimate{get;set;}
    public boolean ShowEmailListviewSection{get;set;}
    public boolean spClientChatterFeedCheck{get;set;}
    public boolean spClientChatterFeedCheckVF{get;set;}  
    public boolean ShowoldTimesheetflow{get;set;}
    public boolean ShowJobTimeTab{get;set;}
    Public boolean ShowShipmentTab{get;set;}
    
    public String graphicsValue{get;set;}
    public String sessionValue{get;set;}
    public String tagValue{get;set;}
    public String musicValue{get;set;}
    public boolean checkedSFUser{get;set;}
    public string testString{get;set;}
    
    
    public List<Tool_Tip__c> TTP{get;set;}
    public String JobTeam{get;set;}
    public String Schedule{get;set;}
    public String JobSpecs{get;set;}
    
    
    public JobdetailpageLightening07Extension(ApexPages.StandardController controller) 
    {
         isNotesEditable = false;
         this.jj=(job__c)controller.getrecord();
         orgId = UserInfo.getOrganizationId();
         system.debug('org id --------->'+orgId); 
         strOrganizationName = UserInfo.getOrganizationName();
          
        /* errormsgid='';
          errormsg='';
          
          string url= ApexPages.currentPage().getParameters().get('Errormsg');
         if (url!=null){
            errormsgid=url.split('@@@')[0];
            string errormsg1=url.split('@@@')[1];
             errormsg=errormsg1.split(',')[1];
             // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+url));
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+errormsgid));
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+errormsg));
          }
        */
         TTP=new List<Tool_Tip__c>();
         TTP=[select id,Job_Specs__c,Client_Invoice__c,Estimate__c,Tags__c ,Graphic_Deliverable__c,Workdocs__c,Job_Team__c,Job_Time__c,Shipment__c ,Production_Estimate__c,Purchase_Order__c,Quotes__c,Schedule__c,Vendor_Invoice__c from Tool_Tip__c limit 1];
        
        
       /*   Help_Text__c HelpText= Help_Text__c.getOrgDefaults();
          JobTeam=HelpText.Job_Team__c;
          Schedule=HelpText.Schedule__c;*/
           
           
         ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
         ShowProductionEstimate =activeSettings.Active__c;
         ShowEmailListviewSection=activeSettings.Email_Functionality__c;
         spClientChatterFeedCheck = activeSettings.DisableJobChatterforSPClientContac__c;
         ShowJobTimeTab= activeSettings.TS_Entry_Button__c;
         ShowShipmentTab=activeSettings.Shipment_Tab__c;
         
               
         tab = apexpages.currentpage().getparameters().get('tab');
         if(tab == '' || tab == null){
             tab = 'Jobdetail';
         }
         
         jobId=System.currentPagereference().getParameters().get('id');
         lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by CreatedDate];
         
         
         
         
         List<Job_Task__c > lstJobTasks = [Select Id, Name, Status__c, Marked_Done__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Job__c =: jj.Id Order BY Task_Order__c ASC];
        
        if(lstJobTasks.size() > 0){
            Decimal totalDays = 0;
            Decimal completedDays = 0;
            for(Job_Task__c ts:lstJobTasks){
                totalDays = totalDays + ts.Days__c;
                if(ts.Marked_Done__c){
                    completedDays = completedDays + ts.Days__c;
                }
            }
            TC = totalDays;
            CC = completedDays;
        }
        else{
            TC = 0;
            CC = 0;
        }
        
             
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
             
             
    }
    
    public Pagereference AddStaffs()
    {
           String theId=ApexPages.CurrentPage().getParameters().get('id');
           PageReference p = Page.JobTeamAddEditStaff;
           p.setredirect(true);
           p.getParameters().put('id',theID); 
           return p;
    }
    
    public Pagereference AddStaffsLightning()
    {
           String theId=ApexPages.CurrentPage().getParameters().get('id');
           PageReference p = Page.JobTeamAddEditStaff_Lightning;
           p.setredirect(true);
           p.getParameters().put('id',theID); 
           return p;
    }

    
       
    public void incrementCounter() {
       
        List<Job_Task__c > lstJobTasks = [Select Id, Name, Status__c,Marked_Done__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Job__c =: jj.Id Order BY Task_Order__c ASC];
        
        if(lstJobTasks.size() > 0){
            Decimal totalDays = 0;
            Decimal completedDays = 0;
            for(Job_Task__c ts:lstJobTasks){
                totalDays = totalDays + ts.Days__c;
                if(ts.Marked_Done__c){
                    completedDays = completedDays + ts.Days__c;
                }
            }
            TC = totalDays;
            CC = completedDays;
        }
        else{
            TC = 0;
            CC = 0;
        }
        
        
    }
    
    public pagereference changeTab(){
        String newTab = Apexpages.currentPage().getParameters().get('newTab');
        
        String theId=ApexPages.CurrentPage().getParameters().get('id');
        PageReference p = Page.JobdetailpageLightening07;
        p.setredirect(true);
        p.getParameters().put('id',theID);
        p.getParameters().put('tab',newTab);  
        return p;
    }
}