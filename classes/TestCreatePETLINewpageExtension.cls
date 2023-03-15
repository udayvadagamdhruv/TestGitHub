@isTest
Public class TestCreatePETLINewpageExtension 
{
    static testMethod void TestCreatePETLINewpageExtension ()
    {
      /*Material_Item__c MI=new Material_Item__c(name='Test');
          insert MI;
        
          Production_Estimate_Template__c TestIAT=new Production_Estimate_Template__c(Name='Test IAT');
            Insert TestIAT;
        
          GL_Department__c testGLD = new GL_Department__c(Name='GLD016');
            try
            {
            insert testGLD;
            }
            catch(System.DMLException e)
            {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
            GL_Code__c testGL=new GL_Code__c(Name='GLC016',GL_ID__c='GLC016',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
             }
             catch(System.DMLException e)
             {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
           Vendor__c testVendor=new Vendor__c(Name='TV016',Email__c='abcd@gmail.com',Zip__c='12345');
             try
              {
                  insert testVendor;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }  
          
    
            Vendor_GL_Code__c vgc = new Vendor_GL_Code__c(GL_Code__c=testGL.id,Vendor__c=testVendor.id);
             try
              {
                  insert vgc;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }  
        
          
        
        
          
          Production_Estimate_Temp_Line_Items__c  testIATLI =new  Production_Estimate_Temp_Line_Items__c  (Production_Estimate_Template__c=TestIAT.id);
              
            
           ApexPages.currentPage().getParameters().put('Parentid',TestIAT.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testIATLI);
     
           // Instantiate the extention instance with the standard controller
           CreatePETLINewpageExtension ext =new CreatePETLINewpageExtension(con);
        
           // Invoke the primary method on the extension 
           ApexPages.PageReference result1=ext.saveme();
          
           
           ext.setGLDName(testGLD.id);
           ext.getGLDName();
        ApexPages.PageReference result111=ext.saveme();
           ext.setGLCName(testGL.id);
           ext.getGLCName();
        ApexPages.PageReference result222=ext.saveme();
           ext.setVName(testVendor.id);
           ext.getVName();
           ext.setMIName(MI.id);
           ext.getMIName();
           ext.getGLDepartments();
           ext.getMaterialItems();
           ext.getMaterialItems2();
           ext.getOptions2();
           ext.getVendors();
           ext.getGLCodes();
           ext.saveme();
          ext.cancelme();
          // ext.setMaterialItems('Test234'); 
           
         */

        }



}