@isTest
public class Test_JobTeamAssignUser{
/*Private static testMethod void JobTaskRoleTest()
  {
   Profile p1=[Select Id, Name From Profile where Name=: 'System Administrator' LIMIT 1]; 
   
   //Set up user 
   User u2 = [Select id,IsActive from User where IsActive =: True and ProfileId =:p1.id Limit 1];
   System.RunAs(u2)
    {
      UserRole ur12 = new UserRole(Name = 'Design Manager');
      insert ur12;
      
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 326');
       try
        {
            insert testMedia;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
        }
           
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 326',Media_Types__c=testMedia.Id);
          insert testST;
       
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 326');
          insert testSpec;
     
      Job__c testJob1=new Job__c(Name='Test Job 326',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
        }
       System.assertEquals('Test Job 326',testJob1.Name);       
               
      Job_Team__c testJT=new Job_Team__c(Job__c=testJob1.Id,Role__c='Design Manager');
       try
        {
            insert testJT;
        }       
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
        }
              
      // Instantiate the standard controller with the Job Team 
      
        Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Design Manager',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com',IsDeleted__c = False);
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
             
        ApexPages.StandardController con = new ApexPages.StandardController(testJT);
        ApexPages.currentPage().getParameters().put('Id',testJT.Id);
    
        // Instantiate the extention instance with the standardcontroller 
        JobTeamAssignUser ext=new JobTeamAssignUser(con);
        
        JobTeamAssignUser.CCWrapper ccw = new JobTeamAssignUser.CCWrapper();
        
        JobTeamAssignUser.VenWrapper vcw = new JobTeamAssignUser.VenWrapper();
        // Invoke the Save method on the extension
        ApexPages.PageReference result=ext.Save();
        ext.roleWraps[0].selected=true;
        result=ext.Save();
        ApexPages.PageReference result1=ext.cancel();
        
        ext.CCntwraps[0].selected=true;
        ext.Save();
        
        ext.VenWraps[0].selected = true;
        ext.Save();
      }//End of RunAs
     
     }*/
}