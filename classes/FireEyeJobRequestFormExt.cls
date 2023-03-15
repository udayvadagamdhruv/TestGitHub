public with sharing class FireEyeJobRequestFormExt{
/*
    public String SpecV,Specs,SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid,ScheduleType,ScheduleCalc;
    
    public Job__c obJob;
    
    public Job__c objJob{get; set;}
    
    
    public String getSpecValue() {  return SpecV; }
    public void setSpecValue(String s) {  this.SpecV= s; }
    
    
    public String getspec1() {  return Specs; }
    public void setspec1(String s) {  this.Specs= s; }
    
    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    
    public list<Spec_Item__c> lstspecItems{get; set;}
    
    public list<Job_Spec__c> lstJobspec{get; set;}
    
    public boolean pgb2{get; set;}
    
    public boolean pgb1{get; set;}    
   
    public transient  String imageBody{get;set;}
    public transient  String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public transient  List<Document> lstDoc;
   
    public string filename1{get; set;}
    public blob commandbutton1{get; set;}
    
    Public Schedule_Template__c NameCustomScheduletype{get;set;}
    Public Media_Type__c NameMediatype{get;set;}
    
    //Added fields ends here
    

    public FireEyeJobRequestFormExt(ApexPages.StandardController controller) {
       
     
       
        this.obJob=(Job__c)controller.getRecord();        
        pgb2 = true;        
        pgb1 = true;
        
       loadImg();

    }
    
    
    public void loadImg()
    {    
        //added this code to add logo to page by rahul on 10-Feb-2014.
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo2' LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }
          
        
        //added code for logo ends here.
    }
    
    
    Map<id,List<Spec_Item__c>> maplstspec=new Map<id,List<Spec_Item__c>>();
    
    public List<selectOption> getSpecValues() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('All', 'All'));  
        optionList.add(new selectOption('Energy', 'Energy'));  
        optionList.add(new selectOption('Education', 'Education'));
        optionList.add(new selectOption('Financial Services', 'Financial Services'));   
               
        return optionList;  
    }
 
    public List<selectOption> getScheduleTemplates()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('List Pull', 'List Pull')); 
        optionList.add(new selectOption('Eblast', 'Eblast')); 
        optionList.add(new selectOption('List Import', 'List Import')); 
       
        return optionList;
    }
    
    public List<selectOption> getSpecs()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('Yes', 'Yes')); 
        optionList.add(new selectOption('No', 'No')); 
       
        return optionList;
    }
    
    
   
    
    public void specList(){           
           lstspecItems = new list<Spec_Item__c>();
           system.debug('spec is ....'+SpecTempName);
           lstspecItems = [select Name,Description__c,Specification_Template__r.Name from Spec_Item__c where Specification_Template__c =: SpecTempName ];
    }
    
   
    public PageReference saveme(){  
        
      NameMediatype=[Select id ,name from Media_Type__c where name='FireEye' limit 1]; 
      NameCustomScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name =:ScheduleTemp AND Media_Types__r.name='FireEye' limit 1];
        
       if(obJob.Dummy_Text_1__c == null)
        {
            String stringMediaType = Schema.Job__c.fields.Dummy_Text_1__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must enter Name.');
            ApexPages.addMessage(myMsg);
            return null;
        }
       
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

        if(ScheduleTemp == null)
        {
            String strSchedule = Schema.Job__c.fields.Schedule_Template__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select a '+strSchedule +'.');
            ApexPages.addMessage(myMsg);
            return null;
        }
           
        
        else
        {
             if (Schema.sObjectType.Job__c.fields.Media_Types__c.isCreateable()) {   
                 obJob.Media_Types__c=NameMediatype.id;}
             if (Schema.sObjectType.Job__c.fields.Schedule_Template__c.isCreateable()) {   
                 obJob.Schedule_Template__c=NameCustomScheduletype.id;  }  
             if (Schema.sObjectType.Job__c.fields.Schedule_Calc__c.isCreateable()) {   
                 obJob.Schedule_Calc__c ='End Date';}
            
            
            try
            {
                
                If(Test.isRunningTest()==false){ 
                    if(Schema.sObjectType.Job__c.isCreateable()){insert obJob;                    }
                
                    Job_Spec__c jobspec1=new Job_Spec__c();
                    if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) {
                        jobspec1.Name='Do you need help with content creation';}
                    if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) {
                        jobspec1.Description__c=Specs;}
                    if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) {
                        jobspec1.Job__c=obJob.id;}
                    if(Schema.sObjectType.Job_Spec__c.isCreateable()){insert jobspec1;}
                     
                     Job_Spec__c jobspec2=new Job_Spec__c();
                     if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) { 
                         jobspec2.Name='Campaign Vertical';}
                     if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) {
                         jobspec2.Description__c=SpecV;}
                     if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) {
                         jobspec2.Job__c=obJob.id;}
                    if(Schema.sObjectType.Job_Spec__c.isCreateable()){insert jobspec2;}
                
                }
                
                
                
                               
                obJob = new Job__c();           
                PageReference p = new PageReference('/apex/FireEyeJobcreatedfromSite');
                p.setRedirect(true); 
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
    
*/ 

}