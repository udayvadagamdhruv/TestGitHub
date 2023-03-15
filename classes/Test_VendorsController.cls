@IsTest
public class Test_VendorsController {
    public static testMethod void Test_VendorsController(){  
       
        GL_Department__c testGLD = new GL_Department__c(Name='GLD015');
        try
        {
            insert testGLD;
        }
        catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        GL_Code__c testGL=new GL_Code__c(Name='GLC015',GL_ID__c='GLC015',GL_Department__c = testGLD.id);
        try
        {
            insert testGL;
        }
        catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        Vendor__c testVendor=new Vendor__c(Name='TV015',Email__c='abcd@gmail.com',Zip__c='12345');
        try
        {
            insert testVendor;
        }
        catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Vendor with same name Exists'));
        }  
        
        Vendor__c testVendor1=new Vendor__c(Name='Test Vendor9901',Email__c='abc@gmail.com',Zip__c='12345');
        insert testVendor1;
        
        Vendor_Contact__c testVC=new Vendor_Contact__c(Vendor__c=testVendor.Id,First_Name__c='Tom',Last_Name__c='Cruise',Email__c='abcde9@gmail.com');
        insert testVC;
        
        Vendor_GL_Code__c vgc = new Vendor_GL_Code__c(GL_Code__c=testGL.id,Vendor__c=testVendor.id);
        insert vgc;
        
        Test.startTest();
        
        VendorsController.getFieldsforObject('Vendor__c');
        VendorsController.geLabelforObject('Vendor__c');
        VendorsController.getRole();
        VendorsController.getGLCodes();
        
        VendorsController.DeleteVen(testVendor1.Id); 
        VendorsController.vendorContacts(testVendor1.Id);  
        VendorsController.DeleteVenCon(testVC.Id);
        VendorsController.vendorGlcode(testVendor1.Id);
        VendorsController.DeleteVenGlcode(vgc.Id);
        VendorsController.getvendorQuote(10,10,testVendor1.Id);
        VendorsController.getTotalVQRecords(testVendor1.Id);
        VendorsController.getvendorPO(10,10,testVendor1.Id);
        VendorsController.getTotalVPRecords(testVendor1.Id);
        VendorsController.getvendorInv(10,10,testVendor1.Id);
        VendorsController.getTotalVINVRecords(testVendor1.Id);
        VendorsController.getvendorBB(10,10,testVendor1.Id,'Active');
        VendorsController.getTotalVBBRecords(testVendor1.Id,'Active');
        VendorsController.fetchPicklistvalues();
        VendorsController.getvendorBBI(10,10,testVendor1.Id);
        VendorsController.getTotalVBBIRecords(testVendor1.Id);
        
        Test.stopTest();
    }
}