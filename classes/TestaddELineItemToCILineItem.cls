//@isTest
Public class TestaddELineItemToCILineItem{
/*  Public static testMethod void TestaddELineItemToCILineItem()
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
         Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='ELI0 361',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c = testGL.id,Vendor__c = testVendor.id,Amount__c=100,Quantity__c=10,Approved__c = true );
       try
        {
            insert testELI;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
               
       Estimate_Spec_Item__c testESI = new Estimate_Spec_Item__c(Name='Spec Item 361',Estimates__c=testELI.Id);
        try
         {
            insert testESI;
         }
        catch(System.DMLException e)
         {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }       
         
         Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
   
         Client_Invoice__c  testclientinvoice=new Client_Invoice__c(Job__c=testjob1.Id,Client_Name__c=testClient.Id);
         insert testclientinvoice;
         
         ApexPages.currentPage().getParameters().put('id',testclientinvoice.Id);
         
       
          addELineItemToCILineItem ext =new addELineItemToCILineItem();
          ApexPages.PageReference result=ext.Save(); 
           ext.roleWraps[0].checked=True;
           result=ext.save();   
           ApexPages.PageReference result1=ext.Back();   



}*/

}