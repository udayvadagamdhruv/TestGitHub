public with sharing class NewJobFromSite {

    

    public String SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid,ScheduleType,ScheduleCalc;
    public Job__c obJob;
    
    public Job__c objJob{get; set;}
    
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    
    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }
    
    public list<Spec_Item__c> lstspecItems{get; set;}
    
    public list<Job_Spec__c> lstJobspec{get; set;}
    
    public boolean pgb2{get; set;}
    
    public boolean pgb1{get; set;}    
    
    public NewJobFromSite(ApexPages.StandardController controller) {
        this.obJob=(Job__c)controller.getRecord();
        pgb2 = true;
        pgb1 = true;
        
        //lstspecItems = new list<Spec_Item__c>();
    }
    
    
    Map<id,List<Spec_Item__c>> maplstspec=new Map<id,List<Spec_Item__c>>();
    
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
            //maplstspec.put(r.Id,)
              
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
        if(obJob.Due_Date__c == null)
        {
            String stringMediaType = Schema.Job__c.fields.Due_Date__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must enter Due date.');
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
            String strSchedule = Schema.Job__c.fields.Schedule_Template__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select a '+strSchedule);
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        
        if(SpecTempName == null)
        {
            String strSchedule = Schema.Job__c.fields.Specification_Template__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select '+strSchedule );
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        else{
            obJob.Media_Types__c=MTName;
            obJob.Schedule_Template__c=ScheduleTemp;
            obJob.Specification_Template__c=SpecTempName;
            obJob.Schedule_Calc__c = 'End Date';
            try{
                insert obJob;
                list<Job_Spec__c> lstJspec = new list<Job_Spec__c>();
                if(SpecTempName != null){
                    for(Spec_Item__c obj:lstspecItems)
                    {
                        Job_Spec__c jobSpec = new Job_Spec__c();
                        jobSpec.Job__c = obJob.Id;
                        jobSpec.Name = obj.Name;
                        jobSpec.Description__c = obj.Description__c;
                        lstJspec.add(jobSpec);
                        
                    }
                    if(lstJspec.size()>0)
                    {
                        insert lstJspec; 
                    }
                }
                string strid = obJob.Id;                
                obJob = new Job__c();           
                PageReference p = new PageReference('/apex/jobcreatedfromSite');
                p.setRedirect(false); 
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
   /*  public PageReference savespecs(){
    
        update lstJobspec ;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.confirm,'Job created successfully.');
        ApexPages.addMessage(myMsg);            
        PageReference p = new PageReference('/apex/Newjobfromsite');
        p.setRedirect(false);
        return p;
    }
    
    public PageReference save()
    {
    try
     {
      update lstJobSpec;
     }
     catch(System.DMLException e)
     {
                 return null;
     }

      return null;     
    }*/
    // End of method Save   
    
    // This method is called on to handle Cancel button
     /*Public PageReference cancelme()
     {
        return null;     
     }*/
     
     Public pagereference newJob(){
        Pagereference pg= new Pagereference('/apex/Newjobfromsite');
        pg.setRedirect(true);
        return pg;    
    }
    
    public PageReference cancel(){
        PageReference p = new PageReference('/apex/Newjobfromsite');
        p.setRedirect(true);
        return p;    
    }
}