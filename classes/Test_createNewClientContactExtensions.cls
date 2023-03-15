@isTest
public class Test_createNewClientContactExtensions{
   /* static testMethod void Test_createNewClientContactExtensions()
    {
        Profile p = [select id from profile where name='System Administrator' limit 1];
         
         User uId= [Select Id from User where ProfileId =: p.Id and IsActive =: True LIMIT 1];
          
          System.RunAs(uId)
          {
             UserRole ur=new UserRole(Name='Test UserRole');
                 insert ur;
          
        Client__c testClient = new Client__c(Name='Test Client 9897');
            insert testClient;
            
        System.assertEquals('Test Client 9897',testClient.Name);
        
        Client_Contact__c testCC = new Client_Contact__c(First_Name__c='Test Client', Last_Name__c='Contact' ,Name = 'Test Client Contact', Client__c=testClient.id,Email__c='testClientContact9897@SFDC.com');     
        insert testCC; 
        Client_Contact__c testCC1 = new Client_Contact__c(First_Name__c='Test Client', Last_Name__c='Contact' ,Name = 'Test Client Contact', Client__c=testClient.id,Email__c='testClientContact9897@SFDC.com');     
              
          // Instantiate the extention instance with the standard controller 
          
        ApexPages.StandardController con = new ApexPages.StandardController(testCC1); 
        
         // Create the instance of a class
        createNewClientContactExtensions ext = new createNewClientContactExtensions(con);

            // Invoke the primary methodson the extension 
        ApexPages.Pagereference result = ext.saveme();
        
        ext.RoleId=ur.id;
        String role=ext.getRoleId();
        ext.setRoleId(role);
        List<SelectOption> optionsRole=ext.getRole();
        ext.cancelme();
        
        // To cover catch block inside Saveme method
        //delete testCC;
        
        result = ext.saveme();
        
        //Test coverage for editClientContact class.
        ApexPages.StandardController con1 = new ApexPages.StandardController(testCC); 
        editClientContact ext1 = new editClientContact(con1);
        
        ext1.saveme();
        ext1.RoleId=ur.id;
        String role1=ext1.getRoleId();
        ext1.setRoleId(role1);
        List<SelectOption> optionsRole1=ext1.getRole();
        ext1.saveme();
        ext1.strEmail='mani@gmail.com';
         
        }
    }*/
}