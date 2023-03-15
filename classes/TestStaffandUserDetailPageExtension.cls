@isTest
public class TestStaffandUserDetailPageExtension {
	/*static testMethod void StaffandUserDetail()
    {
        Profile p = [select id from profile where name='System Administrator' limit 1];
        UserRole ur=new UserRole(Name='Test UserRole1');
        insert ur;
         
        User testUser=new User();
        testUser.FirstName='mani';
        testUser.LastName='kurella';
        testUser.Email='testUser11@gmail.com';
        testUser.Username='testUser9533@gmail.com';
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
       
       System.assertEquals('kurella',testuser.LastName);
       
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
}