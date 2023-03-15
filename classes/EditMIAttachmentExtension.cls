// This class is used to Edit Job Attachment

public with sharing class EditMIAttachmentExtension{

   // Global variables
   /* public String attachemetname{set;get;}
    public Attachment objAttachment;
    public boolean isError{get;set;}
    String strId,MIId;
    // End Global varianles
    
    
   // Start Constructor
    
    public EditMIAttachmentExtension(ApexPages.StandardController controller)
    {
        strId=System.currentPagereference().getParameters().get('id');
       // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+strId));
        this.objAttachment=(Attachment)controller.getRecord();
        Attachment a=[Select Name, parentId from Attachment where Id=: strId limit 1];
        attachemetname=a.Name;
       // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+attachemetname+'1111'));
        MIId=a.parentId;
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
      
        PageReference p;
        
        p =  new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MIId+'&section=NA');
        
        p.setRedirect(true);
        return p;
    }
    // End method SaveAttachment
    
      // This method is called on to handle Cancel button
    public Pagereference cancelme()
    {
       
        PageReference p;
        p =  new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MIId+'&section=NA');
        p.setRedirect(true);
        return p;
    }
    // End of Cancel method
    
   */
}
// End of Class