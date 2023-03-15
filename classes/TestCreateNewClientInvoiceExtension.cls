//@isTest
Public class TestCreateNewClientInvoiceExtension{
/*static testMethod void TestCreateNewClientInvoiceExtension(){

  Job_Number_Setting__c customSetting994 = new  Job_Number_Setting__c(Name= 'yy');
           insert customSetting994;
            
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 623');
           insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 623',Media_Types__c=testMedia.Id);
           insert testST;
         
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 623');
           insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 623',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                 insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
             }
           System.assertEquals('Test Job 623',testJob1.Name);  
               
           Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
   
           Client_Invoice__c  testI=new Client_Invoice__c(Job__c=testjob1.Id,Client_Name__c=testClient.Id);

           ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testI);
     
           // Instantiate the extention instance with the standard controller
           CreateNewClientInvoiceExtension  ext =new CreateNewClientInvoiceExtension(con);
        
           // Invoke the primary method on the extension 
           ApexPages.PageReference result1=ext.saveme();
           ApexPages.PageReference result2=ext.cancelme();
            
            
           // Negative Test
           Client_Invoice__c testI1=new Client_Invoice__c();
           ApexPages.StandardController con1=new ApexPages.StandardController(testI1);
           CreateNewClientInvoiceExtension ext1=new CreateNewClientInvoiceExtension(con1);
           ApexPages.PageReference result3=ext.saveme();
           ApexPages.PageReference result4=ext.cancelme();
           
             


}
*/


}