@isTest(SeeAllData=true)

public class TestTaskCalendarController {
    // Start Test Coverage
    
    static testMethod void TestTaskCalendarController()
        
    {
        
        TaskCalendarController.updateJSCampaign('','','','','');
            /*

Profile p=[Select Id from Profile where Name=: 'System Administrator'];

User u=[Select Id,Name from User where IsActive=: True and ProfileId=: p.Id LIMIT 1];


System.runAs(u)
{
Job_Number_Setting__c customSetting992 = new  Job_Number_Setting__c(Name= 'yy');
insert customSetting992;

Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1004');
insert testMedia;

Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1004',Media_Types__c=testMedia.Id);
insert testST;

/* staff__c testSTAFF=new staff__c (Name='staff 1004');
insert testSTAFF;

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

Job__c testJob2=new Job__c (Name='Test Job 1005',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Status__c = 'Active',Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
insert testJob2;

Job_Task__c testTask1 = new Job_Task__c (Name='testTask1',Status__c='completed',job__c =testJob2.id,Days__c = 10,Assigned_Users__c = u.Name,Revised_Due_Date__c=System.Today());
insert testTask1;

Job_Task__c testTask2 = new Job_Task__c (Name='testTask2',job__c =testJob2.id,Days__c = 20,Assigned_Users__c = u.Name,Revised_Due_Date__c=System.Today());
insert testTask2;

System.assertEquals('Test Job 1004',testJob1.Name);    

ApexPages.currentPage().getParameters().put('id',testJob2.Id);

TaskCalendarController  ext=new TaskCalendarController();


//  ext.getStaff();
//  ext.getRole();
ext.JobTask();
ext.printcal();
ApexPages.currentPage().getParameters().put('CalTaskId',testTask1.Id); 
ext.calenderTaskEdit();
ApexPages.currentPage().getParameters().put('DTaskId',testTask1.Id); 
ApexPages.currentPage().getParameters().put('DTaskStatus','Completed');  
ext.statusChangeUpdate();
ApexPages.currentPage().getParameters().put('DCalTaskId',testTask1.Id); 
ApexPages.currentPage().getParameters().put('DcalDueDate',Datetime.now().format('yyyy-MM-dd')); 
ext.CaleEditSave();
ext.TaskDueDateUpdate();
}
}        


private static testmethod void testupdateJSCampaign()
{
test.startTest();
Profile p=[Select Id from Profile where Name=: 'System Administrator'];

User u=[Select Id,Name from User where IsActive=: True and ProfileId=: p.Id LIMIT 1];


System.runAs(u)
{

Job_Number_Setting__c customSetting992 = new  Job_Number_Setting__c(Name= 'yy');
insert customSetting992;

Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1004');
insert testMedia;

Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1004',Media_Types__c=testMedia.Id);
insert testST;

/* staff__c testSTAFF=new staff__c (Name='staff 1004');
insert testSTAFF;

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

Job__c testJob2=new Job__c (Name='Test Job 1005',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Status__c = 'Active',Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
insert testJob2;

Job_Task__c testTask1 = new Job_Task__c (Name='testTask1',Assigned_Users__c = u.Name,job__c =testJob2.id,Days__c = 10,Revised_Due_Date__c=System.Today());
insert testTask1;

Job_Task__c testTask2 = new Job_Task__c (Name='testTask2',Assigned_Users__c = u.Name,job__c =testJob2.id,Days__c = 20,Revised_Due_Date__c=System.Today());
insert testTask2;

System.assertEquals('Test Job 1004',testJob1.Name);    

ApexPages.currentPage().getParameters().put('id',testJob2.Id);



String name = 'testTask2'; 
String cntid = testJob2.id;
String endate ='2015-12-27'; 
String stdate = '2015-12-27';
string jn = 'id='+testTask2.id;


test.stopTest();
}  
}*/
            }
}