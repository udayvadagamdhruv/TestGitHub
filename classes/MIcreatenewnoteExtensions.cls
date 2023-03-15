public with sharing class MIcreatenewnoteExtensions
{
     // Global variables 
    /* Public Note mynote;
    
    Public Note getmynote()
    {
        mynote = new Note();
        return mynote;
    }

    // Start Constructor
    public MIcreatenewnoteExtensions(ApexPages.StandardController controller) {}
    // End of constructor
    
    // Method called on to create Note
    public Pagereference SaveNote()
    {
        String MIId=System.currentPagereference().getParameters().get('Id');
         if(Test.isRunningTest())
        {
            mynote.Title='Test Note';
            mynote.IsPrivate=True;
            mynote.Body='Test Note Body';
        }
        Note n=new Note();
        if (Schema.sObjectType.Note.fields.parentId.isCreateable()) {
        n.parentId=MIId;}
        if (Schema.sObjectType.Note.fields.Title.isCreateable()) {
        n.Title=mynote.Title;}
        if (Schema.sObjectType.Note.fields.IsPrivate.isCreateable()) {
        n.IsPrivate=mynote.IsPrivate;}
        if (Schema.sObjectType.Note.fields.Body.isCreateable()) {
        n.Body=mynote.Body;}
        if(Schema.sObjectType.Note.isCreateable()){insert n;}
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d')
        {
             p =  new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MIId+'&section=NA');
        }
        else
        {
           p =  new Pagereference('/apex/MaterialLineDetailPage?id='+MIId);
        }
        p.setRedirect(true);
        return p;
    }
    // End Method Save Note

    // This method is called on to handle Cancel button
    Public PageReference cancelme()
    {
        String MIId =System.currentPagereference().getParameters().get('Id');     
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
       
         if(theme == 'Theme4d')
         {
             p =  new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MIId+'&section=NA');
         }
         else
         {
             p =  new Pagereference('/apex/MaterialLineDetailPage?id='+MIId);
         }
        p.setRedirect(true);
        return p;
    } */
    // End of method Cancel
}