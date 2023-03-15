// This class is used to display/view Note of Job record
public with sharing class JobViewNote {
/*
 public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }
    
    // Start global variables
    public Note n{get;set;}
    public Id strId{get;set;}
    public Id jobId{get;set;}
    public String strNoteId{get;set;}
    // End global variables

    // Standard Constructor
    public JobViewNote(ApexPages.StandardController controller)
    {
       strId=ApexPages.currentPage().getParameters().get('Id');
       n=[Select id,Title,Body,IsPrivate,ParentId from Note where Id=: strId];
       jobId=n.ParentId;
       strNoteId=n.id;
    }
    // End Constructor
    
    // Method is called on to cancel button
    public Pagereference cancel()
    {
      //strId=ApexPages.currentPage().getParameters().get('Id');
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
    // End Cancel method
    
    // This method is called on to handle Edit button
    public pagereference editNote()
    {
        //Pagereference p=new Pagereference('/apex/EditJobNote?Id='+strNoteId);
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d' || theme == 'Theme4t'){
         p =  new Pagereference('/apex/EditJobNoteLightning?id='+strNoteId);
         }
         else{
         p =  new Pagereference('/apex/EditJobNote?id='+strNoteId);
         }
        p.setRedirect(true);
        return p;
    }
    // End method editNote
    
    
     // This method is called on to handle delete button
    public Pagereference deleteNote()
    {
        Pagereference p=new Pagereference('/apex/DeleteJobNote?Id='+strNoteId);
        p.setRedirect(true);
        return p;
    }
    // End method deleteNote
    
    // Start Test Coverage 
    
    static testMethod void Test_JobViewNote()
    {
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 852');
             
                insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 852',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 852');
         
                insert testSpec;
          
         Job__c testJob1=new Job__c(Name='Test Job 852',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               
          try
           {
                   insert testJob1;
           }
          catch(System.DMLException e)
           {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
           }
          System.assertEquals('Test Job 852',testJob1.Name);  
          
          Note n=new Note(parentId=testJob1.Id,Title='Test Title 852',IsPrivate=True,Body='Test Note Body');
               insert n;
              
          ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                   
          ApexPages.currentPage().getParameters().put('Id', n.Id);
               
          JobViewNote ext= new JobViewNote(con);
          ApexPages.Pagereference result1=ext.Cancel();
          result1=ext.editNote();
          result1=ext.deleteNote();
     }*/
     // End Test Coverage
}
// End of Class