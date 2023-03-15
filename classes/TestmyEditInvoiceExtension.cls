//@isTest
Public Class TestmyEditInvoiceExtension{
   /*static testMethod void TestmyEditInvoiceExtension()
     {
         string vgl;
            Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');
            insert customSetting1;
     
            Media_Type__c testMedia=new Media_Type__c(Name='TM02Mar');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='TST02Mar',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='TST02Mar');
               insert testSpec;
           
           Job__c testJob1=new Job__c(Name='TJ02Mar',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('TJ02Mar',testJob1.Name);  
     
           GL_Department__c GLD = new GL_Department__c(Name='test GL');
           insert GLD;
           
           GL_Code__c GLC = new GL_Code__c(Name = 'abc', GL_Department__c = GLD.id, GL_ID__c = 'abc123', Unit_Type__c = 'Days');
           insert GLC;
     
           Vendor__c ven = new Vendor__c(Name = 'ven1');
           insert ven;
           
           Vendor_GL_Code__c venGL = new Vendor_GL_Code__c(GL_Code__c = GLC.id, Vendor__c = ven.id);
           insert venGL;
           
           Invoice__c ESI = new Invoice__c(Name='INV01March',Job__c=testJob1.id, Vendor__c = ven.id);
           insert ESI;
           
           Invoice_Line_Item__c invli = new Invoice_Line_Item__c(Invoice__c = ESI.id,GL_Code__c = GLC.id);
           insert invli;
           
            ApexPages.currentPage().getParameters().put('id',invli.Id);

            ApexPages.StandardController con = new ApexPages.StandardController(invli);
            myEditInvoiceExtension ext = new myEditInvoiceExtension(con);
            
            ext.ILIid = invli.id;
            ext.vgl = venGL.id;
            ApexPages.PageReference result1=ext.cancl();
            result1 = ext.savbtn();
            list<selectOption> result2 = ext.getGLcode();

// Instantiate the extention instance with the Custom Controller
           myEditInvoiceExtension ext1=new myEditInvoiceExtension(con);
           
// Invoke the primary method on the extension
           //ApexPages.PageReference result1=ext1.cancl();
//  System.assertEquals(ESI.id,ext.theID);
           //result1 = ext1.savbtn();

      } */


}