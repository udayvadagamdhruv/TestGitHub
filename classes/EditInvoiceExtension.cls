// This class is used to Edit Invoice
public with sharing class EditInvoiceExtension 
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            } 
    
    
    // Global Variables 
    private final Invoice__c objIN;
    public string jobid {set;get;}
    String objINId;
    // End of Global variables
    
    // Constructor 
    public EditInvoiceExtension(ApexPages.StandardController controller) 
    {
         this.objIN=(Invoice__c)controller.getrecord();
         jobid=Apexpages.Currentpage().getparameters().get('id');
         //objINId = objIN.Id;
         objINId =jobid;
    }
    // End of Constructor 
    
    String strINId;   
    // Save Method
    Public PageReference saveme()
    {
       try
       {
            update objIN;
            strINId = objIN.Id;        
       } 
       catch(system.DMLException e)
       {
           return null;
       }
       
       
       if(isLtng)
       {
              // After editing invoice navigate to its detail page
              PageReference pageRef = new PageReference('/apex/InvoiceDetailpageLightning?id='+strINId);
              pageRef.setRedirect(true);
              return pageRef; 
        }
        else
        {
              PageReference pageRef = new PageReference('/apex/InvoiceDetailpage?id='+strINId);
              pageRef.setRedirect(true);
              return pageRef;
        }
       
     }
     // End of method Save
    
    // Methoda called on to handle Cancel button
    Public PageReference cancelme()
    {       
        
        if(isLtng)
        {
            PageReference pageRef = new PageReference('/apex/InvoiceDetailpageLightning?id='+objINId);
            pageRef.setRedirect(true);
            return pageRef; 
        }
        else
        {
            PageReference pageRef = new PageReference('/apex/InvoiceDetailpage?id='+objINId);
            pageRef.setRedirect(true);
            return pageRef; 
        }
        
    }  
    // End of method Cancel

    // Test Coverage Code
     Private static testMethod void Test_EditInvoiceExtension()
     {
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 321');
             insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 321',Media_Types__c=testMedia.Id);
             insert testST;
      
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 321');
             insert testSpec;
       
         Job__c testJob1=new Job__c(Name='Test Job 321',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
          try
           {
               insert testJob1;
           }
          catch(System.DMLException e)
           {
               System.assert(e.getMessage().contains('Job with same name Exists'));
           }
          System.assertEquals('Test Job 321',testJob1.Name); 
           
         Vendor__c testVendor=new Vendor__c(Name='Vendor 321');
             insert testVendor;  
   
         Invoice__c testI=new Invoice__c(Job__c=testjob1.Id,Date_Received__c=System.Today(),Vendor__c=testVendor.Id);
          try
           {
               insert testI;
           }
          catch(System.DMLException e)
           {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
           }

         Invoice__c testIn = [Select id,Job__c,Vendor__c from Invoice__c where id =: testI.Id];

         // Instantiate the standard controller with the Invoice
         ApexPages.StandardController con=new ApexPages.StandardController(testIn);
         ApexPages.currentPage().getParameters().put('Id',testIn.Id);

         // Instantiate the extention instance with the standard controller 
          EditInvoiceExtension ext=new EditInvoiceExtension(con);
        
         // Invoke the primary method on the extension */
          ApexPages.PageReference result1=ext.saveme();
          result1=ext.cancelme();
            
          delete testIn;
          result1=ext.saveme();
       }    
   // End of Test Coverage Case
}
// End of class