// Extension Class for Edit Media Type 
public with sharing class EditMediaTypeExtension 
{

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
      public string MTprefix {set;get;}


    // Global Variables
          private final Media_Type__c objMediaType;
      // End of Global Variables
    
    // Standard Controller Constructor
    public EditMediaTypeExtension(ApexPages.StandardController controller) 
    {
         this.objMediaType=(Media_Type__c)controller.getrecord();
         
          Schema.DescribeSObjectResult r=Media_Type__c.SObjectType.getDescribe();
          MTprefix=r.getKeyPrefix();
    }
    // End of Standard Controller Constructor

    // Method Called on to Update Media Type
     Public PageReference saveme()
    {
        try
        {
            update objMediaType;
            System.debug('Media Type updated successfully@@@ '+objMediaType);
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After updating the holiday, navigate to Holiday tab 
        
        PageReference p;
        if(isLtng)
          {
               p=new Pagereference('/'+MTprefix +'/o');
          }
       else
           {
             p =  new Pagereference('/apex/AdminListView?intFocus=8');
           }   
            p.setRedirect(true);
            return p;
           
        
    }
    // End of Method Update Media Type
    
    //Cancel Method
      public PageReference cancelme()
      {
          PageReference p;
           if(isLtng)
          {
              p=new Pagereference('/'+MTprefix +'/o');
          }
       else
           {
             p= new Pagereference('/apex/AdminListView?intFocus=8');
           }  
          p.setRedirect(true);
          return p;
      }
    //End of cancel method
    
    // Test Coverage Code    
    static testMethod void Test_EditMediaTypeExtension()
     {        
        Media_Type__c testMedia=new Media_Type__c(Name='MT012');
           try
            {
                insert testMedia;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
         
         Media_Type__c testMedia1=new Media_Type__c(Name='MT012');
           try
            {
                insert testMedia1;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }     
        
            // Instantiate the standard controller with the Media Type
         ApexPages.StandardController con=new ApexPages.StandardController(testMedia);
         
             // Instantiate the extention instance with the standard controller
         
         EditMediaTypeExtension ext=new EditMediaTypeExtension(con);        
         
             // Invoke the primary method on the extension 
         ApexPages.PageReference result=ext.saveme();
    
         System.assertEquals('MT012',testMedia.Name);
            
         Delete testMedia;
         
         result=ext.saveme(); 
         result=ext.cancelme();  
     }     
    // End of Test method
}// End of Class