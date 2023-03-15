public with sharing class StaffandUserDetailPageExtension 
{
   // Global variables 
   
/*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
   
    public Id userId{get;set;}
    List<User> amit{get;set;}
    private final User user;
    public String staffUsername{get;set;}
    // End of Global variables
    
    // Start Constructor 
    public StaffandUserDetailPageExtension(ApexPages.StandardController controller) 
    {
        this.user= (User)controller.getrecord();
        userid = ApexPages.currentpage().getParameters().get('id');
    }
    // End Constructor
    
    // This method is called to deactivate User 
    public pagereference deactivateUser()
    {
        try
        {
          
             User userDeactivate=[Select Id,IsActive,Username,User_Types__c from User where id=: userid limit 1];
             if(userDeactivate.User_Types__c!='Licensed User')
             {
                staffUsername=userDeactivate.Username;
                 if(schema.SobjectType.User.Fields.IsActive.isUpdateable()){ 
                     userDeactivate.IsActive=False;}
                 if(schema.SobjectType.User.Fields.IsDeleted__c.isUpdateable()){ 
                     userDeactivate.IsDeleted__c=True;}
                 if(Schema.sObjectType.User.isUpdateable()){
                     update userDeactivate;}
                deleteStaff(staffUserName);
             }
             else
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' please change the status to Unlicensed Staff.'));
                 return null;
             }
            
             
            if(isLtng)
            {
                    System.debug('User deactivation Successful'+userDeactivate);
                    PageReference p=new PageReference('/apex/StaffTabLightning');
                    p.setRedirect(true);
                    return p;
            }
            else
            {
                    System.debug('User deactivation Successful'+userDeactivate);
                    PageReference p=new PageReference('/apex/AdminListView?intFocus=5');
                    p.setRedirect(true);
                    return p;
            }
            
            
            
            
        }
        catch(Exception e)
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occurred while deactivating the User.'));
             return null;
        }
    }
    // End method deactivate User 
  
  //Method for button to get back to Users list  
     Public PageReference UsersView()
     {
            if(isLtng)
            {
                    PageReference p=new PageReference('/apex/StaffTabLightning');
                    p.setRedirect(true);
                    return p;
            }
            else
            {
                    PageReference p=new PageReference('/apex/AdminListView?intFocus=5');
                    p.setRedirect(true);
                    return p;
            }
     }
  //End of Method 
  
  //Method for User's edit functionality            
     Public PageReference EditUser()
     {
             
            if(isLtng)
            {
                    PageReference p =  new Pagereference('/apex/EditStaffAndUserLightning?id='+userid);
                    p.setRedirect(true);
                    return p;
            }
            else
            {
                    PageReference p =  new Pagereference('/apex/EditStaffAndUser?id='+userid);
                    p.setRedirect(true);
                    return p; 
            }
             
             
             
              
     }            
 //End of Edit User Method
    
    @future
    public static void deleteStaff(String staffUsername)
    {
        try
        {
            Staff__c st=[Select Id from Staff__c where Username__c=: staffUsername];
            if(schema.SobjectType.Staff__c.Fields.IsDeleted__c.isUpdateable()){ 
                st.IsDeleted__c=True;}
            if(Schema.sObjectType.Staff__c.isUpdateable()){
                update st;}
            System.debug('Corresponding staff is deleted');
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,String.valueOf(e)));
        }
    }
    public  pagereference resetpassword()
    {
        try
        {
             if(user.IsActive==True)
             {
                 System.ResetPasswordResult result = System.resetPassword(userId,true);
                 
                 
                 if(isLtng)
                 {
                        PageReference p=new PageReference('/apex/StaffandUserDetailPageLightning?id='+userid);
                        p.setRedirect(true);
                        return p; 
                 }
                 else
                 {
                        PageReference p=new PageReference('/apex/StaffandUserDetailPage?id='+userid);
                        p.setRedirect(true);
                        return p; 
                 }
                 
                 
                 
                 
             }
             else
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'User is Inactive'));
                 return null;
             }
        }
        catch(Exception e)
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
             return null;
        }
   
 // return null;
   
    }  
    
    // This method is called on to handle Display Calendar button for the selected Staff
    public Pagereference displayStaffCalendar()
    {
        Pagereference p=Page.DisplayCalendarFilterByUser;
        p.getParameters().put('id',userid);
        return p;
    }
    // ENd of method displayStaffCalendar
    
    // Test Method 
  /*  static testMethod void StaffandUserDetail()
    {
        Profile p = [select id from profile where name='System Administrator' limit 1];
        UserRole ur=new UserRole(Name='Test UserRole1');
        insert ur;
         
        User testUser=new User();
        testUser.FirstName='Sameer';
        testUser.LastName='Raut1';
        testUser.Email='testUser11@gmail.com';
        testUser.Username='testUser778@gmail.com';
        testUser.alias='test2';
        testUser.UserRoleId=ur.Id;
        testUser.CommunityNickName='test12';
        testUser.TimeZoneSidKey = 'Asia/Kolkata';//for ex'Asia/Calcutta'    //calcutta value replaced by kolkata by yogini on 14-Mar-14
        testUser.LocaleSidKey = 'en_GB'; //for ex 'en_GB'
        testUser.EmailEncodingKey = 'ISO-8859-1';//for ex'ISO-8859-1';
        testUser.ProfileId =p.Id;
        testUser.LanguageLocaleKey = 'en_US'; //for ex 'en_US'
        testUser.IsActive=True;
        insert testuser;
       
       System.assertEquals('Raut1',testuser.LastName);
       
       ApexPages.StandardController con=new ApexPages.StandardController(testuser);
       StaffandUserDetailPageExtension  ext=new StaffandUserDetailPageExtension(con);
       ApexPages.Pagereference result1= ext.resetPassword();
       result1=ext.UsersView();
       result1=ext.EditUser();
      
       testUser.IsActive=False;
       update testUser;
       result1=ext.resetPassword();
       result1=ext.deactivateUser();
       result1=ext.displayStaffCalendar();
     
     // ApexPages.StandardController con1=new ApexPages.StandardController(u);
     // StaffandUserDetailPageExtension  ext1=new StaffandUserDetailPageExtension(con1);
    //  ApexPages.PageReference result2 = ext1.resetPassword();
    //   result2 = ext1.resetPassword();
    
        User testUser2=new User();
        testUser2.FirstName='Abhishek';
        testUser2.LastName='Raut1';
        testUser2.Email='testUser4545@gmail.com';
        testUser2.Username='testUser4545@gmail.com';
        testUser2.alias='test2';
        testUser2.UserRoleId=ur.Id;
        testUser2.CommunityNickName='test4545';
        testUser2.TimeZoneSidKey = 'Asia/Kolkata';//for ex'Asia/Calcutta'    //calcutta value replaced by kolkata by yogini on 14-Mar-14
        testUser2.LocaleSidKey = 'en_GB'; //for ex 'en_GB'
        testUser2.EmailEncodingKey = 'ISO-8859-1';//for ex'ISO-8859-1';
        testUser2.ProfileId =p.Id;
        testUser2.LanguageLocaleKey = 'en_US'; //for ex 'en_US'
        testUser2.IsActive=True;
        insert testuser2;
       
       ApexPages.CurrentPage().getParameters().put('id',testUser2.id);
       
       // Instantiate the standard controller with the User
       ApexPages.StandardController con2=new ApexPages.StandardController(testuser2);
       
       // Instantiate the extention instance with the standard controller 
       
       StaffandUserDetailPageExtension  ext2=new StaffandUserDetailPageExtension(con2);
       
       // Invoke the primary method on the extension
       ApexPages.Pagereference result3= ext2.resetPassword();
       ApexPages.Pagereference result2= ext2.deactivateUser();
    } */
 // End of test Method 
}// End of Class