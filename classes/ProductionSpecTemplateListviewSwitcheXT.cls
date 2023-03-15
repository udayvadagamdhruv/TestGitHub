public with sharing class ProductionSpecTemplateListviewSwitcheXT {

public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

public string proseptempprefix {set;get;}

    public ProductionSpecTemplateListviewSwitcheXT(ApexPages.StandardController controller) {

   proseptempprefix=Production_Spec_Template__c.SobjectType.getDescribe().getKeyPrefix();
        // proseptempprefix=Production_Spec_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }


  public pageReference PsTemplistview(){
  
  PageReference p;
     if(isLtng)
     {
        p =  new Pagereference('/'+proseptempprefix+'/o');
     }
     else
     {
        p =  new Pagereference('/apex/AdminListView?intFocus=10');
     }
      p.setRedirect(true);
      return p;
  
}


}