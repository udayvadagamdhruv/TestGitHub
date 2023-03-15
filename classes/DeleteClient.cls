// This page is used to delete Client
public with sharing class DeleteClient 
{
    // Global Variables
    String strClient;
    private final Client__c objClient;
    public Client__c clnt;
    public Boolean isError{get;set;}
    public String oId{get;set;}
    // End of Global Variables
    
    // Standard Controller Constructor
    public DeleteClient(ApexPages.StandardController con) 
    {
        isError = False;
        this.objClient=(Client__c)con.getrecord();
      //  clnt = [select id,Name from Client__c where id =: objClient.id];
      //  strClient = clnt.id;
      
      Schema.DescribeSObjectResult r = Client__c.sObjectType.getDescribe();
      oId = r.getKeyPrefix();
    }
    // End of Standard Controller Constructor
    
    // Method called on to Delete Holiday 
     public PageReference checkDelete()
     {
     //  Client__c obj = [select id,Name from Client__c where id =: strClient];   
       try
        {
           Database.delete(objClient);        
        }
        catch(System.DMLException e)
        {
           isError = True;
           return null;
        }
        //PageReference p =  new Pagereference('/apex/ClientTabOverride');
        PageReference p =  new Pagereference('/'+oId);
        p.setRedirect(true);
        return p;
     }
     // End of Delete Method
     
      // Test Coverage
      static testMethod void Test_DeleteClient()
      {
          Client__c testAcc = new Client__c(Name='Test Client 1580');
          insert testAcc;
          
          System.assertEquals('Test Client 1580',testAcc.Name);
          
          ApexPages.CurrentPage().getParameters().put('id',testAcc.id);
         
             // Instantiate the standard controller with the Client
          ApexPages.StandardController con = new ApexPages.StandardController(testAcc);
        
            // Instantiate the extention instance with the standardcontroller
          DeleteClient ext = new DeleteClient(con);
        
//          ext.isError = True;          
            // Invoke the Delete method on the extension
          ApexPages.PageReference result = ext.CheckDelete();
          
        
          result = ext.CheckDelete();
          
     }// End of Test Coverage
}// End of Class