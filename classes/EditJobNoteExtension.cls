// This Class is Used in Edit JobNote Vf page for edit functionality of JobNote 
public with sharing class EditJobNoteExtension 
{
    // Global variables
    
     public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }
    public Note objNote;
    public boolean isError{get;set;}
    String strId,jobId;
    // End of Global variables
  /*  Public Note getmynote()
    {
        mynote = new Note();
        return mynote;
    }*/
 
  // Constructor
    public EditJobNoteExtension(ApexPages.StandardController controller) 
    {
        strId=System.currentPagereference().getParameters().get('id');
        this.objNote=(Note)controller.getRecord();
        Note n=[Select parentId from Note where Id=: strId limit 1];
        jobId=n.parentId;
    }
   // End Of Constructor
    
    // Method called on to Edit Note
    public Pagereference SaveNote()
    {
        String strId =  objNote.Id;   
        try
        {
            update objNote;
        }
        catch(Exception e)
        {
            isError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); return null;
        }
        // After updating Note, navigate to Notes Tab
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
    // End of method SaveNote
    
    // Method for Cancel Button 
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
   // End of Cancel Method 
    
    
    // Start Test Coverage
    static testMethod void Test_EditJobNoteExtension()
    {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 610');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 610',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 610');
         
                insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 610',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0));
               }
           System.assertEquals('Test Job 610',testJob1.Name);    
               
           Note n=new Note(parentId=testJob1.Id,Title='Test Title 610',IsPrivate=True,Body='Test Note Body');
           try
           {
                   insert n;
           }
           catch(System.DMLException e)
           {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0));
           }
               
           ApexPages.currentPage().getParameters().put('Id', n.Id);
               
            // Instantiate the standard controller with the Note
           ApexPages.StandardController con=new ApexPages.StandardController(n);
        
           // Instantiate the extention instance with the standardcontroller
           EditJobNoteExtension ext=new EditJobNoteExtension(con);
        
           // Invoke the primary method on the extension
           ApexPages.PageReference result=ext.SaveNote();
        
           ApexPages.PageReference result1=ext.cancelme();
        
           delete n;
           result=ext.SaveNote();
    }
    // End of Test coverage 
}
// End of Class