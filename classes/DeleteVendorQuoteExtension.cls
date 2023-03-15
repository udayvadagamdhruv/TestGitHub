// This class is used to Delete Vendor Quote
public with sharing class DeleteVendorQuoteExtension 
{
      // Global variables  
   /*   public Id strId;  
      private final Vendor_Quote__c objVendorQuote; 
      // End Global variables
    
      // Start constructor
    public DeleteVendorQuoteExtension(ApexPages.StandardController controller) 
    {
       this.objVendorQuote=(Vendor_Quote__c)controller.getrecord();
       strId = [Select Id, Quote__c from Vendor_Quote__c where Id =:objVendorQuote.Id limit 1].Quote__c; 
    }
    // End Constructor 
    
    // This method is called on to Delete Vendor Quote
     public PageReference checkDelete()
     {
        try
        {
             if(Vendor_Quote__c.sObjectType.getDescribe().isDeletable()){
                 Database.delete(objVendorQuote); }       
        }
        catch(System.DMLException e)
        {
            return null;
        }
        PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+strId);
        p.setRedirect(true);
        return p;
     }
     // End of method checkDelete
     
    // Start Test Coverage Code
        static testMethod void Test_DeleteVendorQuoteExtension()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 311');
             
                insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 311',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
              Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 312',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 311');
                insert testSpec;
                
                Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 312');
                insert testSpec1;
           
            
               Job__c testJob1=new Job__c(Name='Test Job 312',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
                System.assertEquals('Test Job 312',testJob1.Name);   
               
                GL_Department__c testGLD = new GL_Department__c(Name='TestGLD2');
                 try
                 {
                     insert testGLD;
                 }
                 catch(System.DMLException e)
                 {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                 }
            
                 Quote__c testQ=new Quote__c(Name='Quote 311',Job__c=testjob1.Id,GL_Department__c=testGLD.Id);
                 try
                 {
                   insert testQ;
                 }
                 catch(System.DMLException e)
                 {
                    System.assertEquals('REQUIRED_FIELD_MISSING',e.getDmlStatusCode(0));
                 }
                 catch(Exception f)
                 {
                     System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',f.getDmlStatusCode(0));
                 }
                
                Vendor__c testVendor=new Vendor__c(Name='Vendor 311');
                insert testVendor;
             
                Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
                insert testVQ;
   
                ApexPages.StandardController con=new ApexPages.StandardController(testVQ);
                ApexPages.currentPage().getParameters().put('Id',testVQ.Id);
          
        
                // Instantiate the extention instance with the standard controller
            
                 DeleteVendorQuoteExtension ext=new DeleteVendorQuoteExtension(con);
        
                // Invoke the primary method on the extension
                
                // Delete Job Tasks
                 List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob1.Id];
                 delete lstTask;
         
                 // Delete Job Specs
         
                 List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob1.Id];
                 delete lstSpecs;
         
                // Delete Estimates
                
                 List<Estimate_Line_Items__c> lstELI=[select id from Estimate_Line_Items__c where Job__c=:testJob1.Id];
                 delete lstELI;
                 
                 // Delete PO's
        
                 List<Purchase_Order__c> lstPO=[select id from Purchase_Order__c where Job__c=:testJob1.Id];
                 delete lstPO;

                 Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Test Job 312'];
                 obj1.Status__c='Cancelled';
                 update obj1;
                 
                 ApexPages.PageReference result1=ext.checkDelete();
                 ApexPages.PageReference result2=ext.checkDelete();
       }    */
        // End of Test Coverage 
}
// End of class