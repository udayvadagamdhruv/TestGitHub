public with sharing class CampaignTemplateDetailSwitchExt {
/*
 public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
   public string  CTempId {set;get;}
   public string  CJobId {set;get;}
   public Campaign_Jobs__c CJobrec {set;get;}

    public CampaignTemplateDetailSwitchExt(ApexPages.StandardController controller) {
    CJobId=controller.getRecord().id;
    Campaign_Jobs__c CTemp=[select id,Name,Campaign_Template__c,Media_Type__c From Campaign_Jobs__c where id=:CJobId];
    CTempId =CTemp.Campaign_Template__c;
    }
    
    public pagereference CTDetailview(){
    PageReference p;
     if(isLtng)
     {
       p =  new Pagereference('/apex/detailCampaignTemplateLightning?id='+CTempId);
     }
     else
     {
       p =  new Pagereference('/apex/detailCampaignTemplate?id='+CTempId);
     }
      p.setRedirect(true);
      return p;
    }*/

}