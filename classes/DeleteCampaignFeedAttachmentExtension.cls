public with sharing class DeleteCampaignFeedAttachmentExtension{

    // Global variables 
/*    public FeedItem objAttachment;
    public boolean isError{get;set;}
    String strid,CampId;
    // End of Global 
    
    // Standard Controller Constructor
    public DeleteCampaignFeedAttachmentExtension(ApexPages.StandardController controller) 
    {
        strId=System.currentPagereference().getParameters().get('id');
        this.objAttachment=(FeedItem )controller.getRecord();
        FeedItem  Att1=[Select parentId from FeedItem where Id=: strId limit 1];
        CampId=Att1.parentId;
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
        PageReference  p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId);
        p.setRedirect(true);
        return p;
    }*/
    // End CheckDelete Method
}