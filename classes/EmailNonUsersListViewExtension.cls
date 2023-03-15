public with sharing class EmailNonUsersListViewExtension {

     // Global Variables 
     
      public List<Task> Tasks{get;set;}
      public String jobId;
      
     // End of Global variables 
      
     // Start Constructor
     public EmailNonUsersListViewExtension (ApexPages.StandardController controller)
      {
         jobId=System.currentPagereference().getParameters().get('id');
         Tasks=[Select Id,Subject,Status,whatid,LastmodifiedDate,Email_Address__c,Description,CreatedByid,ownerid,Sender_Address__c from Task where whatid =: jobId AND Status='Completed' WITH SECURITY_ENFORCED order by CreatedDate DESC];
      }
      // End of Constructor
      
      
      
      

}