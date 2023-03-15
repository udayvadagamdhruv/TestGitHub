@isTest
public class Test_POReportWithESIs{
    private static testMethod void Test_POReportWithESIsExtension()
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
        
      Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='ELI0 361',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c = testGL.id,Vendor__c = testVendor.id,Amount__c=100,Quantity__c=10);
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
        
        
        Purchase_Order__c PO=new Purchase_Order__c(GL_Code__c=testGL.id,Job__c=testJob1.id,Vendor__c=testVendor.id);    
        try
        {
            insert PO;
        }
         catch(DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        } 
        
        
        PO_Line_Item__c POLI=new PO_Line_Item__c(Purchase_Order__c=PO.id,Estimate_Line_Item__c=testELI.id,GL_Code__c=testGL.id,Amount__c=100);    
        try
        {
            insert POLI;
        }
         catch(DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        } 
        
      ApexPages.CurrentPage().getParameters().put('id',PO.id);
      ApexPages.StandardController con=new ApexPages.StandardController(POLI);
      POReportWithESIs.wrapper wr1 = new POReportWithESIs.wrapper();
      POReportWithESIs.wrapper2 wr2 = new POReportWithESIs.wrapper2();    
      POReportWithESIs ext=new POReportWithESIs(con); 
      ext.setupGrouping();
       
    }  
}