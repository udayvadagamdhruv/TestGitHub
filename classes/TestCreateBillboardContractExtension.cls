//@isTest
Public class TestCreateBillboardContractExtension{
/*static testMethod void TestCreateBillboardContractExtension(){

  Job_Number_Setting__c customSetting994 = new  Job_Number_Setting__c(Name= 'yy');
           insert customSetting994;
          Client__c testClient=new Client__c(Name='Client 623');
           insert testClient; 
          Vendor__c testvendor=new Vendor__c (Name='Vendor 623',Vendor_Type__c ='Outdoor');
           insert testvendor; 
   
          Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
            insert testI;
           
          Billboard_Contract__c testbbc=new Billboard_Contract__c(Billboard__c=testI.id,BB_Vendor_Name__c=testvendor.id);
            
              
            
           ApexPages.currentPage().getParameters().put('bbid',testI.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testbbc);
     
           // Instantiate the extention instance with the standard controller
           CreateBillboardContractExtension ext =new CreateBillboardContractExtension(con);
        
           // Invoke the primary method on the extension 
           ApexPages.PageReference result1=ext.saveme();
           ApexPages.PageReference result2=ext.cancelme();
           List<SelectOption> vendors=ext.getVendors();
           string result4=ext.getVendorName();
           ext.SetVendorName('vendor'); 
         

}*/



}