//@isTest
Public class TestCreateProductionEstimateExtension{


// Positive Test Case
   /* Public static testMethod void TestCreateProductionEstimateExtension()
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
        
      Material_Item__c Mi= new Material_Item__c(Name='TestMItem');  
      insert Mi;
        
            
      Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Calc_Unit__c='Sheet' , Quantity__c=10,Qty_Up__c=2,Sided__c='Double');
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateProductionEstimateExtension ext=new CreateProductionEstimateExtension(con);  
      
      ext.GLDName = testGLD.id;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.id;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
          
      ext.VName = testVendor.Id;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
      
      ext.MIName= Mi.Id;
      String MIName= ext.getMIName();
      ext.setMIName(MIName);
      List<SelectOption> options3 = ext.getMaterialItems();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Production_Estimate__c  testELI4=new Production_Estimate__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI4);
      CreateProductionEstimateExtension ext1=new CreateProductionEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  
  // End of Test Coverage Code
  
  // Positive Test Case
    Public static testMethod void TestCreateProductionEstimateExtension1()
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
        
      Material_Item__c Mi= new Material_Item__c(Name='TestMItem');  
      insert Mi;
        
            
      Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Calc_Unit__c='Sheet' , Quantity__c=10,Qty_Up__c=2,Sided__c='Single');
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateProductionEstimateExtension ext=new CreateProductionEstimateExtension(con);  
      
      ext.GLDName = null;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = null;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
          
      ext.VName = null;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
      
      ext.MIName= Mi.Id;
      String MIName= ext.getMIName();
      ext.setMIName(MIName);
      List<SelectOption> options3 = ext.getMaterialItems();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Production_Estimate__c  testELI4=new Production_Estimate__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI4);
      CreateProductionEstimateExtension ext1=new CreateProductionEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  
  // End of Test Coverage Code
  
  Public static testMethod void TestCreateProductionEstimateExtension2()
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
        
      Material_Item__c Mi= new Material_Item__c(Name='TestMItem');  
      insert Mi;
        
            
      Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Calc_Unit__c='Sheet' , Quantity__c=10,Qty_Up__c=2,Sided__c='Single');
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateProductionEstimateExtension ext=new CreateProductionEstimateExtension(con);  
      
      ext.GLDName = testGLD.id;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = null;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
          
      ext.VName = null;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
      
      ext.MIName= Mi.Id;
      String MIName= ext.getMIName();
      ext.setMIName(MIName);
      List<SelectOption> options3 = ext.getMaterialItems();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Production_Estimate__c  testELI4=new Production_Estimate__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI4);
      CreateProductionEstimateExtension ext1=new CreateProductionEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  
  // End of Test Coverage Code
   Public static testMethod void TestCreateProductionEstimateExtension3()
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
        
      Material_Item__c Mi= new Material_Item__c(Name='TestMItem');  
      insert Mi;
        
            
      Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Calc_Unit__c='Each' , Quantity__c=10,Qty_Up__c=2,Sided__c='Single');
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateProductionEstimateExtension ext=new CreateProductionEstimateExtension(con);  
      
      ext.GLDName = testGLD.id;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.id;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
          
      ext.VName = null;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
      
      ext.MIName= Mi.Id;
      String MIName= ext.getMIName();
      ext.setMIName(MIName);
      List<SelectOption> options3 = ext.getMaterialItems();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Production_Estimate__c  testELI4=new Production_Estimate__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI4);
      CreateProductionEstimateExtension ext1=new CreateProductionEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  
  // End of Test Coverage Code
  
  // End of Test Coverage Code
   Public static testMethod void TestCreateProductionEstimateExtension4()
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
        
      Material_Item__c Mi= new Material_Item__c(Name='TestMItem');  
      insert Mi;
        
            
      Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Calc_Unit__c='Sheet' , Quantity__c=10,Qty_Up__c=2,Sided__c='Single');
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateProductionEstimateExtension ext=new CreateProductionEstimateExtension(con);  
      
      ext.GLDName = testGLD.id;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.id;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
          
      ext.VName = testVendor.Id;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
      
      ext.MIName= Mi.Id;
      String MIName= ext.getMIName();
      ext.setMIName(MIName);
      List<SelectOption> options3 = ext.getMaterialItems();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Production_Estimate__c  testELI4=new Production_Estimate__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI4);
      CreateProductionEstimateExtension ext1=new CreateProductionEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  
  // End of Test Coverage Code
  
  // End of Test Coverage Code
   Public static testMethod void TestCreateProductionEstimateExtension5()
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
        
      Material_Item__c Mi= new Material_Item__c(Name='TestMItem');  
      insert Mi;
        
            
      Production_Estimate__c testELI=new Production_Estimate__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Calc_Unit__c='Each' , Quantity__c=10,Qty_Up__c=2,Sided__c='Single');
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateProductionEstimateExtension ext=new CreateProductionEstimateExtension(con);  
      
      ext.GLDName = testGLD.id;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.id;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
          
      ext.VName = testVendor.Id;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
      
      ext.MIName= Mi.Id;
      String MIName= ext.getMIName();
      ext.setMIName(MIName);
      List<SelectOption> options3 = ext.getMaterialItems();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Production_Estimate__c  testELI4=new Production_Estimate__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI4);
      CreateProductionEstimateExtension ext1=new CreateProductionEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  */
  // End of Test Coverage Code
  
  
  }