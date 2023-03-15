// Class to Delete Job Attachment 
public with sharing class DeleteJobAttachmentExtension {

    // Global variables 
    public Attachment objAttachment;
    public boolean isError{get;set;}
    String strid,Jobid;
    // End of Global 
    
    // Standard Controller Constructor
    public DeleteJobAttachmentExtension(ApexPages.StandardController controller) 
    {
        strId=System.currentPagereference().getParameters().get('id');
        this.objAttachment=(Attachment)controller.getRecord();
        Attachment Att1=[Select parentId from Attachment where Id=: strId limit 1];
        jobId=Att1.parentId;
    }
    // End Constructor

    // Method called on to delete Job Attachment
    public pagereference checkDelete()
    {
        try
        {
            Database.delete(objAttachment);
        }
        catch(Exception e)
        {
            isError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); return null;
        }
        // After deleting Job Attachment navigate to following URL 
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
    // End CheckDelete Method

    // Test Coverage 
        static testMethod void Test_DeleteJobAttachmentExtension()
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

           Attachment a=new Attachment(parentId=testJob1.Id,Name='Test File',Body=b);
           
               insert a;
               
        // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.StandardController(a);
           ApexPages.currentPage().getParameters().put('Id', a.Id);
        
        // Instantiate the extention instance with the standardcontroller
           DeleteJobAttachmentExtension ext=new DeleteJobAttachmentExtension(con);
        
        // Invoke the Delete method 
           ApexPages.Pagereference result=ext.checkDelete();
        
        // The below line covers the catch block in checkDetele method 
           ApexPages.Pagereference result1=ext.checkDelete();
     }
    // End of Test Coverage
}// End of CLass
/* End of Class*/