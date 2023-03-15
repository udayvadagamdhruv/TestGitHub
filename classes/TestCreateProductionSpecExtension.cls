@isTest
public class TestCreateProductionSpecExtension {
	/*static testMethod void TestCreateProductionSpecExtension()
    {
         Production_Spec_Template__c testPST1=new Production_Spec_Template__c(Name='PST0003');
         try
         {
            insert testPST1;
         }
         catch(System.DMLException e)
         {
            System.assert(e.getMessage().contains('Error'));
         }
         system.assertEquals('PST0003',testPST1.Name);
         
         Production_Spec_Item__c testPSI=new Production_Spec_Item__c(Name='TestPSI0001',Production_Spec_Template__c=testPST1.Id);
                 
        // Instantiate the standard controller with the Production Spec Item 
        ApexPages.StandardController con=new ApexPages.StandardController(testPSI);
        
        // Instantiate the extention instance with the standardcontroller 
        CreateProductionSpecItemExtension ext=new CreateProductionSpecItemExtension(con);
        ext.pstemplateid='test';
        ext.prospeTempcname='test';
        // Invoke the primary method on the extension 
        ApexPages.PageReference result=ext.saveme();
        
        delete testPSI;
        result=ext.saveme();
         result=ext.cancel();
     }*/
    // End Test Coverage
}