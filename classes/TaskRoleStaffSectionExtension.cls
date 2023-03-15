public with sharing class TaskRoleStaffSectionExtension {

    // Global Variables 
    
    
    public boolean isLtng{private set; get{
                                    String theme = UserInfo.getUITheme();
                                    return (theme=='Theme4d')?true:false;
                                  }
    }  
    
    
    
    
     
      public List<Job_Task_Role__c> lstTR{get;set;}
      public String Taskid;
      
     // End of Global variables 
      
     // Start Constructor
     public TaskRoleStaffSectionExtension (ApexPages.StandardController controller)
      {
         Taskid=System.currentPagereference().getParameters().get('id');
         lstTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: Taskid order by CreatedDate];
      }
      // End of Constructor
      
      
      //start Method to go to the JobTeamAddEditStaff page
      public Pagereference AddStaffs()
       {
           String theId=ApexPages.CurrentPage().getParameters().get('id');
           
           if(isLtng)
                 {
                   PageReference p = Page.TaskRoleAddEditStaffLightning;
                   p.setredirect(true);
                   p.getParameters().put('id',theID); 
                   return p;
                 }
          else
                 {
                  PageReference p = Page.TaskRoleAddEditStaff;
                   p.setredirect(true);
                   p.getParameters().put('id',theID); 
                   return p;
          
                  }
       }
      //End Method to go to the JobTeamAddEditStaff page
}