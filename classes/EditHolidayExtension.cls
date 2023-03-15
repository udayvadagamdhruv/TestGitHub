// Extension Class for Edit Holiday 
public with sharing class EditHolidayExtension 
{
/*
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
   public string holidayprefix{set;get;}      

    //Global Variables
        private final Holiday__c objHoliday;
      //End of Global Variables
    
    // Standard Controller Constructor
    public EditHolidayExtension(ApexPages.StandardController controller) 
    {
         this.objHoliday=(Holiday__c)controller.getrecord();
         holidayprefix=Holiday__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor 

    // Method Called on to Update Holiday
     Public PageReference saveme()
    {
        try
        {
            update objHoliday;
            System.debug('Holiday updated successfully@@@ '+objHoliday);
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After updating the holiday navigate to Holiday tab
       if(isLtng)
             {   
              PageReference p =  new Pagereference('/'+holidayprefix+'/o');
              p.setRedirect(true);
              return p;
              }
        else
             {
              PageReference p =  new Pagereference('/apex/AdminListView?intFocus=4');
              p.setRedirect(true);
              return p;
             }
    }
    // End of Method Update Holiday
    
    //Cancel Method
         Public PageReference cancelme()
         {
             if(isLtng)
             {   
              PageReference p =  new Pagereference('/'+holidayprefix+'/o');
              p.setRedirect(true);
              return p;
              }
        else
             {
              PageReference p =  new Pagereference('/apex/AdminListView?intFocus=4');
              p.setRedirect(true);
              return p;
             }
         }
    //End of Cancel method
    
    // Test Coverage
    static testMethod void Test_EditHolidayExtension()
    {
        Holiday__c testH=new Holiday__c(Name='Test Holiday1',Date__c =System.Today());
        try
        {
            insert testH;
        }
        catch(System.DMLException e)
        {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
        }
        System.assertEquals('Test Holiday1',testH.Name);
        
        testH.Name='Test Holiday1520';
        testH.Date__c=System.Today()+1;
        
        // Instantiate the standard controller with the holiday 
        ApexPages.StandardController con=new ApexPages.StandardController(testH);
        
        // Instantiate the extention instance with the standardcontroller 
        EditHolidayExtension ext=new EditHolidayExtension(con);
        
        // Invoke the primary method on the extension
        ApexPages.PageReference result=ext.saveme();
        result=ext.cancelme();
        
        // To cover catch block
        delete testH;
        result=ext.saveme();
    }// End of Test Coverage*/
}// End of Class