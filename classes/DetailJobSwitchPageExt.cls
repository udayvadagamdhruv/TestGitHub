public with sharing class DetailJobSwitchPageExt {
   /* public string JobId{get;set;}
    public string th {get;set;}
    public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }
    public DetailJobSwitchPageExt(ApexPages.StandardController controller) {
         JobId = controller.getRecord().id;
           th=Userinfo.getUITheme();
    }
    
    public Pagereference jobMobileRedirection(){
    

    Pagereference pg;
        if(th=='Theme4d')
             pg=new Pagereference('/apex/JobdetailpageLightening07?id='+JobId);
        else if(th=='Theme4t')
              pg=new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+JobId);
        else
             pg=new Pagereference('/apex/JobListView?id='+JobId);
    
             pg.setRedirect(true);
             return pg; 
    }*/
    

}