// This class is used to create New Staff and User record

public with sharing class CreateNewStaffAndUserExtension4
{ 
     // Global variables
     
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
     
     
    public String profile;
    public String ProfileId;
    public String Role;
    public String RoleId;
    public String getProfileId() { return profileId; }
    public void setProfileId(String p) {  this.profileId = p; }
    public String getRoleId() { return RoleId; }
    public void setRoleId(String p) {  this.RoleId = p; }
    public  boolean isError{get;set;}
    public User us;
    public Staff__c st;
    public Staff__c st1;
    public UserRole u{get;set;}
    Public String uName;
    // End of Global variables
 
    // Standard Controller Constructor
    public CreateNewStaffAndUserExtension4(ApexPages.StandardController con)
    {
         isError = false;
         this.us= (User)con.getrecord();
         us.emailencodingkey='UTF-8';
         us.languagelocalekey='en_US';
         us.localesidkey='en_US';
         us.timezonesidkey='America/Los_Angeles';
    }
    // End constructor
    
    
    // This method is called on to populate Roles from Organization
    public List<selectOption> getRole()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
          for (UserRole roles :[SELECT Id,Name FROM UserRole ORDER BY Name])  
          {    
                options.add(new selectOption(roles.Id,roles.Name)); //for all records found - add them to the picklist options
          }
        return options; //return the picklist options
    }
    // End of method getRole
    
    // This method is called on to populate Profiles from Organization
    public List<selectOption> getProfile()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
          for (Profile users1 :[SELECT Id,Name,UserLicense.Name FROM Profile where UserLicense.Name =: 'Salesforce' OR UserLicense.Name =: 'Salesforce Platform' ORDER BY Name])  
          {    
                options.add(new selectOption(users1.Id, users1.Name)); //for all records found - add them to the picklist options
          }
        return options; //return the picklist options
    }
    // End of method getProfile
  
    // Method called on to Save record
    public Pagereference saveme()
   {
      if(profileId==NULL) // Check Profile is empty
       {
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Profile : You must select a Profile.');
            ApexPages.addMessage(myMsg1);
            return null;
       }
       if(RoleId==NULL) // Check Role is empty
       {
            ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'Role : You must select a Role.');
            ApexPages.addMessage(myMsg2);
            return null;
       }
       if(us.FirstName.length() < 3) // Check User/Staff First Name is atleast three characters
       {
           ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'First Name must have at least three characters');
           ApexPages.addMessage(myMsg3);
           return NULL;
       }
       String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(us.Username);
        
        if (!MyMatcher.matches())
         {
           ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'UserName: Not in valid email format');
           ApexPages.addMessage(myMsg3);
           return NULL;
        }
       else
       {
            UserRole u=[Select Id,Name from UserRole where Id=:RoleId];
            String uName=u.Name;
            Profile pro=[Select Id,Name from Profile where Id =: profileId];
            String proName=pro.Name;
       
            if(us.User_Types__c=='Unlicensed Staff') // If Usertype is Unlicensed Staff then Create Staff Record
            {             
                 Staff__c st=new Staff__c();
                 st.First_Name__c=us.FirstName;
                 st.Last_Name__c=us.LastName;
                 st.Name=us.FirstName+' '+us.LastName;
                 st.Email__c=us.Email;
                 st.Alias__c=(us.FirstName).subString(0,3)+''+(us.LastName).subString(0,1);
                 st.User_Type__c=us.User_Types__c;
                 st.Department__c=us.Department;
                 st.Username__c=us.Username;
                 st.Phone_1__c=us.Phone;
                 st.Fax__c=us.Fax;
                 st.Role__c=uName;
                 st.Profile__c=proName;
                 st.IsDeleted__c=False;
                 try
                 {    
                       insert st;          // Create Staff Record
                 }
                 catch(Exception e)
                 {
                     return NULL;
                 }      
                 System.debug('@@Staff record is inserted successfully '+st);  
         }  
          // If usertype is Licensed User then create User record, send mail notification to user and also create record in Staff table
          
          // Staff record is created using future method
         if(us.User_Types__c=='Licensed User')
         {                
                us.ProfileId=ProfileId;
                us.UserRoleId=RoleId;
                us.alias=(us.FirstName).subString(0,3)+''+(us.LastName).subString(0,1);
                us.Phone=us.Phone;
                us.Fax=us.Fax;
                us.User_Types__c=us.User_Types__c;
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.EmailHeader.triggerUserEmail = true;
                us.setOptions(dmo);
                try
                {
                    insert us;   // Create User record
                }
                catch(Exception e)
                {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
                    return NULL;
                }  
                // createStaff method is a future method and it is invoked to create Staff record for respected User  
                createstaff(us.User_Types__c,us.FirstName,us.LastName,us.Email,us.Username,us.UserRoleId,us.ProfileId,us.alias,us.CommunityNickname,us.Phone,us.Fax,us.emailencodingkey,us.languagelocalekey,us.localesidkey,us.timezonesidkey);
               }  
        }           
        // After save naviagate to Admin--> Staff Tab  
        
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/StaffTabLightning');
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
    // End of Save method

    //This method is invoked to handle Cancel Button
     Public PageReference cancelme()
     {
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/StaffTabLightning');
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
    //End of cancel Method
 
     // Start future method
     // This method is invoked to create Staff for respected User
     @future
    public static void createstaff(String User_Type,String fname,String lname, String email, String username, String role,string profile,String alias,String commNickName,String ph,String fax,String emailEncodingKey, String locale, String language, String TimeZone)
    {
           UserRole u=[Select Id,Name from UserRole where Id =: role];
        
           Profile pro=[Select Id,Name from Profile where Id =: profile];
        
    
           Staff__c st1=new Staff__c(User_Type__c=User_Type,First_Name__c=fname,Last_Name__c =lname,Name=fname+' '+lname,Email__c=email, Username__c=username, Role__c=u.Name,Profile__c=pro.Name,Alias__c=alias,CommunityNickName__c=commNickName,Phone_1__c=ph,Fax__c=fax,Time_Zone__c=TimeZone,Locale__c=locale,Language__c=language,Email_Encoding__c=emailEncodingKey );    
           try
            {
                insert st1;     // Create Staff record for respcted User
            }
             catch(DMLException e)
            {
                 // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
            }
           System.debug('@@Staff record is inserted successfully '+st1);
     }
     // End of future method
    
    // Test Coverage
  /*  static testMethod void createStaffUser()
    {
         Profile p = [select id from profile where name='System Administrator' limit 1];
         
         User uId= [Select Id from User where ProfileId =: p.Id and IsActive =: True LIMIT 1];
          
          System.RunAs(uId)
          {
             UserRole ur=new UserRole(Name='Test UserRole');
                 insert ur;
             System.assertEquals('Test UserRole',ur.Name);
         
             User testUser=new User();
                testUser.LastName='TestRaut';
                testUser.FirstName='Test User2';
                testUser.Email='testUser888@gmail.com';
                testUser.Username='testUser8888@gmail.com';
                testUser.UserRoleId=ur.Id;
                testUser.ProfileId =p.Id;
                testUser.User_Types__c='Staff';
                testUser.Department='Test Dept 001';
                testUser.Fax='1234';
                testUser.Phone='9870123456';
        
             // Instantiate the Standard Controller with User record
              ApexPages.currentPage().getParameters().put('id',testUser.id); 
              ApexPages.StandardController con1=new ApexPages.StandardController(testUser);
        
            // Instantiate the extention instance with the standardcontroller
             CreateNewStaffAndUserExtension4 ext1=new CreateNewStaffAndUserExtension4(con1);
        
             ext1.RoleId=ur.id;
             String role=ext1.getRoleId();
             ext1.setRoleId(role);
             List<SelectOption> optionsRole=ext1.getRole();
        
             ext1.ProfileId=p.id;
             String Profile=ext1.getProfileId();
             ext1.setProfileId(Profile);
             List<SelectOption> optionsProfile=ext1.getProfile();

             // Invoke saveme method on extension
             ApexPages.Pagereference result1=ext1.saveme();
        
            // to cover UserTYpe as User
        
             Profile p1 = [select id from profile where name='System Administrator' limit 1];
             UserRole ur1=new UserRole(Name='Test UserRole');
             insert ur1;
         
             User testUser2=new User();
             testUser2.FirstName='Test User 002';
             testUser2.LastName='Raut';
             testUser2.Email='testUserRaut002@gmail.com';
             testUser2.Username='testUserRaut002@gmail.com';
             testUser2.UserRoleId=ur1.Id;
             testUser2.Fax='4321';
             testUser2.Phone='9871032145';        
        
             testUser2.ProfileId =p1.Id;
             testUser2.User_Types__c='User';
             
            // Instantiate the Standard Controller with User record
             ApexPages.currentPage().getParameters().put('id',testUser2.id); 
             ApexPages.StandardController con2=new ApexPages.StandardController(testUser2);
        
            // Instantiate the extention instance with the standardcontroller
             CreateNewStaffAndUserExtension4 ext2=new CreateNewStaffAndUserExtension4(con2);
        
             ext2.RoleId=NULL;
             String role1=ext2.getRoleId();
             ext2.setRoleId(role1);
             List<SelectOption> optionsRole1=ext1.getRole();
        
             ext2.ProfileId=p.Id;
             String Profile2=ext2.getProfileId();
             ext2.setProfileId(Profile2);
             List<SelectOption> optionsProfile2=ext1.getProfile();
             result1=ext2.saveme();
             result1=ext2.cancelme();
        
             ext2.RoleId=ur.id;
             String role3=ext2.getRoleId();
             ext2.setRoleId(role3);
             List<SelectOption> optionsRol3=ext1.getRole();
        
             ext2.ProfileId=NULL;
             String Profile4=ext2.getProfileId();
             ext2.setProfileId(Profile4);
             List<SelectOption> optionsProfile4=ext1.getProfile();
             result1=ext2.saveme();
        
             ext2.RoleId=ur.id;
             String role5=ext2.getRoleId();
             ext2.setRoleId(role5);
             List<SelectOption> optionsRole5=ext1.getRole();    
        
             ext2.ProfileId=p.id;
             String Profile6=ext2.getProfileId();
             ext2.setProfileId(Profile6);
             List<SelectOption> optionsProfile6=ext2.getProfile();
             result1=ext2.saveme();
        
           
             User testUser1=new User();
                testUser1.LastName='Raut1';
                testUser1.FirstName='Test User1';
                testUser1.alias='TeRa';
                testUser1.Email='testUser999@gmail.com';
                testUser1.Username='testUser9991@gmail.com';
                testUser1.UserRoleId=ur.Id;
                testUser1.ProfileId =p.Id;
                testUser1.User_Types__c='User';
                testUser1.Department='Test Dept 001';
                testUser1.Fax='1234';
                testUser1.Phone='9870123456';
                testUser1.emailencodingkey='UTF-8';
                testUser1.languagelocalekey='en_US';
                testUser1.localesidkey='en_US';
                testUser1.timezonesidkey='America/Los_Angeles';
                insert testUser1;
        
            System.assertEquals('testUser999@gmail.com',testUser1.Email);
        
              // Instantiate the Standard Controller with User record 
            ApexPages.currentPage().getParameters().put('id',testUser1.id); 
            ApexPages.StandardController con3=new ApexPages.StandardController(testUser1);
        
            // Instantiate the extention instance with the standardcontroller
            CreateNewStaffAndUserExtension4 ext3=new CreateNewStaffAndUserExtension4(con3);
        
            result1=ext3.saveme();
            User u1=[Select Id from User where id=:testUser1.id];
            u1.User_Types__c='Staff';
            update u1;
        }
   }*/
    // End of Test Coverage
}
// End of Class