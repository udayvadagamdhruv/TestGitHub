// This Class to Delete Job Note
public with sharing class DeleteJobNoteExtension {
    
    // Global variables
    public Note objNote;
    public boolean isError{get;set;}
    String strid,Jobid;
    // End of Global variables
    
    // Standard Controller Constructor
    public DeleteJobNoteExtension(ApexPages.StandardController controller) 
    {
       strId=System.currentPagereference().getParameters().get('id');
        this.objNote=(Note)controller.getRecord();
        Note n=[Select parentId from Note where Id=: strId limit 1];
        jobId=n.parentId;
    }
    // End of Standard Controller Constructor

    // Method called on to delete Job Note
    public pagereference checkDelete()
    {
    try
    {
        Database.delete(objNote);
    }
    catch(Exception e)
    {
        isError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); return null;
    }
    // AFter deleting Note navigate to Notes Tab
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
    // End of delete Method

    
    // Start Test Coverage
   static testMethod void jobNote()
   {
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 309');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 309',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 310',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 309');
                insert testSpec;
                
                Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 310');
                insert testSpec1;
           
            
          // Job__c testJob1=new Job__c(Job_Auto_Number__c='309',Name='Test Job 309',Flag__c=True,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
           Job__c testJob1=new Job__c(Name='Test Job 309',Flag__c=false,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
            System.assertEquals('Test Job 309',testJob1.Name);   
               
               Note n=new Note(parentId=testJob1.Id,Title='Test Title 309',IsPrivate=True,Body='Test Note Body');
               insert n;
               
             // Instantiate the standard controller with the Job 
             
            ApexPages.StandardController con=new ApexPages.StandardController(n);
            ApexPages.currentPage().getParameters().put('Id', n.Id);
       
            // Instantiate the extention instance with the standardcontroller
            DeleteJobNoteExtension ext=new DeleteJobNoteExtension(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result=ext.checkDelete();
      
           // The below line covers the catch block in checkDetele method 
            ApexPages.Pagereference result1=ext.checkDelete();
          }
        // End of Test Coverage
  }  
// End of Class