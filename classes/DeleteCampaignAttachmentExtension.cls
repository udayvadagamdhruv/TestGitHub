// Class to Delete Camp Attachment 
public with sharing class DeleteCampaignAttachmentExtension{

    // Global variables 
  /*  public Attachment objAttachment;
    public boolean isError{get;set;}
    String strid,CampId;
    // End of Global 
    
    // Standard Controller Constructor
    public DeleteCampaignAttachmentExtension(ApexPages.StandardController controller) 
    {
        strId=System.currentPagereference().getParameters().get('id');
        this.objAttachment=(Attachment)controller.getRecord();
        Attachment Att1=[Select parentId from Attachment where Id=: strId limit 1];
        CampId=Att1.parentId;
    }
    // End Constructor

    // Method called on to delete Camp Attachment
    public pagereference checkDelete()
    {
        try
        {
            if(Attachment.sObjectType.getDescribe().isDeletable()){
                Database.delete(objAttachment);
            }
        }
        catch(Exception e)
        {
            isError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); return null;
        }
        // After deleting Camp Attachment navigate to following URL 
       
        PageReference p;
         p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId+'&section=NAAtt');
        p.setRedirect(true);
        return p;
    }*/
    // End CheckDelete Method

  
}// End of CLass
/* End of Class*/