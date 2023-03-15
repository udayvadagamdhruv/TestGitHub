// Extension Class for Edit Tag Template 
public with sharing class EditTagTemplateExtension 
{
    // Global Variables
      /*    private final Tag_Template__c objTagTemplate;
          
           public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
      // End of Global Variables
    
    // Standard Controller Constructor
    public EditTagTemplateExtension(ApexPages.StandardController controller) 
    {
         this.objTagTemplate=(Tag_Template__c)controller.getrecord();
    }
    // End of Standard Controller Constructor

    // Method Called on to Update Tag Template
     Public PageReference saveme()
    {
        try
        {
            update objTagTemplate;
            System.debug('Tag Template updated successfully@@@ '+objTagTemplate);
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
        string TagTempID=objTagTemplate.id;
        
         PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+TagTempID);
            }
            else
            {
               p =  new Pagereference('/apex/TagTemplatedetailpage?id='+TagTempID);
            }
        
      //  PageReference p =  new Pagereference('/apex/AdminListView?intFocus=11');
        p.setRedirect(true);
        return p;
    }
    // End of Method Update Tag Template
    
    //Cancel Method
      public PageReference cancelme()
      {
          string TagTempID=objTagTemplate.id;
           PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+TagTempID);
            }
            else
            {
               p =  new Pagereference('/apex/TagTemplatedetailpage?id='+TagTempID);
            }
      
        //  PageReference p =  new Pagereference('/apex/AdminListView?intFocus=11');
          p.setRedirect(true);
          return p; 
      }
    //End of cancel method
    */
   
}// End of Class