// This page is used to create Holiday

public with sharing class createHoliday 
{
   public boolean isLtng{set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
   public string holidayprefix{set;get;}         
            
    // Global variables
    private final Holiday__c h;
    // End of Global variables
    
    // Start constructor
    public createHoliday(ApexPages.StandardController controller) 
    {
        this.h=(Holiday__c)controller.getRecord();
        holidayprefix=Holiday__c.SobjectType.getDescribe().getKeyPrefix();
       // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+holidayprefix));
    }
    // End Constructor

    // This method is called on to Save Holiday
     Public PageReference saveme()
     {
       try 
       { 
            insert h;
       }
       catch(System.DMLException e)
       {
          system.debug('error msg'+e.getMessage());
           return null;
       }
       PageReference p;
        if(isLtng)
            p = new Pagereference('/'+holidayprefix+'/o');
        else
            p =  new Pagereference('/apex/AdminListView?intFocus=4');
            p.setRedirect(true);
           return p;
           
        }  
    // End Save method

    // This method is called on to handle Cancel button
    Public PageReference cancelme()
    {
        PageReference p;
        if(isLtng)
              p =  new Pagereference('/'+holidayprefix+'/o');
        else
             p =  new Pagereference('/apex/AdminListView?intFocus=4');
              p.setRedirect(true);
              return p;

    }
    // End Cancel method

    //Test Coverage Code              
    Static testMethod void Test_createHoliday()
    {
        Holiday__c testH=new Holiday__c(Name='H007',Date__c=System.Today());
        ApexPages.StandardController con=new ApexPages.StandardController(testH);
        createHoliday ext=new createHoliday(con);
        System.assertEquals('H007',testH.Name);
        ApexPages.PageReference result1=ext.cancelme(); 
        result1=ext.saveme(); 
        //ext.isLtng=true;
        //ApexPages.PageReference result2=ext.cancelme(); 
       result1=ext.saveme(); 
    }
    //End of test method
}
// End of Class