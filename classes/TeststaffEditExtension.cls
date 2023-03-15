//@isTest
Public Class TeststaffEditExtension{

// Start Test Coverage 
    /*    static testMethod void TeststaffEdit()
        {
        
            Profile p1=[Select Id,Name from Profile where Name =: 'System Administrator' LIMIT 1];
        
            User u1=[Select Id,IsActive from User where IsActive=: True AND ProfileId=: p1.Id LIMIT 1];
        
            // Set up User
            System.RunAs(u1)
          {
                 UserRole uRole1=new UserRole(Name='Testing');
                     insert uRole1;
           
                 Staff__c testST=new Staff__c(User_Type__c='Unlicensed Staff',First_Name__c='Test',Last_Name__c='Staff',Username__c='testStaff1021@jobsuite.com',Email__c='testStaff1021@jobsuite.com',Alias__c='TEST',Role__c=uRole1.Name,Profile__c='System Administrator',Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
            
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
                 testUser.User_Types__c='Licensed User';
                 insert testuser;
            
                System.assertEquals('Unlicensed Staff',testST.User_Type__c);
            
                ApexPages.currentPage().getParameters().put('id',testST.id);
            
                // Instantiate the standard controller with the Staff
                ApexPages.StandardController con1=new ApexPages.StandardController(testST);
            
                // Instantiate the extention instance with the standard controller 
                staffEditExtension ext1=new staffEditExtension(con1);
            
                // Invoke the primary method on the extension
                ApexPages.Pagereference result1=ext1.saveme();
            
                ext1.getRole();
                ext1.getProfile();
                ext1.getRoleName();
                ext1.setProfileName(p1.id);
                ext1.setRoleName(urole1.id);
                ext1.getProfileName();
           
                User u=[Select Id,FirstName,LastName,Name,alias,Username,Email from User where Id=: testuser.Id limit 1];
            
                Staff__c testST2=new Staff__c(User_Type__c='Licensed User',First_Name__c=u.FirstName,Last_Name__c=u.LastName,Username__c=u.UserName,Email__c=u.Email,Role__c=uRole1.Name,Alias__c=u.alias,Profile__c=p1.name,Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
            
                insert testST2;
            
                ApexPages.currentPage().getParameters().put('id',testST2.id);
            
                // Instantiate the standard controller with the Staff
                ApexPages.StandardController con2=new ApexPages.StandardController(testST2);
            
                // Instantiate the extention instance with the standard controller 
                staffEditExtension ext2=new staffEditExtension(con2);
                
                // Invoke the primary method on the extension
                result1=ext2.saveme();
                
               Staff__c testST3=new Staff__c(User_Type__c='Licensed User',First_Name__c='Test',Last_Name__c='Staff',Username__c='testStaff10211@jobsuite.com',Email__c='testStaff10211@jobsuite.com',Alias__c='TEST',Role__c=uRole1.Name,Profile__c=p1.Name,Active__c=True,Fax__c='12345',Phone_1__c='9870123456',Email_Encoding__c='ISO 8859-1');
                
                insert testST3;
       
                ApexPages.currentPage().getParameters().put('id',testST3.id);
            
                // Instantiate the standard controller with the Staff
                ApexPages.StandardController con3=new ApexPages.StandardController(testST3);
            
                // Instantiate the extention instance with the standard controller 
                staffEditExtension ext3=new staffEditExtension(con3);
            
                // Invoke the primary method on the extension
               result1=ext3.saveme();
              ApexPages.PageReference  result3=ext3.Cancel();
       }//End of RunAs       
    }*/
    // End Test Coverage


}