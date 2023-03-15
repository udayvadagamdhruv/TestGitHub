public with sharing class CampaigncreatenewnoteLightningExtensions
{
     // Global variables 
   /*  Public Note mynote;
    
    Public Note getmynote()
    {
        mynote = new Note();
        return mynote;
    }

    // Start Constructor
    public CampaigncreatenewnoteLightningExtensions(ApexPages.StandardController controller) {}
    // End of constructor
    
    // Method called on to create Note
    public Pagereference SaveNote()
    {
        String CampId=System.currentPagereference().getParameters().get('Id');
         if(Test.isRunningTest())
        {
            mynote.Title='Test Note';
            mynote.IsPrivate=True;
            mynote.Body='Test Note Body';
        }
        Note n=new Note();
        if(schema.SobjectType.Note.Fields.parentId.isCreateable()){ 
            n.parentId=CampId;
        }
        if(schema.SobjectType.Note.Fields.Title.isCreateable()){ 
            n.Title=mynote.Title;
        }
        if(schema.SobjectType.Note.Fields.IsPrivate.isCreateable()){ 
            n.IsPrivate=mynote.IsPrivate;
        }
        if(schema.SobjectType.Note.Fields.body.isCreateable()){ 
            n.Body=mynote.Body;
        }
        if(Schema.sObjectType.Note.isCreateable()){
            insert n;
        }
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d')
        {
             p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId+'&section=NAAtt');
        }
        else
        {
           p =  new Pagereference('/apex/CampaignDetailPageCustom?id='+CampId);
        }
        p.setRedirect(true);
        return p;
    }
    // End Method Save Note

    // This method is called on to handle Cancel button
    Public PageReference cancelme()
    {
        String CampId=System.currentPagereference().getParameters().get('Id');     
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
       
         if(theme == 'Theme4d')
        {
             p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId+'&section=NAAtt');
        }
        else
        {
           p =  new Pagereference('/apex/CampaignDetailPageCustom?id='+CampId);
        }
        p.setRedirect(true);
        return p;
    } */
    // End of method Cancel
}