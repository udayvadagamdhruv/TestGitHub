// This class is used as a extension for RoleDetail page
public with sharing class DisplayTasksInRoleCalendar {

    // Global variables 
    
/*    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
   
    
    public Id userRoleId{get;set;}
    // End Global variable
    
    // Start Constructor 
    public DisplayTasksInRoleCalendar(ApexPages.StandardController controller) {
        userRoleId=ApexPages.CurrentPage().getParameters().get('id');
    }
    // End Constructor 
    
    // method called on to handle calendar view button 
    public Pagereference roleCalendarTask()
    {
        Pagereference p=Page.DisplayRoleCalendar;
        p.getParameters().put('id',userRoleId);
        return p;
    }
    // end calendar view method 
   
   //Method to Back to Rples List 
     Public PageReference RolesView()
     {
     PageReference p;
      if(isLtng)
            {
                   p =  new Pagereference('/apex/RoleTabLightning');
                 
            }
            else
            {
                   p =  new Pagereference('/apex/AdminListView?intFocus=6');
                 
            }
            p.setRedirect(true);
            return p; 
     
     }
   //End of Roles view method  
   
   //Method to Edit the Role         
     Public PageReference EditRole()
     {
         PageReference p;
            if(isLtng)
            {
                   p =  new Pagereference('/apex/EditRoleLightning?id='+userRoleId);
            }
            else
            {
                   p =  new Pagereference('/apex/EditRole?id='+userRoleId);
                  
            }
         	p.setRedirect(true);
            return p; 
         
     }
   //End of Edit Role method 
   
   // This method is called on to delete Role
   public pagereference deleteRole()
   {
       UserRole ur=[Select id,Name from UserRole where id=:userRoleId];
      
      String roleName=ur.Name;
      
      List<Staff__c> lstStaff=[Select id,name from Staff__c where Role__c=: roleName and IsDeleted__c =: false];
      
      List<User> lstUser=[Select id,name from User where UserRoleId=: userRoleId and IsActive=True];
      
      try
      {
      
      if(lstStaff.size()==0 && lstUser.size()==0)
      {
            if(UserRole.sObjectType.getDescribe().isDeletable()){
                Database.delete(ur); }
      }
      else
      {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Your attempt to delete this role could not be completed because staff/users are currently assigned to this role');
           ApexPages.addMessage(myMsg);     return NULL;
      }  
      }
      catch(System.DMLException e)
      {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
            return null;
      }
      
      
       
		PageReference p;        
         if(isLtng)
            {
                   p =  new Pagereference('/apex/RoleTabLightning');
                   
            }
            else
            {
                    p=new PageReference('/apex/AdminListView?intFocus=6');
                   
            }
        	p.setRedirect(true);
            return p;
        
        
   }          
   // End of method deleteRole

    
    // Start Test Coverage
    /*    static testMethod void displayTaskInRoleCal()
        {
            UserRole ur=new UserRole(Name='Test Role 995');
            insert ur;
              
            System.assertEquals('Test Role 995',ur.Name);
            
            ApexPages.currentPage().getParameters().put('id',ur.id);
            
             // Instantiate the standard controller with the Role
            ApexPages.StandardController con=new ApexPages.StandardController(ur);    
            
             // Instantiate the extention instance with the standardcontroller
            DisplayTasksInRoleCalendar ext=new DisplayTasksInRoleCalendar(con);
            
            // Invoke the primary method on the extension
            ApexPages.Pagereference result=ext.roleCalendarTask();
            
            result=ext.RolesView();
            result=ext.EditRole();
            result=ext.DeleteRole();
        }*/
    // End Test Coverage
}
// End of class