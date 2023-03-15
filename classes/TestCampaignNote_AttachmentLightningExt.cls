//@isTest
public class TestCampaignNote_AttachmentLightningExt {
/*	static testMethod void TestCampaignNote_AttachmentLightningExt()
        {
            Profile p=[Select Id from Profile where Name='System Administrator' limit 1];
            
           User u=[Select Id from User where IsActive=: True and profileId=: p.Id Limit 1];
            
            System.runAs(u)
           {
           
               Campaign__c  testI=new Campaign__c(name='test 123');
               insert testI;
           
               Note n=new Note(parentId=testI.Id,Title='Test Title 352',IsPrivate=True,Body='Test Note Body');
                   insert n;
               
               System.assertEquals('Test Title 352',n.Title);
              
               // Instantiate the standard controller with the Job
               ApexPages.StandardController con=new ApexPages.StandardController(testI);
                   
               ApexPages.currentPage().getParameters().put('Id', testI.Id);
               
               // Instantiate the extention instance with the standard controller 
               
               CampaignNote_AttachmentLightningExt ext= new CampaignNote_AttachmentLightningExt(con);
               
               // Invoke the primary method on the extension
               
               ApexPages.Pagereference pr=ext.CreateNote();
               pr=ext.AttachFile();
           
               ApexPages.Pagereference pg1=ext.editNote();
               ApexPages.Pagereference pg2=ext.editAttachment();
               ApexPages.Pagereference pg3=ext.deleteNote();
               ApexPages.Pagereference pg4=ext.deleteAttachment();
               ApexPages.Pagereference pg5=ext.deleteFeedAttachment();
               }
        }
    // End Test Coverage */
}