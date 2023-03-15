//@isTest
Public class TestCreateBillboardInvoiceLIExtension{
/*static testMethod void TestCreateBillboardInvoiceLIExtension(){

  Job_Number_Setting__c customSetting994 = new  Job_Number_Setting__c(Name= 'yy');
           insert customSetting994;
          Client__c testClient=new Client__c(Name='Client 623');
           insert testClient; 
          Vendor__c testvendor=new Vendor__c (Name='Vendor 623',Vendor_Type__c ='Outdoor');
           insert testvendor; 
   
          Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
            insert testI;
           
          Billboard_Invoice__c  testbbi=new Billboard_Invoice__c (Billboard__c=testI.id);
            Insert testbbi;
          
          Billboard_Invoice_Line_Item__c  testbbili =new  Billboard_Invoice_Line_Item__c(Billboard_Invoice__c=testbbi.id);
              
            
           ApexPages.currentPage().getParameters().put('bbiid',testbbi.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testbbili);
     
           // Instantiate the extention instance with the standard controller
           CreateBillboardInvoiceLIExtension ext =new CreateBillboardInvoiceLIExtension(con);
        
           // Invoke the primary method on the extension 
           ApexPages.PageReference result1=ext.saveme();
           ApexPages.PageReference result2=ext.cancelme();
           List<SelectOption>  Departments=ext.getGLDepartments();
            List<SelectOption> Codes=ext.getGLCodes();
           string result4=ext.getGLDName();
           ext.SetGLDName('Test234'); 
           string result5=ext.getGLCName();
           ext.SetGLCName('test123');
         

}*/



}