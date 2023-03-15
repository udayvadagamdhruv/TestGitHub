@isTest
public class TestdisplayScheduleTaskUnderScheduleTemp{
/*
static testMethod void TestdisplayScheduleTaskUnderScheduleTemp()
    {         
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1007');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1007',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schedule Task 1007',Days__c=2,Schedule_Template__c=testST.id);
                insert testSchedule;
                
          System.assertEquals('Test Schedule Task 1007',testSchedule.Name);   

          
          // Instantiate the extention instance with the Custom Controller
          
          displayScheduleTaskUnderScheduleTemp ext=new displayScheduleTaskUnderScheduleTemp();
          
          ext.LoadData();
          
      // Invoke the primary methods on the extension        
          ApexPages.pagereference result=ext.save();
            result=ext.Cancel();
            result=ext.editTask();
            result=ext.insertTask();
            result=ext.insertTaskBelow();
            ext.selectedTaskId=testSchedule.id;
            ext.DeleteTask();
            ext.selectedTaskId=NULL;
            ext.DeleteTask();
            Schedule_Task__c st=[Select id from Schedule_Task__c where id=:testSchedule.id limit 1];
            delete st;
            ext.save();
            ext.LoadData();
    }// End of Test Coverage Code 

*/


}