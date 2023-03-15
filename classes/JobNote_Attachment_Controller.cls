// This class is used to display list of notes and attachments related to one Job
public with sharing class JobNote_Attachment_Controller
{
    // Global variables 
    public LIST<Note> n1{get;set;}
    public LIST<Attachment> n2{get;set;}
    public LIST<CollaborationGroupFeed> n3{get;set;}
    public list<ContentDocumentLink> n4{get;set;}
  //public LIST<FeedItem> n3{get;set;}
    public String strNoteId{get;set;}
    public String strNoteId1{get;set;}
    public String strAttId{get;set;}
    public String FeedAttId{get;set;}
    String strId;
     public List<Tool_Tip__c> TTP{get;set;}
     // End of Global variables
     
   //  public JobNote_Attachment_Controller(){}
    
    // Standard Controller Constructor 
    public JobNote_Attachment_Controller(ApexPages.StandardController controller)
    {
        strNoteId='';
        strAttId='';
        FeedAttId='';
        strId=System.currentPagereference().getParameters().get('id');
         
         n1 = [select id, title, body from note where parentid=:strId];
         n2 = [select id, Name from Attachment where parentid=:strId];    
         n3 = [select id, ContentFileName,ContentSize from CollaborationGroupFeed where parentid=:strId ];
         n4 = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId=:strId];
       // n3 = [select id, ContentFileName,ContentSize from FeedItem where parentid=:strId ];
       
       TTP=new List<Tool_Tip__c>();
         TTP=[select id,Files__c,Notes__c,Attachment__c,Job_Specs__c,Client_Invoice__c,Estimate__c,Graphic_Deliverable__c,Workdocs__c,Job_Team__c,Job_Time__c,Shipment__c ,Production_Estimate__c,Purchase_Order__c,Quotes__c,Schedule__c,Vendor_Invoice__c from Tool_Tip__c limit 1];
        
       
    }
    // End of Constructor 
    
     // This method is called on to create New Note
     public Pagereference CreateNote()
    {
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d' || theme == 'Theme4t' ){
         p =  new Pagereference('/apex/JobCreateNewNoteLightning?id='+strId);
         }
         else{
         p =  new Pagereference('/apex/JobCreateNewNote?id='+strId);
         }
         p.setRedirect(true);
         return p; 
    }  
    // End of method CreateNote
    
    // This method is caled on to handle attachment
    public Pagereference AttachFile()
    {
         //PageReference p =  new Pagereference('/apex/JobAttachment?id='+strId);
         String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
         if(theme == 'Theme4d' || theme == 'Theme4t' ){
         p =  new Pagereference('/apex/JobAttachmentLightning?id='+strId);
         }
         else{
         p =  new Pagereference('/apex/JobAttachment?id='+strId);
         }
         p.setRedirect(true);
         return p; 
    }  
    // End of method AttachFile

    
    public Pagereference editNote()
    {
     //   Note objNote=[Select Id from Note where id=:strNoteId];
        //Pagereference p=new Pagereference('/apex/EditJobNote?Id='+strNoteId);
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d'){
         p =  new Pagereference('/apex/EditJobNoteLightning?id='+strNoteId);
         }
         else{
         p =  new Pagereference('/apex/EditJobNote?id='+strNoteId);
         }
        p.setRedirect(true);
        return p;
    }
    
    // This method is caled on to delete Note
    public Pagereference deleteNote()
    {
        Pagereference p=new Pagereference('/apex/DeleteJobNote?Id='+strNoteId1);
        p.setRedirect(true);
        return p;
    }
    // End of method deleteNote
    
    // This method is called on to edit Attachment
     public Pagereference editAttachment()
    {
       // Attachment objAttachment=[Select Id from Attachment where id=:strAttId];
        //Pagereference p=new Pagereference('/apex/EditJobAttachment?Id='+strAttId);
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
         if(theme == 'Theme4d' || theme == 'Theme4t' ){
         p =  new Pagereference('/apex/EditJobAttachmentLightning?id='+strAttId);
         }
         else{
         p =  new Pagereference('/apex/EditJobAttachment?id='+strAttId);
         }
        p.setRedirect(true);
        return p;
    }
    // End of method editAttachment
    
    // This method is called on to deleteAttachment
    public Pagereference deleteAttachment()
    {
       Pagereference p=new Pagereference('/apex/DeleteJobAttachment?Id='+strAttId);
       p.setRedirect(true);
       return p;
    }
    // End of method deleteAttachment
    
    
    // This method is called on to delete Feed Attachment
    public Pagereference deleteFeedAttachment()
    {
       Pagereference p=new Pagereference('/apex/DeleteJobFeedAttachment?Id='+FeedAttId);
       p.setRedirect(true);
       return p;
    }
    // End of method deleteAttachment

    
    
    
   /* // Test Coverage
        static testMethod void Test_JobNote_Attachment_Controller()
        {
            Profile p=[Select Id from Profile where Name='System Administrator' limit 1];
            
           User u=[Select Id from User where IsActive=: True and profileId=: p.Id Limit 1];
            
            
            
            System.runAs(u)
           {
           
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 352');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 352',Media_Types__c=testMedia.Id);
             
                insert testST;
                 
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 352');
    
                insert testSpec;
          
             Job__c testJob1=new Job__c(Flag__c = false,Job_Auto_Number__c = '2012-04-01',Name='Test Job 352',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
             insert testJob1;
              
              
              System.assertEquals('Test Job 352',testJob1.Name);   
           
               Note n=new Note(parentId=testJob1.Id,Title='Test Title 352',IsPrivate=True,Body='Test Note Body');
                   insert n;
               
               System.assertEquals('Test Title 352',n.Title);
              
               // Instantiate the standard controller with the Job
               ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                   
               ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
               
               // Instantiate the extention instance with the standard controller 
               
               JobNote_Attachment_Controller ext= new JobNote_Attachment_Controller(con);
               
               // Invoke the primary method on the extension
               
               ApexPages.Pagereference pr=ext.CreateNote();
               pr=ext.AttachFile();
           
               ApexPages.Pagereference pg1=ext.editNote();
               ApexPages.Pagereference pg2=ext.editAttachment();
               ApexPages.Pagereference pg3=ext.deleteNote();
               ApexPages.Pagereference pg4=ext.deleteAttachment();
               }
        }
    // End Test Coverage */
}
// End of CLass