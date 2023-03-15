@isTest
Public class TestShipmentPrintExtension{
private static testMethod void TestShipmentPrintExtension()
     {
      
      Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
      insert customSetting001; 
     
      Media_Type__c testMedia=new Media_Type__c(Name='TM32444');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='TST32444',Media_Types__c=testMedia.Id);
      insert testST;
               
      Specification_Template__c testSpec=new Specification_Template__c(Name='TSPT32444');
      insert testSpec;
            
      Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='Job32444',Name='TestJobByDeveloper32444',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
       
      System.assertEquals('TestJobByDeveloper32444',testJob1.Name);    
            
      GL_Department__c testGLD = new GL_Department__c(Name='TestGLD32444');
       try
        {
            insert testGLD;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
              
      GL_Code__c testGL=new GL_Code__c(Name='GLC32444',GL_ID__c='TestGL32444',GL_Department__c = testGLD.id,Unit_Type__c='Project');
       try
        {
            insert testGL;
        }
       catch(System.DMLException e)
        {
            System.debug(e.getMessage());
        }
             
      Vendor__c testVendor=new Vendor__c(Name='TestV32444',Email__c='abcd@gmail.com',Zip__c='12345');
       try
        {
            insert testVendor;
        }
       catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Vendor with same name Exists'));
        }
        
    
         Production_Estimate__c  testPELI=new Production_Estimate__c(Name='PELI0 361',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c = testGL.id,Amount__c=100,Quantity__c=10);
       try
        {
            insert testPELI;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
               
       Production_Estimate_Spec_Item__c testPESI = new Production_Estimate_Spec_Item__c(Name='Spec Item 361',Production_Estimate__c =testPELI.Id);
        try
         {
            insert testPESI;
         }
        catch(System.DMLException e)
         {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }
               
        
        Client__c testClient=new Client__c(Name='Test client');
         insert testClient; 
         
        
           
         Shipment__c   testI=new Shipment__c (Client__c=testClient.Id,Job__c=testJob1.Id);
         insert testI;
         Shipment_Line_Item__c sli=new Shipment_Line_Item__c(Shipment__c=testI.id,Production_Estimate__c=testPELI.id);
         insert sli;
        
      ApexPages.CurrentPage().getParameters().put('id',testI.id);
      ApexPages.StandardController con=new ApexPages.StandardController(sli);    
      ShipmentPrintExtension ext=new ShipmentPrintExtension(con); 
      ext.setupGrouping();
      
       
    }  
    
    



}