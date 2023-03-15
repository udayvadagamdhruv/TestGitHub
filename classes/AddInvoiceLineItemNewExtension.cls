// This class is used as a extension to add Invoice Line Items

public with sharing class AddInvoiceLineItemNewExtension 
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    
    // Glbal variables
    private final Invoice_Line_Item__c ILI;
    public String Invoiceid{get;set;}
    public String InvoiceName{get;set;}
    public String VendorId{get;set;}
    public String VendorName{get;set;}
    // End of Global variables
      
    // Start constructor
    public AddInvoiceLineItemNewExtension(ApexPages.StandardController controller) 
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
               Vendor_GL_Code__c elis=[Select id,Name,Vendor__c,GL_Code__c,GL_Code__r.Name,GL_Code__r.GL_ID__c from Vendor_GL_Code__c where GL_Code__c =: aID and Vendor__c=: VendorId  Limit 1];
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
        { return null;}
      // After creating Invoice Line Item record navigate to Invoice Detail Page        
     
        if(isLtng)
        {
             PageReference pageRef = new PageReference('/apex/Invoicedetailpagelightning?id='+Invoiceid);
              pageRef.setRedirect(true);
              return pageRef; 
        }
        else
        {
              PageReference pageRef = new PageReference('/apex/Invoicedetailpage?id='+Invoiceid);
              pageRef.setRedirect(true);
              return pageRef;
        }
     
     
     
     
    }
  // End of Save Method

        // Cancel Method
     Public PageReference cancelme()
     {       
        if(isLtng)
        {
             PageReference pageRef = new PageReference('/apex/Invoicedetailpagelightning?id='+Invoiceid);
              pageRef.setRedirect(true);
              return pageRef; 
        }
        else
        {
              PageReference pageRef = new PageReference('/apex/Invoicedetailpage?id='+Invoiceid);
              pageRef.setRedirect(true);
              return pageRef;
        }    
    }
        // End of Cancel Method 
        
 }