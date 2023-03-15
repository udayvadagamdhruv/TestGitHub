//@isTest
public class TestEditTagTemplateExtension{
	/* static testMethod void Test_EditTagTemplateExtension()
     {        
        Tag_Template__c testTag=new Tag_Template__c(Name='TAG012');
           try
            {
                insert testTag;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
         
         Tag_Template__c testTagT=new Tag_Template__c(Name='TT012');
           try
            {
                insert testTagT;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }     
        
            // Instantiate the standard controller with the Media Type
         ApexPages.StandardController con=new ApexPages.StandardController(testTag);
         
             // Instantiate the extention instance with the standard controller
         
         EditTagTemplateExtension ext=new EditTagTemplateExtension(con);        
         
             // Invoke the primary method on the extension 
         ApexPages.PageReference result=ext.saveme();
    
         System.assertEquals('TAG012',testTag.Name);
         System.assertEquals('TT012',testTagT.Name);
            
         Delete testTag;
         
         result=ext.saveme(); 
         result=ext.cancelme();  
     }*/
}