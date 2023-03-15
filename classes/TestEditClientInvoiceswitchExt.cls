//@isTest
public class TestEditClientInvoiceswitchExt {
	/*static TestMethod void TestEditClientInvoiceswitchExt  (){
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 381');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 381',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 381');
                insert testSpec;
                
          Campaign__c testCampaign=new Campaign__c(Name='Test Camp 381');
              insert testCampaign;     
            
           Job__c testJob1=new Job__c(Name='Test Job 381',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign.id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
               
               System.assertEquals('Test Job 381',testJob1.Name);
        
        Client__c testClient=new Client__c(Name='Client 623');
       insert testClient;  
        
       Client_Invoice__c testCI=new Client_Invoice__c(Name='CLI', Client_Name__c=testClient.id,Job__c=testJob1.id);
        insert testCI;
        EditClientInvoiceswitchExt controller = new EditClientInvoiceswitchExt (new ApexPages.StandardController(testCI));
       // boolean x = controller.isMobile;
}*/
}