//@isTest
public class TestBBViewNote {
 /*   static testMethod void TestBBViewNote()
    {
          Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
            
            Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
               
          System.assertEquals('test 123',testI.Name);  
          
          Note n=new Note(parentId=testI.Id,Title='Test Title 852',IsPrivate=True,Body='Test Note Body');
               insert n;
              
          ApexPages.StandardController con=new ApexPages.StandardController(testI);
                   
          ApexPages.currentPage().getParameters().put('Id', n.Id);
               
          BBViewNote ext= new BBViewNote(con);
          ApexPages.Pagereference result1=ext.Cancel();
          result1=ext.editNote();
          result1=ext.deleteNote();
     }*/
}