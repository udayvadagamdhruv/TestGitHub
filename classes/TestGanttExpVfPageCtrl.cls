@isTest
public class TestGanttExpVfPageCtrl {
    // Start Test Coverage
    
   @testSetup static void SetupMethod() 
    {
        GanttExpVfPageCtrl ext=new GanttExpVfPageCtrl();
    
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1004');
        insert testMedia;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1004',Media_Types__c=testMedia.Id);
        insert testST;
        
        Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schdule Task 1004',Days__c=2,Schedule_Template__c=testST.id);
        insert testSchedule;       
        
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1004');
        insert testSpec;
        
        Campaign__c testCamp=new Campaign__c(Name='Test Camp 1004',Start_Date__c=System.Today(),End_Date__c=System.Today(),Status__c = 'Active' );    
        insert testCamp;  
        
        Client__c testClient=new Client__c(Name='Test Account 1004');
        insert testClient;
       
        Client_Contact__c testContact=new Client_Contact__c(Name='Test Client SRI',First_Name__c='Test Client',Last_Name__c='SRI',Client__c=testClient.id,Email__c='test1004@SFDC.com');
        insert testContact;
      
        Job__c testJob1=new Job__c (Name='Test Job 1004',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Status__c = 'Active',Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
        insert testJob1;
        
        System.assertEquals('Test Job 1004',testJob1.Name);    
        ext.getCampaigns();
        ext.getClients();
        ext.getCampStatus();
        ext.getJobNames();
        ext.getjobStatus();
        ext.getCampaignnames();
        ext.test();
        ext.redirect();
        ext.getMediatype();
        ext.getscheduletemp();
         
       GanttExpVfPageCtrl.loadrecordsJobs(testCamp.name,testClient.name,testMedia.name,testSpec.name,testJob1.Status__c);
        GanttExpVfPageCtrl.loadrecordsJobcampaigns(testCamp.name,testCamp.Status__c);
         GanttExpVfPageCtrl.getGanttTasks(testCamp.name,testClient.name,testMedia.name,testSpec.name,testJob1.Status__c);
        //GanttExpVfPageCtrl.updateJobRec(testJob1.id,System.Today(),System.Today(),true);
        //GanttExpVfPageCtrl.updateJobCampaigns(testCamp.id,testCamp.Start_Date__c,testCamp.End_Date__c);
      
        
    }
     @isTest static void testcmp(){
         test.startTest();
         Campaign__c testcmp=[select Id,Name from Campaign__c where Name='Test Camp 1004'];
         string startenddate=string.valueof(System.Today());
       
       GanttExpVfPageCtrl.updateJobCampaigns(testcmp.Id,startenddate,startenddate);
         test.stopTest();
    }
    
    @isTest static void testjob(){
       //List<String> obj=['Account','Job__c'];
       // calendarCmpController.getObjectFieldLabels('Account');
       test.startTest();
        //Campaign__c testcmp=[select Id,Name from Campaign__c where Name='Camp'];
        //Client__c testclient=[select Id,Name from Client__c where name='test client'];
        //Media_Type__c testmedia=[select Id,Name from Media_Type__c where Name='Test Media 614'];
        //Schedule_Template__c testST=[select id,Name,Media_Types__c from Schedule_Template__c where Name='Test Schedule Template 614'];
        Job__c testJob2=[select id,name from Job__c where Name='Test Job 1004'];
        string startenddate=string.valueof(System.Today());
        
       
        GanttExpVfPageCtrl.updateJobRec(testJob2.Id,startenddate,startenddate,true);
        test.stopTest();
        
    }
}