public with sharing class MIViewNote{
/*
 // Start global variables
    public Note n{get;set;}
    public Id strId{get;set;}
    public Id MIId{get;set;}
    public String strNoteId{get;set;}
    // End global variables

    // Standard Constructor
    public MIViewNote(ApexPages.StandardController controller)
    {
       strId=ApexPages.currentPage().getParameters().get('Id');
       n=[Select id,Title,Body,IsPrivate,ParentId from Note where Id=: strId];
       MIId=n.ParentId;
       strNoteId=n.id;
    }
    // End Constructor
    
    // Method is called on to cancel button
    public Pagereference cancel()
    {
      //strId=ApexPages.currentPage().getParameters().get('Id');
      //PageReference p =  new Pagereference('/apex/JobListView?id='+MIId+'&intFocus=8');
      String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
         p =  new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MIId);
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
         p =  new Pagereference('/apex/EditMINoteLightning?id='+strNoteId);
        p.setRedirect(true);
        return p;
    }
    // End method editNote
    
    
     // This method is called on to handle delete button
    public Pagereference deleteNote()
    {
        Pagereference p=new Pagereference('/apex/DeleteMINote?Id='+strNoteId);
        p.setRedirect(true);
        return p;
    }*/
    // End method deleteNote

}