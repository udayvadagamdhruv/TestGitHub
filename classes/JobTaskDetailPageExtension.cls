public with sharing class JobTaskDetailPageExtension {
    public boolean isMobile{set; get;}
    public boolean isclassic{set; get;}
    public boolean isLight{set; get;}
    public JobTaskDetailPageExtension(ApexPages.StandardController controller) {
        String theme = UserInfo.getUITheme();
        if(theme == 'Theme4t'){
            isMobile = true;
        }
        else if(theme == 'Theme4d'){
            isLight = true;
        }
        else{
            isclassic = true;
        }
    }

}