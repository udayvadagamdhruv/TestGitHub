//@istest
Public class TestEditBillboardInvoiceLIextensions{

/*static testMethod void TestEditBillboardInvoiceLIextensions()
      {
           Client__c testClient=new Client__c(Name='Test client');
           insert testClient; 
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
   
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
          System.assertEquals('test 123',testI.Name);
          
          Billboard_Invoice__c bbi=new Billboard_Invoice__c(Billboard__c=testI.id);
          insert bbi;
          Billboard_Invoice_Line_Item__c bbili=new Billboard_Invoice_Line_Item__c(Billboard_Invoice__c=bbi.id);
          insert bbili;
          
          
         Billboard_Invoice_Line_Item__c  testBBili = [Select id,name,GL_Department__c,GL_Code__c from Billboard_Invoice_Line_Item__c   where id =:bbili.Id];
         
          // Instantiate the standard controller with the Client
          ApexPages.StandardController con = new ApexPages.StandardController(testBBili);
          EditBillboardInvoiceLIextensions ext = new EditBillboardInvoiceLIextensions(con);
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