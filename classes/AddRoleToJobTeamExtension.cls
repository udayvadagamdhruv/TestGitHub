// This class is used to handle Add Role functionality on Job Team layout
public with sharing class AddRoleToJobTeamExtension {

   /* // Global Variables 
    public boolean isError{get;set;}
    public List<RoleWrapper> rolewraps{get;set;}
    public List<Job_Team__c> lstJobTeam{get;set;}
    public Job_Team__c objJobTeam{get;set;}
    public Id jobId {get;set;}
    // End of Global variables 
    
    // Standard Controller Constructor
    public AddRoleToJobTeamExtension(ApexPages.StandardController controller)
    {
        jobId=ApexPages.CurrentPage().getParameters().get('id');
        rolewraps=new List<RoleWrapper>();
        List<UserRole> uRole=[Select Name from UserRole ORDER By Name LIMIT 10000];
        for(UserRole u:URole)
        {
            RoleWrapper rw=new RoleWrapper();
            rw.u=u;
            rw.checked=false;
            roleWraps.add(rw);
        }    
     }
    
    // End Constructor
    
    // Start Save method
    public pagereference save()
    {
        try
      {
         for(RoleWrapper rw:roleWraps)
         {
            lstJobTeam=new List<Job_Team__c>(); 
            if(rw.checked==true)
             {
                 objJobTeam=new Job_Team__c();
                 if(schema.SobjectType.Job_Team__c.Fields.Role__c.isCreateable()){
                     objJobTeam.Role__c=rw.u.Name;
                 }
                 if(schema.SobjectType.Job_Team__c.Fields.Job__c.isCreateable()){
                     objJobTeam.Job__c=jobId;
                 }
                 lstJobTeam.add(objJobTeam);
             }
             if(Schema.sObjectType.Job_Team__c.isCreateable()){
                 insert lstJobTeam;
             }
         }
             // After creating a role navigate to Job Detail View
             PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
             p.setRedirect(true);
             return p;
         }
        catch(DMLException e)
        {
          isError = true;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); 
          return null;
        }
    }
    // End of Save
    
    // This method is called on to handle Cancel method
    public pagereference cancel()
    {
          PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
          p.setRedirect(true);
          return p;
    }
    // End of method Cancel
    
    // Start Wrapper Class
    public class RoleWrapper
     {
         public UserRole u{get;set;}
         public Boolean checked{get;set;}
     }
     // End Wrapper Class
     
     // Start Test Coverage
         static testMethod void Test_AddRoleToJobTeamExtension()
         {
                 
                Profile p=[Select Id from Profile where Name=: 'System Administrator'];
                
                User u=[Select Id from User where IsActive=: True LIMIT 1];
                
                System.runAs(u)
                {

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
                
                  Job__c testJob1=new Job__c(Job_Auto_Number__c='614',Name='Test Job 614',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                       insert testJob1;
                       
                  
                 System.assertEquals('Test Job 614',testJob1.Name);     
                 
                  ApexPages.currentPage().getParameters().put('id',testJob1.id);
          
                  // Instantiate the extention instance with the standard controller
                  
                  ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                 
                  //  Create the instance of a class
                  AddRoleToJobTeamExtension ext=new AddRoleToJobTeamExtension(con);
                 
                  // Invoke methods of a class using extension  
                  ApexPages.Pagereference result=ext.save();
                 
                  ext.roleWraps[0].checked=True;
          
                  result=ext.save();
                  
                  // Delete Job Tasks
                  List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob1.Id];
                  delete lstTask;
         
                  // Delete Job Specs
         
                   List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob1.Id];
                   delete lstSpecs;
         
                   Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Test Job 614'];
                   obj1.Status__c='Cancelled';
                   update obj1;
         
                     // To cover catch block
                   Job__c obj2=[Select id from Job__c where Name=: 'Test Job 614'];
                   delete obj2;
                   result = ext.save();
                   result = ext.cancel();
                   }
         }
     // End Test Coverage*/
}
// End of Class