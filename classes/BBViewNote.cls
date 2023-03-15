public with sharing class BBViewNote {
/*
 // Start global variables
    public Note n{get;set;}
    public Id strId{get;set;}
    public Id BBId{get;set;}
    public String strNoteId{get;set;}
    // End global variables

    // Standard Constructor
    public BBViewNote (ApexPages.StandardController controller)
    {
       strId=ApexPages.currentPage().getParameters().get('Id');
       n=[Select id,Title,Body,IsPrivate,ParentId from Note where Id=: strId];
       BBId=n.ParentId;
       strNoteId=n.id;
    }
    // End Constructor
    
    // Method is called on to cancel button
    public Pagereference cancel()
    {
      //strId=ApexPages.currentPage().getParameters().get('Id');
      //PageReference p =  new Pagereference('/apex/JobListView?id='+BBId+'&intFocus=8');
      String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
         p =  new Pagereference('/apex/BillboardDetailPageLightning?id='+BBId+'&section=NA');
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
         p =  new Pagereference('/apex/EditBillboardNoteLightning?id='+strNoteId);
        p.setRedirect(true);
        return p;
    }
    // End method editNote
    
    
     // This method is called on to handle delete button
    public Pagereference deleteNote()
    {
        Pagereference p=new Pagereference('/apex/DeleteBillboardNote?Id='+strNoteId);
        p.setRedirect(true);
        return p;
    }
    // End method deleteNote
*/
}