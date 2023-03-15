public with sharing class JobsUnderCampaignTemplateController {

   /*public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
  Public String theID;
  public List<Campaign_Jobs__c> CTempJobs{get;set;} 

 public JobsUnderCampaignTemplateController (){
   theID = ApexPages.CurrentPage().getParameters().get('id');
   CTempJobs=new List<Campaign_Jobs__c>();
   CTempJobs=[select id,Name,Campaign_Template__c,Media_Type__c,Schedule_Template__c from Campaign_Jobs__c Where Campaign_Template__c=:theId];
   }


 public pagereference NewCampaignJob(){
 
 pagereference p;
 if(isLtng)
  p=new pagereference('/apex/NewCampaignJobLightning');
 else
  p=new pagereference('/apex/NewCampaignJob');
  p.getParameters().put('CTempId',theID);
  p.setredirect(true);
 return p;
 
 }*/

}