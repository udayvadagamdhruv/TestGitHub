// This class is used to display list of notes and attachments related to one Job
public with sharing class MINote_AttachmentLightningController
{
    // Global variables 
  /*  public LIST<Note> n1{get;set;}
    public LIST<Attachment> n2{get;set;}
    public LIST<CollaborationGroupFeed> n3{get;set;}
    public list<ContentDocumentLink> n4{get;set;}
  //public LIST<FeedItem> n3{get;set;}
    public String strNoteId{get;set;}
    public String strNoteId1{get;set;}
    public String strAttId{get;set;}
    public String FeedAttId{get;set;}
    String strId;
     // End of Global variables
     
   //  public JobNote_Attachment_Controller(){}
    
    // Standard Controller Constructor 
    public MINote_AttachmentLightningController(ApexPages.StandardController controller)
    {
        strNoteId='';
        strAttId='';
        FeedAttId='';
        strId=System.currentPagereference().getParameters().get('id');
         
         n1 = [select id, title, body from note where parentid=:strId];
         n2 = [select id, Name from Attachment where parentid=:strId];    
         n3 = [select id from CollaborationGroupFeed where parentid=:strId ];
         n4 = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId=:strId];
       // n3 = [select id, ContentFileName,ContentSize from FeedItem where parentid=:strId ];
    }
    // End of Constructor 
    
     // This method is called on to create New Note
    public Pagereference CreateNote()
    {
        PageReference p;
       
         p =  new Pagereference('/apex/MIcreatenewnoteLightning?id='+strId);
         p.setRedirect(true);
         return p; 
    }  
    // End of method CreateNote
    
    // This method is caled on to handle attachment
    public Pagereference AttachFile()
    {
         PageReference p;
         p =  new Pagereference('/apex/MIAttachmentLightning?id='+strId);
         p.setRedirect(true);
         return p; 
    }  
    // End of method AttachFile

    
    public Pagereference editNote()
    {
     //   Note objNote=[Select Id from Note where id=:strNoteId];
        PageReference p;
        p =  new Pagereference('/apex/EditMINoteLightning?id='+strNoteId);
        p.setRedirect(true);
        return p;
    }
    
    // This method is caled on to delete Note
    public Pagereference deleteNote()
    {
        Pagereference p=new Pagereference('/apex/DeleteMINote?Id='+strNoteId1);
        p.setRedirect(true);
        return p;
    }
    // End of method deleteNote
    
    // This method is called on to edit Attachment
     public Pagereference editAttachment()
    {
       // Attachment objAttachment=[Select Id from Attachment where id=:strAttId];
       
        PageReference p;
        p =  new Pagereference('/apex/EditMIAttachmentLightning?id='+strAttId);
        p.setRedirect(true);
        return p;
    }
    // End of method editAttachment
    
    // This method is called on to deleteAttachment
    public Pagereference deleteAttachment()
    {
       Pagereference p=new Pagereference('/apex/DeleteMIAttachment?Id='+strAttId);
       p.setRedirect(true);
       return p;
    }
    // End of method deleteAttachment
    
    
    // This method is called on to delete Feed Attachment
    public Pagereference deleteFeedAttachment()
    {
       Pagereference p=new Pagereference('/apex/DeleteMIFeedAttachment?Id='+FeedAttId);
       p.setRedirect(true);
       return p;
    }
    // End of method deleteAttachment
*/
}
// End of CLass