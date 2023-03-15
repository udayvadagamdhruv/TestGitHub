public with sharing class EditTagtempLineItemsExt{

   // Global Variables
       /*   private final Tag_Template_Item__c objTagLI;
          private Tag_Template_Item__c objTagLIQ;
          
           public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string TagTempLIprefix {set;get;}
     public String TagTempID{get;set;}
          
      // End of Global Variables
    
    // Standard Controller Constructor
    public EditTagtempLineItemsExt(ApexPages.StandardController controller) 
    {
         this.objTagLI=(Tag_Template_Item__c)controller.getrecord();
         objTagLIQ=[select id,TagTemplate__c,name from Tag_Template_Item__c where  id =:objTagLI.id];
         TagTempID=objTagLIQ.TagTemplate__c;
          TagTempLIprefix = Tag_Template_Item__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor

    // Method Called on to Update 
     Public PageReference saveme()
    {
        try
        {
            update objTagLI;
            System.debug('Media Type updated successfully@@@ '+objTagLI);
        }
        catch(System.DMLException e) { return null;}
    
            PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+TagTempID);
            }
            else
            {
               p =  new Pagereference('/apex/TagTemplatedetailpage?id='+TagTempID);
            }
            p.setRedirect(true);
            return p;
    }
    // End of Method Update 
    
    //Cancel Method
      public PageReference cancelme()
      {
            PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+TagTempID);
            }
            else
            {
               p =  new Pagereference('/apex/TagTemplatedetailpage?id='+TagTempID);
            }
            p.setRedirect(true);
            return p;
             
      }*/
    //End of cancel method

}