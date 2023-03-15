public with sharing class StaffListViewSwitchExt
{

    public boolean isLtng{private set; get{
                                                String theme = UserInfo.getUITheme();
                                                return (theme=='Theme4d')?true:false;
                                            }
                }  
    
    public string Staffprefix{set;get;}

    public StaffListViewSwitchExt(ApexPages.StandardController controller) {

     Staffprefix=Staff__c.SobjectType.getDescribe().getKeyPrefix();
    // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+glcodeprefix));
    }


public pageReference Staffview(){
  
  
     if(isLtng)
     {
           //  PageReference p =  new Pagereference('/'+Staffprefix+'/o');
             PageReference p =  new Pagereference('/apex/StaffTabLightning');
             p.setRedirect(true);
             return p;
     }
     else
     {
          PageReference p =  new Pagereference('/apex/AdminListView?intFocus=5');
          p.setRedirect(true);
          return p;
     
     }
  
}

}