// This class is used to display Quote Detail
public with sharing class QuoteDetailPageExtension 
{
   // Global variables
  /*  public List<Quote__c> vq{get;set;} 
    String theID;
    public String qtid{set;get;}
    // End of Global variables
    
    // Start Constructor
    public QuoteDetailPageExtension(ApexPages.StandardController controller) 
    {
         theID = ApexPages.CurrentPage().getParameters().get('id');
         vq=[select id,Name,Approved__c from Quote__c where id =: theID AND Approved__c = true];
         qtid=theID;
     }
     // End of Constructor
     
    // Test Method 
      static testMethod void Test_QuoteDetailPageExtension()
      {
           Quote__c quote = new Quote__c();
           ApexPages.StandardController con=new ApexPages.StandardController(quote);
           QuoteDetailPageExtension ext=new QuoteDetailPageExtension(con);
           System.assertEquals(quote.id,ext.theID);
       } 
     // End of test Method */
}
// End of Class