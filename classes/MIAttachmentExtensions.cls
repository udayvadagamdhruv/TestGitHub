public with sharing class MIAttachmentExtensions
{
 /*   public Attachment myfile;

    // This method is used to create instance of attached file
    public Attachment getmyfile()
    {
        myfile=new Attachment();
        return myfile;
       
     }
     // ENd of method getMyFile
 
     // Constructor
     public MIAttachmentExtensions(ApexPages.StandardController controller) 
     {}
     // End of Constructor
    
    // This method is called on to Save attached file
     public pagereference Savedoc()
      {
            String MIId=System.currentPagereference().getParameters().get('id'); //Retreive JobId
            if(Test.isRunningTest())
            {
                myfile.body = Blob.valueOf('Test Attachmant 613');
                myfile.Name = 'TestName 613';
                
                System.debug('==============myfile.body========================'+myfile.body);
                System.debug('==============myfile.name========================'+myfile.name);
            }
          
           Attachment jobAttachment=new Attachment();
           if (Schema.sObjectType.Attachment.fields.parentId.isCreateable()) {
           jobAttachment.parentId=MIId;}
           if (Schema.sObjectType.Attachment.fields.name.isCreateable()) {
           jobAttachment.name=myfile.Name;}
           if (Schema.sObjectType.Attachment.fields.body.isCreateable()) {
           jobAttachment.body=myfile.body; }//Create instance of Attachment and add fields to it
      
          // Insert the Attachment
          try
          {
              if(Schema.sObjectType.Attachment.isCreateable()){ insert jobAttachment;}
          }
          catch(System.DMLException e)
          {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the file to upload'));
              return null;
          }
          // Navigation after inserting an attachment
        
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
        // End of method SaveDoc
    
        // This method is called on to handle Cancel button
        public Pagereference cancelme()
        {
              String MIId=System.currentPagereference().getParameters().get('id');

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
         }*/
         // End of method cancel
}