@isTest
public class TestDisplayTasksInCalendar {
	/*static testMethod void test_DisplayTasksInCalendar()
   {
         Job_Number_Setting__c customSetting952 = new  Job_Number_Setting__c(Name= 'yy');

              insert customSetting952;
        
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 905');
             
               insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 905',Media_Types__c=testMedia.Id);
             
               insert testST;
                 
         Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 905',Schedule_Template__c=testST.Id);
         
                insert testScheduleTask1;

         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 905');
         
                insert testSpec;
                
         Job__c testJob1=new Job__c(Name='Test Job 905',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c='Active');
         
                insert testJob1;
         System.assertEquals('Test Job 905',testJob1.Name);
                 
         Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 905',Status__c='Active',Revised_Due_Date__c=System.Today(),Job__c=testJob1.Id);
         
                insert testJT;    
            
            //To handle If part in constructor 
           ApexPages.currentPage().getParameters().put('id',testJob1.id);          
           
           // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.standardController(testJob1);
           
           // Instantiate the extention instance with the standardcontroller
           
           DisplayTasksInCalendar obj=new DisplayTasksInCalendar(con);
           ApexPages.Pagereference pg=obj.cancel();
       
           // To handle Else part in constructor 
           Job__c testJob2=new Job__c(Name='Test Job 906',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c='Active');
         
                 insert testJob2;
           System.assertEquals('Test Job 906',testJob2.Name);
                 
           ApexPages.currentPage().getParameters().put('id',testJob2.id);    
                 
           // Instantiate the standard controller with the Job
           ApexPages.StandardController con2=new ApexPages.standardController(testJob2);
           
           // Instantiate the extention instance with the standard controller
           DisplayTasksInCalendar obj2=new DisplayTasksInCalendar(con2);
    }*/
    
}