@istest
public class Test_displayAllClientJobsTabController 
{
   /* 
    static testMethod void Test_displayAllClientJobsTabController()
    {
        
         Profile p1=[Select Id, Name From Profile where Name=: 'System Administrator' LIMIT 1]; 
             //Set up user 
    
          User u1 = [SELECT Id,FirstName,LastName,Name FROM User WHERE ISActive =: True And ProfileId =: p1.Id Limit 1];
        
            //Run As U1 
    
        System.RunAs(u1){
        
            Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

           insert customSetting001;
    
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1012');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1012',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1012');
                insert testSpec;
                
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 1012');    
              insert testCamp;  
   
           Client__c testClient=new Client__c(Name='Test Account 1012');
               insert testClient;
               
           Client_Contact__c testContact=new Client_Contact__c(Name=u1.Name,First_Name__c=u1.FirstName,Last_Name__c=u1.LastName,Client__c=testClient.id,Email__c='test1012@SFDC.com',Salesforce_User__c=True,username__c='test7003@SFDC.com');
               insert testContact;    
                      
                
          Job__c testJob1=new Job__c(Job_Auto_Number__c='1012',Name='Test Job 1012',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id,Status__c='Active');
               insert testJob1;
               
               System.assertEquals('Test Job 1012',testJob1.Name);
               

           ApexPages.currentPage().getParameters().put('id',testJob1.id);
           ApexPages.StandardController con1=new ApexPages.StandardController(testJob1);
           displayAllClientJobsTabController ext=new displayAllClientJobsTabController(con1);
           
           ext.selectedItem='All';
           ext.filterJobs();    
           
           ext.selectedItem='Status is Active';
           ext.filterJobs();    
           
           ext.selectedItem='Status is Cancelled';
           ext.filterJobs();    
           
           ext.selectedItem='Status is Completed';
           ext.filterJobs(); 
           
           ext.selectedItem='Status is On Hold';
           ext.filterJobs(); 
           
           ext.selectedItem='Status is Requested';
           ext.filterJobs(); 
              
            ext.getItems();
      }// Runs as U1
  }
 // End Test Coverage */

}