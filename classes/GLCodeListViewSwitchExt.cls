public with sharing class GLCodeListViewSwitchExt {

public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

public string glcodeprefix {set;get;}

    public GLCodeListViewSwitchExt(ApexPages.StandardController controller) {

     glcodeprefix=GL_code__c.SobjectType.getDescribe().getKeyPrefix();
    // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+glcodeprefix));
    }


public pageReference gllistview(){
  
  PageReference p ;
     if(isLtng)
     {
            p= new Pagereference('/'+glcodeprefix +'/o');
     
     }
     else
     {
           p = new Pagereference('/apex/AdminListView?intFocus=1');
     
     }
         p.setRedirect(true);
          return p;
  
}

}