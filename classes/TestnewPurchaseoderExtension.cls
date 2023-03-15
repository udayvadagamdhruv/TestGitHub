//@istest
public class TestnewPurchaseoderExtension {
       
     /*   static testMethod void TestnewPurchaseoderExtension2()
         {
             
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 616');
          insert testMedia;
          
          Job_Number_Setting__c customSetting1004 = new  Job_Number_Setting__c(Name= 'NO');

            insert customSetting1004;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 616',Media_Types__c=testMedia.Id);
          insert testST;
         
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 616');
          insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 616',Job_Auto_Number__c='J 616',Flag__c =True,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
          System.assertEquals('Test Job 616',testJob1.Name); 
              
          Staff__c st = new Staff__c(Name='Staff 001',UserName__c='test@test.com');
          insert st;
            
            
          GL_Department__c testGLD = new GL_Department__c(Name='GLD100');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
         //// Not increasing test Coverage
          GL_Code__c testGL=new GL_Code__c(Name='GC100',GL_ID__c='GC100',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
             }
             catch(System.DMLException e)
             {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
            
             Vendor__c testVendor=new Vendor__c(Name='TestV9919',Email__c='abcd@gmail.com',Zip__c='12345');
             try
              {
                  insert testVendor;
              }
              catch(System.DMLException e)
              {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }  
             
            Vendor_Contact__c testVC=new Vendor_Contact__c(Vendor__c=testVendor.Id,First_Name__c='Tom',Last_Name__c='Cruise',Email__c='abcde9@gmail.com');  
               try
                  {
                      insert testVC;
                  }
                  catch(System.DMLException e)
                  {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                  }
            
             Estimate_Line_Items__c testELI1 = new Estimate_Line_Items__c(Name='EST321',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id,Vendor__c=testVendor.id,Approved__c=true);
              try
              {
                  insert testELI1;
              }
              catch(System.DMLException e)
              {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }  
             //////
              
            Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Approved_By_Staff__c=st.id);
            
            ApexPages.currentPage().getParameters().put('v',testVendor.Id);
            ApexPages.currentPage().getParameters().put('vc',testVC.Id);
            ApexPages.StandardController con=new ApexPages.StandardController(testPO);
            
            // Instantiate the extention instance with the standard controller
            
            newPurchaseorderExtension   ext=new newPurchaseorderExtension(con);
            
             ext.StaffName = st.id;
             String StaffName = ext.getStaffName();
             ext.setStaffName(StaffName);
             ext.StaffName = testVendor.id;
             
             String vendorName= ext.getvendorName();
               ext.vendorName=testVendor.id;
             ext.setvendorName(vendorName);
             List<SelectOption> options = ext.getStaffs();
             List<SelectOption> options1 = ext.getVendor(); 
             List<SelectOption> options2=ext.getVendorContact(); 
             List<SelectOption> options3=ext.getJobs();
        
           //// Invoke the primary method on the extension ////
            ext.vendorName=testVendor.id;
             ApexPages.PageReference result1=ext.saveme();
             ApexPages.PageReference result2=ext.cancelme();
             
             // negative Test 
             
             Purchase_Order__c testPO1=new Purchase_Order__c();
            // ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
             ApexPages.currentPage().getParameters().put('v',testVendor.Id);
            ApexPages.currentPage().getParameters().put('vc',testVC.Id);
             ApexPages.StandardController con1=new ApexPages.StandardController(testPO1); 
             newPurchaseorderExtension   ext1=new newPurchaseorderExtension(con1);
              ext.vendorName=testVendor.id;
             ext.ShowProductionEstimate=false;
             ApexPages.PageReference result3=ext.saveme();
             ApexPages.PageReference result4=ext.cancelme();
                
             ext.ShowProductionEstimate=true;
             ApexPages.PageReference result8=ext.saveme();
             ApexPages.PageReference result9=ext.cancelme();
             
             
             
               // ext.AddLIitems();
        }    
        // End of Positive Test Case
*/
        
        
}