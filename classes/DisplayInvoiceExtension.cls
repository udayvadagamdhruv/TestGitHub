// This method is used to display Invoices under Job Tab
public with sharing class DisplayInvoiceExtension 
{/*
//Added by Rahul starts--
    public string myClient {get; set;}
    public Invoice_Line_Item__c inv {get; set;}
//--ends

    public String getPoId() {
        return poId;
    }

    // Global variables
    //  String theID;
   id theID;
    public List<Invoice_Line_Item__c> ILI{get;set;} 
    Invoice__c objInv{get;set;}
    ID poId{get;set;}
    // String poId{get;set;}
//Added by Rahul
    public String inSt{get; set;}
    // End of Global variables

//by rahul added code starts--
    //Delete Line Item 
    public pageReference deleteRec(){
        string pgId = ApexPages.currentPage().getParameters().get('id');
        system.debug('@@@@@@@@@@@@@ '+myClient);
        system.debug('************* '+pgId );

        inv = [SELECT id, Name, Invoice__c, Invoice__r.Invoice_Status__c FROM Invoice_Line_Item__c WHERE Id =: myClient];
       if(Invoice_Line_Item__c.sObjectType.getDescribe().isDeletable()){
           delete inv;}

        PageReference newpg = new PageReference('/apex/InvoiceDetailPage?id='+pgId);
        return newpg;
    }

    //Edit record
    public pageReference editRec(){
        string pgId = ApexPages.currentPage().getParameters().get('id');
        system.debug('@@@@@@@@@@@@@ '+myClient);
        system.debug('************* '+pgId );

        inv = [SELECT id, Name, Invoice__c, Invoice__r.Purchase_Order__c, Invoice__r.Invoice_Status__c, Amount__c, GL_Code__c, Estimate_Line_Item__c FROM Invoice_Line_Item__c WHERE Id =: myClient];

//created this following new page.
        PageReference newpg = new PageReference('/apex/EditLineItem?id='+myClient);
        newpg.setRedirect(true);
        return newpg;
    }
//added code ends here
    
    // Start Constructor
    public DisplayInvoiceExtension()
    {
         theID = ESAPI.encoder().SFDC_HTMLENCODE(ApexPages.CurrentPage().getParameters().get('id'));
         objInv=[Select Id, Name, Purchase_Order__c, Invoice_Status__c from Invoice__c where Id=: theId LIMIT 1];
         poId=ESAPI.encoder().SFDC_HTMLENCODE(objInv.Purchase_Order__c);
         ILI=[select id,Name,Invoice__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,Amount__c,GL_Code__c,Unit_Type__c from Invoice_Line_Item__c where Invoice__c =: theID ORDER BY Name];
         
//added by Rahul
         inSt = objInv.Invoice_Status__c;
    }
    // End of Constructor
 
    // This method is called on to add Invoice LIne Item for selected Invoice
     public PageReference add_ILI()
    {
        PageReference p =  Page.AddInvoicelineItem;
        p.setRedirect(true);
        p.getParameters().put('Invid',theID);
        return p;
    } 
    // End of method
    
     // This method is called on to add PO LIne Item for selected Invoice
    public PageReference add_ILI_from_poli()
    {
       
     //   PageReference p =  Page.AddPOLineItem;
        PageReference p =  Page.addPOLineItem;
        p.setRedirect(true);
        p.getParameters().put('Invid',theID);
        return p;
    } 
    // End of method
    
    
    public PageReference save()
    {
     try
      {
           update ILI;
      }
     catch(System.DMLException e)
      {
           return null;
      }
      // After updating PO, navigate to Purchase Order Tab
      PageReference p =  new Pagereference('/apex/InvoiceDetailPage?id='+theID);
      p.setRedirect(true);
      return p; 
    }
    //End Of Save Method  
    
    //Method For Cancel button    
     public PageReference cancelme()
       {
        PageReference p =  new Pagereference('/apex/InvoiceDetailPage?id='+theID);
        p.setRedirect(true);
        return p;     
       }
    //End Of Cancel Buttons method  
  /*   
    // Start Test Coverage Code
      static testMethod void DisplayInvoiceWhenApproved()
     {
              Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
     
            Media_Type__c testMedia=new Media_Type__c(Name='TM02Mar');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='TST02Mar',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='TST02Mar');
               insert testSpec;
           
           Job__c testJob1=new Job__c(Name='TJ02Mar',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('TJ02Mar',testJob1.Name);  
     
     
     
           Invoice__c ESI = new Invoice__c(Name='INV01March',Job__c=testJob1.id);
           insert ESI;
           
           GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1101');
           insert testGLD;
           
           GL_Code__c testGL=new GL_Code__c(Name='GL Code 1101',GL_ID__c='TestGL9988',GL_Department__c = testGLD.id);
           insert testGL;
           
           Vendor__c v = new Vendor__c(Name = 'Tset');
           
           Estimate_Line_Items__c eli = new Estimate_Line_Items__c(Name = 'Test Eli', GL_Department__c = testGLD.Id, GL_Code__c = testGL.Id,Job__c = testJob1.Id,Quantity__c = 12,Vendor__c = v.Id);
           
           Invoice_Line_Item__c ili = new Invoice_Line_Item__c(Invoice__c = ESI.Id,GL_Code__c = testGL.Id,Amount__c = 100,Estimate_Line_Item__c = eli.Id );
           insert ili;
           
            ApexPages.currentPage().getParameters().put('id',ESI.Id);

            // Instantiate the extention instance with the Custom Controller
           DisplayInvoiceExtension ext=new DisplayInvoiceExtension();
           
              // Instantiate the extention instance with the Custom Controller
           DisplayInvoiceExtension ext1=new DisplayInvoiceExtension();
          
           
            // Invoke the primary method on the extension
           ApexPages.PageReference result1=ext1.add_ILI();
           System.assertEquals(ESI.id,ext.theID);
           ext1.myClient = ili.Id;
           result1 = ext1.save();
           result1 = ext1.cancelme();
           result1 = ext1.add_ILI_from_poli();
           result1 = ext1.deleteRec();
      } 
     // End of test Method*/
}// End of Class