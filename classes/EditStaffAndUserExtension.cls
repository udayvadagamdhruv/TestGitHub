// This class is used to edit User record
public with sharing class EditStaffAndUserExtension 
{
    // Global variables
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }
    
    Public String ProfileName,userid,username;
    public String getProfileName() { return ProfileName; }
    public void setProfileName(String s) {  this.ProfileName = s; }
    Public String UserRolename;
    public String getUserRolename() { return UserRolename; }
    public void setUserRolename(String s) {  this.UserRolename = s; }
    private final User user;
    public String oldUsername;
    // End of Global variables
   
      // Start Constructor  
    public EditStaffAndUserExtension(ApexPages.StandardController controller)
    {
      this.user = (User)controller.getRecord();
      system.debug('old values of user---------->'+user);
      User u22 = [Select UserRoleId,Alias,CommunityNickName,Username,Email,FirstName,LastName,ProfileId,Phone,Extension,Fax,Title,CompanyName,Department,IsDeleted__c from User where id=:user.id];
      ProfileName = u22.ProfileId;
      UserRolename = u22.UserRoleId;
      userid = user.Id;
      oldUsername = user.Username; 
      System.debug('Old User name in controller @@@ '+oldUsername);
    }
    // End of Constructor
    
  /*  public Pagereference reset()
    {
    Database.DMLOptions dlo = new Database.DMLOptions();
    dlo.EmailHeader.triggerUserEmail = true;
    database.insert(user,dlo);
    return null;
    } */
    
     // This method is used to populate profiles in dropdown list
     public List<selectOption> getProfile()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        for (Profile users1 :[SELECT Id,Name,UserLicense.Name FROM Profile where UserLicense.Name =: 'Salesforce' OR UserLicense.Name =: 'Salesforce Platform' ORDER By Name])  
          {    
                options.add(new selectOption(users1.Id, users1.Name)); //for all records found - add them to the picklist options
          }
        return options; //return the picklist options
    }
    // End of getProfile
    
    // This method is used to populate all roles into dropdown list
    public List<selectOption> getRole()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        for (UserRole roles :[SELECT Id,Name FROM UserRole ORDER BY Name Limit 5000])  
        {    
             options.add(new selectOption(roles.Id,roles.Name)); //for all records found - add them to the picklist options
        }
        return options; //return the picklist options
    }
    // End of method getRole
    
    
  // This method is called on to save User  
    public Pagereference saveme()
    {
     try
     {
     
       // System.debug('============First Name Length=============================='+user.FirstName.length());
       //  System.debug('============First Name =============================='+user.FirstName);
     
     
         // If user is converted to Staff then Usertype is set to Unlicensed Staff and User record is made as Inactive
         
        If(user.User_Types__c=='Licensed User' && user.IsActive==false) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please change the User Type to Unlicensed Staff.');
            ApexPages.addMessage(myMsg);
            return null;
        }
         
        If(user.User_Types__c=='Unlicensed Staff') 
        {
            user.User_Types__c='Unlicensed Staff';
            user.IsActive=False;
        }
        if(ProfileName == null) // Check Profile is empty
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Profile: You must select a Profile.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        if(UserRolename == null) // Check role is empty
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Role: You must select a Role.');
            ApexPages.addMessage(myMsg);
            return null;
         }
       
       integer firstnamesize;
        if(user.FirstName==null || user.firstName=='')
         firstnamesize=0;
        else
        firstnamesize=user.FirstName.length();
        
       
       
       if(firstnamesize < 3 || firstnamesize==0) // Check User/Staff First Name is atleast three characters
        {
           ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'First Name must have at least three characters');
           ApexPages.addMessage(myMsg3);
           return NULL;
        }
         else
         {
            if(ProfileName != null)
            {
                Profile a1 = [SELECT Id, name FROM Profile where id =: ProfileName];
                user.profileId = a1.id;
            } 
            if(UserRolename != null)
            {
                UserRole ur1 = [SELECT Id, name FROM UserRole where id =: UserRolename];
                user.UserRoleId = ur1.id;
            } 
            try
            {

                update user;  // Update the User record
                system.debug('updated values of user---------->'+user);
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
                return NULL;
            }   
          } 
          
        User u=[Select Id,Name,UserRoleId,Alias,CommunityNickName,Username,Email,FirstName,LastName,ProfileId,Phone,Extension,Fax,Title,CompanyName,Department,User_Types__c,IsActive from User where id=:user.id];
        String staffName,roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,title,companyName,dept,userType;
        Boolean active;
        staffName = u.Name;
        roleId=u.UserRoleId;
        uName=u.Username;
        alias=u.alias;
        comm=u.CommunityNickName;
        email=u.Email;
        fName=u.FirstName;
        lName=u.Lastname;
        profileId=u.ProfileId;
        ph=u.Phone;
        fax=u.Fax;
        title=u.Title;
        companyName=u.CompanyName;
        dept=u.Department;
        userType=u.User_Types__c;
        active=user.IsActive;
        
        System.debug('Old User name in Update Staff @@@ '+oldUsername);
        
        // call future method to Update related Staff
        updateStaff(staffName,roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,oldUsername,active);
       
       //updating user name in Job Team 
       
      /* list<Job_Team__c> JobTeamlist=new list<Job_Team__c>();
       for(Job_Team__c JTeam: [select Id,Name,Staff__c from Job_Team__c where Email__c=:User.Email])
        {
            JTeam.Staff__c = u.Name;
            system.debug('============================================>'+u.name);
            JobTeamlist.add(JTeam);
        }
        
        Database.update(JobTeamlist);
       */ 
        
    }
    catch(DMLException e)
    {
          return null;
    }
    // Navigate to Admin--> Staff Tab
    
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
     
     // This is future method and It is invoked to update respected Staff
     @future
    public static void updatestaff(String staffName,String roleId,String username,String alias,String comm,String email,String fName,String lName,String profileId,String ph,String fax,String dept,String userType, String oldUsername,Boolean active)
    {
        UserRole u=[Select Id,Name from UserRole where Id =: roleId];
        String uRole1=u.Name;
        Profile pro=[Select Id,Name from Profile where Id =: profileId];
        String proName=pro.Name;
    
        Staff__c st1=[Select Id,Active__c,Role__c,Username__c,Alias__c,CommunityNickName__c,Email__c,First_Name__c,Last_Name__c,Name,Profile__c,Phone_1__c,Fax__c,Department__c,User_Type__c from Staff__c where Username__c =: oldUsername LIMIT 1];    
        
        try
        {
            st1.Role__c = uRole1;
            st1.Alias__c = alias;
            st1.CommunityNickName__c = comm;
            st1.Email__c = email;
            st1.Username__c = username;
            st1.First_Name__c = fName;
            st1.Last_Name__c = lName;
            st1.Name = staffName;
            st1.Profile__c = proName;
            st1.Phone_1__c = ph;
            st1.Fax__c = fax;
            st1.Department__c = dept;
            st1.User_Type__c = userType;
           st1.Active__c=active;
            update st1;
        }
         catch(DMLException e)
        {
         // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
        }
         System.debug('@@Staff record is updated successfully '+st1);
     }
 // End of method updateStaff
 
    // This method is used to handle cancel button
      public Pagereference cancelme()
      {
         
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
      // End of method cancel
    

    // Test Method    
 /*   static testMethod void EditStaffAndUser()
    {
         Profile p = [select id from profile where name='System Administrator' limit 1];
         UserRole ur=[Select Id, Name from UserRole LIMIT 1];
        
         User u=[Select Id from User where IsActive=: True LIMIT 1];
        
         System.runAs(u)
        {
            // Insert Staff Record
            Staff__c testST=new Staff__c(User_Type__c='Staff',First_Name__c='Test',Last_Name__c='Staff',Username__c='testUser857@SFDC.com',Email__c='testUser857@SFDC.com',Alias__c='teST',Role__c=ur.Name,Profile__c='System Administrator',Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
            
                insert testST;
                
            System.assertEquals('Staff',testST.User_Type__c);    
            
            // Insert User Record
            User testUser=new User();
                 testUser.LastName='Raut11';
                 testUser.FirstName='Test User';
                 testUser.Email='testUser111@gmail.com';
                 testUser.UserRoleId=ur.Id;
                 testUser.ProfileId =p.Id;
                 testUser.User_Types__c='Staff';
                 testUser.Department='Test Dept 001';
                 testUser.Fax='1234';
                 testUser.Phone='9870123456';
                 testUser.alias='testA';
                 testUser.LanguageLocaleKey='en_US';
                 testUser.EmailEncodingKey='ISO-8859-1';
                 testUser.LocaleSidKey='en_US';
                 testUser.TimeZoneSidKey='Asia/Kolkata';    //Calcutta value replaced Kolkata by yogini on 14-Mar-14
                 testUser.CommunityNickname='testComm';
                 testUser.Username='testUser857@SFDC.com';
                 testUser.IsActive=True;
            insert testuser;
        
            ApexPages.currentPage().getParameters().put('id',testUser.id); 
           
           ApexPages.StandardController con1=new ApexPages.StandardController(testuser);
       
           EditStaffAndUserExtension   ext1=new EditStaffAndUserExtension (con1);
     
           ext1.UserRoleName=ur.id;
           String role1=ext1.getUserRolename();
           ext1.setUserRolename(role1);
           List<SelectOption> optionsRole1=ext1.getRole();
        
           ext1.ProfileName=p.id;
           String Profile1=ext1.getProfileName();
           ext1.setProfileName(Profile1);
           List<SelectOption> optionsProfile1=ext1.getProfile();
    
           ApexPages.PageReference result2 = ext1.saveme();
       
           result2=ext1.cancelme();    
      }
    } // End of method runAs
// End of test Method */
}
// End of Clas