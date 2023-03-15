//@isTest
Public class TestDisplayProdEstimateSpecWhenApproved{
// Test Method       
    /*  static testMethod void TestDisplayProdEstimateSpecWhenApproved()
      {
          
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
             
           Production_Estimate_Spec_Item__c testPESpecItem1=new Production_Estimate_Spec_Item__c(name='test Production Estimate Spec Item',Description__c='Test Discription 1', Production_Estimate__c=testELINew.id);
          insert testPESpecItem1;
          
          Production_Estimate_Spec_Item__c testPESpecItem2=new Production_Estimate_Spec_Item__c(name='test Production Estimate Spec Item',Description__c='Test Discription 2', Production_Estimate__c=testELINew.id);
          insert testPESpecItem2;
           
           ApexPages.currentPage().getParameters().put('Id',testELINew.Id);
           
           Production_Estimate_Spec_Item__c ESI = new Production_Estimate_Spec_Item__c();
           
      
          // Instantiate the standard controller with the Estimate Spec Item
           ApexPages.StandardController con=new ApexPages.StandardController(ESI);
           
           // Instantiate the extention instance with the standardcontroller
           DisplayProdEstimateSpecWhenApproved ext=new DisplayProdEstimateSpecWhenApproved(con);
           //System.assertEquals(ESI.id,ext.theID); 
              ext.shownewFileds();
              ext.newsavejobspecs();
             ext.pespecid=testPESpecItem1.id;
              ext.showEditFields();
             ext.savejobspec();
             ext.canceljobspec();
             ext.deljobspec();
          
    } */
 // End of test Method


}