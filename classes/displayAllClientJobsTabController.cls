/* This class is used to display list of Job to Client Contact */
public with sharing class displayAllClientJobsTabController 
{ 
   // Global variables 
  /*  public List<Job__c> lstJob1{get;set;}
    public String strClientContact;
    public String strClient{get;set;}
    public string selectedItem{get;set;}
    String listName;
    // End Global variables
    
    // Start Constructor
  
    public displayAllClientJobsTabController(ApexPages.StandardController controller) 
    {
        strClientContact=UserInfo.getName();
        Client_Contact__c c=[select Name,Client__r.Name from Client_Contact__c where Name=: strClientContact limit 1];
        strClient=c.Client__r.Name;
        lstJob1=[Select Name,Job_Auto_Number__c,Schedule_Template__r.Name,Job_Id__c,Start_Date__c,Due_Date__c,Status__c from Job__c where JS_Client__r.Name=:strClient];
    }
    // End Constructor 

    // Method called on to display Jobs based on selected Status of Job 
    public void filterJobs()
    {
        strClientContact=UserInfo.getName();
        Client_Contact__c c=[select Name,Client__r.Name from Client_Contact__c where Name=: strClientContact limit 1];
        strClient=c.Client__r.Name;
        lstJob1=new List<Job__c>();
    
        if(selectedItem=='All')
        {
            lstJob1=[Select Name,Job_Auto_Number__c,Schedule_Template__r.Name,Start_Date__c,Due_Date__c,Status__c from Job__c where Client__r.Name=:strClient];
        }
        if(selectedItem=='Status is Active')
        {
           lstJob1=[Select Name,Job_Auto_Number__c,Schedule_Template__r.Name,Start_Date__c,Due_Date__c,Status__c from Job__c where JS_Client__r.Name=:strClient and Status__c=: 'Active'];
        }
        if(selectedItem=='Status is Cancelled')
        {
           lstJob1=[Select Name,Job_Auto_Number__c,Schedule_Template__r.Name,Start_Date__c,Due_Date__c,Status__c from Job__c where JS_Client__r.Name=:strClient and Status__c=: 'Cancelled'];
        }
         if(selectedItem=='Status is Completed')
        {
           lstJob1=[Select Name,Job_Auto_Number__c,Schedule_Template__r.Name,Start_Date__c,Due_Date__c,Status__c from Job__c where JS_Client__r.Name=:strClient and Status__c=: 'Completed'];
        }
        if(selectedItem=='Status is On Hold')
        {
           lstJob1=[Select Name,Job_Auto_Number__c,Schedule_Template__r.Name,Start_Date__c,Due_Date__c,Status__c from Job__c where JS_Client__r.Name=:strClient and Status__c=: 'On Hold'];
        }
         if(selectedItem=='Status is Requested')
        {
           lstJob1=[Select Name,Job_Auto_Number__c,Schedule_Template__r.Name,Start_Date__c,Due_Date__c,Status__c from Job__c where JS_Client__r.Name=:strClient and Status__c=: 'Requested'];
        }
        
     }
     // End filterJobs method
    
    // list of Items to populate Status picklist
    public List<SelectOption> getItems()
    {
        List<SelectOption> options=new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Status is Active','Status is Active'));
        options.add(new SelectOption('Request is Cancelled','Request is Cancelled'));
        options.add(new SelectOption('Status is Completed','Status is Completed'));
        options.add(new SelectOption('Request is On Hold','Request is On Hold'));
        options.add(new SelectOption('Status is Requested','Status is Requested'));
   return options;
    }
    // End getItems method
    
*/   
   
}
// End of Class