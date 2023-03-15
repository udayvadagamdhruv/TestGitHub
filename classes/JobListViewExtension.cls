// This class is used to display Job Detail page
public with sharing class JobListViewExtension 
{
    // Global variables
    public String tabInFocus{get;set;}
    String intTabFocus;
    ID jobid;
     // public List<Job__Feed> myfeed{get;set;}
    //End of Global variables

    // Start Constructor
    public JobListViewExtension(ApexPages.StandardController controller) 
    {
        intTabFocus = ESAPI.encoder().SFDC_HTMLENCODE(System.currentPageReference().getParameters().get('intFocus'));
        jobid =  ESAPI.encoder().SFDC_HTMLENCODE(System.currentPageReference().getParameters().get('id'));
        
    /*   myfeed = [SELECT Id,Type,
                          CreatedById, CreatedBy.FirstName, CreatedBy.LastName,
                           ParentId,Parent.Name,
                           Body, Title, LinkUrl, ContentData, ContentFileName,
                               (SELECT Id, FieldName, OldValue, NewValue
                                FROM FeedTrackedChanges ORDER BY Id DESC),
                               (SELECT Id, CommentBody, CreatedDate,
                                CreatedBy.FirstName, CreatedBy.LastName
                                FROM FeedComments ORDER BY CreatedDate LIMIT 10),
                               (SELECT CreatedBy.FirstName, CreatedBy.LastName
                                FROM FeedLikes)
                           FROM Job__Feed
                           WHERE ParentID =: jobid
                           ORDER BY CreatedDate DESC, Id DESC
                           LIMIT 20];  */
  
        if(intTabFocus=='1')
        {
         tabInFocus = 'Details';
        }
        if(intTabFocus=='2')
        {
            tabInFocus = 'Job Specs';
        }
    }
    // End of Constructor

  /*  // Start Coverage Code
    static testMethod void jobListViewClient()
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
    }// End of Test Coverage*/
}// End of Class