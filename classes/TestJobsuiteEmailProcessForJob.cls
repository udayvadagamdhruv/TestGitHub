@isTest
Public class TestJobsuiteEmailProcessForJob{


static testMethod void TestJobsuiteEmailProcessForJob() {
   
   
   Media_Type__c testMedia=new Media_Type__c(Name='Test Media 313');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 313',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 314',Media_Types__c=testMedia.Id);
               insert testST1;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 313');
               insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 314');
               insert testSpec1;
           
           Job__c testJob1=new Job__c(Name='Test Job 314',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('Test Job 314',testJob1.Name);  
   
  // create a new email and envelope object
  
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

  // setup the data for the email
  email.subject =testJob1.id;
  email.fromname = 'FirstName LastName';
  env.fromAddress = 'someaddress@email.com';

  // add an attachment
  Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
  attachment.body = blob.valueOf('my attachment text');
  attachment.fileName = 'textfile.txt';
  attachment.mimeTypeSubType = 'text/plain';

  email.binaryAttachments =
    new Messaging.inboundEmail.BinaryAttachment[] { attachment };

  // call the email service class and test it with the data in the testMethod
  JobsuiteEmailProcessForJob emailProcess = new JobsuiteEmailProcessForJob();
  emailProcess.handleInboundEmail(email, env);

  

}

static testMethod void TestJobsuiteEmailProcessForJob1() {
   
   
   Media_Type__c testMedia=new Media_Type__c(Name='Test Media 313');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 313',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 314',Media_Types__c=testMedia.Id);
               insert testST1;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 313');
               insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 314');
               insert testSpec1;
           
           Job__c testJob1=new Job__c(Name='Test Job 314',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('Test Job 314',testJob1.Name);  
   
  // create a new email and envelope object
  
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

  // setup the data for the email
  email.subject =testJob1.id;
  email.fromname = 'FirstName LastName';
  env.fromAddress = 'someaddress@email.com';

  

  // call the email service class and test it with the data in the testMethod
  JobsuiteEmailProcessForJob emailProcess = new JobsuiteEmailProcessForJob();
  emailProcess.handleInboundEmail(email, env);

  

}



}