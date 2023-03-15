// Extension Class to Delete Client Contact

public with sharing class DeleteClientContactExtension 
{
    // Global variables
    private String ClientId;
    private final Client_Contact__c objContact;
    public String email{get;set;}
    public boolean sfUser{get;set;}
    public Id CCid{get;set;}
    // End of Global variables

    // Standard Controller Constructor
    public DeleteClientContactExtension(ApexPages.StandardController con) 
    {
        this.objContact=(Client_Contact__c)con.getrecord();
        
        // Client__c ClientId = [Select Id from Client_Contact__c where Id =:objContact.Id limit 1];
        Client_Contact__c c=[Select Id, EMail__c,Client__c, Salesforce_User__c from Client_Contact__c where Id=:objContact.id];
        
        clientId=c.Client__c;
        email=c.Email__c;
        sfUser=c.Salesforce_User__c;
    }
    // End of Standard Controller Constructor
   
   // Method called on to Delete ClientContact
   public PageReference CheckDelete()
   {
      try
        {
            Database.delete(objContact); 
           // deactivateCurrentUser(email,sfUser);
        }
       catch(DMLException e)
        {
            return null;
        }
        // After Deletion Navigate to the ClintContact ListView
         PageReference p =  new Pagereference('/apex/ClientViewPageSwitchPage?id='+ClientId); 
         p.setRedirect(true);
         return p;
         
   }
    // End of Delete Method
    
      // After deleting Client Contact if its related User record is created then deactivate the related User record
     /*
      @future
      public static void deactivateCurrentUser(String email,boolean sfUser)
      {
          if(sfUser==True)
          {
              try
              {
                  User u=[Select Id,IsActive from User where Username =: email];
                  u.IsActive=False;
                  u.IsDeleted__c=True;
                  update u;
                  System.debug('User Deactivation Successful');
               }
               catch(System.DMLException e)
               {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueOf(e));
                    ApexPages.addMessage(myMsg);
               }    
           }
      }// End of future method
    */
         // Start Test Coverage
         static testMethod void deleteClientContactPositiveTest()
         {
             Client__c testAcc=new Client__c(Name='Test Account');
             
             try
             {
                 insert testAcc;
                 System.debug('Client inserted successfully@@@ '+testAcc);
             }
             catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
             Client__c testAcc1=new Client__c(Name='Test Account');
             
              try
             {
                 insert testAcc1;
                 System.debug('Client inserted successfully@@@ '+testAcc1);
             }
             catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             Client__c testAcc2=new Client__c(Name='Test Account 1');
             try
             {
                 insert testAcc2;
                 System.debug('Client inserted successfully@@@ '+testAcc2);
             }
             catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
            Client__c Ac = [Select id,Name from Client__c where id =: testAcc2.Id];
            
             Ac.Name='Test Account';
             try
             {
             update Ac;
             }
              catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             Client_Contact__c testCon=new Client_Contact__c(First_Name__c='Test',Last_Name__c='Contact 1',Client__c=testAcc.Id,Email__c='testUserSFDC@yahoo.com',UserName__c='testUserSFDC@yahoo.com');
             try
             {
                 insert testCon;
                 System.debug('Client Contact inserted successfully@@@ '+testCon);
             }
             catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
              System.assertEquals('testUserSFDC@yahoo.com',testCon.Email__c);     
             
            // Instantiate the standard controller with the Client Contact 
            ApexPages.StandardController con=new ApexPages.StandardController(testCon);
        
            // Instantiate the extention instance with the standardcontroller 
            DeleteClientContactExtension ext=new DeleteClientContactExtension(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result=ext.CheckDelete();
         
            ApexPages.PageReference result1=ext.CheckDelete();
        
            Client_Contact__c testCon2=new Client_Contact__c(First_Name__c='Test',Last_Name__c='Contact 2',Client__c=testAcc.Id,Email__c='testUserSFDC98@gmail.com',UserName__c='testUserSFDC98@gmail.com',Salesforce_User__c=True);
            
                 insert testCon2;
        
            ApexPages.CurrentPage().getParameters().put('id',testCon2.id);    
                   
            // Instantiate the standard controller with the Client Contact
            ApexPages.StandardController con2=new ApexPages.StandardController(testCon2);
        
            // Instantiate the extention instance with the standardcontroller
            DeleteClientContactExtension ext2=new DeleteClientContactExtension(con2);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result2=ext2.CheckDelete();
         }// End of Test Coverage
}// End of Class