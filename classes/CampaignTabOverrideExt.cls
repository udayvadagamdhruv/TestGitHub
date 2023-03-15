public with sharing class CampaignTabOverrideExt {

    

    
public boolean isLtng {set;get{

 return(UserInfo.getUITheme()=='Theme4d')?true:false;

}}

public string campprefix {set;get;}

   public CampaignTabOverrideExt(ApexPages.StandardController controller) {
   campprefix=Campaign__c.SobjectType.getDescribe().getKeyPrefix();


    }



public CampaignTabOverrideExt (){

    campprefix=Campaign__c.SobjectType.getDescribe().getKeyPrefix();
   }
   
   public PageReference campaignsview() {
      PageReference p;
      if(isLtng)
      {
      
         p=new PageReference ('/'+campprefix+'/o');
         
       }
       else{
             p =new PageReference ('/apex/CampaignTabOverride');
        }
       
       p.setRedirect(true);
          return p;
    }
   

}