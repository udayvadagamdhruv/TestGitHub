@isTest
public class TestJobCostReport {
	 static testMethod void jobCostReport()
    {
         Job_Number_Setting__c customSetting1002 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1002;
            
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1002');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1002',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1002');
                insert testSpec;
                
         Campaign__c testCamp=new Campaign__c(Name='Test Camp 1002');    
              insert testCamp;  
   
         Account testClient=new Account(Name='Test Account 1002');
               insert testClient;
               
         Contact testContact=new Contact(FirstName='Test Client',LastName='ARAB',AccountId=testClient.id,Email='test1002@SFDC.com');
               insert testContact;    
                      
                
         Job__c testJob1=new Job__c(Name='Test Job 1002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,Client__c=testClient.id,Client_Contact__c=testContact.id);
               insert testJob1;
               
         System.assertEquals('Test Job 1002',testJob1.Name);
               
            // Instantiate the extention instance with the Custom Controller 
          JobCostReport ext222=new JobCostReport();
        
            Document document=new Document();
                document.Body = Blob.valueOf('Some Text');
                document.ContentType = 'application/pdf';
                document.DeveloperName = 'my_document';
                document.IsPublic = true;
                document.Name = 'JobSuite_OrganizationLogo';
                document.FolderId = [select id from folder where name = 'JobSuiteFolder'].id;
               insert document;
            JobCostReport ext2222=new JobCostReport();        
    }
}