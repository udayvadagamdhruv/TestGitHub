//@isTest
Public Class TestDisplayProductionEstimateJobTab{

 // Test Coverage Code
    /* static testMethod void TestDisplayProductionEstimateJobTab()
      {
      
          DisplayProductionEstimateJobTab ext=new DisplayProductionEstimateJobTab();
           
          Job_Number_Setting__c customSetting621 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting621;
             
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 621');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 621',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 621');
                insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 621',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
           
            System.assertEquals('Test Job 621',testJob1.Name);
           
            GL_Department__c testGLD1 = new GL_Department__c(Name='GLD3');
            try
            {
                insert testGLD1;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            } 
            
           Material_Item__c  testI=new Material_Item__c (name='test 123',Calc_Unit__c ='Size',Qty_On_Hand__c=10,Width_inches__c=100,length_inches__c=1800,Machine_OH_Linear_Foot_Cost__c=90, Price_Each__c=10000,Labor_Linear_Foot_Cost__c=1000);
            insert testI;
                  
           Production_Estimate__c testELINew=new Production_Estimate__c(Name='Est3612',Quantity__c =10,Length_in_Inches__c =70,Width_in_Inches__c =60,Job__c=testjob1.Id,GL_Department__c=testGLD1.id,Material_Item__c=testI.id,Calc_Unit__c='Size');
              
                   insert testELINew;
               
           
            
            Material_Usage_line_item__c  Tmuli= new Material_Usage_line_item__c (Material_Item__c=testI.id,Qty_On_Hand__c=100,Production_Estimate__c=testELINew.id);
            insert Tmuli;
                   
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
            // Instantiate the extention instance with the controller
           DisplayProductionEstimateJobTab  ext1=new DisplayProductionEstimateJobTab ();
          
           ApexPages.PageReference result1=ext1.createPELI();
          
           result1=ext1.save();
           result1=ext1.cancelme();
           result1=ext1.createPO();
           
         DisplayProductionEstimateJobTab   ext4=new DisplayProductionEstimateJobTab  ();
         Double result=ext4.getSumCash();
        
         ApexPages.currentPage().getParameters().put('Id',testELINew.Id);
        
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD994');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GL Code 9984',GL_ID__c='TestGL9984',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
            Production_Estimate__c  testELI=new Production_Estimate__c (Name='Quote 8901',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
                insert testELI;
            
            Production_Estimate__c testELI1=new Production_Estimate__c (Name='Quote 601',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Amount__c=123456);
                insert testELI1;
          
            Production_Estimate_Template__c PETemp=new Production_Estimate_Template__c(name='Production Estimate');
            insert PETemp;
            Production_Estimate_Temp_Line_Items__c PETLineItem=new Production_Estimate_Temp_Line_Items__c(name='Ptmpline Item',Production_Estimate_Template__c=PETemp.id,Calc_Unit__c='Each',Quantity__c=2,Sort_Order__c=1,Material_Item__c=testI.id);
            insert PETLineItem;
            
            ext1.theID=testJob1.Id;
            result1=ext1.save();
             ext1.ViewAllPE();
             ext1.ShowLessPE();
              ext1.Approve();
             ext1.UnApprove();
             result1=ext1.Del();
            
            ext1.importSpecs();
            ext1.PETempName=PETemp.Name;
            
             ext1.importSpecs();
            
            ext.strPEID = testELI1.id;
           ext1.duplicatePE();
            ext1.getPETemplate();
            ext1.strPEstID = '';
            ext1.strPEstID1 = '';
          ext1.str = '';
    }  
    
 // End of test Method       

// Test Coverage Code
     static testMethod void TestDisplayProductionEstimateJobTab1()
      {
      
          DisplayProductionEstimateJobTab ext=new DisplayProductionEstimateJobTab();
           
          Job_Number_Setting__c customSetting621 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting621;
             
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 621');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 621',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 621');
                insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 621',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
           
            System.assertEquals('Test Job 621',testJob1.Name);
           
            GL_Department__c testGLD1 = new GL_Department__c(Name='GLD3');
            try
            {
                insert testGLD1;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            } 
            
           Material_Item__c  testI=new Material_Item__c (name='test 123',Calc_Unit__c ='Each',Qty_On_Hand__c=10,Width_inches__c=100,length_inches__c=1800,Machine_OH_Linear_Foot_Cost__c=90, Price_Each__c=10000,Labor_Linear_Foot_Cost__c=1000);
            insert testI;
                  
           Production_Estimate__c testELINew=new Production_Estimate__c(Name='Est3612',Quantity__c =10,Length_in_Inches__c =70,Width_in_Inches__c =60,Job__c=testjob1.Id,GL_Department__c=testGLD1.id,Material_Item__c=testI.id,Calc_Unit__c='Each');
              
                   insert testELINew;
               
           
            
            Material_Usage_line_item__c  Tmuli= new Material_Usage_line_item__c (Material_Item__c=testI.id,Qty_On_Hand__c=100,Production_Estimate__c=testELINew.id);
            insert Tmuli;
                   
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
            // Instantiate the extention instance with the controller
           DisplayProductionEstimateJobTab  ext1=new DisplayProductionEstimateJobTab ();
          
           ApexPages.PageReference result1=ext1.createPELI();
          
           result1=ext1.save();
           result1=ext1.cancelme();
           result1=ext1.createPO();
           
         DisplayProductionEstimateJobTab   ext4=new DisplayProductionEstimateJobTab  ();
         Double result=ext4.getSumCash();
        
         ApexPages.currentPage().getParameters().put('Id',testELINew.Id);
        
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD994');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GL Code 9984',GL_ID__c='TestGL9984',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
            Production_Estimate__c  testELI=new Production_Estimate__c (Name='Quote 8901',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
                insert testELI;
            
            Production_Estimate__c testELI1=new Production_Estimate__c (Name='Quote 601',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Amount__c=123456);
                insert testELI1;
            
            ext1.theID=testJob1.Id;
            ext1.save();
             ext1.importSpecs();
            ext1.duplicatePE();
            ext1.getPETemplate();
    }  
    
 // End of test Method 

*/



}