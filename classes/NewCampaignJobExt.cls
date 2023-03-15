public with sharing class NewCampaignJobExt {

  /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
    public string CTempName{set;get;}
  
    public string CTempId;
    public  Campaign_Jobs__c CampJob;
    public string MTName {set;get;}
    public string ScheduleTemp {set;get;}
    // End of Global variables
    

    public NewCampaignJobExt(ApexPages.StandardController controller) {
     this.CampJob=(Campaign_Jobs__c)controller.getRecord();
     CTempId=Apexpages.currentpage().getParameters().get('CTempId');
     
     Campaign_Template__c  CTemRec=[select id,name from Campaign_Template__c where id=:CTempId];
     CTempName=CTemRec.Name;
     
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
 
   public Pagereference SaveCampaignJob(){
   
   try{
         if(MTName == null)
            {
                String stringMTName = Schema.Campaign_Jobs__c.fields.Media_Type__c.getDescribe().getLabel();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,stringMTName+' : You must select a '+stringMTName+'.'));
                return null;
            }
         if(ScheduleTemp == null)
            {
                String strSchedule = Schema.Campaign_Jobs__c.fields.Schedule_Template__c.getDescribe().getLabel();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select a '+strSchedule));
                return null;
            }
         
         else{
           if (Schema.sObjectType.Campaign_Jobs__c.fields.Campaign_Template__c.isCreateable()) {   
               CampJob.Campaign_Template__c=CTempId;}
           if (Schema.sObjectType.Campaign_Jobs__c.fields.Media_Type__c.isCreateable()) {   
               CampJob.Media_Type__c=MTName;}
           if (Schema.sObjectType.Campaign_Jobs__c.fields.Schedule_Template__c.isCreateable()) {   
               CampJob.Schedule_Template__c=ScheduleTemp;}
           if(Schema.sObjectType.Campaign_Jobs__c.isCreateable()){
               insert CampJob;}
          
          
         String StrCTempId=CampJob.Campaign_Template__c; 
            PageReference p;
            if(isLtng)
               p= new Pagereference('/apex/detailCampaignTemplateLightning?id='+StrCTempId);
           else
               p= new Pagereference('/apex/detailCampaignTemplate?id='+StrCTempId);
               p.setRedirect(true);
               return p;
          }
          
       }    
   
   Catch(System.DMLException e){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
    return null;
   }
   
  }
  
  
   public Pagereference cancel(){
   Pagereference p;
   if(isLtng)
      p= new Pagereference('/apex/detailCampaignTemplateLightning?id='+CTempId);
     else
       p= new Pagereference('/apex/detailCampaignTemplate?id='+CTempId);
       p.setRedirect(true);
       return p;
  }
   */
}