@isTest
public class Test_editPurchaseorderExtension{
   /* static testMethod void Test_editPurchaseorderExtension()
    {
    Media_Type__c testMedia=new Media_Type__c(Name='Test Media 347');
             
                insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 347',Media_Types__c=testMedia.Id);
             
                 insert testST;
  
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 347');
                insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 347',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
               // Insert Staff Record
               
               Staff__c staff=new Staff__c(First_Name__c='Test',Last_Name__c='Staff 987',Name='Test Staff 987',UserName__c='test@test.com',Email__c ='Test@test.com');
               insert staff;
               System.assertEquals('Test Job 347',testJob1.Name);
        
        
               Vendor__c testVendor=new Vendor__c(Name='TestV9919',Email__c='abcd@gmail.com',Zip__c='12345');
             try
              {
                  insert testVendor;
              }
              catch(System.DMLException e)
              {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
        
                 Vendor_Contact__c testVC=new Vendor_Contact__c(Vendor__c=testVendor.Id,First_Name__c='Tom',Last_Name__c='Cruise',Email__c='abcde9@gmail.com');  
               try
                  {
                      insert testVC;
                  }
                  catch(System.DMLException e)
                  {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                  }
        
   
               Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Vendor__c=testVendor.id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Approved_By_Staff__c=staff.id);
                    insert testPO;
             
                 // Instantiate the standard controller with the Purchase Order
               ApexPages.StandardController con=new ApexPages.StandardController(testPO);
               ApexPages.currentPage().getParameters().put('Id',testPO.Id);
              
                 // Instantiate the extention instance with the standard controller
               editPurchaseorderExtension ext=new editPurchaseorderExtension(con);
        
                // Invoke the saveme method on the extension 
           
               ApexPages.PageReference result1=ext.saveme();
            
               // Invoke the cancelme method on the extension 
               ApexPages.PageReference result2=ext.cancelme();
            
               result1=ext.saveme();
               ext.getStaffs();
               ext.getVendorContact();
      
              // Test for Staff equals NULL
            
               Purchase_Order__c testPO2=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No');
                    insert testPO2;
             
               // Instantiate the standard controller with the Purchase Order
                con=new ApexPages.StandardController(testPO2);
                ApexPages.currentPage().getParameters().put('Id',testPO2.Id);
              
                  // Instantiate the extention instance with the standard controller
               ext=new editPurchaseorderExtension(con);
        
                // Invoke the saveme method on the extension 
           
               result1=ext.saveme();
    
    
    }*/
}