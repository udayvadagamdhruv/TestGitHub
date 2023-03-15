public with sharing class GLDepartmentListviewSwitchExt{
 @TestVisible 
public boolean isLtng{private set; get{
                                          String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

public string gdcodeprefix {set;get;}

    public GLDepartmentListviewSwitchExt(ApexPages.StandardController controller) {

     gdcodeprefix=GL_Department__c.SobjectType.getDescribe().getKeyPrefix();
    // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+glcodeprefix));
    }


public pageReference gdlistview(){
  
  PageReference p;
     if(isLtng)
     {
       p= new Pagereference('/'+gdcodeprefix +'/o');
     }
     else
     {
        p= new Pagereference('/apex/AdminListView?intFocus=9');
     }
     p.setRedirect(true); 
     return p;
}

}