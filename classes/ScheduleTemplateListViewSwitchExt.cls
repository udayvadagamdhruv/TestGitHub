public with sharing class ScheduleTemplateListViewSwitchExt {
public boolean isLtng{private set; get{
                                         string  theme= UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

public string stcodeprefix {set;get;}

    public ScheduleTemplateListViewSwitchExt(ApexPages.StandardController controller) {

     stcodeprefix =Schedule_Template__c.SobjectType.getDescribe().getKeyPrefix();
    // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+glcodeprefix));
    }


public pageReference sclistview(){
  
  
     if(isLtng)
     {
             PageReference p =  new Pagereference('/'+stcodeprefix +'/o');
              p.setRedirect(true);return p;
     }
     else
     {
          PageReference p =  new Pagereference('/apex/AdminListView?intFocus=2');
          p.setRedirect(true);
          return p;
     
     }
  
}

}