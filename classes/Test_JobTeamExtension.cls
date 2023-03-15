@isTest
public class Test_JobTeamExtension{
     // Start Test Coverage 
 /*   static testMethod void Test_JobTeamExtension()
     {
          Job_Number_Setting__c customSetting997 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting997;
     
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 358');
             
                insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 358',Media_Types__c=testMedia.Id);
             
                insert testST;
      
           GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL009');
             
                insert testGL;
            
           Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 358',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
            
                insert testSCT1;
                
            Schedule_Task__c testSCT2=new Schedule_Task__c(Name='Test Schedule Task 359',Schedule_Template__c=testST.Id,Days__c=3,GL_Code__c=testGL.Id);
            
                insert testSCT2;
             
            ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Designer',Schedule_Task__c=testSCT1.Id);
            
                insert testSTR1;
           
            ScheduleTaskRole__c testSTR3=new ScheduleTaskRole__c(Name='Art Director',Schedule_Task__c=testSCT1.Id);
            
                insert testSTR3;
           
            ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='Project Manager',Schedule_Task__c=testSCT2.Id);
               
                insert testSTR2;
           
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 359');
           
                insert testSpec;
      
           Job__c testJob1=new Job__c(Name='Test Job 360',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
               }
           System.assertEquals('Test Job 360',testJob1.Name);    
           
           Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer');
           
               insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager');
           
               insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director');
               insert testJT3;
               
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
         
               // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
           // Instantiate the extention instance with the standardcontroller 
               JobTeamExtension ext=new JobTeamExtension(con);
        
           // Invoke the primary method on the extension
         
           Job_Team__c testJT4=new Job_Team__c();
            try
             {
                insert testJT4;
             }
            catch(System.DMLException e)
             {
                System.assertEquals('REQUIRED_FIELD_MISSING' , e.getDmlStatusCode(0));
             }
        
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
         
            // Instantiate the standard controller with the Job 
           ApexPages.StandardController con2=new ApexPages.StandardController(testJob1);
        
            // Instantiate the extention instance with the standardcontroller 
            JobTeamExtension ext2=new JobTeamExtension(con2);
        
            // Invoke the primary method on the extension 

            ext2.strJTRID = testJT1.Id;
        
            Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
            insert testStaff1;
            
            Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Project Manager',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
            insert testStaff2;
            
            Staff__c testStaff3=new Staff__c(First_Name__c='Test First Name 3',Last_Name__c='Test Last Name 3',Role__c='Project Manager',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
            insert testStaff3;
        
            ApexPages.PageReference result3=ext2.AssignTheUser();
           
            ext2.strJTRID = testJT1.Id;
            ApexPages.PageReference result4=ext2.deleteRole();
    }
  // End of Test method JobTeam Test 
  
  // Test Method JobTeamTest1
  static testMethod void jobTeamTest1()
    {
    
           Job_Number_Setting__c customSetting996 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting996;
           
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 358');
             
                insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 358',Media_Types__c=testMedia.Id);
             
                 insert testST;
      
           GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL009');
             
                 insert testGL;
            
           Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 358',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
           
                 insert testSCT1;
                
           Schedule_Task__c testSCT2=new Schedule_Task__c(Name='Test Schedule Task 359',Schedule_Template__c=testST.Id,Days__c=3,GL_Code__c=testGL.Id);
           
                 insert testSCT2;
             
           ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Designer',Schedule_Task__c=testSCT1.Id);
           
                 insert testSTR1;
           
           ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='Project Manager',Schedule_Task__c=testSCT2.Id);
           
                 insert testSTR2;
           
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 359');
           
                insert testSpec;
      
           Job__c testJob1=new Job__c(Name='Test Job 360',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
           System.assertEquals('Test Job 360',testJob1.Name);
               
           Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer');
           insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager');
           insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director');
           insert testJT3;
               
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);

           // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
          // Instantiate the standard controller with the Spec Item 
          // ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
           // Instantiate the extention instance with the standardcontroller 
          JobTeamExtension ext=new JobTeamExtension(con);
          ApexPages.Pagereference result=ext.addNewRole();
      
         ext.strJTRID = testJT1.Id;
        
         Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='teststaff1@gmail.com',UserName__c='teststaff1@gmail.com');
         insert testStaff1;
            
         Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Designer',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
         insert testStaff2;
            
         Staff__c testStaff3=new Staff__c(First_Name__c='Test First Name 3',Last_Name__c='Test Last Name 3',Role__c='Designer',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
         insert testStaff3;
        
        // Invoke the primary method on the extension
         ApexPages.PageReference result3=ext.AssignTheUser();
        
         testJob1.Start_Date__c=System.Today()+15;
         update testJob1;
           
         ext.strJTRID = testJT3.Id;
         result3=ext.deleteRole();
     }*/
// End of Test Coverage 
}