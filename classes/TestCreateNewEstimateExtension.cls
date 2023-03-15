@isTest
public class TestCreateNewEstimateExtension {
	/* private static testMethod void Test_CreateNewEstimateExtension()
     {
     
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 321');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 321',Media_Types__c=testMedia.Id);
      insert testST;
                 
      Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 321',Media_Types__c=testMedia.Id);
       try
        {
            insert testST1;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
               
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 321');
      insert testSpec;
                
      Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 321');
       try
        {
            insert testSpec1;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
            
      Job__c testJob1=new Job__c(Name='Test Job 321',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Job with same name Exists'));
        }
       System.assertEquals('Test Job 321',testJob1.Name);    
            
      GL_Department__c testGLD = new GL_Department__c(Name='TestGLD7');
       try
        {
            insert testGLD;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
              
      GL_Code__c testGL=new GL_Code__c(Name='GL Code 9900',GL_ID__c='TestGL9900',GL_Department__c = testGLD.id);
       try
        {
            insert testGL;
            System.debug('GL Code inserted successfully@@@ '+testGL);
        }
       catch(System.DMLException e)
        {
            System.debug(e.getMessage());
        }
             
      Vendor__c testVendor=new Vendor__c(Name='TestV9900',Email__c='abcd@gmail.com',Zip__c='12345');
       try
        {
            insert testVendor;
        }
       catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Job with same name Exists'));
        }  
            
      Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateNewEstimateExtension   ext=new CreateNewEstimateExtension(con);  
      ext.getamount();
      ext.GLDName='Null';
      ext.GLDName = testGLD.id;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.id;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
      ext.selectedDepartment='dep';
      ext.UserSelectedControllingOption='Selectedcon';
      ext.UserSelectedDependentOption='seldep';
      ext.quoteid='id';
      ext.VName = testVendor.Id;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Estimate_Line_Items__c testELI3=new Estimate_Line_Items__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI3);
      CreateNewEstimateExtension   ext1=new CreateNewEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  */
}