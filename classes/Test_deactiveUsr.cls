@isTest
public class Test_deactiveUsr{
    
    static testmethod void Test_deactiveUsr(){
    
        Profile p = [select id from profile where name='System Administrator' limit 1];
        UserRole ur=[Select Id, Name from UserRole LIMIT 1];
    
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
             testUser.TimeZoneSidKey='Asia/Kolkata'; //calcutta value replaced by kolkata
             testUser.CommunityNickname='testComm';
             testUser.Username='testUser857@SFDC.com';
             testUser.IsActive=True;
        insert testuser;
            
        boolean fg = false;
        string st1 = testuser.id+'';
        string role= ur.name;   
        deactiveUsr.updtusr(fg,st1,role);
    }
}