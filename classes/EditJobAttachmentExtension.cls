// This class is used to Edit Job Attachment

public with sharing class EditJobAttachmentExtension {

   public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }

   // Global variables
    public String attachemetname{set;get;}
    public Attachment objAttachment;
    public boolean isError{get;set;}
    String strId,jobId;
    // End Global varianles
    
    
   // Start Constructor
    
    public EditJobAttachmentExtension(ApexPages.StandardController controller)
    {
        strId=System.currentPagereference().getParameters().get('id');
       // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+strId));
        this.objAttachment=(Attachment)controller.getRecord();
        Attachment a=[Select Name, parentId from Attachment where Id=: strId limit 1];
        attachemetname=a.Name;
       // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+attachemetname+'1111'));
        jobId=a.parentId;
    }
    // End constructor
    
    // This method is called on to Save Atachment
    public Pagereference SaveAttachment()
    {
        String strId =  objAttachment.Id;   
        try
        {
            update objAttachment;
        }
        catch(Exception e)
        {
            isError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); 
            return null;
        }
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
    // End method SaveAttachment
    
      // This method is called on to handle Cancel button
    public Pagereference cancelme()
    {
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
    // End of Cancel method
    
    // Start Test Coverage
     static testMethod void Test_EditJobAttachmentExtension()
    {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 999',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 998',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 999');
                insert testSpec;
                
         Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 998');
                insert testSpec1;
           
            
          Job__c testJob1=new Job__c(Name='Test Job 999',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
          try
           {
                   insert testJob1;
           }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
               Blob b = Blob.valueOf('Hello World');
               
               System.assertEquals('Test Job 999',testJob1.Name);

               Attachment a=new Attachment(parentId=testJob1.Id,Name='Test File',Body=b);
               insert a;
               
               ApexPages.currentPage().getParameters().put('Id', a.Id);
            
               // Instantiate the standard controller with the Attachment 
               ApexPages.StandardController con=new ApexPages.StandardController(a);
        
               // Instantiate the extention instance with the standardcontroller 
               EditJobAttachmentExtension ext=new EditJobAttachmentExtension(con);
        
               // Invoke the primary method on the extension
               ApexPages.PageReference result=ext.SaveAttachment();
        
               ApexPages.currentPage().getParameters().put('Id', a.Id);
            
               // Instantiate the standard controller with the Job 
               ApexPages.StandardController con1=new ApexPages.StandardController(a);
        
              // Instantiate the extention instance with the standardcontroller 
              EditJobAttachmentExtension ext1=new EditJobAttachmentExtension(con1);
        
              // Invoke the primary method on the extension
                result=ext1.cancelme();
        
                delete a;
                result=ext.SaveAttachment();
           }
    // End of Test Coverage
}
// End of Class