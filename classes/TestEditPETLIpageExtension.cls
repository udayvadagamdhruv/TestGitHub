@istest
Public class TestEditPETLIpageExtension{

	  static testMethod void TestEditPETLIpageExtension()
      {
       	/*
          Material_Item__c MI=new Material_Item__c(name='Test');
          insert MI;
          
          Production_Estimate_Template__c TestIAT=new Production_Estimate_Template__c(Name='Test IAT');
            Insert TestIAT;
          
          Production_Estimate_Temp_Line_Items__c  testIATLI =new  Production_Estimate_Temp_Line_Items__c  (Production_Estimate_Template__c=TestIAT.id,Material_Item__c=MI.id);
          insert testIATLI;
          
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
        
          
         Production_Estimate_Temp_Line_Items__c   TestIALI1= [Select id,name,Material_Item__c,Production_Estimate_Template__c from Production_Estimate_Temp_Line_Items__c where id =:testIATLI.Id];
         
          // Instantiate the standard controller with the Client
          
          ApexPages.StandardController con = new ApexPages.StandardController(testIATLI);
          ApexPages.currentpage().getParameters().put('id',testIATLI.id);
          EditPETLIpageExtension ext = new EditPETLIpageExtension(con);
          //EditPETLIpageExtension e = new EditPETLIpageExtension();
          ext.qid = testIATLI.id;
          ApexPages.PageReference result1=ext.saveme();
          ext.getGLDepartments();
          ext.getGLCodes();
          ext.getVendors();
          ext.cancelme();
          ext.setGLDName('test');
          ext.getGLCName();
          ext.setGLCName('test');
          ext.setVName('test');
          ext.getMIName();
          ext.setMIName('test');
          ext.getGLDName();
          ext.getVName();*/
     }// End of Test Coverage


}