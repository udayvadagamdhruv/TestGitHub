public with sharing class MediaTypeListviewSwitchExt {

 public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
 public string mediatypeprefix {set;get;}

    public MediaTypeListviewSwitchExt(ApexPages.StandardController controller) {
     mediatypeprefix=Media_Type__c.SobjectType.getDescribe().getKeyPrefix();
    }


public pageReference Mtlistview(){
  
  PageReference p;
     if(isLtng)
     {
         p =new Pagereference('/'+mediatypeprefix+'/o');
     }
     else
     {
        p =new Pagereference('/apex/AdminListView?intFocus=8');
     }
       p.setRedirect(true);
       return p;
     
  
}

}