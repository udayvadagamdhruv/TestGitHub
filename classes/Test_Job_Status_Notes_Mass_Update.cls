@isTest
public class Test_Job_Status_Notes_Mass_Update {
    static testMethod void Test_Job_Status_Notes_Mass_Update_Test(){
        Job_Number_Setting__c customSetting988 = new  Job_Number_Setting__c(Name= 'yy');
        insert customSetting988;
        
        Campaign__c testCamp=new Campaign__c(Name='Test Camp 858');
        Media_Type__c testMedia=new Media_Type__c(Name='Media Type 858');
        insert testMedia;
        
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='ST858',Media_Types__c=testMedia.Id);
        insert testST;
        
        Specification_Template__c testSpec=new Specification_Template__c(Name='SPT858');
        insert testSpec;
        
        Campaign__c testCampaign1=new Campaign__c(Name='Camp858',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
        insert testCampaign1;
        
        Client__c a=new Client__c(Name='Account858');
        insert a;
        
        Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 858',Last_Name__c='Contact 858',Client__c=a.id,Email__c='testEmail858@sfdc.com',Salesforce_User__c=False);
        insert c;
        
        Job__c testJob1=new Job__c(Name='Job858',Start_Date__c=System.Today(),Job_Description__c ='test description',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
        
        insert testJob1;
        
        Job__c testJob2=new Job__c(Name='Job858',Start_Date__c=System.Today(),Job_Description__c ='test description',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
        
        insert testJob2;
        
        list<Job__c> joblist=new list<Job__c>(); 
        joblist.add(testJob1);
        joblist.add(testJob2);
        System.assertEquals('Job858',testJob1.Name);    
        
        ApexPages.StandardSetController stanSetCon=new ApexPages.StandardSetController(joblist);
        Job_Status_Notes_Mass_Update_Controller con=new Job_Status_Notes_Mass_Update_Controller(stanSetCon);
        con.updateStatusNotes();
        con.CancelStatusNotes();
        
    }
}