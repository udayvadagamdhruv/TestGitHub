@isTest
public class TestBatchStaffNameUpdateforTaskrole 
{
	 static testMethod void TestBatchStaffNameUpdateforTaskrole()
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
                
               Client_Contact__c testCC = new Client_Contact__c(First_Name__c='Test Client', Last_Name__c='Contact' ,Name = 'Test Client Contact', Client__c=testClient.id,Email__c='testClientContact9897@SFDC.com',Salesforce_User__c=true,UserName__c='testClientContact9897@SFDC.com');     
               insert testCC;
              
               Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');
               insert customSetting001;
            
              Media_Type__c testMedia=new Media_Type__c(Name='TM001');
              insert testMedia;
              
              Schedule_Template__c testST=new Schedule_Template__c(Name='ST001',Media_Types__c=testMedia.Id);
              insert testST;
       
              Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST001',Schedule_Template__c=testST.Id);
              insert testSCT1;
                     
              Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST002',Schedule_Template__c=testST.Id);
              insert testSCT2;
                     
              ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='R001',Schedule_Task__c=testSCT1.Id);
              insert testSTR1;
                     
              ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='R002',Schedule_Task__c=testSCT2.Id);
              insert testSTR2;            
                     
              Specification_Template__c testSpec=new Specification_Template__c(Name='SPT001');
              insert testSpec;
                    
              Spec_Item__c testSPI=new Spec_Item__c(Name='SI001',Specification_Template__c=testSpec.Id); 
              insert testSPI;
             
              Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
              insert testCampaign1;
                 
              Job__c testJob1=new Job__c(Name='Job002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testCC.id,Schedule_Calc__c='Start Date');
              insert testJob1;
              
                Job_Task__c testJTS1=new Job_Task__c(Name='Test JT 897',Days__c=2,Job__c=testJob1.id);
          
                  insert testJTS1;
           Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test JT 897',Job_Task__c=testJTS1.Id);
        
                insert testJTR1;  
             
              Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer');
              insert testJT1;
               
              Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager');
              insert testJT2;
               
              Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director');
              insert testJT3;
            
              
              // Instantiate the extention instance with the standard controller 
                  list<Job_Task_Role__c> JobTaskrolelist=new List<Job_Task_Role__c>();
                  JobTaskrolelist.add(testJTR1);
                  BatchStaffNameUpdateforTaskrole shn = new BatchStaffNameUpdateforTaskrole(JobTaskrolelist); 
          	      database.executeBatch(shn, 1);
        
        }
    }
}