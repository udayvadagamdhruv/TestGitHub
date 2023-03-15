public with sharing class CampaignViewNote {
/*
  // Start global variables
    public Note n{get;set;}
    public Id strId{get;set;}
    public Id CampId{get;set;}
    public String strNoteId{get;set;}
    // End global variables

    // Standard Constructor
    public CampaignViewNote (ApexPages.StandardController controller)
    {
       strId=ApexPages.currentPage().getParameters().get('Id');
       n=[Select id,Title,Body,IsPrivate,ParentId from Note where Id=: strId];
       CampId=n.ParentId;
       strNoteId=n.id;
    }
    // End Constructor
    
    // Method is called on to cancel button
    public Pagereference cancel()
    {
      //strId=ApexPages.currentPage().getParameters().get('Id');
      //PageReference p =  new Pagereference('/apex/JobListView?id='+CampId+'&intFocus=8');
      String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
         p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId);
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
         p =  new Pagereference('/apex/EditCampaignNoteLightning?id='+strNoteId);
        p.setRedirect(true);
        return p;
    }
    // End method editNote
    
    
     // This method is called on to handle delete button
    public Pagereference deleteNote()
    {
        Pagereference p=new Pagereference('/apex/DeleteCampaignNote?Id='+strNoteId);
        p.setRedirect(true);
        return p;
    }
    // End method deleteNote
*/

}