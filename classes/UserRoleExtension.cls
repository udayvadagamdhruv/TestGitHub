// This class is used to create New UserRole
public with sharing class UserRoleExtension 
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

    // Global variables 
 //   public boolean isError{get;set;}
    private final UserRole objRole{get;set;}
    string str{get;set;}
    // ENd of Global variables 
    
    // Standard Controller Constructor 
    public UserRoleExtension(ApexPages.StandardController controller)
    {
     //   isError=false;
        this.objRole=(UserRole)controller.getRecord();
    }
    // End Constructor 
    
    // Method called on to Save New Role 
    public Pagereference Save()
    {
       string str = objRole.Name;
       list<UserRole> lstr = [select name from UserRole where Name=:str];
       if((lstr.size())>0)
       {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Role : '+str)); 
       }
       else
       {
           try
           {
               insert objRole;
           }
           catch(DMLException e)
           {
                //  isError = true;
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));  return null;
        }
        PageReference p1;
            if(isLtng)
            {
                p1=new PageReference('/apex/RoleTabLightning');
                
            }
           else
           {
               p1=new PageReference('/apex/AdminListView?intFocus=6');
           }   
           			p1.setRedirect(true);
                     return p1;

        }
       return null;
      }
    // End Save Role
    
    //Cancel Method
      Public PageReference cancelme()
      {
         PageReference p1;  
         if(isLtng)
         {
             p1=new PageReference('/apex/RoleTabLightning');
             
         }
         else
         {
              p1=new PageReference('/apex/AdminListView?intFocus=6');
         }      
          p1.setRedirect(true);
          return p1;
              
      }
   //End of Cancel Method

}
//End of class