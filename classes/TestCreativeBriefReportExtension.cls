@isTest

Public Class TestCreativeBriefReportExtension{

 static testMethod void TestCreativeBriefReportExtension()
    {
            Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting001;
            
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1008');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1008',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1008');
                insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='Test Spec Item 1008',Specification_Template__c=testSpec.id);
              insert testSPI;              
                
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 1008');    
              insert testCamp;  
   
           Client__c testClient=new Client__c(Name='Test Account 1008');
               insert testClient;
               
           Client_Contact__c testContact=new Client_Contact__c(Name='Test Client AUS',First_Name__c='Test Client',Last_Name__c='AUS',Client__c=testClient.id,Email__c='test1008@SFDC.com');
               insert testContact;    
                      
                
          Job__c testJob1=new Job__c(Name='Test Job 1008',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
               insert testJob1;
               
           System.assertEquals('Test Job 1008',testJob1.Name);    
               
           ApexPages.currentPage().getParameters().put('id',testJob1.id);
               
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                       
           CreativeBriefReportExtension ext=new CreativeBriefReportExtension(con);
    }



}