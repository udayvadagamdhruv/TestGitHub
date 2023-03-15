// This class is used to Display Jobs Under Client Contact Detail
public with sharing class DisplayJobUnderClientContactDetail 
{
  /*  // Global variables
    transient public List<Job__c> job{get;set;}
    String theID;
    // End of Global variables
    
     // Start Constructor
     public DisplayJobUnderClientContactDetail() 
     {
         theID = ApexPages.CurrentPage().getParameters().get('id');
         job=[Select id,Name,JS_Client__c,Job_Auto_Number__c,Campaign__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client_Contact__c =: theId ORDER BY Job_Auto_Number__c];
     }
     // End of Constructor
 
    // Test Coverage Code
      static testMethod void DisplayJobUnderClientContact()
       {
           Contact c = new Contact();
        
             // Instantiate the extention instance with the Custom Controller
    
           DisplayJobUnderClientContactDetail ext=new DisplayJobUnderClientContactDetail();
    
           DisplayJobUnderClientContactDetail ext1=new DisplayJobUnderClientContactDetail();
           System.assertEquals(c.id,ext1.theID);
        } // End of test Method*/
}// End of Class