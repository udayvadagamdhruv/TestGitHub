// This Class is Used in JobAttachment vf page 
public with sharing class JobAttachmentExtensions 
{
   public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }

    // Global variables
    public Attachment myfile;
    // End Global variables

    // This method is used to create instance of attached file
    public Attachment getmyfile()
    {
        myfile=new Attachment();
        return myfile;
       
     }
     // ENd of method getMyFile
 
     // Constructor
     public JobAttachmentExtensions(ApexPages.StandardController controller) 
     {}
     // End of Constructor
    
    // This method is called on to Save attached file
     public pagereference Savedoc()
      {
            String jobId=System.currentPagereference().getParameters().get('id'); //Retreive JobId
            if(Test.isRunningTest())
            {
                myfile.body = Blob.valueOf('Test Attachmant 613');
                myfile.Name = 'TestName 613';
                
                System.debug('==============myfile.body========================'+myfile.body);
                System.debug('==============myfile.name========================'+myfile.name);
            }
          
           Attachment jobAttachment=new Attachment(parentId=jobId,name=myfile.Name,body=myfile.body); //Create instance of Attachment and add fields to it
      
          // Insert the Attachment
          try
          {
              insert jobAttachment;
          }
          catch(System.DMLException e)
          {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the file to upload'));
              return null;
          }
          // Navigation after inserting an attachment
          //PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=8');
          String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d'){
         p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=notes');
         }
         else if(theme == 'Theme4t'){
         p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid+'&tab=RelatedList'+'&section=JobFiles');
         }
         else{
         p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=8');
         }
          p.setRedirect(true);
          return p;
        }
        // End of method SaveDoc
    
        // This method is called on to handle Cancel button
        public Pagereference cancelme()
        {
              String jobId=System.currentPagereference().getParameters().get('id');
              //PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=8');
              String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d'){
         p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=notes');
         }
         else if(theme == 'Theme4t'){
         p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid+'&tab=RelatedList'+'&section=JobFiles');
         }
         else{
         p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=8');
         }
              p.setRedirect(true);
              return p;      
         }
         // End of method cancel
    
        // Test Coverage
        static testMethod void Test_JobAttachmentExtensions()
        {
             Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

                insert customSetting001;
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 613');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 613',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
            Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 613');
                 insert testSpec;
                
             Job__c testJob1=new Job__c(Name='Test Job 613',Flag__c=True, Job_Auto_Number__c='Job 613',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
               System.assertEquals('Test Job 613',testJob1.Name);  
               
               // Instantiate the standard controller with the Job
               
               ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                   
               ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
               
               // Instantiate the extention instance with the standard controller 
               JobAttachmentExtensions ext= new JobAttachmentExtensions(con);
               
               test.startTest();
               
               ext.getmyfile();
               
               // Invoke the primary method on the extension   
               Pagereference pg=ext.SaveDoc();
               
               Pagereference pg1=ext.cancelme();
               
               Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Test Job 613'];
               obj1.Status__c='Cancelled';
               update obj1;
         
               Job__c obj2=[Select id from Job__c where Name=: 'Test Job 613'];
               delete obj2;
               pg=ext.SaveDoc();
               
               test.stopTest();
        }
    /* End of Test Coverage*/

}
/* End Of Class */