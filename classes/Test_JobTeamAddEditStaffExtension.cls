//@isTest
public class Test_JobTeamAddEditStaffExtension{
     // Start Test Coverage 
    /*static testMethod void Test_JobTeamAddEditStaffExtension()
     {
          Job_Number_Setting__c customSetting997 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting997;
            Client__c c=new Client__c(name='test client');
            insert c;
            Vendor__c v=new Vendor__c(name='test Vendor');
            insert v;
     
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
      
           Job__c testJob1=new Job__c(Name='Test Job 360',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,JS_Client__c=c.id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
               }
           System.assertEquals('Test Job 360',testJob1.Name);    
           
           Job_Task__c testJTS1=new Job_Task__c(Name='Test JT 897',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS1;
           Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test JT 897',Job_Task__c=testJTS1.Id,Email__C='mani@gmail.com');
        
                insert testJTR1;  
                      
                  
        
          
           Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer');
           
               insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager',Staff__c='manikanta',Email__C='mani@gmail.com');
           
               insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',Staff__c='manikanta',Email__C='mani@gmail.com');
              
             insert testJT3;
             
             Job_Task__c testJTS12=new Job_Task__c(Name='Designer',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS12;
             
          Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJTS12.Id,Email__C='mani@gmail.com');
        
                insert testJTR2;   
             
         list<Job_Task_Role__c> lstJTRDelete11= [Select Id,Job_Task__c,Job_Task__r.Job__c from Job_Task_Role__c where Name=: testJT1.Role__c and Job_Task__r.Job__c =: testJT1.job__c ];

             delete lstJTRDelete11;
               
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
         
               // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
           // Instantiate the extention instance with the standardcontroller 
               JobTeamAddEditStaffExtension ext=new JobTeamAddEditStaffExtension(con);
        
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
            JobTeamAddEditStaffExtension ext2=new JobTeamAddEditStaffExtension(con2);
        
            // Invoke the primary method on the extension 

          
        
            Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
            insert testStaff1;
            
            Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Project Manager',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
            insert testStaff2;
            
            Staff__c testStaff3=new Staff__c(First_Name__c='Test First Name 3',Last_Name__c='Test Last Name 3',Role__c='Art Director',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
            insert testStaff3;
            
            
            Client_Contact__c  testcc1=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLasNam1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff176@gmail.com');
            insert testcc1;
            
            Client_Contact__c  testcc2=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLastName 1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff167@gmail.com');
            insert testcc2;
            
            Vendor_Contact__c testVC1=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLastName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC1;
            
            
            Vendor_Contact__c  testVC2=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLasName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC2;
           
              List<SelectOption> Rtypes=ext2.getStatusList();
              
              ext2.StatusString ='Staff';
              
            ext2.SerachStaff();
            Job_Team__c testJT5=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',staff__c='manikanta',Email__C='mani@gmail.com');
              
             insert testJT5;
            
            ApexPages.PageReference result4=ext2.Addstaff();
            ApexPages.PageReference result5=ext2.cancel();
         ext2.DisplayChart();
         ext2.DisplayChart1();
    }
  // End of Test method JobTeam Test 
  
    static testMethod void Test_JobTeamAddEditStaffExtension1()
     {
          Job_Number_Setting__c customSetting997 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting997;
            Client__c c=new Client__c(name='test client');
            insert c;
            Vendor__c v=new Vendor__c(name='test Vendor');
            insert v;
     
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
      
           Job__c testJob1=new Job__c(Name='Test Job 360',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,JS_Client__c=c.id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
               }
           System.assertEquals('Test Job 360',testJob1.Name);    
           
           Job_Task__c testJTS1=new Job_Task__c(Name='Test JT 897',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS1;
           Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test JT 897',Job_Task__c=testJTS1.Id,Email__C='mani@gmail.com');
        
                insert testJTR1;  
                      
                  
        
          
           Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer',Email__C='mani@gmail.com');
           
               insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager',Email__C='mani@gmail.com');
           
               insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',Email__C='mani@gmail.com');
              
             insert testJT3;
             
             Job_Task__c testJTS12=new Job_Task__c(Name='Designer',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS12;
             
          Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJTS12.Id,Email__C='mani@gmail.com');
        
                insert testJTR2;   
             
         list<Job_Task_Role__c> lstJTRDelete11= [Select Id,Job_Task__c,Job_Task__r.Job__c,Email__C from Job_Task_Role__c where Name=: testJT1.Role__c and Job_Task__r.Job__c =: testJT1.job__c ];

             delete lstJTRDelete11;
               
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
         
               // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
           // Instantiate the extention instance with the standardcontroller 
               JobTeamAddEditStaffExtension ext=new JobTeamAddEditStaffExtension(con);
        
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
            JobTeamAddEditStaffExtension ext2=new JobTeamAddEditStaffExtension(con2);
        
            // Invoke the primary method on the extension 

          
        
            Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
            insert testStaff1;
            
            Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Project Manager',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
            insert testStaff2;
            
            Staff__c testStaff3=new Staff__c(First_Name__c='Test First Name 3',Last_Name__c='Test Last Name 3',Role__c='Art Director',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
            insert testStaff3;
            
            
            Client_Contact__c  testcc1=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLasNam1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff176@gmail.com');
            insert testcc1;
            
            Client_Contact__c  testcc2=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLastName 1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff167@gmail.com');
            insert testcc2;
            
            Vendor_Contact__c testVC1=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLastName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC1;
            
            
            Vendor_Contact__c  testVC2=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLasName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC2;
           
              List<SelectOption> Rtypes=ext2.getStatusList();
              
              ext2.StatusString ='All';
              
            ext2.SerachStaff();
            Job_Team__c testJT5=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',staff__c='manikanta',Email__C='mani@gmail.com');
              
             insert testJT5;
            
            ApexPages.PageReference result4=ext2.Addstaff();
            ApexPages.PageReference result5=ext2.cancel();
          ext2.DisplayChart();
         ext2.DisplayChart1();
    }
  // End of Test method JobTeam Test 
  
   static testMethod void Test_JobTeamAddEditStaffExtension12()
     {
          Job_Number_Setting__c customSetting997 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting997;
            Client__c c=new Client__c(name='test client');
            insert c;
            Vendor__c v=new Vendor__c(name='test Vendor');
            insert v;
     
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
      
           Job__c testJob1=new Job__c(Name='Test Job 360',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,JS_Client__c=c.id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
               }
           System.assertEquals('Test Job 360',testJob1.Name);    
           
           Job_Task__c testJTS1=new Job_Task__c(Name='Test JT 897',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS1;
           Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test JT 897',Job_Task__c=testJTS1.Id,Email__C='mani@gmail.com');
        
                insert testJTR1;  
                      
                  
        
          
           Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer',Email__C='mani@gmail.com');
           
               insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager',Email__C='mani@gmail.com');
           
               insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',Email__C='mani@gmail.com');
              
             insert testJT3;
             
             Job_Task__c testJTS12=new Job_Task__c(Name='Designer',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS12;
             
          Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJTS12.Id,Email__C='mani@gmail.com');
        
                insert testJTR2;   
             
         list<Job_Task_Role__c> lstJTRDelete11= [Select Id,Job_Task__c,Job_Task__r.Job__c from Job_Task_Role__c where Name=: testJT1.Role__c and Job_Task__r.Job__c =: testJT1.job__c ];

             delete lstJTRDelete11;
               
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
         
               // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
           // Instantiate the extention instance with the standardcontroller 
               JobTeamAddEditStaffExtension ext=new JobTeamAddEditStaffExtension(con);
        
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
            JobTeamAddEditStaffExtension ext2=new JobTeamAddEditStaffExtension(con2);
        
            // Invoke the primary method on the extension 

          
        
            Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
            insert testStaff1;
            
            Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Project Manager',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
            insert testStaff2;
            
            Staff__c testStaff3=new Staff__c(First_Name__c='Test First Name 3',Last_Name__c='Test Last Name 3',Role__c='Art Director',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
            insert testStaff3;
            
            
            Client_Contact__c  testcc1=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLasNam1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff176@gmail.com');
            insert testcc1;
            
            Client_Contact__c  testcc2=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLastName 1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff167@gmail.com');
            insert testcc2;
            
            Vendor_Contact__c testVC1=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLastName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC1;
            
            
            Vendor_Contact__c  testVC2=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLasName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC2;
           
              List<SelectOption> Rtypes=ext2.getStatusList();
              
              ext2.StatusString ='Client Contact';
              
            ext2.SerachStaff();
            Job_Team__c testJT5=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',staff__c='manikanta',Email__C='mani@gmail.com');
              
             insert testJT5;
            
            ApexPages.PageReference result4=ext2.Addstaff();
            ApexPages.PageReference result5=ext2.cancel();
          ext2.DisplayChart();
         ext2.DisplayChart1();
    }
  // End of Test method JobTeam Test 
  
  static testMethod void Test_JobTeamAddEditStaffExtension123()
     {
          Job_Number_Setting__c customSetting997 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting997;
            Client__c c=new Client__c(name='test client');
            insert c;
            Vendor__c v=new Vendor__c(name='test Vendor');
            insert v;
     
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
      
           Job__c testJob1=new Job__c(Name='Test Job 360',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,JS_Client__c=c.id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
               }
           System.assertEquals('Test Job 360',testJob1.Name);    
           
           Job_Task__c testJTS1=new Job_Task__c(Name='Test JT 897',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS1;
           Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test JT 897',Job_Task__c=testJTS1.Id,Email__C='mani@gmail.com');
        
                insert testJTR1;  
                      
                  
        
          
           Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer',Email__C='mani@gmail.com');
           
               insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager',Email__C='mani@gmail.com');
           
               insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',Email__C='mani@gmail.com');
              
             insert testJT3;
             
             Job_Task__c testJTS12=new Job_Task__c(Name='Designer',Days__c=2,Job__c=testJob1.id,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com');
          
                  insert testJTS12;
             
          Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJTS12.Id,Email__C='mani@gmail.com');
        
                insert testJTR2;   
             
         list<Job_Task_Role__c> lstJTRDelete11= [Select Id,Job_Task__c,Job_Task__r.Job__c from Job_Task_Role__c where Name=: testJT1.Role__c and Job_Task__r.Job__c =: testJT1.job__c ];

             delete lstJTRDelete11;
               
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
         
               // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
           // Instantiate the extention instance with the standardcontroller 
               JobTeamAddEditStaffExtension ext=new JobTeamAddEditStaffExtension(con);
        
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
            JobTeamAddEditStaffExtension ext2=new JobTeamAddEditStaffExtension(con2);
        
            // Invoke the primary method on the extension 

          
        
            Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Designer',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
            insert testStaff1;
            
            Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Project Manager',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
            insert testStaff2;
            
            Staff__c testStaff3=new Staff__c(First_Name__c='Test First Name 3',Last_Name__c='Test Last Name 3',Role__c='Art Director',Email__c='testEmailStaff3@gmail.com',UserName__c='testEmailStaff3@gmail.com');
            insert testStaff3;
            
            
            Client_Contact__c  testcc1=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLasNam1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff176@gmail.com');
            insert testcc1;
            
            Client_Contact__c  testcc2=new Client_Contact__c(Client__c=c.id,First_Name__c='TestFirstName6',Last_Name__c='TestLastName 1',Client_Contact_Role__c='Designer',Email__c='testEmailStaff17@gmail.com',UserName__c='testEmailStaff167@gmail.com');
            insert testcc2;
            
            Vendor_Contact__c testVC1=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLastName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC1;
            
            
            Vendor_Contact__c  testVC2=new Vendor_Contact__c(Vendor__c=v.id,First_Name__c='TestFirstName7',Last_Name__c='TestLasName2',Role__c='Project Manager',Email__c='testEmailStaff72@gmail.com',User_Name__c='testEmailStaff9602@gmail.com');
            insert testVC2;
           
              List<SelectOption> Rtypes=ext2.getStatusList();
              
              ext2.StatusString ='Vendor Contact';
              
            ext2.SerachStaff();
            Job_Team__c testJT5=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director',staff__c='manikanta',Email__C='mani@gmail.com');
              
             insert testJT5;
            
            ApexPages.PageReference result4=ext2.Addstaff();
            ApexPages.PageReference result5=ext2.cancel();
          ext2.DisplayChart();
         ext2.DisplayChart1();
    }
  // End of Test method JobTeam Test
  
  */
  
  
  
  
}