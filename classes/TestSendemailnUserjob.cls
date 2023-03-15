@isTest
Public class TestSendemailnUserjob{

 Public static testmethod void TestSendemailnUserjob(){
 
         /*  Media_Type__c testMedia=new Media_Type__c(Name='Test Media 313');
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
           
            string before = 'Testing base 64 encode';
            Blob beforeblob = Blob.valueOf(before);
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
            ApexPages.StandardController con = new ApexPages.StandardController(testJob1);
        
            // Instantiate the extention instance with the standardcontroller
          SendemailnUserjob ext = new SendemailnUserjob(con);
          ext.email='test@gmail.com';
          ext.emailBody ='Hi testing from Jobsuite';
          ext.filename1='Test.pdf';
          ext.commandbutton1=beforeblob;
        
          //ext.sendmail();
         // ext.sendmail();
          ext.cancel();
 */
 
 
 
 } 

}