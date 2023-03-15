public with sharing class EditJobTaskSwitchPageExtension
{
    public boolean isMobile{set; get;}
    public boolean isclassic{set; get;}
    public boolean isLight{set; get;}
    
    public Id clinvid;
    public EditJobTaskSwitchPageExtension(ApexPages.StandardController controller) 
    {
    clinvid=Apexpages.currentpage().getParameters().get('id');
      String theme = UserInfo.getUITheme();
        if(theme == 'Theme4t'){
            isMobile = true;
        }
        else if(theme == 'Theme4d'){
            isLight = true;
           // redirectpage();
        }
        else{
            isclassic = true;
        }
    
    }
    
    

}