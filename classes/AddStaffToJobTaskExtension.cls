// This class is used to add staff
public with sharing class AddStaffToJobTaskExtension
 {
    // Global variables
   /*     public Boolean isError{get;set;}
        public Id jobTaskId{get;set;}
        public List<StaffWrapper> staffWraps{get;set;}
        public List<Job_Team__c> lstJobTeam{get;set;}
        public List<Job_Task_Role__c> lstJTR{get;set;}
        public Job_Task_Role__c objJTR{get;set;}
    // End of Global variables
    
    // Standard controller Constructor
    public AddStaffToJobTaskExtension(ApexPages.StandardController controller)
    {
                jobTaskId=ApexPages.CurrentPage().getParameters().get('Id');
                Job_Task__c objJT=[Select Id, Job__c from Job_Task__c where Id=:jobTaskId];
                Id jobId=objJT.Job__c;
                lstJobTeam=[Select Staff__c,Role__c from Job_Team__c where Job__c=: jobId and Staff__c!=''];
                staffWraps=new List<StaffWrapper>();
                for(Job_Team__c jTeam:lstJobTeam)
                {
                    StaffWrapper stw=new StaffWrapper();
                    stw.st=jTeam;
                    stw.Checked=False;
                    staffWraps.add(stw);
                }
    }
    // End Constructor
    
    // Method called on to save 
    public pagereference save()
    {
         try
      {
         for(StaffWrapper sw:staffWraps)
         {
            lstJTR=new List<Job_Task_Role__c>(); 
            if(sw.checked==true)
            {
                objJTR=new Job_Task_Role__c();
                if(schema.SobjectType.Job_Task_Role__c.Fields.Name.isCreateable()){
                    objJTR.Name=sw.st.Role__c;
                }
                if(schema.SobjectType.Job_Task_Role__c.Fields.User__c.isCreateable()){
                    objJTR.User__c=sw.st.Staff__c;
                }
                if(schema.SobjectType.Job_Task_Role__c.Fields.Job_Task__c.isCreateable()){
                    objJTR.Job_Task__c=jobTaskId;
                }
                lstJTR.add(objJTR);
            }
             if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){
                 insert lstJTR;
             }
         }
             PageReference p =  new Pagereference('/apex/JobTaskDetailPage?id='+jobTaskId);
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
    // End of method save
    
    // This method is used to handle cancel method
    public pagereference cancel()
    {
         PageReference p =  new Pagereference('/apex/JobTaskDetailPage?id='+jobTaskId);
         p.setRedirect(true);
         return p;
    }
    // End of method cancel
    
    // Start Wrapper Class
        public class StaffWrapper
        {
            public Job_Team__c st{get;set;}
            public Boolean Checked{get;set;}
        }
    // End Wrapper Class 
    
    // Start Test Coverage
    static testMethod void addStaffToJobTask()
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
                 
          AddStaffToJobTaskExtension ext=new AddStaffToJobTaskExtension(con);
                 
          ApexPages.Pagereference result=ext.save();
                  
          ext.staffWraps[0].checked=True;
                      
          result=ext.save();    
                          
          delete testJT1;
          
          result=ext.save();        
          
          result = ext.cancel();
    }*/
    // End Test Coverage 
}
// End of Class