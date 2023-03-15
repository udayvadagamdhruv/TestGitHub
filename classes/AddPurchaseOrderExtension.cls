// This class is used to Add Purchase Order

public with sharing class AddPurchaseOrderExtension
{
  /*    // Global variables
    public String Invoiceid{get;set;}
    public List<POWrapper> rolewraps{get;set;}
    public Invoice_Line_Item__c stRole{get;set;}
    public List<Invoice_Line_Item__c> lst{get;set;}
       // End of Global variables

     // Start Constructor
     public AddPurchaseOrderExtension()
      {
          Invoiceid = ApexPages.currentPage().getParameters().get('id');
          roleWraps=new List<POWrapper>();
          Invoice__c invoice = [Select id,Name,Job__c,Vendor__c from Invoice__c where id =: Invoiceid];
          List<Purchase_Order__c> PO=[Select id,Name,Total_Amount__c,Vendor__c,Job__c From Purchase_Order__c where Vendor__c =: invoice.Vendor__c and Job__c =: invoice.Job__c and Status__c = 'Sent'];
          for(Purchase_Order__c e: PO)
          {
            POWrapper rw=new POWrapper();
            rw.e=e;
            rw.checked=false;
            roleWraps.add(rw);        
          }
      }
      // End Constructor
  
     // Start Wrapper Class
     public class POWrapper
     {
         public Purchase_Order__c e{get;set;}
         public Boolean checked{get;set;}
     } 
     // End Wrapper Class
 
    // Start Save Method
    public pagereference Save()
    {
        try
        {
            for(POWrapper rw:roleWraps)
            {
                lst=new List<Invoice_Line_Item__c>();
                if(rw.checked==true)
                {
                    stRole=new Invoice_Line_Item__c();
                    if(schema.SobjectType.Invoice_Line_Item__c.Fields.Amount__c.isCreateable()){ 
                        stRole.Amount__c=rw.e.Total_Amount__c;
                    }
                    if(schema.SobjectType.Invoice_Line_Item__c.Fields.Invoice__c.isCreateable()){ 
                        stRole.Invoice__c=Invoiceid;
                    }
                    lst.add(stRole);
                }
                if(Schema.sObjectType.Invoice_Line_Item__c.isCreateable()){
                    insert lst;
                }
                
            }
            // After creating Invoice Line Items navigate to Invoice Detail Page
            PageReference p =  new Pagereference('/apex/InvoiceDetailPage?id='+Invoiceid);
            p.setRedirect(true);
            return p;
        }
        catch(DMLException e)
        {
            return null;
        }
    }
  // End Save Method
  
      // Start of back method
      public pagereference Back()
      {
          PageReference p =  new Pagereference('/apex/InvoiceDetailPage?id='+Invoiceid);
          p.setRedirect(true);
          return p;
      }
     // End of Back
     
     // Test Coverage 
     static testMethod void Test_AddPurchaseOrderExtension()
      {
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 345');
           try
            {
                insert testMedia;
            }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             }
           
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 345',Media_Types__c=testMedia.Id);
               insert testST;
       
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 345');
               insert testSpec;
        
           Job__c testJob1=new Job__c(Job_Auto_Number__c='2012 - 1',Name='Test Job 345',Flag__c=True,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
           try
            {
                insert testJob1;
            }
            catch(System.DMLException e)
            {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
            } 
           System.assertEquals('Test Job 345',testJob1.Name);
                    
           Vendor__c testVendor=new Vendor__c(Name='Test Vendor 345');
               insert testVendor;
         
           Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,Name='041');
               insert testPO;
         
           Invoice__c testI=new Invoice__c(Job__c=testjob1.Id,Date_Received__c=System.Today(),Vendor__c=testVendor.Id);
               insert testI;
          
           Purchase_Order__c PO=[Select Id,Name,Total_Amount__c,Vendor__c,Job__c From Purchase_Order__c where Vendor__c =: testI.Vendor__c and Job__c =: testI.Job__c and Status__c = 'Sent' limit 1];
       
           ApexPages.currentPage().getParameters().put('Id',testI.Id);
 
           // Create the instance of class          
           AddPurchaseOrderExtension ext=new AddPurchaseOrderExtension();
           
           // Invoke the method of class using instance of class
           ApexPages.Pagereference result1=ext.Save();
          
           ext.roleWraps[0].Checked=true;
           result1=ext.Save();
           ApexPages.Pagereference result2=ext.Back();

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

          // Delete Quotes
          List<Quote__c> lstQ=[select id from Quote__c where Job__c=:testJob1.Id];
          delete lstQ;
         
            // Delete Invoices
           List<Invoice__c> lstInv=[Select id from Invoice__c where Job__c=:testJob1.id];
           delete lstInv;          
        
           Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Test Job 345'];
           obj1.Status__c='Cancelled';
           update obj1;

           Job__c obj2=[Select id from Job__c where Name=: 'Test Job 345'];
           delete obj2;
           result1=ext.save();
      }*/
    // End of Test Coverage
}// End of Class