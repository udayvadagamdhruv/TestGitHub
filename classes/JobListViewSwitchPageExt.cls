public with sharing class JobListViewSwitchPageExt {

    public JobListViewSwitchPageExt(ApexPages.StandardController controller) {

    }
    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }
    

}