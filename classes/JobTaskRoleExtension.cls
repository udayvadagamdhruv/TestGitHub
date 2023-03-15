// This class is used to add Role for Task 
public with sharing class JobTaskRoleExtension {

    // Global variables 
    /*public  boolean isError{get;set;}
    public List<RoleWrapper> rolewraps{get;set;}
    public Job_Task_Role__c stRole{get;set;}
    public List<Job_Task_Role__c> lst{get;set;}
    List<Job_Team__c> lstJobTeam{get;set;}
    public Job_Task_Role__c stc;
    String strSTId,strid;
    public String qid{get;set;}
    // End of Global variables 

    // Standard Controller 
    public JobTaskRoleExtension(ApexPages.StandardController controller) 
    {
       isError=false;
       this.stc=(Job_Task_Role__c)controller.getrecord();
       qid=ApexPages.CurrentPage().getParameters().get('qid');
       stc.Job_Task__c=qid;
       roleWraps=new List<RoleWrapper>();
    
       List<UserRole> uRole=[Select Name from UserRole ORDER By Name LIMIT 10000];
    
        for(UserRole u: uRole)
        {
            RoleWrapper rw=new RoleWrapper();
            rw.u=u;
            rw.checked=false;
            roleWraps.add(rw);        
        }
    }
    // End of Constructor

     // Start Wrapper class : THis class will bind Role and Checkbox on User interface
     public class RoleWrapper
     {
         public UserRole u{get;set;}
         public Boolean checked{get;set;}
     }
     // End of Wrapper Class
            
    // Method called on to Save selected Roles
    public pagereference Save()
    {
     try
      {
         for(RoleWrapper rw:roleWraps)
         {
            lst=new List<Job_Task_Role__c>();
            lstJobTeam=new List<Job_Team__c>(); 
            if(rw.checked==true)
             {
                 stRole=new Job_Task_Role__c();
                 strid = stc.Job_Task__c;
                  if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) {   
                      stRole.Name=rw.u.Name;}
                 if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) {   
                     stRole.Job_Task__c=strid;}
                 lst.add(stRole);
             }
             if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ insert lst;}
         }
             // After Save operation navigate to JobTaskDetail page
             PageReference p =  new Pagereference('/apex/JobTaskDetailPage?id='+qid);
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
     // End Of Save method
     
     // Method called on to handle Cancel button operation 
     public pagereference cancel()
     {
         // strid = stc.Job_Task__c;
          PageReference p =  new Pagereference('/apex/JobTaskDetailPage?id='+qid);
          p.setRedirect(true);
          return p;
     }
     // End of Cancel Button
     
     // Test Coverage 
         static testMethod void Test_JobTaskRoleExtension()
         {
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 303');
           
           try
           {
               insert testMedia;
           }
           catch(System.DMLException e)
           {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
           }
                
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 303',Media_Types__c=testMedia.Id);
                 insert testST;
                 
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 304',Media_Types__c=testMedia.Id);
                 insert testST1;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 303');
                 insert testSpec;
                
          Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 304');
                 insert testSpec1;
           
          Job__c testJob1=new Job__c(Name='Test Job 303',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
               }      
          System.assertEquals('Test Job 303',testJob1.Name);
               
          Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 301',Job__c=testJob1.Id,Days__c=5,Start_Date__c=System.Today());
           try
            {
                 insert testJT;
            }       
           catch(System.DMLException e)
            {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
            }
       
       // Instantiate the standard controller with the Job Task
       Job_Task_Role__c objJTR=new Job_Task_Role__c(Job_Task__c=testJT.Id);
       ApexPages.StandardController con = new ApexPages.StandardController(objJTR);
        
      // Instantiate the extention instance with the standard controller
      JobTaskRoleExtension ext=new JobTaskRoleExtension(con);
              
      
      // Invoke the Save method on the extension
      ApexPages.PageReference result=ext.Save();
      ext.roleWraps[0].checked=true;
      result=ext.save();
      ApexPages.PageReference result1=ext.cancel();
    }
// End of Test Coverage */
}
// End of Class