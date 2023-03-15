// This Class to Delete Job Note
public with sharing class DeleteCampaignNoteExtension{
   /* 
    // Global variables
    public Note objNote;
    public boolean isError{get;set;}
    String strid,CampId;
    // End of Global variables
    
    // Standard Controller Constructor
    public DeleteCampaignNoteExtension(ApexPages.StandardController controller) 
    {
       strId=System.currentPagereference().getParameters().get('id');
        this.objNote=(Note)controller.getRecord();
        Note n=[Select parentId from Note where Id=: strId limit 1];
        CampId=n.parentId;
    }
    // End of Standard Controller Constructor

    // Method called on to delete Job Note
    public pagereference checkDelete()
    {
        try
        {
            if(Note.sObjectType.getDescribe().isDeletable()){
                Database.delete(objNote);
            }
        }
        catch(Exception e)
        {
            isError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); return null;
        }
        // AFter deleting Note navigate to Notes Tab
          
        PageReference p;
        p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId+'&section=NAAtt');
        p.setRedirect(true);
        return p;
    }
    // End of delete Method
*/
  
  }  
// End of Class