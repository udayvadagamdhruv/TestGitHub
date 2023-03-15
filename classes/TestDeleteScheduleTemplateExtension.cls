@isTest
public class TestDeleteScheduleTemplateExtension {
/*	 static testMethod void Test_DeleteScheduleTemplateExtension()
         {
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
            insert testMedia;
            
             Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1',Media_Types__c=testMedia.Id);
             try
             {
                 insert testST;
                 System.debug('Schedule Template record inserted successfully@@@ '+testST);
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
             
              Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 1',Media_Types__c=testMedia.Id);
              try
              {
                 insert testST1;
                 System.debug('Schedule Template record inserted successfully@@@ '+testST);
              }
              catch(System.DMLException e)
              {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
             
             // Instantiate the standard controller with the Schedule Template 
             Schedule_Template__c obj=[Select Id from Schedule_Template__c where Id=:testST.Id];
             ApexPages.StandardController con=new ApexPages.StandardController(obj);
        
             // Instantiate the extention instance with the standard controller 
            
            DeleteScheduleTemplateExtension ext=new DeleteScheduleTemplateExtension(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result1=ext.CheckDelete();
            ApexPages.PageReference result2=ext.CheckDelete();
            ApexPages.PageReference result3=ext.schtageback();
       }   */
}