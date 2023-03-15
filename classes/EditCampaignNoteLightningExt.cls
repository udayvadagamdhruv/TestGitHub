// This Class is Used in Edit JobNote Vf page for edit functionality of JobNote 
public with sharing class EditCampaignNoteLightningExt
{
    // Global variables
    /*/public Note objNote;
    public boolean isError{get;set;}
    String strId,CampId;
    // End of Global variables
  /*  Public Note getmynote()
    {
        mynote = new Note();
        return mynote;
    }*
 
  // Constructor
    public EditCampaignNoteLightningExt(ApexPages.StandardController controller) 
    {
        strId=System.currentPagereference().getParameters().get('id');
        this.objNote=(Note)controller.getRecord();
        Note n=[Select parentId from Note where Id=: strId limit 1];
        CampId=n.parentId;
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
        
        p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId+'&section=NAAtt');
        
        p.setRedirect(true);
        return p;
    }
    // End of method SaveNote
    
    // Method for Cancel Button 
    public Pagereference cancelme()
    {
        PageReference p;
        p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId+'&section=NAAtt');
        p.setRedirect(true);
        return p;
    }
   // End of Cancel Method 
    
  */
}
// End of Class