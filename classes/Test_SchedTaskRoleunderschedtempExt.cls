@isTest
public class Test_SchedTaskRoleunderschedtempExt{
      static testMethod void Test_SchedTaskRoleunderschedtempExt()
           {
         /*    Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
                insert testMedia;
                
             Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 10',Media_Types__c=testMedia.Id);
                 
                  insert testST;
                  
              GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL001');
                  insert testGL;
         
              Schedule_Task__c testSCT=new Schedule_Task__c(Name='Test Schedule Task 10',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
                 insert testSCT;
                 
              System.assertEquals('Test Schedule Task 10',testSCT.Name);   
                 
               User u1 = [SELECT UserRole.Name from User where Profile.Name='System Administrator' limit 1];
               RoleWrapper w = New RoleWrapper();
                
               List<RoleWrapper> wlist = new List<RoleWrapper>(); 
      
               w.u = u1.UserRole;
               w.Checked= True;
               wlist.add(w); 
               
                // Instantiate the standard controller with the Spec Item
       
               ScheduleTaskRole__c st=new ScheduleTaskRole__c();
               //insert st;
               
               ApexPages.currentPage().getParameters().put('scheduleTaskId',testSCT.id);
               ApexPages.StandardController con = new ApexPages.StandardController(st);
        
                // Instantiate the extention instance with the standardcontroller 
                SchedTaskRoleunderschedtempExt ext=new SchedTaskRoleunderschedtempExt(con);
                 ApexPages.PageReference result=ext.Save();    
                 
                 ext.roleWraps[0].checked=True;
                
        
                // Invoke the primary method on the extension 
                
                 result=ext.Save();     
               
               User u2 = [SELECT UserRole.Name from User where Profile.Name='System Administrator' limit 1];
               RoleWrapper w1 = New RoleWrapper();
                
               List<RoleWrapper> wlist1 = new List<RoleWrapper>(); 
      
               w1.u = u2.UserRole;
               w1.Checked= True;
               wlist1.add(w); 
               
                // Instantiate the standard controller with the Spec Item 
       
                ScheduleTaskRole__c st1=new ScheduleTaskRole__c();
               //upsert st1;
               
                ApexPages.currentPage().getParameters().put('scheduleTaskId',testSCT.id);
               ApexPages.StandardController con1 = new ApexPages.StandardController(st1);
        
                // Instantiate the extention instance with the standardcontroller 
                SchedTaskRoleunderschedtempExt ext1=new SchedTaskRoleunderschedtempExt(con1);
        
                //  Invoke the primary method on the extension 
                 ApexPages.PageReference result1=ext1.Save();   
                 result1=ext1.cancel();
                 
                 
                     }
     // End Test Coverage 
     
      public class RoleWrapper
                 {
                     public UserRole u{get;set;}
                     public Boolean checked{get;set;}*/
                 }      

    
    }