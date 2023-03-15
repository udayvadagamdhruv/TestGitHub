public with sharing class CreateNewJobNewSwitchPageExt {

    public CreateNewJobNewSwitchPageExt(ApexPages.StandardController controller) {

    }
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }
    

}