public with sharing class JobRequestFormEditExt{
    
    public JobRequestFormEditExt(ApexPages.StandardController controller) {}

/*

    public String SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid,ScheduleType,ScheduleCalc,jobid,name,description;
    
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
    
    
  /*public transient String imageBody{get;set;}
    public transient String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public transient List<Document> lstDoc;
    public string filename1{get; set;}
    public blob commandbutton1{get; set;}*/
    
    //Added fields ends here
    




/*
    public JobRequestFormEditExt(ApexPages.StandardController controller) {
    this.obJob=(Job__c)controller.getRecord();       
     jobid = ApexPages.currentpage().getParameters().get('id');
     
        Job__c abc = [select id,Name,Media_Types__c,Schedule_Template__c,JS_Client__c,Campaign__c,JS_Client_Contact__c,Specification_Template__c,UpdateSchedDateFieldCheck__c from Job__c  where id =: jobid  Limit 1];
        
       lstJobspec=[select Id, Name,Description__c from Job_Spec__c where Job__c =:jobid];
       
       system.debug('>>>>>>>>>>>>>>>>>  lstJobspec  >>>>>>>>>>'+lstJobspec);
       
        MTName = abc.Media_Types__c;
        ScheduleTemp = abc.Schedule_Template__c;
        ClientName = abc.JS_Client__c;
        CCName = abc.JS_Client_Contact__c;
        CampaignName = abc.Campaign__c; 
        SpecTempName = abc.Specification_Template__c;
        specList();
        
     
        pgb2 = true;        
        pgb1 = true;
        
     /*   imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }*/
        
     //added code for logo ends here.
    
    /*
    }
    
     public List<Job_Spec__c> getlstJobspec()
    { 
        return [select Id, Name,Description__c from Job_Spec__c where Job__c =:jobid];
    }
    
    
    
    Map<id,List<Spec_Item__c>> maplstspec=new Map<id,List<Spec_Item__c>>();
    
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
        for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c order by Name]) 
        {  
             optionList.add(new selectOption(a.Id, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));  
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
    
   /* public list<Spec_Item__c> getList1()
    {
        lstspecItems = new list<Spec_Item__c>();
        system.debug('spec is ....'+SpecTempName);
        lstspecItems = [select Name,Description__c,Specification_Template__r.Name from Spec_Item__c where Specification_Template__c =: SpecTempName];
        if(SpecTempName == '' || SpecTempName == '- None -')
        {
            lstspecItems  = new list<Spec_Item__c>();
        }
        return lstspecItems ;
    }*/
   /* 
    public void specList(){           
           lstspecItems = new list<Spec_Item__c>();
           system.debug('spec is ....'+SpecTempName);
           lstspecItems = [select Name,Description__c,Specification_Template__r.Name from Spec_Item__c where Specification_Template__c =: SpecTempName ];
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
    
    
    
    
    public PageReference saveme(){  
        
        if(obJob.Name == null)
        {
            String stringMediaType = Schema.Job__c.fields.Name.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must enter Job Name.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
      /*  if(obJob.Due_Date__c == null)
        {
            String stringDueDate = 'Requested Due Date';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringDueDate +' : You must enter'+stringDueDate +'.');
            ApexPages.addMessage(myMsg);
            return null;
        }*/

        
       /* if(MTName == null)
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
      
      
      
        
     /* if(SpecTempName == null )
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
        
        if(CampaignName== null )
        {
            String strCampaignName = Schema.Job__c.fields.Campaign__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strCampaignName +' : You must select a '+strCampaignName +'.' );
            ApexPages.addMessage(myMsg);
            return null;
        }
        
     */
/*
        

        
        
        else{
            if(schema.SobjectType.Job__c.Fields.Media_Types__c.isUpdateable() && schema.SobjectType.Job__c.Fields.Media_Types__c.isCreateable()){
                obJob.Media_Types__c=MTName;
            }
            if(schema.SobjectType.Job__c.Fields.Schedule_Template__c.isUpdateable() && schema.SobjectType.Job__c.Fields.Schedule_Template__c.isCreateable()){
                obJob.Schedule_Template__c=ScheduleTemp;    
            }
            if(schema.SobjectType.Job__c.Fields.Specification_Template__c.isUpdateable() && schema.SobjectType.Job__c.Fields.Specification_Template__c.isCreateable()){
                obJob.Specification_Template__c=SpecTempName;
            }
            if(schema.SobjectType.Job__c.Fields.JS_Client__c.isUpdateable() && schema.SobjectType.Job__c.Fields.JS_Client__c.isCreateable()){
                obJob.JS_Client__c=ClientName;
            }
            if(schema.SobjectType.Job__c.Fields.JS_Client_Contact__c.isUpdateable() && schema.SobjectType.Job__c.Fields.JS_Client_Contact__c.isCreateable()){
                obJob.JS_Client_Contact__c =CCName;
            }
            if(schema.SobjectType.Job__c.Fields.Campaign__c.isUpdateable() && schema.SobjectType.Job__c.Fields.Campaign__c.isCreateable()){
                obJob.Campaign__c = CampaignName;
            }
          //  obJob.Schedule_Calc__c='End Date';
            
            
            try{
                
                If(Test.isRunningTest()==false){ 
                    if(schema.SobjectType.Job__c.isCreateable() && Schema.sObjectType.Job__c.isUpdateable() ){ 
                        upsert obJob;   
                    }
                }
                list<Job_Spec__c> lstJspec = new list<Job_Spec__c>();
                if(SpecTempName != null){
                
                    
                    List<Job_Spec__c> lstExtSpecs = new List<Job_Spec__c>();
                    lstExtSpecs = [select Id, Name from Job_Spec__c where Job__c =:obJob.Id];
                    If(lstExtSpecs.size()>0){
                       if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
                           delete lstExtSpecs;}
                    }
                    
                    for(Spec_Item__c obj:lstspecItems)
                    {
                        Job_Spec__c jobSpec = new Job_Spec__c();
                        if(schema.SobjectType.Job_Spec__c.Fields.Job__c.isUpdateable() && schema.SobjectType.Job_Spec__c.Fields.Job__c.isCreateable()){
                            jobSpec.Job__c = obJob.Id;
                        }
                        if(schema.SobjectType.Job_Spec__c.Fields.Name.isUpdateable() && schema.SobjectType.Job_Spec__c.Fields.Name.isCreateable()){
                            jobSpec.Name = obj.Name;
                        }
                        if(schema.SobjectType.Job_Spec__c.Fields.Description__c.isUpdateable() && schema.SobjectType.Job_Spec__c.Fields.Description__c.isCreateable()){
                            jobSpec.Description__c = obj.Description__c;
                        }
                        lstJspec.add(jobSpec);
                        
                    }
                    if(lstJspec.size()>0)
                    {
                        if(Schema.sObjectType.Job_Spec__c.isCreateable() && Schema.sObjectType.Job_Spec__c.isUpdateable() ){ 
                            upsert lstJspec; 
                        }
                    }
               }
                string strid = obJob.Id; 
                
              /*   if(filename1!=null ){
        
       
                Attachment SpecAttachment=new Attachment(parentId=obJob.Id,name=filename1,body=commandButton1); //Create instance of Attachment and add fields to it
        
                insert SpecAttachment;
                SpecAttachment.body = null; // clears the viewstate

               }*/
        
              /*                 
                obJob = new Job__c();           
                PageReference p = new PageReference('/apex/JobRequestFormdetailpageMobile?id='+strid);
                p.setRedirect(true); 
                objJob =  obJob;
                lstJobspec = new list<Job_Spec__c>();  
                lstJobspec  = [Select Id, Name,Description__c from Job_Spec__c where Job__c =:strid ];
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
    
     public PageReference cancelme(){ 
     
      PageReference p = new PageReference('/apex/JobRequestFormdetailpageMobile?id='+jobid);
                p.setRedirect(true); 
                return p;
     
     
     } */
 
}