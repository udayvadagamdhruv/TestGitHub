public with sharing class CreateTagtempLineItemsExt {
    /*
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
    
    public string TagLineitemprefix {set;get;}
    public String TagTempID{get;set;}
    // Global variables
    String TagLIName;
    
    private final Tag_Template_Item__c TagLineitem;
    
    
    public CreateTagtempLineItemsExt(ApexPages.StandardController controller) 
    {
    
         this.TagLineitem= (Tag_Template_Item__c )controller.getRecord(); 
        TagTempID=ApexPages.CurrentPage().getParameters().get('TagID');
         TagLineitem.TagTemplate__c=TagTempID;
         Schema.DescribeSobjectResult r = Tag_Template_Item__c.SobjectType.getDescribe();
         TagLineitemprefix=r.getKeyPrefix();
    }
    
    
      // This method is called on to save Production Spec Item
    Public PageReference saveme()
    {
        try
        {
            String strid;
            
            insert TagLineitem;
            strid = TagLineitem.TagTemplate__c;        
            
            PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+strid);
            }
            else
            {
               p =  new Pagereference('/apex/TagTemplatedetailpage?id='+strid);
            }
            p.setRedirect(true);
            return p;
        }
        catch(System.DMLException e)
        {
            
            return null;
        }
    }
    
    public pageReference cancel()
    {
            String strid;
            
            strid = TagLineitem.TagTemplate__c;   
            PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+strid);
            }
            else
            {
               p =  new Pagereference('/apex/TagTemplatedetailpage?id='+strid);
            }
            p.setRedirect(true);
            return p;
    
    
    }*/
    

}