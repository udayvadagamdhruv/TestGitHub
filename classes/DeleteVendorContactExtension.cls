// This class is used to class to Delete Vendor Contact
public with sharing class DeleteVendorContactExtension 
{
    // Global variables 
    public boolean isError{get;set;}
    private Id vendorId;
    private final Vendor_Contact__c objVC;
    // End of Global variables 

    // Standard controller constructor
    public DeleteVendorContactExtension(ApexPages.StandardController con)
    {
         isError=false;   
         this.objVC=(Vendor_Contact__c)con.getrecord();
         vendorId = [Select Id, Vendor__c from Vendor_Contact__c where Id =:objVC.Id limit 1].Vendor__c; 
    }
    // End of Standard Controller Constructor 
    
     // This method is called on to delete Vendor Contact record
     public PageReference CheckDelete()
     {
        try
        {
           Database.delete(objVC);    
        }
        catch(System.DMLException e)
        {
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); 
            return null;
        }
        // After deleting Vendor Contact, navigate to Vendor Detail Page
        PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+vendorId+'&section=VendorContact'); 
        p.setRedirect(true);
        return p;   
     }
     // End of delete method
     
     // Start Test Coverage Code
    static testMethod void Test_DeleteVendorContactExtension()
     {
         Vendor__c testVendor=new Vendor__c(Name='TestV999');
         insert testVendor;
         
         Vendor_Contact__c testVC1=new Vendor_Contact__c(First_Name__c='TestVC1',Last_Name__c='Test Last Name',Email__c='testemail@gmail.com',Vendor__c=testVendor.Id);
         insert testVC1;
         
         System.assertEquals('TestVC1',testVC1.First_Name__c);
         
          // Instantiate the standard controller with the Client Contact 
        ApexPages.StandardController con=new ApexPages.StandardController(testVC1);
        
        // Instantiate the extention instance with the standardcontroller
        DeleteVendorContactExtension ext=new DeleteVendorContactExtension(con);
        
        // Invoke the primary method on the extension 
        ApexPages.PageReference result=ext.CheckDelete();
        ApexPages.PageReference result1=ext.CheckDelete();  
     }
     // End of Positive Test Case
}
// End of Class