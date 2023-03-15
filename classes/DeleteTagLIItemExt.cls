public with sharing class DeleteTagLIItemExt
{
    // Start Global variables
    /*
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    public Id JobId;
    private final Tag_Template_Item__c objSI;
    // End of Global variables
    
    // Start Constructor
    public DeleteTagLIItemExt(ApexPages.StandardController con) 
    {
        this.objSI=(Tag_Template_Item__c)con.getrecord();
        JobId = [Select Id, TagTemplate__c from Tag_Template_Item__c where Id =:objSI.Id limit 1].TagTemplate__c;
    }
    // End of Constructor
    
    // This method is called on to delete tag Item    
     public PageReference checkDelete()
     {
        try
        {
             if(Tag_Template_Item__c.sObjectType.getDescribe().isDeletable()){
                 Database.delete(objSI);}        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
        
        
          PageReference p;
            if(isLtng)
            {
                 p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+JobId);
            }
            else
            {
                  p = new Pagereference('/apex/TagTemplatedetailpage?id='+JobId);
            }
        
        
        
      //   PageReference p =  new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+JobId);
         p.setRedirect(true);
         return p;
     }*/
     // End of delete method
}