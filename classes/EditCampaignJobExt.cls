public with sharing class EditCampaignJobExt {
/*
  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
    public string CTempName{set;get;}
  
    public string CTempId;
    public  Campaign_Jobs__c CampJob;
    public string MTName {set;get;}
    public string ScheduleTemp {set;get;}

    public EditCampaignJobExt(ApexPages.StandardController controller) {
     this.CampJob=(Campaign_Jobs__c )controller.getRecord();
     Campaign_Jobs__c  cjrec=[select id,Name,Campaign_Template__c,Campaign_Template__r.Name,Media_Type__c,Schedule_Template__c from Campaign_Jobs__c Where Id=:CampJob.id];
     CTempId=cjrec.Campaign_Template__c;
     CTempName=cjrec.Campaign_Template__r.Name;
     MTName=cjrec.Media_Type__c;
     ScheduleTemp=cjrec.Schedule_Template__c;
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
 
  
   public Pagereference EditSaveCampJob(){
   
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
          //CampJob.Campaign_Template__c=CTempId;
             if(schema.SobjectType.Campaign_Jobs__c.Fields.Media_Type__c.isUpdateable()){
                 CampJob.Media_Type__c=MTName;
             }
             if(schema.SobjectType.Campaign_Jobs__c.Fields.Schedule_Template__c.isUpdateable()){
                 CampJob.Schedule_Template__c=ScheduleTemp;
             }
             if(Schema.sObjectType.Campaign_Jobs__c.isUpdateable()) {
                 Update CampJob;
             }
          
          
        // String StrCTempId=CampJob.Campaign_Template__c; 
            PageReference p;
            if(isLtng)
               p= new Pagereference('/apex/detailCampaignTemplateLightning?id='+CTempId);
           else
               p= new Pagereference('/apex/detailCampaignTemplate?id='+CTempId);
               p.setRedirect(true);
               return p;
          }
          
       }    
      Catch(System.DMLException e){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
    return null;
   }
     
  }
  
  
  public Pagereference Cancel(){
        PageReference p;
        if(isLtng)
          p= new Pagereference('/apex/detailCampaignTemplateLightning?id='+CTempId);
         else
         p= new Pagereference('/apex/detailCampaignTemplate?id='+CTempId);
         p.setRedirect(true);
         return p;
          }
*/
  
}