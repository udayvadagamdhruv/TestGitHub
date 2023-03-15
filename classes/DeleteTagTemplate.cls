// This Class is used to Delete Tag Template
public with sharing class DeleteTagTemplate
{
    // Global Variables
   /* private final Tag_Template__c objTagTemplate;
    public Boolean isError{get;set;}
    // End of Global Variables 
    
      public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
    public string tagsPrefix{get;set;}
    
    
    
    // Standard Controller Constructor 
    public DeleteTagTemplate(ApexPages.StandardController con) 
    {
        isError = False;
        this.objTagTemplate=(Tag_Template__c)con.getrecord();
        tagsPrefix=Tag_Template__c.SobjectType.getDescribe().getKeyPrefix();

    }
    // End of Standard Controller Constructor 
    
    // Method called on to Delete Media Type
     public PageReference checkDelete()
     {
        try
        {
            if(Tag_Template__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objTagTemplate);     }   
        }
        catch(System.DMLException e)
        {
           isError = True;
           return null;
        }
        // AFter deleting a record navigate to Tag Template Tab in Admin
        
          PageReference p ;
          if(isLtng)
          {
                p=  new Pagereference('/'+tagsPrefix+'/o');
          }
          else
          {
             p = new Pagereference('/apex/AdminListView?intFocus=11');
          }
          p.setRedirect(true);
          return p;
        
        
        
      /*  PageReference p =  new Pagereference('/apex/AdminListView?intFocus=11');
        p.setRedirect(true);
        return p;*
     }
     // End of Delete Method
     
     
    public pagereference Tagslistback()
    {
          PageReference p ;
          if(isLtng)
          {
                p=  new Pagereference('/'+tagsPrefix+'/o');
          }
          else
          {
             p = new Pagereference('/apex/AdminListView?intFocus=11');
          }
          p.setRedirect(true);
          return p;
    
    } 
     
     

    // Start Test Coverage Code
    static testMethod void Test_DeleteTagTemplate()
    {
          Tag_Template__c testTagTemplate=new Tag_Template__c(Name='Test Tag9999');
          try
          {   
            insert testTagTemplate;
          } 
         catch(System.DMLException e)
         {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
         }  
           
          // Instantiate the standard controller with the Tag Template
          
          ApexPages.currentPage().getParameters().put('Id',testTagTemplate.Id);
          ApexPages.StandardController con=new ApexPages.StandardController(testTagTemplate);
        
          // Instantiate the extention instance with the standardcontroller
          DeleteTagTemplate ext=new DeleteTagTemplate(con);
        
          // Invoke the primary method on the extension
          ApexPages.PageReference result=ext.checkDelete();
         
          // Below code covers the Catch statement 
          result=ext.checkDelete();       
    }// End of Test Coverage code*/
}// End of Class