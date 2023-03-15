// This class is used to Display Jobs Under Client Detail
public with sharing class DisplayJobUnderClientDetail 
{
    // Global variables
    public List<Job__c> job{get;set;}
    String theID;
    public String strStatus{get;set;}
    integer count;
    integer countstr;
    public List<selectOption> getStatusList() 
    {
        List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
         optionList.add(new selectOption('All Jobs', 'All Jobs')); 
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
        
        return optionList;  
    }
    // End of Global variables
    
    // Start Constructor
     public DisplayJobUnderClientDetail() 
     {    
         strStatus= 'Active';
         theID = ApexPages.CurrentPage().getParameters().get('id');
         job=[Select id,Name,JS_Client__c,Campaign__c,Job_Auto_Number__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: theId and Status__c = :'Active' ORDER BY JOB_Auto_NUmber__c LIMIT 1000];
     }
     // End of Constructor
     
     public void populateJobList()
    {
     
     count = [select count() from Job__c where JS_Client__c =: theId];
     if(strStatus == 'All Jobs')
     {
      countstr = [select count() from Job__c where JS_Client__c =: theId ];
      }
      else
      {
        countstr = [select count() from Job__c where JS_Client__c =: theId and Status__c = :strStatus ];
      }
    
    /* if(strStatus == 'All Jobs' )
      job=[Select id,Name,JS_Client__c,Campaign__c,Job_Auto_Number__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: theId ORDER BY JOB_Auto_NUmber__c LIMIT 1000];
    else
      job=[Select id,Name,JS_Client__c,Campaign__c,Job_Auto_Number__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c limit 1000 ];
      system.debug('lst :::::::::::::::;; ' + job.size());*/ 
      if(strStatus == 'All Jobs')
      {
      
          if(count>1000)
          {
            job=[Select id,Name,JS_Client__c,Campaign__c,Job_Auto_Number__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: theId ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
          }else
          {
            job=[Select id,Name,JS_Client__c,Campaign__c,Job_Auto_Number__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: theId ORDER BY JOB_Auto_NUmber__c LIMIT 1000 ];
          }
      }
      else
      {
          if(countstr >1000 )
          {
            job=[Select id,Name,JS_Client__c,Campaign__c,Job_Auto_Number__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c DESC limit 1000 ];
          }else
          {
            job=[Select id,Name,JS_Client__c,Campaign__c,Job_Auto_Number__c,JS_Client_Contact__c,Completion_Date__c,Schedule_Template__c,Media_Types__c,Start_Date__c,Status__c,Specification_Template__c,Number_of_Days__c,Due_Date__c from Job__c where JS_Client__c =: theId and Status__c = :strStatus ORDER BY JOB_Auto_NUmber__c limit 1000 ];
          }
      }
      
    }
     
        
    // Start Test Coverage Code
     static testMethod void DisplayJobUnderClient()
    {
           Client__c a = new Client__c();
            //Job__c testJob1=new Job__c(Name='Job011',Start_Date__c=System.Today(),Media_Types__c='test',Schedule_Template__c='test',Specification_Template__c='Test1',Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
           
             // Instantiate the extention instance with the Custom Controller
         
           DisplayJobUnderClientDetail ext=new DisplayJobUnderClientDetail();
           
           DisplayJobUnderClientDetail ext1=new DisplayJobUnderClientDetail();
           ext.strStatus = 'All Jobs';
           ext.populateJobList();
           ext.strStatus = 'Active';
           ext.populateJobList();
           
          ext.strStatus= 'Active';
          String strStatus1 = ext.strStatus;
           List<SelectOption> options5 = ext.getStatusList();
           
           System.assertEquals(a.id,ext1.theID);      
    } 
     // End of test Method 
}// End of Class