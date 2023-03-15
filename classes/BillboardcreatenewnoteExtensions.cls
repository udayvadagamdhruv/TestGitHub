public with sharing class BillboardcreatenewnoteExtensions 
{
     // Global variables 
    /* Public Note mynote;
    
    Public Note getmynote()
    {
        mynote = new Note();
        return mynote;
    }

    // Start Constructor
    public BillboardcreatenewnoteExtensions(ApexPages.StandardController controller) {}
    // End of constructor
    
    // Method called on to create Note
    public Pagereference SaveNote()
    {
        String BillboardId=System.currentPagereference().getParameters().get('Id');
         if(Test.isRunningTest())
        {
            mynote.Title='Test Note';
            mynote.IsPrivate=True;
            mynote.Body='Test Note Body';
        }
        Note n=new Note();
        if(schema.SobjectType.Note.Fields.parentId.isCreateable()){ 
            n.parentId=BillboardId;
        }
        if(schema.SobjectType.Note.Fields.Title.isCreateable()){ 
            n.Title=mynote.Title;
        }
        if(schema.SobjectType.Note.Fields.IsPrivate.isCreateable()){ 
            n.IsPrivate=mynote.IsPrivate;
        }
        if(schema.SobjectType.Note.Fields.Body.isCreateable()){ 
            n.Body=mynote.Body;
        }
        if(Schema.sObjectType.Note.isCreateable()){
            insert n;
        }
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d')
        {
            p =  new Pagereference('/apex/BillboardDetailPageLightning?id='+BillboardId+'&section=NA');
        }
        else
        {
            p =  new Pagereference('/apex/BillboardDetailPage?id='+BillboardId);
        }
        p.setRedirect(true);
        return p;
    }
    // End Method Save Note

    // This method is called on to handle Cancel button
    Public PageReference cancelme()
    {
        String BillboardId=System.currentPagereference().getParameters().get('Id');     
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
       
         if(theme == 'Theme4d')
         {
             p =  new Pagereference('/apex/BillboardDetailPageLightning?id='+BillboardId+'&section=NA');
         }
         else
         {
             p =  new Pagereference('/apex/BillboardDetailPage?id='+BillboardId);
         }
        p.setRedirect(true);
        return p;
    } */
    // End of method Cancel
}