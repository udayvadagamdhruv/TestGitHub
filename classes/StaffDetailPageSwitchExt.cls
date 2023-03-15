public with sharing class StaffDetailPageSwitchExt 
{
     public string StaffId{get;set;}
    public StaffDetailPageSwitchExt(ApexPages.StandardController controller) {
         StaffId= controller.getRecord().id;


    }
    
     public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }
    


}