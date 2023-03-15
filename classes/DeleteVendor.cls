public with sharing class DeleteVendor 
{
    public String oId{get;set;}
    // Globl Variables
    private final Vendor__c Vendor;
    public Boolean isError{get;set;}
    // End Of Global Variables 

    // Standard Controller Constructor 
    public DeleteVendor(ApexPages.StandardController controller) 
    {
        isError = False;
        this.Vendor=(Vendor__c)controller.getrecord();
        Schema.DescribeSObjectResult r1 = Vendor__c.sObjectType.getDescribe();
        oId = r1.getKeyPrefix();
    }

    // Method called on to delete Vendor
    public PageReference checkDelete()
    {
      try
       {
           isError = True;
           Database.delete(Vendor);
       }
       catch(System.DMLException e)
       {
           return null;
       }
      
      // After deletion navigate to GL Code 
      PageReference p = new PageReference('/'+oId);
      p.setRedirect(true);
      return p; 
    }
    // End of delete method
 
 
    
   // Test Coverage Code
    static testMethod void Test_DeleteVendorExtension()
         {
             Vendor__c testGL=new Vendor__c(Name='Test V2902');
             
             try
             {
                 insert testGL;
           
             }
             
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
             System.assertEquals('Test V2902',testGL.Name);
             
             
             // Instantiate the standard controller with the GLCode 
            ApexPages.StandardController con=new ApexPages.StandardController(testGL);
        
            // Instantiate the extention instance with the standardcontroller
            DeleteVendor ext=new DeleteVendor(con);
        
            // Invoke the Delete method on the extension 
            ApexPages.PageReference result=ext.CheckDelete();
        
             // The below code covers the Catch statement in checkDelete method 
            ApexPages.PageReference result1=ext.CheckDelete();
        }// End of Test Coverage Code
}