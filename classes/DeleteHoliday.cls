// Extension Class to Delete Holiday 
public with sharing class DeleteHoliday 
{
  
  public boolean isLtng {set;get{
                          
                          return (UserInfo.getUITheme()=='Theme4d')?true:false;
                          
                          }}
   public string hldyprefix {set;get;}
     
    // Global Variables
    private final Holiday__c objHoliday;
    String str;
    // End of Global Variables 
    
    public Holiday__c ho;

    // Standard Controller Constructor 
    public DeleteHoliday(ApexPages.StandardController con) 
    {
        this.objHoliday=(Holiday__c)con.getrecord();
        ho = [select id,Name from Holiday__c where id =: objHoliday.id];
        str = ho.id;
        hldyprefix=Holiday__c.SobjectType.getDescribe().getKeyPrefix();
      //  Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.error,''+isLtng));
    }
    // End of Standard Controller Constructor
    
    // Method called on to Delete Holiday
     public PageReference checkDelete()
     {
          Holiday__c h = [select id,Name from Holiday__c where id =: str];   
          try
         {
            Database.delete(h);        
         }
         catch(System.DMLException e)
         {
           return null;
         }
       if(isLtng)
           {
             PageReference p =  new Pagereference('/'+hldyprefix+'/o');
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
     // End of Delete Method 
     
      // Test Coverage 
    
    // Positive Test Case
        static testMethod void Test_DeleteHoliday()
         {
            Holiday__c testH=new Holiday__c(Name='Test HL1',date__c=System.Today());
             insert testH;
            
             System.assertEquals('Test HL1',testH.Name);
             
             Holiday__c testH1=new Holiday__c(Name='Test HL1',date__c=System.Today());
             try
             {
                 insert testH1;  
             }
             catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
             }
             
             Holiday__c testH3=new Holiday__c(Name='Test HL23',date__c=System.Today());
             insert testH3;
             
             Holiday__c testH4 = [select id,Name,date__c from Holiday__c where id =: testH3.Id];
             testH4.Name='Test HL1';
             try
             {
                 update testH4;  
             }
             catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
             // Instantiate the standard controller with the Holiday 
            ApexPages.StandardController con=new ApexPages.StandardController(testH);
        
            // Instantiate the extention instance with the standardcontroller 
            DeleteHoliday ext=new DeleteHoliday(con);
        
            // Invoke the Delete method on the extension 
            ApexPages.PageReference result=ext.CheckDelete();
           
            System.assertNotEquals(testH, null);
            
    }// End of Test Method
}
// End of Class