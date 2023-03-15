public with sharing class SpecificationTemplateListViewExt {

  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

public string spetcodeprefix {set;get;}



    public SpecificationTemplateListViewExt(ApexPages.StandardController controller) {

    spetcodeprefix =Specification_Template__c.SobjectType.getDescribe().getKeyPrefix();


    }
    
 public pageReference spetlistview(){
  
  PageReference p;
     if(isLtng)
       p = new Pagereference('/'+spetcodeprefix +'/o');
     else
       p =  new Pagereference('/apex/AdminListView?intFocus=3');
       p.setRedirect(true);
       return p;

}   

}