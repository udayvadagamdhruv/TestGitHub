public with sharing class JobRequestFormExt{

      public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }
    

    public String SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid,ScheduleType,ScheduleCalc;
    
    public Job__c obJob;
    
    public Job__c objJob{get; set;}
    
    
    public String getCampaignName() { return CampaignName; }
    public void setCampaignName(String s) {  this.CampaignName = s; }
    
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    
    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }
    
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
    public String getCCName() {  return CCName; }
    public void setCCName(String s) {  this.CCName = s; }
    
    public list<Spec_Item__c> lstspecItems{get; set;}
    
    public list<Job_Spec__c> lstJobspec{get; set;}
    
    public boolean pgb2{get; set;}
    
    public boolean pgb1{get; set;}    
    
  //  public transient List<Document> lstDoc;
    
    
  /* public string filename1{get; set;}
   public blob commandbutton1{get; set;}*/
    
    //Added fields ends here
    


    // Constructor
    public JobRequestFormExt(ApexPages.StandardController controller) 
    {
        this.obJob=(Job__c)controller.getRecord();        
        pgb2 = true;        
        pgb1 = true;
      lstspecItems = new list<Spec_Item__c>();
    }
    
    
    Map<id,List<Spec_Item__c>> maplstspec=new Map<id,List<Spec_Item__c>>();
    
    public List<selectOption> getCampaigns() 
    {   
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c where Status__c='Active' WITH SECURITY_ENFORCED order by Name]) 
        {         
            optionList.add(new selectOption(a.Id, a.Name)); 
            
        }
     
        return optionList;  
    }
  
  
  
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c WITH SECURITY_ENFORCED order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }            
        return optionList;  
    }
 
    public List<selectOption> getScheduleTemplates()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Schedule_Template__c r : [SELECT Id,Name FROM Schedule_Template__c where Media_Types__c=: MTName and Active__c=True WITH SECURITY_ENFORCED order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));
            //maplstspec.put(r.Id,)
              
        }
        return optionList;
    }
    
    public List<selectOption> getClients() 
    {        
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c WITH SECURITY_ENFORCED order by Name]) 
        {  
             optionList.add(new selectOption(a.Id, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));  
        }
        return optionList;  
    }
    
    public List<selectOption> getClientContacts()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Client_Contact__c r : [SELECT Id,Name FROM Client_Contact__c where Client__c =: Clientname and Active__c =:true WITH SECURITY_ENFORCED order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    
  
    public void specList(){           
           
           system.debug('spec is ....'+SpecTempName);
            
           
           lstspecItems = [select Name,Description__c,Specification_Template__r.Name from Spec_Item__c where Specification_Template__c =: SpecTempName WITH SECURITY_ENFORCED];
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'List Of Spec Items'+lstspecItems);
            ApexPages.addMessage(myMsg);
    }
    
    public List<selectOption> getSpecificationTemplates() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Specification_Template__c a : [SELECT Id, name FROM Specification_Template__c WITH SECURITY_ENFORCED order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
    
    
    
    public PageReference saveme(){  
        
          if(obJob.Name == null)
        {
            String stringMediaType = Schema.Job__c.fields.Name.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must enter Job Name.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if(obJob.Start_Date__c == null)
        {
            String stringDate = 'Start Date';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringDate +' : You must enter'+stringDate +'.');
            ApexPages.addMessage(myMsg);
            return null;
        }

        
        if(MTName == null)
        {
            
            String stringMediaType = Schema.Job__c.fields.Media_Types__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must select a '+stringMediaType+'.');
            ApexPages.addMessage(myMsg);
            return null;
        }

       
        if(ScheduleTemp == null)
        {
            String strSchedule = 'Job Type';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule +' : You must select a '+strSchedule+'.');
            ApexPages.addMessage(myMsg);
            return null;
        }
      
      
      
        
     /*   if(SpecTempName == null )
        {
            String strSpecificationTemp = Schema.Job__c.fields.Specification_Template__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSpecificationTemp +' : You must select a '+strSpecificationTemp +'.' );
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if(ClientName== null )
        {
            String strClientName = Schema.Job__c.fields.JS_Client__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strClientName +' : You must select a '+strClientName +'.' );
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if(CCName== null )
        {
            String strCCName = Schema.Job__c.fields.JS_Client_Contact__c .getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strCCName +' : You must select a '+strCCName +'.' );
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if(CampaignName == null )
        {
            String strCampaignName = Schema.Job__c.fields.Campaign__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strCampaignName +' : You must select a '+strCampaignName +'.' );
            ApexPages.addMessage(myMsg);
            return null;
        }*/


        

        
        
        else{
            
            if (Schema.sObjectType.Job__c.fields.Media_Types__c.isCreateable()) {   
                obJob.Media_Types__c=MTName;}
            if (Schema.sObjectType.Job__c.fields.Schedule_Template__c.isCreateable()) {   
                obJob.Schedule_Template__c=ScheduleTemp; }   
            if (Schema.sObjectType.Job__c.fields.Specification_Template__c.isCreateable()) {   
                obJob.Specification_Template__c=SpecTempName;}
            if (Schema.sObjectType.Job__c.fields.JS_Client__c.isCreateable()) {   
                obJob.JS_Client__c=ClientName;}
            if (Schema.sObjectType.Job__c.fields.JS_Client_Contact__c.isCreateable()) {   
                obJob.JS_Client_Contact__c =CCName;}
            if (Schema.sObjectType.Job__c.fields.Campaign__c.isCreateable()) {   
                obJob.Campaign__c = CampaignName;}
         //  obJob.Schedule_Calc__c='End Date';
        //    obJob.Status__c='Requested';
            
            
            try{
                
                If(Test.isRunningTest()==false){ 
                    if(Schema.sObjectType.Job__c.isCreateable()){ insert obJob;}
                }
                list<Job_Spec__c> lstJspec = new list<Job_Spec__c>();
                if(SpecTempName != null){
                
                    
                    List<Job_Spec__c> lstExtSpecs = new List<Job_Spec__c>();
                    lstExtSpecs = [select Id, Name from Job_Spec__c where Job__c =:obJob.Id WITH SECURITY_ENFORCED];
                    If(lstExtSpecs.size()>0){
                       if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
                           delete lstExtSpecs;}
                    }
                   if(lstspecItems.size()>0)
                   { 
                    for(Spec_Item__c obj:lstspecItems)
                    {
                        Job_Spec__c jobSpec = new Job_Spec__c();
                        if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) {   
                            jobSpec.Job__c = obJob.Id;}
                        if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) {   
                            jobSpec.Name = obj.Name;}
                        if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) {   
                            jobSpec.Description__c = obj.Description__c;}
                        lstJspec.add(jobSpec);
                        
                    }
                    if(lstJspec.size()>0)
                    {
                        if(Schema.sObjectType.Job_Spec__c.isCreateable()){ insert lstJspec; }
                    }
                    }
                }
                string strid = obJob.Id; 
                
           /*      if(filename1!=null ){
        
       
                Attachment SpecAttachment=new Attachment(parentId=obJob.Id,name=filename1,body=commandButton1); //Create instance of Attachment and add fields to it
        
                insert SpecAttachment;
                SpecAttachment.body = null; // clears the viewstate

               }*/
        
                               
                obJob = new Job__c();           
                PageReference p = new PageReference('/apex/JobRequestFormdetailpageMobile?id='+strid);
                p.setRedirect(true); 
                objJob =  obJob;
                lstJobspec = new list<Job_Spec__c>();  
                lstJobspec  = [Select Id, Name,Description__c from Job_Spec__c where Job__c =:strid WITH SECURITY_ENFORCED];
                return p;
               }
               catch(System.DMLException e)
               {
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,'Duplicate Job Name entered .');
                   ApexPages.addMessage(myMsg);
                   
                   return null; 
               }
                     
        }
    
    }
   
    // End of method Save   
    
        
       
       
       
        public PageReference cancelme()
        { 
     
                PageReference p = new PageReference('/apex/JobTabOverrideMobile');
                p.setRedirect(true); 
                return p;
        } 
       
}