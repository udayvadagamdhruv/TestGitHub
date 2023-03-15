@isTest
public class TestStaffListViewSwitchExt {
	static testmethod void TestAdminpageRedirectExt (){
 	/* Profile p = [select id from profile where name='System Administrator' limit 1];
         
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
   
                ApexPages.StandardController con = new ApexPages.StandardController(testUser);
     			StaffListViewSwitchExt ext=new StaffListViewSwitchExt(con);
                ext.Staffview();
          }    
 	*/
 }
}