// This class is used to displa Role List
public with sharing class RoleList 
{
    // Global variables
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            } 
    
    private List<UserRole> roles;
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public String roleId{get;set;}
    // End of Global variables   
 
    /* public RoleList()
     {}
     */
     
     public String sortExpression
     {
        get
        {
            return sortExp;
        }
        set
        {
            // if the columns is clicked on then switch between ascending and descending modes
            if( value == sortExp)
            {
                sortDirection = (sortDirection== 'ASC')?'DESC' : 'ASC';
            }
            else
            {
                sortDirection='ASC';
            } 
            sortExp=value;
        }
    }
    
    public string getSortDirection()
    {
        // if not columns is selected
        if(sortExpression==NULL || sortExpression=='')
        {
            return 'ASC';
        }
        else
        {
            return sortDirection;
        }
    }
    
    public void setSortDirection(String value)
    {
        sortDirection=value;
    }
    
    public List<UserRole> getRoles()
    {
        return roles;
    }
    
    public PageReference ViewData() 
    {
        string sortFullExp = sortExpression  + ' ' + sortDirection;
      
       //query the database based on the sort expression
        roles = Database.query('Select id, Name from UserRole order by ' + sortFullExp + ' limit 1000');
        return null;
     }

   // public List<UserRole> list_role{get;set;}
  //  public String myMsg {get;set;}
    public RoleList(ApexPages.StandardController controller) 
    {
        
      //      list_role=[Select Name From UserRole Order By Name];
      // roleId = ApexPages.CurrentPage().getParameters().get('id');
      ViewData();
    }
    
    // This method called on to handle New Role button
    public pagereference createNewRole()
    {
          Pagereference p;
            if(isLtng)
            {
                     p=new Pagereference('/apex/createNewRoleLightning');
            }
            else
            {
                     p=new Pagereference('/apex/createNewRole');
            }
       		p.setRedirect(true);
            return p;
       
     /*   Pagereference p=new Pagereference('/apex/createNewRole');
        p.setRedirect(true);
        return p;*/
    }
    // End method CreateNewRole
  
  
  // This method is called on to handle delete Role 
   public PageReference deleteRole()
   {
      //roleId = ApexPages.CurrentPage().getParameters().get('id');
      
      UserRole ur=[Select id,Name from UserRole where id=:roleId];
      
      String roleName=ur.Name;
      
      List<Staff__c> lstStaff=[Select id,name from Staff__c where Role__c=: roleName];
      
      List<User> lstUser=[Select id,name from User where UserRoleId=: roleId and IsActive=True];
      
      try
      {
      
      if(lstStaff.size()==0 && lstUser.size()==0)
      {
            Database.delete(roleId); 
      }
      else
      {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Your attempt to delete this role could not be completed because staff/users are currently assigned to this role');
           ApexPages.addMessage(myMsg);
           return NULL;
      }  
      }
      catch(System.DMLException e)
      {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf('hello')));
            return null;
      }
      
        PageReference p=new PageReference('/apex/AdminListView?intFocus=6');
        p.setRedirect(true);
        return p;
      }
      // End method deleteRole 
      
    // Start Test Coverage
    static testMethod void Test_RoleList()
    {
        UserRole ur=new UserRole(Name='Test Role 321');
        insert ur;
        
        System.assertEquals('Test Role 321',ur.Name);
        ApexPages.CurrentPage().getParameters().put('id',ur.id);
        ApexPages.StandardController con=new ApexPages.StandardController(ur);
        RoleList ext=new RoleList(con);
        ApexPages.Pagereference result=ext.createNewRole();
        result=ext.ViewData();
        ext.sortDirection='DESC';
        ext.sortExpression=NULL;
        ext.sortExp='name';
        ext.setSortDirection('');
         ext.getSortDirection();
        result=ext.ViewData();
        ext.getRoles();
        UserRole uRole=[select id from UserRole where Name='Test Role 321'];
        ext.roleId=uRole.id;
        result=ext.deleteRole();
        
     }
     // End of Test Coverage
}// End of Class