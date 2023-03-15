public with sharing class DeleteBillboardFeedAttachmentExtension{
/*
    // Global variables 
    public FeedItem objAttachment;
    public boolean isError{get;set;}
    String strid,BillboardId;
    // End of Global 
    
    // Standard Controller Constructor
    public DeleteBillboardFeedAttachmentExtension(ApexPages.StandardController controller) 
    {
        strId=System.currentPagereference().getParameters().get('id');
        this.objAttachment=(FeedItem )controller.getRecord();
        FeedItem  Att1=[Select parentId from FeedItem where Id=: strId limit 1];
        BillboardId=Att1.parentId;
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
        PageReference  p =  new Pagereference('/apex/BillboardDetailPageLightning?id='+BillboardId+'&section=NA');
        p.setRedirect(true);
        return p;
    }*/
    // End CheckDelete Method
}