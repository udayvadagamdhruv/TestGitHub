public with sharing class ScheduleTemplateDetailSwitchExt{

public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
    public string SchId{get;set;}
    public Schedule_Task__c Sct{get;set;}

    public ScheduleTemplateDetailSwitchExt(ApexPages.StandardController controller) 
    {
        SchId = controller.getRecord().id;
        
        Sct=[select id,name,Schedule_Template__c from Schedule_Task__c where id=:SchId];
    
    }


public pageReference stlistview(){
  
  String Schtaskid;
  Schtaskid =  Sct.Schedule_Template__c;
    PageReference p;
     if(isLtng)
     {
              p =  new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+Schtaskid);
             
     }
     else
     {
           p =  new Pagereference('/apex/ScheduleTemplateTabOverride?id='+Schtaskid);
       
     }
     p.setRedirect(true);
     return p;
  
}

}