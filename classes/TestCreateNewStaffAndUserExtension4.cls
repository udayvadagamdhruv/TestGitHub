//@IsTest
Public Class TestCreateNewStaffAndUserExtension4{
/*
static testMethod void TestcreateStaffUser()
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
                testUser.User_Types__c='Unlicensed Staff';
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
             testUser2.User_Types__c='Licensed User';
             
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
                testUser1.User_Types__c='Licensed User';
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
            u1.User_Types__c='Unlicensed Staff';
            update u1;
        }
   }

*/



}