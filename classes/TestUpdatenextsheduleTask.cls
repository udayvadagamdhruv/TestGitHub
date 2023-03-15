@istest
Public class TestUpdatenextsheduleTask{

    static testMethod void TestUpdatenextsheduleTask()
        {

  Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
         
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 614');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 614',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
            Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 914',Schedule_Template__c=testST.id,Days__c=3);
                insert testSchedule1;
                
            Schedule_Task__c testSchedule2=new Schedule_Task__C(Name='Test Schedule Task 915',Schedule_Template__c=testST.id,Days__c=3);
                insert testSchedule2;
                
            ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Test Role 001',Schedule_Task__c=testSchedule1.id);
                insert testSTR1;
                
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 614');
                insert testSpec;

 Job__c testJob22=new Job__c(Name='Test Job 44615',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='End Date');
         
                 insert testJob22;     
           Job_Task__c testJobTasknew=new Job_Task__c(Name='Job Task 6188911',Email__c='mani@gmail.com',Job__c=testJob22.Id,Start_Date__c=System.Today(),Marked_Done__c=false,Task_Order__c = 1,Days__c=3,Revised_Due_Date__c=System.Today());
        
                insert testJobTasknew;      
                
         Job_Task__c testJobTasknew1=new Job_Task__c(Name='Job Task 6331911',Email__c='mani@gmail.com',Job__c=testJob22.Id,Start_Date__c=System.Today(),Marked_Done__c=false,Task_Order__c = 2,Days__c=3,Revised_Due_Date__c=System.Today()+1 );
        
                insert testJobTasknew1;  
                
               string jobid= testJob22.id;    
             
                    
                UpdatenextsheduleTask.UpdatenextsheduleTaskmethod(jobid);
            set<string> sjs = new set<string>();
            sjs.add(jobid);
                    UpdatenextsheduleTask.UpdatenextsheduleTaskmethod2(sjs,false);
                    UpdatenextsheduleTask.UpdatenextsheduleTaskmethod2(sjs,true);
}
}