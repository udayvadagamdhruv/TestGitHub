@IsTest
public class Test_AdminController {
    public static testMethod void Test_AdminController(){
        AdminController.geLabelforObject('UserRole');
        AdminController.getRoles();
        AdminController.CreatenewRole('TestRole');
        AdminController.getUsers();
        AdminController.getSURoles(); 
        AdminController.getProfile();
        List<UserRole> urrList=[select id,name from UserRole];
        AdminController.updateRole(urrList);
        
        UserRole ur=new UserRole(Name='Test UserRole');
        insert ur;
        UserRole ur1=new UserRole(Name='Test UserNewRole');
        insert ur1;
        AdminController.DeleteRol(ur1.Id);
        
        Profile p = [select id from profile where name='System Administrator' limit 1];
        User userDeactivate=[Select Id,IsActive,Username,User_Types__c from User limit 1];
        String ProfileId=p.Id;
        String UrRoleId=ur.Id;
        
        /*   User testUser=new User();
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
insert testUser;*/
        
        String UserInsert= '{"User_Types__c":"Licensed User","IsActive":true,"FirstName":"Mani","LastName":"Kurella","Email":"manikanta@dhruvsoft.com","Username":"manikantadsds@dhruvsoft.com","Phone":9533929303,"Fax":9533929303,"Department":null,"communitynickname":"Kurella","TimeZoneSidKey":"America/Los_Angeles","LocaleSidKey":"en_GB","LanguageLocaleKey":"en_US","EmailEncodingKey":"ISO-8859-1","ProfileId":"ProfileId","UserRoleId":"UrRoleId","alias":"ManK"}';
        system.debug('>>>>>UserInsert>>>>>>'+UserInsert);
        Test.startTest();
        AdminController.InsertUsers(UserInsert);
        AdminController.UpdateUsers(UserInsert,'manikantadsds@dhruvsoft.com');
        //  AdminController.deleteStaff('TestStaff');
        AdminController.getStaffs();
        
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
        testUser.alias ='DhrS';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.LocaleSidKey = 'en_GB';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.LanguageLocaleKey = 'en_US'; 
        insert testUser;
        
        AdminController.deactivateUser(testUser.Id);
        AdminController.deleteStaff(testUser.Username);
        Test.stopTest();
    }
    
    
    public static testMethod void Test_AdminController1(){
        
        Profile p = [select id from profile where name='System Administrator' limit 1];
        UserRole UR=[select id from UserRole limit 1];
        String ProId=p.Id;
        String UrRId=UR.Id;
        
        Schedule_Template__c testST1=new Schedule_Template__c(Name='Testing Schedule Template1213',Active__c=True);
        insert testST1;
        
        
        GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1101');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='GL Code 1101',GL_ID__c='TestGL9988',GL_Department__c = testGLD.id);
        insert testGL;
        
        
        Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task123',Schedule_Template__c=testST1.Id,GL_Code__c = testGL.id,Days__c=2,Task_Order__c=1);
        insert testSCT1;
        
        Schedule_Task__c testSCT2=new Schedule_Task__c(Name='Test Schedule Task453',Schedule_Template__c=testST1.Id,GL_Code__c = testGL.id,Days__c=2,Task_Order__c=2);
        insert testSCT2;
        
        Schedule_Task__c testSCT3=new Schedule_Task__c(Name='Test Schedule Task221',Schedule_Template__c=testST1.Id,GL_Code__c = testGL.id,Days__c=2,Task_Order__c=3);
        insert testSCT3;
        
        Schedule_Task__c testSCT4=new Schedule_Task__c(Name='Test Schedule Task212',Schedule_Template__c=testST1.Id,GL_Code__c = testGL.id,Days__c=2,Task_Order__c=4);
        insert testSCT4;
        
        ScheduleTaskRole__c StR = new ScheduleTaskRole__c(Name='testRoless',Schedule_Task__c=testSCT1.Id);
        insert StR;
        
        String SelectedRole = '[{"checked":true,"URole":{"Name":"Art Director"}},{"checked":true,"URole":{"Name":"Client"}},{"checked":false,"URole":{"Name":"Copywriter"}},{"checked":true,"URole":{"Name":"Designer"}},{"checked":false,"URole":{"Name":"Graphic Designer"}},{"checked":false,"URole":{"Name":"Production"}},{"checked":false,"URole":{"Name":"Project Manager"}}]';
        Test.startTest();
        AdminController.getSchduleTasks('Strn');
        list<Schedule_Task__c> SchTaskList=[select id,name from Schedule_Task__c];
        AdminController.UpdateScheuleTasks(SchTaskList);
        AdminController.getTaskBelowOrder(testSCT1.Id);
        AdminController.getSTRolesWrapper(testSCT1.Id);
        AdminController.AddRolesToScheduleTask(testSCT1.Id,SelectedRole);
        AdminController.DeleteScheduleTask(testSCT4.Id);
        
        AdminController.createstaff('Licensed User','Mani','Kurella','manikanta@dhruvsoft.com','manikantadsds@dhruvsoft.com',UrRId,ProId,'ManK','Kurella','9533929303','9533929303','ISO-8859-1','en_US','en_GB','America/Los_Angeles');
        AdminController.updatestaff('Mani Kurell',UrRId,'manikantadsds@dhruvsoft.com','ManK','Kurella','manikanta@dhruvsoft.com','Mani','Kurell',ProId,'9533929303','9533929303','Department','Unlicensed Staff','manikantadsds@dhruvsoft.com',True);
        Test.stopTest();
    }
    
}