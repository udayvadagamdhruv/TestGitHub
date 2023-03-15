@isTest
public class Test_MyWipComponentController {
    static testmethod void TestMethodOne(){
        Job_Number_Setting__c customSetting992 = new  Job_Number_Setting__c(Name= 'yy');
        insert customSetting992;
        
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1004');
        insert testMedia;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1004',Media_Types__c=testMedia.Id);
        insert testST;
        
        
        Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schdule Task 1004',Days__c=2,Schedule_Template__c=testST.id);
        insert testSchedule;       
        
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1004');
        insert testSpec;
        
        Campaign__c testCamp=new Campaign__c(Name='Test Camp 1004',Start_Date__c=System.Today(),End_Date__c=System.Today() );    
        insert testCamp;  
        
        Client__c testClient=new Client__c(Name='Test Account 1004');
        insert testClient;
        
        Client__c testClient1=new Client__c(Name='Test Account 1005');
        insert testClient1;
        
        Client_Contact__c testContact=new Client_Contact__c(Name='Test Client SRI',First_Name__c='Test Client',Last_Name__c='SRI',Client__c=testClient.id,Email__c='test1004@SFDC.com');
        insert testContact;
        
        Client_Contact__c testContact1=new Client_Contact__c(Name='Test Client SRI1',First_Name__c='Test Client1',Last_Name__c='SRI1',Client__c=testClient.id,Email__c='test10104@SFDC.com');
        insert testContact1;     
        
        Job__c testJob1=new Job__c (Name='Test Job 1004',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Status__c = 'Active',Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
        insert testJob1;
        User u=[SELECT Id,Name From User Where Id=:Userinfo.getUserId()];
        Job_Task__c testTask1 = new Job_Task__c (Name='testTask1',Assigned_Users__c=u.name,job__c =testJob1.id,Days__c = 10,Revised_Due_Date__c=System.Today(),Marked_Done__c=false);
        insert testTask1;
        Timesheet_Entries__c tse = new Timesheet_Entries__c(Task_Name__c=testTask1.name, Job__c = testTask1.job__c, User__c = userinfo.getuserid(), Date__c = system.today());
        insert tse;
        
        MyWipComponentController.getFiltersForCalenders();
        MyWipComponentController.getMyWIPTasks('1', '', '', '', '');
        MyWipComponentController.taskUpdatebyDragDrop(testTask1.Id, Datetime.now().format('yyyy-MM-dd'), Datetime.now().format('yyyy-MM-dd'), '1');
        MyWipComponentController.taskUpdatewithResizing(testTask1.Id,  Datetime.now().format('yyyy-MM-dd'));
        MyWipComponentController.getTaskTimeSheets(testTask1.Id);
        MyWipComponentController.deleteTimeSheet(tse.id );
        MyWipComponentController.getProgressTaskstoMyWIp(testTask1.Id, '1', '', '', '', '');
        MyWipComponentController.removeTaskFromMyWIpSection(testTask1.Id, '1', '', '', '', '');
         
        MyWipComponentController.fetchUpdatedTaskInformation(testTask1.Id);
        //MyWipComponentController.getAllProgressTasks('', '', '', '' ,'');
        MyWipComponentController.updateRestSchedule(testTask1.Id,  Datetime.now().format('yyyy-MM-dd'), true);
        MyWipComponentController.getMyWIPTasks('2', '', '', '', '');
        MyWipComponentController.getMyWIPTasks('3', '', '', '', '');
        MyWipComponentController.makeMarkDoneTask(testTask1.Id, '1', '', '', '', '' );
        MyWipComponentController.getProgressTaskstoMyWIp(testTask1.Id, '2', '', '', '', '');
        MyWipComponentController.getProgressTaskstoMyWIp(testTask1.Id, '3', '', '', '', '');
    }
}