@istest
public class Test_JobLogSheetTest1 
{
    
     // Start Test Coverage
    static testMethod void Test_JobLogSheetTest1()
    {
    
         Job_Number_Setting__c customSetting989 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting989;
            
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1003');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1003',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1003');
                insert testSpec;
                
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 1003');    
              insert testCamp;  
   
           Client__c testClient=new Client__c(Name='Test Account 1003');
               insert testClient;
               
           Client_Contact__c testContact=new Client_Contact__c(Name='Test Client Ind',First_Name__c='Test Client',Last_Name__c='Ind',Client__c=testClient.id,Email__c='test1003@SFDC.com',Salesforce_User__c=True,username__c='test7003@SFDC.com');
               insert testContact;    
                      
                
          Job__c testJob1=new Job__c(Name='Test Job 1003',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
               insert testJob1;
          System.assertEquals('Test Job 1003',testJob1.Name);     
          JobLogSheetTest1  ext=new JobLogSheetTest1 ();
          
          Document document=new Document();
                document.Body = Blob.valueOf('Some Text');
                document.ContentType = 'application/pdf';
                document.DeveloperName = 'my_document';
                document.IsPublic = true;
                document.Name = 'JobSuite_OrganizationLogo';
                document.FolderId = [select id from folder where name = 'JobSuiteFolder'].id;
                insert document;
             JobLogSheetTest1  ext1=new JobLogSheetTest1 ();
      //    ext.getmainnodes();     
                   
    } // End of test Method  
    

}