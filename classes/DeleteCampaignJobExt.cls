public with sharing class DeleteCampaignJobExt {
/*
  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string CmpTempprefix {set;get;}
    public string CTempId {set;get;}
    
    private final Campaign_Jobs__c objCT;
    public Boolean isError{get;set;}

    public DeleteCampaignJobExt(ApexPages.StandardController controller) {
         isError = False;
        this.objCT=(Campaign_Jobs__c)controller.getrecord();
        Campaign_Jobs__c cjrec=[select id,name,Campaign_Template__c from Campaign_Jobs__c where id=:objCT.id];
        CmpTempprefix  = Campaign_Template__c.SobjectType.getDescribe().getKeyPrefix();
        CTempId=cjrec.Campaign_Template__c;
    }
    
     public PageReference checkDelete()
     {
        try
        {
            if(Campaign_Jobs__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objCT);    
            }
        }
        catch(System.DMLException e)
        {
           isError = True;
           return null;
        }
        
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
     // End of Delete Method

}