// This class is used to display Roles under Job Detail layout 
public with sharing class JobTeamStaffSectionExtension {
     
     // Global Variables 
     
      public List<Job_Team__c> lstJobTeam{get;set;}
      public String jobId;
      
     // End of Global variables 
      
     // Start Constructor
     public JobTeamStaffSectionExtension(ApexPages.StandardController controller)
      {
         jobId=System.currentPagereference().getParameters().get('id');
         lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by CreatedDate];
      }
      // End of Constructor
      
      
      //start Method to go to the JobTeamAddEditStaff page
      public Pagereference AddStaffs()
       {
           String theId=ApexPages.CurrentPage().getParameters().get('id');
           PageReference p = Page.JobTeamAddEditStaff;
           p.setredirect(true);
           p.getParameters().put('id',theID); 
           return p;
       }
      //End Method to go to the JobTeamAddEditStaff page
      
      
      
 }