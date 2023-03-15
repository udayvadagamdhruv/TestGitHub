public with sharing class staffEditExtension 
{
      // Start Global variables
     /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }
      
    public String ProfileName;
    public String RoleName;
    public String getProfileName() { return profileName; }
    public void setProfileName(String p) {  this.profileName = p; }
    public String getRoleName() { return RoleName; }
    public void setRoleName(String p) {  this.RoleName = p; } 
    public Id aid{get;set;}
    public Staff__c objJTR{get;set;}
    public final Staff__c objstaff;
    public  User usr;
    public String oldUsername;
     // End Global variables

    // Start Constructor
    public staffEditExtension(ApexPages.StandardController controller)
     {
        this.objstaff = (Staff__c)controller.getrecord();
        aid=ApexPages.currentPage().getParameters().get('id');
        system.debug('aid is@@@ :'+aid);
        system.debug('staff obj : ' + objstaff);
        objJTR=[Select id,Name,First_Name__c,User_Type__c,CommunityNickName__c,Alias__c,Last_Name__c,Active__c,Role__c,Email__c,Profile__c,Username__c,IsDeleted__c,Phone_1__c,Phone_2__c,Department__c,Fax__c,Locale__c,Language__c,Time_Zone__c,Email_Encoding__c from Staff__c where Id=: objstaff.id];
            oldUsername = objJTR.Username__c;
      
        String st1=objJTR.Role__c;
       
        String st2=objJTR.Profile__c;
       
        UserRole ur=[Select Name from UserRole where Name =: st1];
        Profile pro=[Select Id,Name from Profile where Name =: st2];
        
        RoleName=ur.Id;
       
        ProfileName=pro.Id;
       
    }
    // End Constructor

  // This method is used to populate all Role into DropdownList
    public List<selectOption> getRole()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
         for (UserRole roles :[SELECT Id,Name FROM UserRole ORDER BY Name])  
          {    
                options.add(new selectOption(roles.Id,roles.Name)); //for all records found - add them to the picklist options
          }
        return options; 
    }
    // End of method getRole
    
      // This method is used to populate all Profiles into DropdownList
     public List<selectOption> getProfile()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
          for (Profile users1 :[SELECT Id,Name,UserLicense.Name FROM Profile where UserLicense.Name =: 'Salesforce' OR UserLicense.Name =: 'Salesforce Platform' ORDER BY Name])  
          {    
                options.add(new selectOption(users1.Id, users1.Name)); //for all records found - add them to the picklist options
          }
        return options;
    }    
    // End of method getProfile
    
   // This method is used to update Staff
    public pagereference Saveme()
    {
        system.debug('Staff name :' + objJTR.Username__c);
        system.debug('Staff name :' + objJTR.First_Name__c);
        system.debug('Staff name :' + objJTR.Last_Name__c);
        
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);        
        Matcher MyMatcher = MyPattern.matcher(objJTR.Username__c);
              
       if(!MyMatcher.matches())
        {
           ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'UserName : Not in valid email format');
           ApexPages.addMessage(myMsg3);
           return NULL;
        }
        if(objJTR.User_Type__c=='Unlicensed Staff') // If usertype is Unlicensed Staff update the Staff Record
        {
            if(schema.SobjectType.Staff__c.Fields.Name.isUpdateable()){ 
                objJTR.Name = objJTR.First_Name__c+' '+objJTR.Last_Name__c;}
             UserRole ur=[Select Name from UserRole where Id =: RoleName];
             Profile pro=[Select Id,Name from Profile where Id =: ProfileName]; 
               if(schema.SobjectType.Staff__c.Fields.Role__c.isUpdateable()){
                   objJTR.Role__c = ur.Name;}
              if(schema.SobjectType.Staff__c.Fields.Profile__c.isUpdateable()){  
                  objJTR.Profile__c = pro.Name;}
             try
             {
                if(objJTR.First_Name__c.length() < 3) // Check User/Staff First Name is atleast three characters
                 {
                   ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'First Name must have at least three characters');
                   ApexPages.addMessage(myMsg3);
                   return NULL;
                 }
                else
                 {
                     if(Schema.sObjectType.Staff__c.isUpdateable()){
                         update objJTR;}   // Update Staff Record
                 }
             }
             catch(Exception e)
             {
                 return NULL;
             }
        }
        
       // If usertype is Licensed User then create User record and update the Staff record using future method
       
       // First Check if user record is already present, If present make it as Active else create the new User record 
       if(objJTR.User_Type__c=='Licensed User')
         {       
             List<User> lstUser=[Select Id,Name from User where Username=:objJTR.Username__c limit 1];
             if(lstUser.size()==1)
             {
                 String roleId, staffName,uName, alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,title,companyName,emailEncodingKey,Language,Locale,timeZone;
                 Boolean active;
                 for(User usr:lstUser)
                 {
                     if(schema.SobjectType.User.Fields.IsActive.isUpdateable()){ 
                         usr.IsActive=True;}
                     if(schema.SobjectType.User.Fields.User_Types__c.isUpdateable()){ 
                         usr.User_Types__c='Licensed User';}
                     if(Schema.sObjectType.User.isUpdateable()){
                         update usr;}
                         
                      User u=[Select Id,IsActive, Name, UserRoleId,Alias,CommunityNickName,Username,Email,FirstName,LastName,ProfileId,Phone,Extension,Fax,Title,CompanyName,Department,User_Types__c,timezonesidkey,emailencodingkey,languagelocalekey,localesidkey from User where id=:usr.id];
                      
                      staffName = u.Name;
                      roleId=u.UserRoleId;
                      uName=u.Username;
                      alias=(u.FirstName).subString(0,3)+''+(u.LastName).subString(0,1);
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
                      emailEncodingKey=u.EmailEncodingKey;
                      Language=u.LanguageLocaleKey;
                      Locale=u.Localesidkey;
                      timeZone=u.timezonesidkey;
                      active=u.IsActive;
                 }
                 // updateStaff is a future method. It is called on to update Staff record when Usertype is converted to Licensed User from Unlicensed Staff
                 updateStaff(staffName,roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,emailEncodingKey,Language,Locale,timeZone,oldUsername,active);
             }
             else
             {
                    
                    Staff__c st=[Select Role__c,Profile__c from STaff__c where Id=: aid];
                    String st1=st.Role__c;
                    String st2=st.Profile__c;

                    // Create a user record if User record does not exist for a Staff

                    usr=new User();
                 if (Schema.sObjectType.User.fields.FirstName.isCreateable()) {usr.FirstName=objJTR.First_Name__c;}
                 if (Schema.sObjectType.User.fields.LastName.isCreateable()) {usr.LastName=objJTR.Last_Name__c;}
                 if (Schema.sObjectType.User.fields.Email.isCreateable()) {usr.Email=objJTR.Email__c;}
                 if (Schema.sObjectType.User.fields.User_Types__c.isCreateable()) {usr.User_Types__c=objJTR.User_Type__c;}
                 if (Schema.sObjectType.User.fields.Department.isCreateable()) {usr.Department=objJTR.Department__c;}
                 if (Schema.sObjectType.User.fields.Username.isCreateable()) {usr.Username=objJTR.Username__c;}
                 if (Schema.sObjectType.User.fields.emailencodingkey.isCreateable()) {usr.emailencodingkey=objJTR.Email_Encoding__c;}
                 if (Schema.sObjectType.User.fields.languagelocalekey.isCreateable()) {usr.languagelocalekey=objJTR.Language__c;}
                 if (Schema.sObjectType.User.fields.localesidkey.isCreateable()) {usr.localesidkey=objJTR.Locale__c;}
                 if (Schema.sObjectType.User.fields.timezonesidkey.isCreateable()) {usr.timezonesidkey=objJTR.Time_Zone__c;}
                 if (Schema.sObjectType.User.fields.Alias.isCreateable()) {usr.Alias=objJTR.Alias__c;}
                 if (Schema.sObjectType.User.fields.CommunityNickName.isCreateable()) {usr.CommunityNickName=objJTR.CommunityNickName__c;}
                    if(objJTR.Email_Encoding__c==NULL)
                    {
                        if (Schema.sObjectType.User.fields.EmailEncodingKey.isCreateable()) {  usr.EmailEncodingKey='ISO-8859-1';}
                    }
                   else
                   {
                       if (Schema.sObjectType.User.fields.EmailEncodingKey.isCreateable()) {  usr.EmailEncodingKey=objJTR.Email_Encoding__c;}
                   }
                   if(objJTR.Language__c==NULL)
                   {
                       if (Schema.sObjectType.User.fields.languagelocalekey.isCreateable()) { usr.languagelocalekey='en_US';}
                   }
                  else
                  {
                      if (Schema.sObjectType.User.fields.languagelocalekey.isCreateable()) { usr.languagelocalekey=objJTR.Language__c;}
                  }
                 if(objJTR.Time_Zone__c==NULL)
                 {    
                     if (Schema.sObjectType.User.fields.timezonesidkey.isCreateable()) {  usr.timezonesidkey='America/Panama';}
                 }
                 else
                 {
                     if (Schema.sObjectType.User.fields.timezonesidkey.isCreateable()) { usr.timezonesidkey=objJTR.Time_Zone__c;}
                 }
                 if(objJTR.Locale__c==NULL)
                 {
                     if (Schema.sObjectType.User.fields.localesidkey.isCreateable()) {usr.localesidkey='en_US';}
                 }
                 else
                 {
                     if (Schema.sObjectType.User.fields.localesidkey.isCreateable()) {usr.localesidkey=objJTR.Locale__c;}
                 }
                     
                 Profile pro=[Select Id,Name from Profile where Name=:st2];
                 UserRole uRole=[Select Id,Name from UserRole where Name=: st1];
                 if (Schema.sObjectType.User.fields.ProfileId.isCreateable()) {  usr.ProfileId=pro.id;}
                 if (Schema.sObjectType.User.fields.UserRoleId.isCreateable()) { usr.UserRoleId=uRole.id;}
                 try
                 {
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.EmailHeader.triggerUserEmail = true;
                    usr.setOptions(dmo);
                     if(Schema.sObjectType.User.isCreateable()){ insert usr;}  // Create User record
                 }
                 catch(Exception e)
                 {
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
                       return NULL;
                 }
                User u=[Select Id,IsActive,Name,UserRoleId,Alias,CommunityNickName,Username,Email,FirstName,LastName,ProfileId,Phone,Extension,Fax,Title,CompanyName,Department,User_Types__c,timezonesidkey,emailencodingkey,languagelocalekey,localesidkey from User where id=:usr.id];
                String staffName = u.Name;
                String roleId=u.UserRoleId;
                String uName=u.Username;
//                String alias=(u.FirstName).subString(0,4);
                String alias=(u.FirstName).subString(0,3)+''+(u.LastName).subString(0,1);
                String comm=u.CommunityNickName;
                String email=u.Email;
                String fName=u.FirstName;
                String lName=u.Lastname;
                String profileId=u.ProfileId;
                String ph=u.Phone;
                String fax=u.Fax;
                String title=u.Title;
                String companyName=u.CompanyName;
                String dept=u.Department;
                String userType=u.User_Types__c;
                String locale=u.localesidkey;
                String language=u.languagelocalekey;
                String emailEncodingKey=u.emailencodingkey;
                String timeZone= u.timezonesidkey;
                Boolean active = u.IsActive;
                
                // updateStaff is a future method and it is called on to update Staff record
                updateStaff(staffName, roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,locale,language,emailEncodingKey,timeZone,oldUsername,active);
             }
         }
        // After editing Staff, navigate to Admin-->Staff Tab 
        
        
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/StaffTabLightning');
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                    Pagereference  pageRef =  new Pagereference('/apex/AdminListView?intFocus=5');
                    pageRef.setRedirect(true);
                    return pageRef;
            }
        
       
    }
    // End of method Save
    
    // This method is used to update STaff if Usertypes has changed to User from Staff
     @future
    public static void updatestaff(String staffName,String roleId,String username,String alias,String comm,String email,String fName,String lName,String profileId,String ph,String fax,String dept,String userType,String locale,String language,String emailEncodingKey, String timeZone, String oldUsername,Boolean active)
    {
        UserRole u=[Select Id,Name from UserRole where Id =: roleId];
        String uName1=u.Name;
        Profile pro=[Select Id,Name from Profile where Id =: profileId];
        String proName=pro.Name;
    
        Staff__c st1=[Select Id,Role__c from Staff__c where Username__c=: oldUsername];    
        try
        {
            if(schema.SobjectType.Staff__c.Fields.Role__c.isUpdateable()){ 
                st1.Role__c=uName1;}
            if(schema.SobjectType.Staff__c.Fields.Alias__c.isUpdateable()){ 
                st1.Alias__c=alias;}
            if(schema.SobjectType.Staff__c.Fields.CommunityNickName__c.isUpdateable()){ 
                st1.CommunityNickName__c=comm;}
            if(schema.SobjectType.Staff__c.Fields.Email__c.isUpdateable()){ 
                st1.Email__c=email;}
            if(schema.SobjectType.Staff__c.Fields.Username__c.isUpdateable()){ 
                st1.Username__c=username;}
            if(schema.SobjectType.Staff__c.Fields.First_Name__c.isUpdateable()){ 
                st1.First_Name__c=fName;}
            if(schema.SobjectType.Staff__c.Fields.Last_Name__c.isUpdateable()){ 
                st1.Last_Name__c=lName;}
            if(schema.SobjectType.Staff__c.Fields.Name.isUpdateable()){ 
                st1.Name = fName+' '+lName;}
            if(schema.SobjectType.Staff__c.Fields.Name.isUpdateable()){ 
                st1.Name = staffName;}
            if(schema.SobjectType.Staff__c.Fields.Profile__c.isUpdateable()){ 
                st1.Profile__c=proName;}
            if(schema.SobjectType.Staff__c.Fields.Phone_1__c.isUpdateable()){ 
                st1.Phone_1__c=ph;}
            if(schema.SobjectType.Staff__c.Fields.Fax__c.isUpdateable()){ 
                st1.Fax__c=fax;}
            if(schema.SobjectType.Staff__c.Fields.Department__c.isUpdateable()){ 
                st1.Department__c=dept;}
            if(schema.SobjectType.Staff__c.Fields.User_Type__c.isUpdateable()){ 
                st1.User_Type__c=userType;}
            if(schema.SobjectType.Staff__c.Fields.Email_Encoding__c.isUpdateable()){ 
                st1.Email_Encoding__c=emailEncodingKey;}
            if(schema.SobjectType.Staff__c.Fields.Locale__c.isUpdateable()){ 
                st1.Locale__c=locale;}
            if(schema.SobjectType.Staff__c.Fields.Language__c.isUpdateable()){ 
                st1.Language__c=language;}
            if(schema.SobjectType.Staff__c.Fields.time_Zone__c.isUpdateable()){ 
                st1.time_Zone__c=timeZone;}
            if(schema.SobjectType.Staff__c.Fields.active__c.isUpdateable()){ 
                st1.active__c=active;}
            if(Schema.sObjectType.Staff__c.isUpdateable()){
                update st1;}
            
             system.debug('Staff name update :' + st1.First_Name__c);
        system.debug('Staff name update  :' + st1.Last_Name__c);
        }
         catch(DMLException e)
        {
             // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
        }
         System.debug('@@Staff record is updated successfully '+st1);
     }
    // End of method updateStaff
    
    // This method is called on to handle Cancel button
    public pagereference Cancel()
    {
       
        if(isLtng)
        {
            PageReference pageRef =  new Pagereference('/apex/StaffDetailPageLightning?id='+aid);
            pageRef.setRedirect(true);
            return pageRef;
        }
        else
        {
            PageReference pageRef =  new Pagereference('/apex/StaffDetailPage?id='+aid);
            pageRef.setRedirect(true);
            return pageRef;
        }
       
    }
    // End of method Cancel
    
  /*  // Start Test Coverage 
        static testMethod void staffEdit()
        {
        
            Profile p1=[Select Id,Name from Profile where Name =: 'System Administrator' LIMIT 1];
        
            User u1=[Select Id,IsActive from User where IsActive=: True AND ProfileId=: p1.Id LIMIT 1];
        
            // Set up User
            System.RunAs(u1)
          {
                 UserRole uRole1=new UserRole(Name='Testing');
                     insert uRole1;
           
                 Staff__c testST=new Staff__c(User_Type__c='Staff',First_Name__c='Test',Last_Name__c='Staff',Username__c='testStaff1021@jobsuite.com',Email__c='testStaff1021@jobsuite.com',Alias__c='TEST',Role__c=uRole1.Name,Profile__c='System Administrator',Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
            
                     insert testST;
          
                 User testUser=new User();
                 testUser.FirstName='Test';
                 testUser.LastName='Staff';
                 testUser.Email='testStaff1021@SFDC.com';
                 testUser.Username='testStaff1021@SFDC.com';
                 testUser.alias='TEST';
                 testUser.UserRoleId=uRole1.Id;
                 testUser.CommunityNickName='test12';
                 testUser.TimeZoneSidKey = 'Asia/Kolkata';//for ex'Asia/Calcutta'    //calcutta value replaced by kolkata by yogini on 14-MAr-14
                 testUser.LocaleSidKey = 'en_GB'; //for ex 'en_GB'
                 testUser.EmailEncodingKey = 'ISO-8859-1';//for ex'ISO-8859-1';
                 testUser.ProfileId =p1.Id;
                 testUser.LanguageLocaleKey = 'en_US'; //for ex 'en_US'
                 testUser.IsActive=True;
                 testUser.User_Types__c='User';
                 insert testuser;
            
                System.assertEquals('Staff',testST.User_Type__c);
            
                ApexPages.currentPage().getParameters().put('id',testST.id);
            
                // Instantiate the standard controller with the Staff
                ApexPages.StandardController con1=new ApexPages.StandardController(testST);
            
                // Instantiate the extention instance with the standard controller 
                staffEditExtension ext1=new staffEditExtension(con1);
            
                // Invoke the primary method on the extension
                ApexPages.Pagereference result1=ext1.save();
            
                ext1.getRole();
                ext1.getProfile();
                ext1.getRoleName();
                ext1.setProfileName(p1.id);
                ext1.setRoleName(urole1.id);
                ext1.getProfileName();
           
                User u=[Select Id,FirstName,LastName,Name,alias,Username,Email from User where Id=: testuser.Id limit 1];
            
                Staff__c testST2=new Staff__c(User_Type__c='User',First_Name__c=u.FirstName,Last_Name__c=u.LastName,Username__c=u.UserName,Email__c=u.Email,Role__c=uRole1.Name,Alias__c=u.alias,Profile__c=p1.name,Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
            
                insert testST2;
            
                ApexPages.currentPage().getParameters().put('id',testST2.id);
            
                // Instantiate the standard controller with the Staff
                ApexPages.StandardController con2=new ApexPages.StandardController(testST2);
            
                // Instantiate the extention instance with the standard controller 
                staffEditExtension ext2=new staffEditExtension(con2);
                
                // Invoke the primary method on the extension
                result1=ext2.save();
                
               Staff__c testST3=new Staff__c(User_Type__c='User',First_Name__c='Test',Last_Name__c='Staff',Username__c='testStaff10211@jobsuite.com',Email__c='testStaff10211@jobsuite.com',Alias__c='TEST',Role__c=uRole1.Name,Profile__c=p1.Name,Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
                
                insert testST3;
       
                ApexPages.currentPage().getParameters().put('id',testST3.id);
            
                // Instantiate the standard controller with the Staff
                ApexPages.StandardController con3=new ApexPages.StandardController(testST3);
            
                // Instantiate the extention instance with the standard controller 
                staffEditExtension ext3=new staffEditExtension(con3);
            
                // Invoke the primary method on the extension
               result1=ext3.save();
       }//End of RunAs       
    }
    // End Test Coverage */
}
// End of Class