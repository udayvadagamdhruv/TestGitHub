//@isTest
public class TestMIAttachmentExtensions {
	/* static testMethod void TestMIAttachmentExtensions()
        {
             
          Material_Item__c  testI=new Material_Item__c (name='test 123',Calc_Unit__c ='Size');
  		  insert testI;
               
               ApexPages.StandardController con=new ApexPages.StandardController(testI);
                   
               ApexPages.currentPage().getParameters().put('Id', testI.Id);
               
               // Instantiate the extention instance with the standard controller 
               MIAttachmentExtensions ext= new MIAttachmentExtensions(con);
               
               test.startTest();
               
               ext.getmyfile();
               
               // Invoke the primary method on the extension   
               Pagereference pg=ext.SaveDoc();
               
               Pagereference pg1=ext.cancelme();
               
               Material_Item__c obj1=[Select id,name from Material_Item__c where Name=: 'test 123'];
               obj1.name='Test 234';
               update obj1;
         
               Material_Item__c obj2=[Select id from Material_Item__c where Name=: 'Test 234'];
               delete obj2;
               pg=ext.SaveDoc();
               
               test.stopTest();
        }*/
    /* End of Test Coverage*/
}