//@isTest
Public class TestEditBillboardInvoiceExtension{
/*static testMethod void TestEditBillboardInvoiceExtension(){

  Job_Number_Setting__c customSetting994 = new  Job_Number_Setting__c(Name= 'yy');
           insert customSetting994;
          Client__c testClient=new Client__c(Name='Client 623');
           insert testClient; 
          Vendor__c testvendor=new Vendor__c (Name='Vendor 623',Vendor_Type__c ='Outdoor');
           insert testvendor; 
   
          Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
            insert testI;
           
          Billboard_Invoice__c  testbbi=new Billboard_Invoice__c (Billboard__c=testI.id);
            Insert testbbi;
            
         Billboard_Invoice__c  BBI = [Select id,name from Billboard_Invoice__c  where id =:testbbi.Id];
         
         // Instantiate the standard controller with the Client
          ApexPages.StandardController con = new ApexPages.StandardController(BBI );
           ApexPages.CurrentPage().getParameters().put('id',BBI.id);
            // Instantiate the extention instance with the standardcontroller
          
          EditBillboardInvoiceExtension ext = new EditBillboardInvoiceExtension(con);
        
        // Invoke the primary method on the extension 
          ApexPages.PageReference result1=ext.saveme();
          ApexPages.PageReference result2=ext.cancelme();
          
          result1=ext.saveme();
          List<SelectOption> vendors=ext.getVendors();
          
          string result4=ext.getVendorName();
          
          ext.setVendorName('Test vendor');
          
          
          
    }*/
    
    }