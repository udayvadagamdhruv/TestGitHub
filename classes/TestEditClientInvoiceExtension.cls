//@isTest
Public class TestEditClientInvoiceExtension{
/*static testMethod void TestEditClientInvoiceExtension(){

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
           insert testI;
           
            Client_Invoice__c    testCI = [Select id,name from Client_Invoice__c   where id =:testI.Id];
         
             // Instantiate the standard controller with the Client
          ApexPages.StandardController con = new ApexPages.StandardController(testCI);
          ApexPages.CurrentPage().getParameters().put('id',testCI.id);
          
          EditClientInvoiceExtension ext = new EditClientInvoiceExtension(con);
          ApexPages.PageReference result1=ext.saveme();
          ApexPages.PageReference result2=ext.cancelme();
          
          result1=ext.saveme();
          
          List<SelectOption> Clients=ext.getClients();
          string result5=ext.getClientName();
          ext.setClientName('Test Client');
          
          
          
  }*/
  }