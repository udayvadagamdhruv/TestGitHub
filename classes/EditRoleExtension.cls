// This class is used to edit Role 
public with sharing class EditRoleExtension 
{

  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
             }  

    // Global variables 
    private final UserRole objRole{get;set;}
    string str{get;set;}
    
public string oldValue;
    // End of Global variables 

    // Standard Controller Constructor
    public EditRoleExtension(ApexPages.StandardController controller)
     {
        this.objRole=(UserRole)controller.getRecord();                
        oldValue = this.objRole.Name;     
     }
     // End Constructor 
    
    // Method called on to Save Role
    public Pagereference Save()
    { 
       PageReference p1;
       string str = objRole.Name ; 
       try
           {
   
      List<UserRole> lstr = [select name from UserRole where Name=:str];  
      
       if((lstr.size()) > 0)        
       {
       
          if(str  != oldValue ) 
          {         
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, str+' already exists, Please Enter New Role Name'));
              return null;
          }
          else
          {
             update objRole; 
             
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
        }
       else
          {
            update objRole; 
        
            if(isLtng)
            {
                p1=new PageReference('/apex/RoleTabLightning');
            }
            else
            {
                p1=new PageReference('/apex/AdminListView?intFocus=6');
            }
               p1.setRedirect(true);  return p1;
          }

               
           }
           catch(DMLException e)
           {
                return null;
           }
           // After editing Role, Navigate to Role Tab
                    //}
        // return null;
                
    }
    // End of Method Save
    
     // Cancel Method
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
    
    // Test Coverage 
    
     /*   static testMethod void Test_EditRoleExtension()
        {
            UserRole u=new UserRole(Name='Design Manager');
            insert u;
            System.assertEquals('Design Manager',u.Name);
            
            ApexPages.StandardController con=new ApexPages.StandardController(u);
            EditRoleExtension ext=new EditRoleExtension(con);
            
            ApexPages.Pagereference result=ext.Save();
            
            delete u;
            result=ext.Save();
            result=ext.cancelme();
            
            UserRole u1=new UserRole(Name='Project Manager');
            insert u1;
            u.Name='';
            try
            {
                ApexPages.StandardController con1=new ApexPages.StandardController(u1);
                EditRoleExtension ext1=new EditRoleExtension(con1);
                ApexPages.Pagereference result1=ext1.Save();
            }
            catch(System.DMLException e)
            {
                System.assertEquals('REQUIRED_FIELD_MISSING' , e.getDmlStatusCode(0));
            }
        }*/
    // End Test Coverage 
}// End of Class