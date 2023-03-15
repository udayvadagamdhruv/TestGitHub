@isTest
public class Test_DisplayRole_User {
     // Start Test Coverage
    /*    static testMethod void Test_DisplayRole_User()
        {
            DisplayRole_User d=new DisplayRole_User();
            
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
             
                insert testMedia;
             
             Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 50',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 50');
                insert testSpec;
                
             Job__c testJob1=new Job__c(Name='Test Job 10',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                 insert testJob1;
                 
             System.assertEquals('Test Job 10',testJob1.Name);         
                 
             Job_Task__c testJobTask=new Job_Task__c(Name='Job Task 10',Job__c=testJob1.Id);
                insert testJobtask;
    
             // Instantiate the extention instance with the standardcontroller 
                DisplayRole_User d1=new DisplayRole_User();
      
       
                ApexPages.currentPage().getParameters().put('Id', testJobTask.Id);
                ApexPages.PageReference result1=d1.AddNewRole();
        
                DisplayRole_User d2=new DisplayRole_User();
        
                Job_Task_Role__c testJobTaskRole=new Job_Task_Role__c(Job_Task__c=testJobTask.Id,Name='Design Manager',User__c='');
                     insert testJobTaskRole;
         
        
                 DisplayRole_User ext=new DisplayRole_User();
                 ext.strJTRID = testJobTaskRole.Id;
                 ApexPages.PageReference result2=ext.AssignTheUser();
                 result2=ext.addNewStaff();
            
                Job_Task_Role__c testJobTaskRole1=new Job_Task_Role__c(Job_Task__c=testJobTask.Id,Name='Project Manager',User__c='');
                 insert testJobTaskRole1;
                 
                Staff__c st=new Staff__c();
                st.First_Name__c='mno';
                st.Last_Name__c='pqr';
                st.Email__c='mnopqr@gmail.com';
                st.UserName__c='mnopqr@gmail.com';
                st.Role__c='Project Manager';
                st.IsDeleted__c=False;
                insert st;       
             
                ext.strJTRID = testJobTaskRole1.Id;
                result2=ext.AssignTheUser();
                ext.DeleteTheUser();
     }*/
    // End of Test Coverage
}