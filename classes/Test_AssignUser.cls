@isTest
public class Test_AssignUser{
  /*  static testMethod void AssignUserTest()
    {
        Job_Number_Setting__c customSetting323 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting323;
            
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 323');
      try
       {
       insert testMedia;
       }
      catch(System.DMLException e)
       {
       System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
       }
      
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 323',Media_Types__c=testMedia.Id);
      insert testST;
       
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 323');
      insert testSpec;
 
      Job__c testJob1=new Job__c(Name='Test Job 323',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
      try
       {
       insert testJob1;
       }
      Catch(System.DMLException e)
       {
       System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
       }
      System.assertEquals('Test Job 323',testJob1.Name);       
               
      Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 323',Job__c=testJob1.Id,Days__c=5,Start_Date__c=System.Today());
      try
       {
       insert testJT;
       }       
      catch(System.DMLException e)
       {
       System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
       }
       
      Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Name='Test First Name 1 Test Last Name 1',Role__c='Design Manager',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
      insert testStaff1;
      
      Client__c testClient = new Client__c(Name='Test Client 9897');
      insert testClient;
      System.assertEquals('Test Client 9897',testClient.Name);
        
      Client_Contact__c testCC = new Client_Contact__c(First_Name__c='Test Client', Last_Name__c='Contact' ,Name = 'Test Client Contact', Client__c=testClient.id,Email__c='testClientContact9897@SFDC.com',Client_Contact_Role__c='Design Manager');
      INSERT testCC;
      
      Vendor__c testVendor=new Vendor__c(Name='Test Vendor9901',Email__c='abc@gmail.com',Zip__c='12345');
      INSERT testVendor;
        
      Vendor_Contact__c testVC=new Vendor_Contact__c(Vendor__c=testVendor.Id,First_Name__c='Tom',Last_Name__c='Cruise',Email__c='abcde9@gmail.com',Role__c='Design Manager');
      INSERT testVC;
              
      Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Designer',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
      insert testStaff2;
      
      Job_Task__c testJT1=new Job_Task__c(Name='Test Job Task 423',Job__c=testJob1.Id,Days__c=5,Start_Date__c=System.Today(),Email__c='mani@gmail.com',Revised_Due_Date__c=System.Today()+1);
      insert testJT1;
                 
      Job_Task_Role__c testJTR=new Job_Task_Role__c(Name='Design Manager',Job_Task__c=testJT.Id,User__c='Test User 007',Email__c='mani@gmail.com');
      insert testJTR;
               
      Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Design Manager',Job_Task__c=testJT.Id,Email__c='mani@gmail.com');
      insert testJTR1;
               
      Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Art Director Manager',Job_Task__c=testJT1.Id,Email__c='mani@gmail.com');
      insert testJTR2;
               
     // Instantiate the standard controller with the Job Task Role Item 
     ApexPages.StandardController con = new ApexPages.StandardController(testJTR1);
     ApexPages.currentPage().getParameters().put('Id',testJTR1.Id);
           
     // Instantiate the extention instance with the standardcontroller
     AssignUser ext=new AssignUser(con);
     
     // Invoke the Save method on the extension 
     AssignUser.CCWrapper ccw = new AssignUser.CCWrapper();
     AssignUser.VenWrapper vcw = new AssignUser.VenWrapper();
     
     ApexPages.PageReference result1=ext.Save();
     
     ext.roleWraps[0].selected=True;
    
     // Invoke the Save method on the extension 
     result1=ext.Save();
     ext.CCntwraps[0].selected=true;
     ext.Save();          
     
     ext.VenWraps[0].selected = true;
     ext.Save();
     // Invoke the Cancel Method
      ApexPages.PageReference result2=ext.cancel();
   }*/
}