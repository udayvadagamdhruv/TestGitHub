//@isTest
public class TestEditVendorExtension {
	 // Test Coverage
/*
     static testMethod void CreateNewVendorPositiveTest()
         {
         
              Vendor__c testVendor=new Vendor__c(Name='Test Vendor9900',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendor;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
               Vendor__c testVendor1=new Vendor__c(Name='Test Vendor9900',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendor1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
             Vendor__c objV = [select Id,Name,Email__c,Zip__c from Vendor__c where Id =: testVendor.Id];
             objV.Name='Test Vendor 100';   
             
             ApexPages.StandardController con=new ApexPages.StandardController(objV);
             ApexPages.currentPage().getParameters().put('Id',objV.Id);
          
            // Instantiate the extention instance with the standard controller
            
            EditVendorExtension   ext=new EditVendorExtension(con);
        
            // Invoke the primary method on the extension 
           
            ApexPages.PageReference result1=ext.saveme();
            ApexPages.PageReference result2=ext.Cancelme(); 
            
            delete objV;
            result1=ext.saveme();
         }
    // End of Test Coverage

    static testMethod Void VendorTest()
    {
               Vendor__c testVendor1=new Vendor__c(Name='Test Vendor 100',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendor1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
               Vendor__c testVendor2=new Vendor__c(Name='Test Vendor 200',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendor2;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
               Vendor__c TV = [select Id,Name,Email__c,Zip__c from Vendor__c where Id =: testVendor2.Id];
               TV.Name='Test Vendor 100';    
               try
               {
                   update TV;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }

              Vendor__c objV = [select Id,Name,Email__c,Zip__c from Vendor__c where Id =: testVendor1.Id Limit 1];
              objV.Name='Test Vendor 100'; 
              objV.Email__c='sdf@gmail.com';
              objV.Zip__c='54321';  
             
             // Instantiate the standard controller with the  Vendor
             ApexPages.StandardController con=new ApexPages.StandardController(objV);
             
             ApexPages.currentPage().getParameters().put('Id',objV.Id);
          
            // Instantiate the extention instance with the standard controller 
            
            EditVendorExtension   ext=new EditVendorExtension(con);
        
            // Invoke the primary method on the extension 
           
            ApexPages.PageReference result1=ext.saveme();
            ApexPages.PageReference result2=ext.Cancelme();
            
            Vendor__c testVendor6=new Vendor__c(Name='Test Vendor 32',Email__c='abc@gmail.com',Zip__c='$#^^');
               try
               {
                   insert testVendor6;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               } 
    }// End of Test Coverage*/
}