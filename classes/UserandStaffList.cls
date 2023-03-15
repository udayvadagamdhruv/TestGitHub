// This class is used to display Staff/User List in Staff Tab
public with sharing class UserandStaffList 
{
    // Global variables
    public List<User> list_user{get;set;}
    public List<Staff__c> list_staff{get;set;}
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            } 
    
    // End of Global variables
    
    // Start Constructor
    public UserandStaffList() 
    {
        list_staff = [select Name,Username__c,First_Name__c,Email__c,Role__c from Staff__c where User_Type__c =: 'Unlicensed Staff' and Active__c=: True and IsDeleted__c=:False Order By First_Name__c ];
        list_user = [select name,Username,FirstName,Email,UserRoleId,UserRole.Name from User where User_Types__c =: 'Licensed User' and IsActive=: True Order By FirstName ];
    }
     // End of Constructor
    
    //Start Method for create new staff or user
      Public PageReference CreateStaffandUser()
      {
                if(isLtng)
                {
                     PageReference p =  new Pagereference('/apex/CreateNewStaffandUserLightning');
                     p.setRedirect(true);
                     return p;  
                }
                else
                {
                    PageReference p =  new Pagereference('/apex/CreateNewStaffandUser');
                    p.setRedirect(true);
                    return p; 
                }
             
             
             
             
             
              
      }
      
   //End of create new staff or user  Method
   
 /* // Test Coverage
        static testMethod void UserandStaffListTest()
        {
            Staff__c st = new Staff__c(Name='Testing',Username__c = 'abcd@gmail.com');
            insert st;
            System.assertEquals('Testing',st.Name);
            UserandStaffList l=new UserandStaffList();
            ApexPages.PageReference result1=l.CreateStaffandUser();
        }
    // End Test Coverage*/
}// End of Class