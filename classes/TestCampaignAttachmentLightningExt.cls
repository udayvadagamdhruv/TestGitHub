//@isTest
public class TestCampaignAttachmentLightningExt {
	/* static testMethod void TestCampaignAttachmentLightningExt()
        {
             
           Campaign__c  testI=new Campaign__c(name='test 123');
           insert testI;
               
               ApexPages.StandardController con=new ApexPages.StandardController(testI);
                   
               ApexPages.currentPage().getParameters().put('Id', testI.Id);
               
               // Instantiate the extention instance with the standard controller 
               CampaignAttachmentLightningExtensions ext= new CampaignAttachmentLightningExtensions(con);
               
               test.startTest();
               
               ext.getmyfile();
               
               // Invoke the primary method on the extension   
               Pagereference pg=ext.SaveDoc();
               
               Pagereference pg1=ext.cancelme();
               
               Campaign__c obj1=[Select id,name from Campaign__c where Name=: 'test 123'];
               obj1.name='Test 234';
               update obj1;
         
               Campaign__c obj2=[Select id from Campaign__c where Name=: 'Test 234'];
               delete obj2;
               pg=ext.SaveDoc();
               
               test.stopTest();
        }
    /* End of Test Coverage*/

}