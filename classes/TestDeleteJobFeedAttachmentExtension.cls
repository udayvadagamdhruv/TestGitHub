@isTest
Public class TestDeleteJobFeedAttachmentExtension{
/* Test Coverage 
        static testMethod void TestDeleteJobFeedAttachmentExtension()
        {
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 612');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 612',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 612');
                insert testSpec;
                
        Job__c testJob1=new Job__c(Job_Auto_Number__c='612',Flag__c=True,Name='Test Job 612',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
               
           System.assertEquals('Test Job 612',testJob1.Name);
               
           Blob b = Blob.valueOf('Hello');

           FeedItem a=new FeedItem (parentId=testJob1.Id,ContentFileName='Test File',Body='hello',ContentData=b);
           
               insert a;
               
        // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.StandardController(a);
           ApexPages.currentPage().getParameters().put('Id', a.Id);
        
        // Instantiate the extention instance with the standardcontroller
           DeleteJobFeedAttachmentExtension ext=new DeleteJobFeedAttachmentExtension(con);
        
        // Invoke the Delete method 
           ApexPages.Pagereference result=ext.checkDelete();
        
        // The below line covers the catch block in checkDetele method 
           ApexPages.Pagereference result1=ext.checkDelete();
     }
    // End of Test Coverage
*/


}