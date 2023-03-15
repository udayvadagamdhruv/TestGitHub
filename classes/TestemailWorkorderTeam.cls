//@isTest

Public class TestemailWorkorderTeam{
//test method 
  
   
  /*  static testMethod void TestemailWorkorderTeam()
    {
     try {
        job__c testjob = New job__c(Name='testJob');
        insert testjob;
       
        staff__c staff = new Staff__c(Name='teststaff',Email__c='test@gmail.com',Role__c = 'Test Role',UserName__c='test@test.com');
        insert staff;
        staff__c staff1 = new Staff__c(Name='teststaff1',Email__c='test1@gmail.com', Role__c = 'Test Role1',UserName__c='test@test1.com');
        insert staff1;
        
        Staff__c testStaff=new Staff__c(Name='teststaff1',First_Name__c='Test Staff',Last_Name__c='001',Email__c='TestStaff001@SFDC.com',Username__c='TestStaff001@SFDC.com',User_Type__c='Staff');
        insert testStaff;
            

        
        Job_Team__c team = new Job_Team__c(Staff__c='teststaff',Job__c =testjob.id,Role__c='Test Role');
        insert team;
        Job_Team__c team1 = new Job_Team__c(Staff__c='teststaff1',Job__c =testjob.id,Role__c='Test Role1');
        insert team1;
        
        System.assertEquals('Test Staff',testStaff.First_Name__c);
        
        
         PageReference pref = Page.emailworkorder;
        pref.getParameters().put('id',testjob.id);
        Test.setCurrentPage(pref);
        
              
        emailWorkorderTeam con = new emailWorkorderTeam();
       /* Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        con.b=bodyBlob; 
            
            
        //Test.startTest();
     
         System.assertEquals('testJob',testjob.Name);
     
        // populate the field with values
        ApexPages.currentPage().getParameters().put('id',testjob.id);
        con.addresses = 'test@noemail.com : test2@noemail.com';
        //con.st1 = 'test@noemail.com';
        //con.b = b1;
        // submit the record
        pref = con.send();
     
        //Test.stopTest(); 
     } 
    catch(DmlException e){}



}*/




}