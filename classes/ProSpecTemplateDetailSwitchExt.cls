public with sharing class ProSpecTemplateDetailSwitchExt {
/*
  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
   public string  pstid {set;get;}
   public Production_Spec_Item__c prospecitem {set;get;}

    public ProSpecTemplateDetailSwitchExt(ApexPages.StandardController controller) {
        pstid=controller.getRecord().id;
        prospecitem=[select id,name,Production_Spec_Template__c From Production_Spec_Item__c Where id=:pstid];
    }

public pageReference pstDetailview() 
  {
  
  String ProSpecTempId=prospecitem.Production_Spec_Template__c;
     PageReference p;
     if(isLtng)
     {
       p =  new Pagereference('/apex/ProductionSpecTemplateDetailLightning?id='+ProSpecTempId);
     }
     else
     {
       p =  new Pagereference('/apex/ProductionSpecTemplateDetail?id='+ProSpecTempId);
     }
      p.setRedirect(true);
      return p;
  
  }*/

}