// Class to Delete MI Attachment 
public with sharing class DeleteMIAttachmentExtension{

    // Global variables 
   /* public Attachment objAttachment;
    public boolean isError{get;set;}
    String strid,MIId;
    // End of Global 
    
    // Standard Controller Constructor
    public DeleteMIAttachmentExtension(ApexPages.StandardController controller) 
    {
        strId=System.currentPagereference().getParameters().get('id');
        this.objAttachment=(Attachment)controller.getRecord();
        Attachment Att1=[Select parentId from Attachment where Id=: strId limit 1];
        MIId=Att1.parentId;
    }
    // End Constructor

    // Method called on to delete Job Attachment
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
        // After deleting Job Attachment navigate to following URL 
       
        PageReference p;
         p =  new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MIId+'&section=NA');
        p.setRedirect(true);
        return p;
    }
    // End CheckDelete Method

  */
}// End of CLass
/* End of Class*/