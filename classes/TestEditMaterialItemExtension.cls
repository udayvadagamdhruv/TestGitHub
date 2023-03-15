//@isTest
Public class TestEditMaterialItemExtension{

/*static testMethod void TestEditMaterialItemExtension (){
			test.startTest();
           Recordtype rt=[SELECT ID, name FROM RecordType WHERE Name ='Each'];
   
           Material_Item__c  testI=new Material_Item__c (name='test 123',Recordtypeid=rt.Id);
           insert testI;
           Material_Item__c  testMI = [Select id,name  from Material_Item__c  where id =:testI.Id];

           
           ApexPages.StandardController con=new ApexPages.StandardController(testMI);
     
           ApexPages.CurrentPage().getParameters().put('id',testMI.id);
            // Instantiate the extention instance with the standardcontroller
          
          EditMaterialItemExtension ext = new EditMaterialItemExtension(con);
        
           // Invoke the primary method on the extension 
           ApexPages.PageReference result1=ext.saveme();
           ApexPages.PageReference result2=ext.cancelme();
           List<SelectOption> Departments=ext.getGLDepartments();
           List<SelectOption> Codes=ext.getGLCodes() ;
           string result4=ext.getGLDName();
           string result5=ext.getGLCName();
           
           ext.setGLCName ('Test GLC');
           ext.setGLDName('Test GLD');
            ext.getCBTempName();
           ext.getPETempName();
       		ext.getCBTemp();
    		ext.getPETemp();
    		ext.setCBTemp('test');
    ext.setPETemp('test');
    test.stopTest();

}*/


}