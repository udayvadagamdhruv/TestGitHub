@istest
public class TestJobListViewExtension {
/*static testMethod void jobListViewClient()
    {
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
          
            // Instantiate the standard controller with the Job
            
             ApexPages.StandardController con1=new ApexPages.StandardController(testJob1);
             ApexPages.currentPage().getParameters().put('intFocus', '1');
             
              // Instantiate the extention instance with the standard controller 
             JobListViewExtension ext1=new JobListViewExtension(con1);
             
             // Instantiate the standard controller with the Job
             ApexPages.StandardController con2=new ApexPages.StandardController(testJob1);
             ApexPages.currentPage().getParameters().put('intFocus', '2');
             
                // Instantiate the extention instance with the standard controller 
             JobListViewExtension ext2=new JobListViewExtension(con2);
    }*/
    }