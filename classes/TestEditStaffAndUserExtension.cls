@IsTest
Public class TestEditStaffAndUserExtension{

  /*static testMethod void TestEditStaffAndUser()
    {
         Profile p = [select id from profile where name='standard user' limit 1];
         UserRole ur=[Select Id, Name from UserRole LIMIT 1];
        
         User u=[Select Id from User where IsActive=: True AND Profile.name ='System Administrator' LIMIT 1];
        
         System.runAs(u)
        {
            // Insert Staff Record
            Staff__c testST=new Staff__c(User_Type__c='Unlicensed Staff',First_Name__c='Test',Last_Name__c='Staff',Username__c='testUser857@SFDC.com',Email__c='testUser857@SFDC.com',Alias__c='teST',Role__c=ur.Name,Profile__c='System Administrator',Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
            
                insert testST;
                
            System.assertEquals('Unlicensed Staff',testST.User_Type__c);    
            
            // Insert User Record
            User testUser=new User();
                 testUser.LastName='Raut11';
                 testUser.FirstName='Test User';
                 testUser.Email='testUser111@gmail.com';
                 testUser.UserRoleId=ur.Id;
                 testUser.ProfileId =p.Id;
                 testUser.User_Types__c='Unlicensed Staff';
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
// End of test Method

*/

}