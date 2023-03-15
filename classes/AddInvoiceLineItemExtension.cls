// This class is used as a extension to add Invoice Line Items

public with sharing class AddInvoiceLineItemExtension 
{
    // Glbal variables
  /*  private final Invoice_Line_Item__c ILI;
    public String Invoiceid{get;set;}
    public String InvoiceName{get;set;}
    public String VendorId{get;set;}
    public String VendorName{get;set;}
    // End of Global variables
     // End of Global variables
      
    // Start constructor
    public AddInvoiceLineItemExtension(ApexPages.StandardController controller) 
    {
        this.ILI=(Invoice_Line_Item__c)controller.getRecord();
        Invoiceid=ApexPages.CurrentPage().getParameters().get('Invid');
        Invoice__c objIN=[Select id,name,Vendor__c,Vendor__r.Name from Invoice__c where id=:Invoiceid];
        InvoiceName=objIN.Name;
        VendorId = objIN.Vendor__c;
        VendorName = objIN.Vendor__r.Name;
        ILI.Invoice__c = InvoiceId;
    }
    // End of Constructor
    
    // Method to populate GL Code
    public List<selectOption> getGLCode()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
       
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
      
         for (AggregateResult ar:[SELECT GL_Code__c,GL_Code__r.Name FROM Vendor_GL_Code__c where Vendor__c=: VendorId Group By GL_Code__c,GL_Code__r.Name Order By GL_Code__r.Name])  
          { 
               String aID = (string)ar.get('GL_Code__c');  
               Vendor_GL_Code__c elis=[Select id,Name,Vendor__c,GL_Code__c,GL_Code__r.Name from Vendor_GL_Code__c where GL_Code__c =: aID and Vendor__c=: VendorId  Limit 1];
               options.add(new selectOption(String.Valueof(ar.get('GL_Code__c')),elis.GL_Code__r.Name)); //for all records found - add them to the picklist options
          }
        return options; //return the picklist options
    }
    // End of method getGLCode
    
   // Save Method
    public PageReference saveme() 
     { 
        try
        {
            insert ILI;
        }
        catch(DMLException e)
        {
            return null;
        }
      // After creating Invoice Line Item record navigate to Invoice Detail Page        
      PageReference pageRef = new PageReference('/apex/Invoicedetailpage?id='+Invoiceid);
      pageRef.setRedirect(true);
      return pageRef;
    }
  // End of Save Method

        // Cancel Method
        Public PageReference cancelme()
        {       
            PageReference p =  new Pagereference('/apex/Invoicedetailpage?id='+Invoiceid);
            p.setRedirect(true);
            return p;     
       }
        // End of Cancel Method 

     // Start Test Method
      static testMethod void CreateInvoice()
        {
            Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
            
           Media_Type__c testMedia=new Media_Type__c(Name='TM01March');
            try
             {
               insert testMedia;
             }
            catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             }
           
           Schedule_Template__c testST=new Schedule_Template__c(Name='TST01March',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='TST01March');
           
                 insert testSpec;
                
           Job__c testJob1=new Job__c(Name='TJ01March',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
               }
            System.assertEquals('TJ01March',testJob1.Name);
               
            GL_Department__c testGLD = new GL_Department__c(Name='GLD01March');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }   
                    
            Vendor__c testVendor=new Vendor__c(Name='TV01March');
            insert testVendor;
             
            GL_Code__c testGL1=new GL_Code__c();
              testGL1.Name='TGLCode01March';
              testGL1.GL_Id__c='GLC01March';
              testGL1.GL_Department__c=testGLD.id;
              testGL1.Unit_Cost__c=2500;
              testGL1.Unit_Type__c='Days';
             
            try
            {
                 insert testGL1;
            }
            catch(System.DMLException e)
            {
                System.assert(e.getMessage().contains('Record already exist with same GLCode'));
            }
             Vendor_GL_Code__c testVGLCode = new Vendor_GL_Code__c(Vendor__c = testVendor.id,GL_Code__c = testGL1.id);
             insert testVGLCode;
             
             Invoice__c inv = new Invoice__c(Name = 'INV00987',Job__c=testJob1.id,Vendor__c = testVendor.id,Revised_Amount__c = 1000);
             insert inv;
             
             Invoice_Line_Item__c ILI = new Invoice_Line_Item__c(GL_Code__c = testGL1.id,Amount__c = 900);
                   
            // Invoke the primary method on the extension 
            ApexPages.currentPage().getParameters().put('Invid',inv.Id);
            ApexPages.StandardController con=new ApexPages.StandardController(ILI);
            
            // Instantiate the extention instance with the standard controller
            
            AddInvoiceLineItemExtension ext=new AddInvoiceLineItemExtension(con); 
            List<SelectOption> options1 = ext.getGLCode();       
        
            // Invoke the primary method on the extension
           
             ApexPages.PageReference result1=ext.saveme();
             ApexPages.PageReference result2=ext.cancelme();
       }*/
    // End Test Coverage
} // End of Class