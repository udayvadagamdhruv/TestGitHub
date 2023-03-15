public with sharing class AdminpageRedirectExt {

     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  



    public PageReference Adminview() 
    {
         if(isLtng)
         {
              PageReference p =  new Pagereference('/apex/AdminListViewLightning');
              p.setRedirect(true);    return p;
         }
         else
         {
             return null; 
         
         }
    }

}