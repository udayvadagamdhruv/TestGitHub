@isTest
public class Test_RetrieveTaskNewTesting{ 
    static testMethod void Test_RetrieveTaskNewTesting()
        {
           /*   test.starttest();
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
                
            Job__c testJob1=new Job__c(Name='Test Job 614',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='Start Date');
         
                 insert testJob1;
                 
             System.assertEquals('Test Job 614',testJob1.Name);
                 
            Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 615',Job__c=testJob1.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 1,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
                insert testJobTask1;
             list<Job_Task__c> Jobtasklist=new list<Job_Task__c>();
        
             Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 616',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 2,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
               Jobtasklist.add(testJobTask2);
        
            Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
                
                Jobtasklist.add(testJobTask3);
            insert Jobtasklist;    
                
            Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Job Task Role 615',Job_Task__c=testJobTask1.Id);
        
                insert testJTR1;
                
                
                
                 List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Job__c.Schedule_Calc__c.getDescribe();
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
      
           Job__c testJob2=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='End Date');
         
                 insert testJob2;
                 
             System.assertEquals('Test Job 615',testJob2.Name);
                 
            Job_Task__c testJobTask4=new Job_Task__c(Name='Job Task 617',Job__c=testJob2.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 4,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
                insert testJobTask4;
        
            
            Job_Task__c testJobTask8=new Job_Task__c(Name='Job Task 6188',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3,Task_Order__c = 4,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
                insert testJobTask8;
                
            Job_Task__c testJobTask5=new Job_Task__c(Name='Job Task 619',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False, Task_Order__c = 5,Days__c=3,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        
                insert testJobTask5;
                
             Job_Task__c testJobTask6=new Job_Task__c(Name='Job Task 618',Job__c=testJob2.Id,Start_Date__c=System.Today(), Task_Order__c = 6,Days__c=3,Marked_Done__c=false,Revised_Due_Date__c=System.Today(),Email__C='mani@gmail.com,sugu@gmail.com' );
        
                insert testJobTask6;
                
            Job_Task__c testJobTask7=new Job_Task__c(Name='Job Task 6191',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Task_Order__c = 7,Days__c=3,Revised_Due_Date__c=System.Today()+1,Email__C='mani@gmail.com,sugu@gmail.com');
        
                insert testJobTask7;
           
           
           
                
                
            Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='test',Job_Task__c=testJobTask6.Id,Email__c='mani@gmail.com');
        
                insert testJTR2;
              Job_Team__c jteam = new Job_Team__c(staff__c='test', role__c='test', email__c='test@test.com', job__c=testJob2.id);  
              insert jteam;
             ApexPages.currentPage().getParameters().put('id',testJob1.Id); 
       
            // Instantiate the standard controller with the Job
            
            ApexPages.StandardController con12=new ApexPages.StandardController(testJob1);
            RetrieveTaskNewTesting ext123=new RetrieveTaskNewTesting(con12);
            
            ApexPages.currentPage().getParameters().put('afJobId',testJob2.Id);
            ApexPages.currentPage().getParameters().put('afTaskId',testJobTask6.Id);
            ApexPages.currentPage().getParameters().put('afTeamateName','test');
            
            ApexPages.currentPage().getParameters().put('afTaskId1',testJobTask6.Id);
            ApexPages.currentPage().getParameters().put('afTeamateName1','test');
            
            ext123.addTeams();
            ext123.removeTeam();
            
            test.stoptest();
            
            ApexPages.currentPage().getParameters().put('id',testJob1.Id); 
       
            // Instantiate the standard controller with the Job
            
            ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
       
            // Instantiate the extention instance with the standard controller 

            RetrieveTaskNewTesting ext1=new RetrieveTaskNewTesting(con);
            
            ext1.strJTID=testJobTask1.Id;
           
  //          ext1.strJTID=testJobTask2.Id;
         
            // Invoke the primary method on the extension
            
            ApexPages.Pagereference result=ext1.save();
            
            Job_Task__c objTaskNew = [select id, name,Email__c, Days__c,Start_date__c,Revised_Due_Date__c from Job_Task__c where id=: testJobTask5.id];          
       
       
       DateTime dtnbew = System.Today().AddDays(2);
       Date  dtnbew1 = System.Today();
       Date d4 = Date.newInstance(dtnbew .Year(), dtnbew .Month(), dtnbew .Day());
       objTaskNew.Start_date__c = dtnbew1;
       update objTaskNew;
        //ext1.dt= d4 ;
       ext1.taskId1 = objTaskNew.id; 
            ext1.taskId = testJobTask5.id;
            ext1.dt = System.Today().AddDays(2);
            ext1.updateRestScheduleRevDt = 'true';
       result=ext1.updateRestSchedule();
        
           result=ext1.displayTasksInCalendar();
       
           result=ext1.createSchedule();
       
           result=ext1.addNewTask();
       
           result=ext1.insertNewTask();
       
           result=ext1.EditJobTask();
         
         ext1.insertNewTaskLight();
            ext1.addNewTaskLight();
            ApexPages.currentPage().getParameters().put('index','1'); 
            ext1.updateScheduleHours();
            //ext1.RetrieveTaskNewTesting();
            ext1.RetrieveTaskNewTesting123();
            ext1.taskId123  = objTaskNew.id;
            ext1.dt123 = System.Today().AddDays(2);
            ext1.saveOrder();
            ext1.TaskId3 = objTaskNew.id;
            ext1.moveUpandDown();
            ext1.refreshTasks();
            ext1.Complete();
            ext1.Active();
            ext1.toggleviewCalender();
            ext1.toggleviewList();
             ApexPages.currentPage().getParameters().put('CalTaskId',objTaskNew.id); 
            ext1.calenderTaskEdit();
            ext1.CaleEditSave();
            ext1.CalEditCancel();
             ApexPages.currentPage().getParameters().put('DTaskId',objTaskNew.id);
            ext1.statusChangeUpdate();
             ApexPages.currentPage().getParameters().put('DCalTaskId',objTaskNew.id);
            ApexPages.currentPage().getParameters().put('DcalDueDate','2018-09-09');
            ext1.TaskDueDateUpdate();
            
            ext1.deltask();
         
            Job_Task__c objTaskNew1 = [select id, name,Email__c, Days__c,Start_date__c from Job_Task__c where id=: testJobTask5.id];
       objTaskNew1.Days__c = 2;
       update objTaskNew1;
       ext1.days1= '5';
       ext1.taskId1 = objTaskNew1.id;
       ext1.updateRestScheduleDays= 'true';
        result=ext1.updateScheduleOnDays();
       
      
       
       result=ext1.deleteJobTask();
         result=ext1.cancelme();
       
           result=ext1.createSchedule();
            
      
  /*    
         ApexPages.currentPage().getParameters().put('id',testJob2.Id); 
       
            // Instantiate the standard controller with the Job
            
             con=new ApexPages.StandardController(testJob2);
       
            // Instantiate the extention instance with the standard controller 

            RetrieveTaskNewTesting ext2=new RetrieveTaskNewTesting(con);

           // ext1.strJTID=testJobTask5.Id;
           
            ext1.strJTID=testJobTask6.Id;
         
            // Invoke the primary method on the extension
            
            result=ext1.save();
       
          
            ext1.strJTID=testJobTask6.Id;
            
            
             // testJobTask5=new Job_Task__c(Name='Job Task 6177',Job__c=testJob1.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3);
        
              //  insert testJobTask5;
                
            //Job_Task__c objTaskNew2 = [select id, name, Days__c,Start_date__c,Revised_Due_Date__c from Job_Task__c where id=: testJobTask3.id]  ;
      // testJobTask5.Revised_Due_Date__c = ;
       //update testJobTask5;
      
       
        result=ext2.displayTasksInCalendar();
       
         //  result=ext2.createSchedule();
       
         //  result=ext2.addNewTask();
       
         //  result=ext2.insertNewTask();
       
          // result=ext2.EditJobTask();
         
           result=ext2.cancelme();
       
          //result=ext2.createSchedule();
       
           result=ext2.deleteJobTask();
       
       
       
         // Job__c testJob3=new Job__c(Name='Test Job 615',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='Start Date');
         
          //       insert testJob3;
                 
          // ApexPages.currentPage().getParameters().put('id',testJob3.Id); 
         
          // ApexPages.StandardController con2=new ApexPages.StandardController(testJob3);
        
          //  RetrieveTaskNewTesting ext3=new RetrieveTaskNewTesting(con2);
        
         //   result=ext3.createSchedule();
            
           // Delete Job Tasks
             List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob2.Id];
             delete lstTask;
         
             // Delete Job Specs
         
             List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob2.Id ];
             delete lstSpecs;
         
             Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Test Job 615'];
             obj1.Status__c='Cancelled';
             //update obj1;
         
         // To cover catch block
         // Job__c obj2=[Select id from Job__c where Name=: 'Test Job 615'];
         //delete obj2;
 
     //   delete testJob1;
        result=ext1.save();
            
      
        
    // End of Test Coverage
    */
   
   }
    }