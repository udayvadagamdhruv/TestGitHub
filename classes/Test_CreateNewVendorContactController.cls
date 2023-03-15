@isTest
public class Test_CreateNewVendorContactController {
    /*static testMethod void Test_CreateNewVendorContactController()
    {
        Profile p = [select id from profile where name='System Administrator' limit 1];
        User uId= [Select Id from User where ProfileId =: p.Id and IsActive =: True LIMIT 1];
        System.RunAs(uId)
        {
            UserRole ur=new UserRole(Name='Test UserRole');
            insert ur;
     
            Vendor__c testVendor=new Vendor__c(Name='Test Vendor9901',Email__c='abc@gmail.com',Zip__c='12345');
            try
            {
                insert testVendor;
            }
            catch(System.DMLException e)
            {
                System.assert(e.getMessage().contains('Vendor with same name Exists'));
            }
               
            Vendor__c testVendorerror=new Vendor__c(Name='Test Vendor9901',Email__c='abc@gmail.com',Zip__c='12345');
            try
            {
                insert testVendorerror;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
               
            Vendor_Contact__c testVC=new Vendor_Contact__c(Vendor__c=testVendor.Id,First_Name__c='Tom',Last_Name__c='Cruise',Email__c='abcde9@gmail.com');
           
            ApexPages.StandardController con=new ApexPages.StandardController(testVC);
            ApexPages.currentPage().getParameters().put('Id',testVC.Id);
          
        
            CreateNewVendorContactController   ext=new CreateNewVendorContactController(con);
        
            ApexPages.PageReference result1=ext.saveme();
            ext.RoleId=ur.id;
            String role=ext.getRoleId();
            ext.setRoleId(role);
            List<SelectOption> optionsRole=ext.getRole();
            result1=ext.saveme();

            Vendor_Contact__c testVendor1=new Vendor_Contact__c();
            try
            {
                ApexPages.StandardController con1=new ApexPages.StandardController(testVendor1);
                CreateNewVendorContactController   ext1=new CreateNewVendorContactController(con1);
                ApexPages.PageReference result2=ext1.saveme();
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
            
            //Test coverage for editClientContact class.
            ApexPages.StandardController con1=new ApexPages.StandardController(testVC);
            ApexPages.currentPage().getParameters().put('Id',testVC.Id);
            EditVendorContactExtension ext1 = new EditVendorContactExtension(con1);
            
            ext1.saveme();
            ext1.RoleId=ur.id;
            String role1=ext1.getRoleId();
            ext1.setRoleId(role1);
            List<SelectOption> optionsRole1=ext1.getRole();
            ext1.saveme();
        }
    }    
    /* End of Positive Test Case*/    
}