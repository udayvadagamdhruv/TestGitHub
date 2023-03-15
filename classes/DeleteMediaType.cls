// This Class is used to Delete Media Type
public with sharing class DeleteMediaType 
{

   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
    public string mediaPrefix{get;set;}
  
    // Global Variables
    private final Media_Type__c objMediaType;
    public Boolean isError{get;set;}
    // End of Global Variables 
    
    // Standard Controller Constructor 
    public DeleteMediaType(ApexPages.StandardController con) 
    {
        isError = False;
        this.objMediaType=(Media_Type__c)con.getrecord();
        mediaPrefix=Media_Type__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor 
    
    // Method called on to Delete Media Type
     public PageReference checkDelete()
     {
        try
        {
            Database.delete(objMediaType);        
        }
        catch(System.DMLException e)
        {
           isError = True;
           return null;
        }
        
       
        // AFter deleting a record navigate to Media Type Tab in Admin
        PageReference p ;
        if(isLtng)
                {
                p=  new Pagereference('/'+mediaPrefix+'/o');
                }
           else
           {
             p = new Pagereference('/apex/AdminListView?intFocus=8');
           }
            p.setRedirect(true);
            return p;
     }
     
     
    public pagereference mtlistback()
    {
       PageReference p;
       if(isLtng)
                {
                  p =  new Pagereference('/'+mediaPrefix+'/o');
                }
           else
           {
              p =  new Pagereference('/apex/AdminListView?intFocus=8');
           }
             p.setRedirect(true);
             return p;
    
    } 
     
     
     // End of Delete Method

    // Start Test Coverage Code
    static testMethod void Test_DeleteMediaType()
    {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media9999');
          try
          {   
            insert testMedia;
          } 
         catch(System.DMLException e)
         {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
         }  
           
          // Instantiate the standard controller with the Media Type
          
          ApexPages.currentPage().getParameters().put('Id',testMedia.Id);
          ApexPages.StandardController con=new ApexPages.StandardController(testMedia);
        
          // Instantiate the extention instance with the standardcontroller
          DeleteMediaType ext=new DeleteMediaType(con);
        
          // Invoke the primary method on the extension
          ApexPages.PageReference result=ext.checkDelete();
         ApexPages.PageReference result2=ext.mtlistback();
         
          // Below code covers the Catch statement 
          result=ext.checkDelete();       
    }// End of Test Coverage code
}// End of Class