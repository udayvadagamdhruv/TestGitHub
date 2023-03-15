@isTest
public class Test_BatchClientConJobShare{
    static testMethod void Test_BatchClientConJobShare()
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
              
                  // Instantiate the extention instance with the standard controller 
                  list<id> Clientid=new List<Id>();
                  clientid.add(testCC.id);
                  BatchClientConJobShare shn = new BatchClientConJobShare(clientid); 
          database.executeBatch(shn, 1);
        
        }
    }
}