//@isTest
public class Test_JobTaskScheduleAddEditStaffExtsion{
     // Start Test Coverage 
 /*   static testMethod void Test_JobTaskScheduleAddEditStaffExtension()
     { 
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 897');
             
               insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 897',Media_Types__c=testMedia.Id);
             
               insert testST;
                 
          Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 897',Schedule_Template__c=testST.id,Days__c=3);
                 
               insert testSchedule1;
                
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Test Role 897',Schedule_Task__c=testSchedule1.id);
              
                insert testSTR1;
                
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 897');
                       
                insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 897',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
          
                  insert testJob1;
         
          System.assertEquals('Test Job 897',testJob1.Name);    
                       
          Job_Task__c testJT1=new Job_Task__c(Name='Test JT 897',Days__c=2,Job__c=testJob1.id);
          
                  insert testJT1;
                      
          Job_Team__c testJobTeam1=new Job_Team__c(Job__c=testJob1.id,Role__c='Test Role 897',Staff__c='Test Staff 897');    
                      
                  insert testJobTeam1;
                                        
          ApexPages.currentPage().getParameters().put('id',testJT1.id);
          
          ApexPages.StandardController con=new ApexPages.StandardController(testJT1);
                 
          JobTaskScheduleAddEditStaffExtension ext=new JobTaskScheduleAddEditStaffExtension(con);
                 
          ApexPages.Pagereference result=ext.Addstaff();
                  
         // ext.staffWraps[0].checked=True;
                      
          result=ext.Addstaff();   
                          
          delete testJT1;
          ext.SerachStaff(); 
          result=ext.Addstaff();        
          
          result = ext.cancel();
    }
    // End Test Coverage */
    
    }