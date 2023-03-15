@isTest

Public class TestSpecItemExtension{

/* static testMethod void TestSpecItemExtension()
    {
         Specification_Template__c testST1=new Specification_Template__c(Name='Testing Specification Template');
         try
         {
            insert testST1;
            System.debug('Specification Template record inserted successfully@@@ '+testST1);
         }
         catch(System.DMLException e)
         {
            System.assert(e.getMessage().contains('Spec Item with same name Exists'));
         }
         
         Spec_Item__c testSPI1=new Spec_Item__c(Name='Test Spec Item 1',Specification_Template__c=testST1.Id);
        
         
         // Instantiate the standard controller with the Spec Item 
        ApexPages.StandardController con=new ApexPages.StandardController(testSPI1);
        
        ApexPages.CurrentPage().getParameters().put('Parentid',testST1.id);
        
        // Instantiate the extention instance with the standardcontroller 
        SpecItemExtension ext=new SpecItemExtension(con);
        
        // Invoke the primary method on the extension 
        ApexPages.PageReference result=ext.saveme();
        
        delete testSPI1;
        result=ext.saveme();
        ApexPages.PageReference result1=ext.cancelme();
     }
    // End Test Coverage 



*/


}