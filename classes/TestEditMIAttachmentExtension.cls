//@isTest
public class TestEditMIAttachmentExtension {
	// Start Test Coverage
   /*  static testMethod void TestEditMIAttachmentExtension()
    {
          Material_Item__c  testI=new Material_Item__c (name='test 123',Calc_Unit__c ='Size');
  		  insert testI;
               
          System.assertEquals('test 123',testI.Name); 
        
               Blob b = Blob.valueOf('Hello World');
               

               Attachment a=new Attachment(parentId=testI.Id,Name='Test File',Body=b);
               insert a;
               
               ApexPages.currentPage().getParameters().put('Id', a.Id);
            
               // Instantiate the standard controller with the Attachment 
               ApexPages.StandardController con=new ApexPages.StandardController(a);
        
               // Instantiate the extention instance with the standardcontroller 
               EditJobAttachmentExtension ext=new EditJobAttachmentExtension(con);
        
               // Invoke the primary method on the extension
               ApexPages.PageReference result=ext.SaveAttachment();
        
               ApexPages.currentPage().getParameters().put('Id', a.Id);
            
               // Instantiate the standard controller with the Job 
               ApexPages.StandardController con1=new ApexPages.StandardController(a);
        
              // Instantiate the extention instance with the standardcontroller 
              EditMIAttachmentExtension ext1=new EditMIAttachmentExtension(con1);
        
              // Invoke the primary method on the extension
                result=ext1.cancelme();
        
                delete a;
                result=ext1.SaveAttachment();
        
        	EditMaterialItemSwitchExt ext2=new EditMaterialItemSwitchExt(con1);
        
        
           }*/
    // End of Test Coverage
}