public with sharing class CampaignAttachmentLightningExtensions
{
   /* public Attachment myfile;

    // This method is used to create instance of attached file
    public Attachment getmyfile()
    {
        myfile=new Attachment();
        return myfile;
       
     }
     // ENd of method getMyFile
 
     // Constructor
     public CampaignAttachmentLightningExtensions(ApexPages.StandardController controller) 
     {}
     // End of Constructor
    
    // This method is called on to Save attached file
     public pagereference Savedoc()
      {
            String CampId=System.currentPagereference().getParameters().get('id'); 
            if(Test.isRunningTest())
            {
                myfile.body = Blob.valueOf('Test Attachmant 613');
                myfile.Name = 'TestName 613';
                
                System.debug('==============myfile.body========================'+myfile.body);
                System.debug('==============myfile.name========================'+myfile.name);
            }
          
          Attachment jobAttachment=new Attachment();//Create instance of Attachment and add fields to it
          if(schema.SobjectType.Attachment.Fields.parentId.isCreateable()){ 
              jobAttachment.parentId=CampId;
          }
          if(schema.SobjectType.Attachment.Fields.name.isCreateable()){ 
              jobAttachment.name=myfile.Name;
          }
          if(schema.SobjectType.Attachment.Fields.body.isCreateable()){ 
              jobAttachment.body=myfile.body; 
          }
      
          // Insert the Attachment
          try
          {
              if(Schema.sObjectType.Attachment.isCreateable()){
                  insert jobAttachment;
              }
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
                 p =  new Pagereference('/apex/CampaignDetailPageCustomLightning?id='+CampId+'&section=NAAtt');
            }
            else
            {
               p =  new Pagereference('/apex/CampaignDetailPageCustom?id='+CampId);
            }
            p.setRedirect(true);
            return p;
        }
        // End of method SaveDoc
    
        // This method is called on to handle Cancel button
        public Pagereference cancelme()
        {
              String CampId=System.currentPagereference().getParameters().get('id');

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
         }*/
         // End of method cancel
}