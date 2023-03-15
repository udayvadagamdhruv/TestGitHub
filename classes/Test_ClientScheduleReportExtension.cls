@isTest
public class Test_ClientScheduleReportExtension{
    public static testMethod void Test_ClientScheduleReportExtension()
        {
        
           Job_Number_Setting__c customSetting950 = new  Job_Number_Setting__c(Name= 'yy');
           insert customSetting950;
                
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1005');
                 
                    insert testMedia;
                 
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1005',Media_Types__c=testMedia.Id);
                 
                     insert testST;
                     
              Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schedule 1005',Schedule_Template__c=testST.id,Days__c=2);
                  insert testSchedule;       
                     
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1005');
                    insert testSpec;
                    
              Campaign__c testCamp=new Campaign__c(Name='Test Camp 1005');    
                  insert testCamp;  
       
               Account testClient=new Account(Name='Test Account 1005');
                   insert testClient;
                   
               Contact testContact=new Contact(FirstName='Test Client',LastName='RUS',AccountId=testClient.id,Email='test1005@SFDC.com');
                   insert testContact;    
                          
              Job__c testJob1=new Job__c(Name='Test Job 1005',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,Client__c=testClient.id,Client_Contact__c=testContact.id);
                   insert testJob1;
              
            List<Document> lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];     
              System.assertEquals('Test Job 1005',testJob1.Name);
                   
              ApexPages.currentPage().getParameters().put('id',testJob1.id);
              ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
              ClientScheduleReportExtension ext=new ClientScheduleReportExtension(con);
        }
}