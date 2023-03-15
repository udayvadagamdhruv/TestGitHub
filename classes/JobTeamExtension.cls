// This class is used to display Roles under Job Detail layout and Create Schedule Functionality
public with sharing class JobTeamExtension {
/*
    // Global Variables 
     public List<Job_Team__c> lstJobTeam{get;set;}
     Map<String,Id> mp1 = new Map<String,Id>();
     Map<Id,Id> mp2 = new Map<Id,Id>();
     Set<Id> stScheduleTaskId = new Set<Id>();
     public string strJTRID{get;set;}
     public string strJTRID_Delete{get;set;}
     public String jobId;
     // End of Global variables 
      
     // Start Constructor
     public JobTeamExtension(ApexPages.StandardController controller)
      {
         jobId=System.currentPagereference().getParameters().get('id');
         lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by CreatedDate];
      }
      // End of Constructor
       
        // This method is called on add New Role
       public Pagereference addNewRole()
       {
           String theId=ApexPages.CurrentPage().getParameters().get('id');
           PageReference p = Page.AddRoleToJobTeam;
           p.setredirect(true);
           p.getParameters().put('id',theID); 
           return p;
       } 
       // End of method addNewRole
       
       // This method is called on to delete Role
      public Pagereference deleteRole()
      { 
      System.debug('Job id : ' + jobId);
      System.debug('Job Team id : ' + strJTRID );
           Job_Team__c objJTR=[Select Id,Role__c,Job__c,Staff__c from Job_Team__c where Id=:strJTRID and Job__c =: jobId];
         List<Job_Task_Role__c> lstJTRDelete=new List<Job_task_Role__c>();
         
         lstJTRDelete=[Select Id,Job_Task__c,Job_Task__r.Job__c from Job_Task_Role__c where Name=: objJTR.Role__c and Job_Task__r.Job__c=: jobId AND User__c = : objJTR.Staff__c];
          if(Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){
              Database.delete(lstJTRDelete);
          }
          if(Job_Team__c.sObjectType.getDescribe().isDeletable()){
              Database.delete(objJTR);   
          }
         PageReference p = new PageReference('/' + jobId);
         p.setRedirect(true);
         return p;
      }
      // End of method deleteRole 
      
      // This method is called on to Assign The User on Job Team layout
    public Pagereference AssignTheUser()
    {
        Job_Team__c objJTR=[Select Id,Role__c,Job__c from Job_Team__c where id=:strJTRID];
        Id jobId=objJTR.Job__c;
        List<Staff__c> lstStaff=[Select Name,Role__c from Staff__c where Role__c =: objJTR.Role__c and IsDeleted__c=:False];
        List<Client_Contact__c> lstCC = [Select Id, Name, Client_Contact_Role__c from Client_Contact__c where Client_Contact_Role__c =: objJTR.Role__c];
        List<Vendor_Contact__c> lstVend = [Select Id, Name, Role__c from Vendor_Contact__c where Role__c =: objJTR.Role__c];
        
        if(lstStaff.size()==1 && lstCC.size() == 0 && lstVend.size() == 0) // If there is only single Staff/ User available for selected Role then assign it directly
        {
               if(Schema.SobjectType.Job_Team__c.Fields.Staff__c.isUpdateable()){ objJTR.Staff__c=lstStaff[0].Name;}
               if(Schema.SobjectType.Job_Team__c.isUpdateable()){update objJTR;}
            String jobId1=objJTR.Job__c;

            PageReference p = new PageReference('/' + jobId);
            p.setRedirect(true);
            return p;
        }    
        // Else navigate user to selected Staff for that Role    
        else 
        {
            Pagereference p=new Pagereference('/apex/AssignUserToRoleOnJobTask1?id='+objJTR.Id);
            p.setRedirect(true);
            return p;
        }
    }
    // End of Assign User
    
   
    

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
 */
 /* 
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
     }
// End of Test Coverage 
*/
}
// End of Class