@isTest
Public class TestStatusReportExtensionsNew{

 // Start Test Coverage
    
  static testMethod void Test_StatusReportExtensions()
    {
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
                
           Campaign__c testCamp=new Campaign__c(Name='Test Camp 1004');    
              insert testCamp;  
   
           Client__c testClient=new Client__c(Name='Test Account 1004');
               insert testClient;
               
           Client__c testClient1=new Client__c(Name='Test Account 1005');
               insert testClient1;
               
           Client_Contact__c testContact=new Client_Contact__c(Name='Test Client SRI',First_Name__c='Test Client',Last_Name__c='SRI',Client__c=testClient.id,Email__c='test1004@SFDC.com');
               insert testContact;
           Client_Contact__c testContact1=new Client_Contact__c(Name='Test Client SRI1',First_Name__c='Test Client1',Last_Name__c='SRI1',Client__c=testClient.id,Email__c='test10104@SFDC.com');
               insert testContact1;     
                      
          Job__c testJob1=new Job__c(Name='Test Job 1004',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Status__c = 'Active',Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
               insert testJob1;
               
          Job__c testJob2=new Job__c(Name='Test Job 1005',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Status__c = 'Active',Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
               insert testJob2;
               
          System.assertEquals('Test Job 1004',testJob1.Name);    
               
          // Instantiate the extention instance with the Custom controller 
          StatusReportExtensionsNew ext=new StatusReportExtensionsNew();
          
          // Invoke the primary method on the extension
          
          //ext.getmainnodes();
          ext.getjbmap();
          string str;
          list<Job__c> lst;
          //cNodes cn = new cNodes(str, lst );
            
         Document document=new Document();
                document.Body = Blob.valueOf('Some Text');
                document.ContentType = 'application/pdf';
                document.DeveloperName = 'my_document';
                document.IsPublic = true;
                document.Name = 'JobSuite_OrganizationLogo';
                document.FolderId = [select id from folder where name = 'JobSuiteFolder'].id;
                insert document;
         StatusReportExtensionsNew ext2=new StatusReportExtensionsNew();
    }  
    // End Test Coverage  









}