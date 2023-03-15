//@isTest
public class Test_multipleScheduleCopy{
   /* static TestMethod void Test_multipleScheduleCopy(){
    
        Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');
        insert customSetting1;
                
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 7003');
        insert testMedia;
                 
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 7003',Media_Types__c=testMedia.Id);
        insert testST;
                     
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 7003');
        insert testSpec;
                    
        Campaign__c testCamp=new Campaign__c(Name='Test Camp 7003');    
        insert testCamp;  
       
        Client__c testClient=new Client__c(Name='Test Account 7003');
        insert testClient;
                   
        Client_Contact__c testContact=new Client_Contact__c(Name='Test Client Ind',First_Name__c='Test Client',Last_Name__c='Ind',Client__c=testClient.id,Email__c='test7003@SFDC.com');
        insert testContact;    
                          
                    
        Job__c testJob1=new Job__c(Name='Test Job 7003',Status__c = 'Active',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
        insert testJob1;
                   
        Job__c testJob2=new Job__c(Name='Test Job 70031',Status__c = 'Active',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
        insert testJob2;
        
        Job_Task__c testJT=new Job_Task__c(Name='Test JT 7003',Job__c = testJob1.Id,Days__c = 2, Assigned_Users__c = 'TestUser', Revised_Due_Date__c = System.Today(), Status__c ='Active');
        insert testJT;
    
        Job_Task__c testJT1=new Job_Task__c(Name='Test JT 7004',Job__c = testJob1.Id,Days__c = 3, Assigned_Users__c = 'TestUser', Revised_Due_Date__c = System.Today(), Status__c ='Active');
        insert testJT1;
        
        Job_Task__c testJT2=new Job_Task__c(Name='Test JT 7003',Job__c = testJob2.Id,Days__c = 2, Assigned_Users__c = 'TestUser', Revised_Due_Date__c = System.Today(), Status__c ='Active');
        insert testJT2;
    
        Job_Task__c testJT3=new Job_Task__c(Name='Test JT 7004',Job__c = testJob2.Id,Days__c = 3, Assigned_Users__c = 'TestUser', Revised_Due_Date__c = System.Today(), Status__c ='Active');
        insert testJT3;
                        
        Job_Task_Role__c testJTR=new Job_Task_Role__c(Name='Test JTR 7003',Job_Task__c=testJT.id);     
        insert testJTR;
              
        List<Job_Task_Role__c> l=[Select Id from Job_Task_Role__c where Job_Task__r.Job__c=:testJob1.id];
        
        System.assertEquals('Test Job 7003',testJob1.Name);     
        ApexPages.currentPage().getParameters().put('CpyId',testJob1.id);
        multipleScheduleCopyController ext = new multipleScheduleCopyController();
        ext.cancel();
        ext.saveRsc();
        ext.jbWrap[0].varJbSelect=true;
        ext.saveRsc();
        
        ApexPages.currentPage().getParameters().put('RSid',testJob1.id);
        multipleScheduleUpdateController ext1 = new multipleScheduleUpdateController();
        ext1.cancel();
        ext1.saveRsc();
        ext1.jbWrap[0].varJbSelect=true;
        ext1.saveRsc();
    }*/
}