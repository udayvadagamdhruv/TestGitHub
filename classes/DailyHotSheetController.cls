// This class is used to display Daily Hot Sheet Report
// Daily Hot Sheet Report displays Tasks assigned to Role which are due today. (Revised Due Date = Today)

public with sharing class DailyHotSheetController 
{    
    // Start Global Variables
    public List<Job_Task_Role__c> lstJTR{get;set;}
    public Date today{get;set;}
    public List<cNodes> hierarchy;
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End of Global Variables
    
    // Start Constructor
    public DailyHotSheetController()
    {
        // Code to display Subscriber Logo
        
        // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
        
         today=System.Today();
         imageURL = '/servlet/servlet.FileDownload?file='; 
         lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo'  LIMIT 1];//WITH SECURITY_ENFORCED
         if(!lstDoc.isEmpty())
         {
               String imageId =  lstDoc[0].Id;
               imageBody = imageURL+imageId; 
               imageNotFound = False;
         }    
         else
         {
               imageNotFound = True;
         }
         // End of code to diplay Subscriber Logo
    }
    // End of Constructor
    
    // This class is used to hold Task Associated with role
    public class cNodes
    {
           public List<Job_Task_Role__c> parent{get;set;} 
           public UserRole gParent{get;set;}
           public cNodes(UserRole ur, List<Job_Task_Role__c> jtr)
           {
               parent=jtr;
               gParent=ur;
           }
    }
    // End of class cNodes
    
    // This method is used to retrieve data to display on report
    public List<cNodes> getMainNodes()
    {
        hierarchy=new List<cNodes>();
        
        //List<Job_Task_Role__c> l=[Select Id,Name,Job_Task__r.Name from Job_Task_Role__c where Job_Task__r.Status__c='Active'];
        List<Job_Task_Role__c> lst=[Select Id,Name, Job_Task__c, Job_Task__r.Name, Job_Task__r.Revised_Due_Date__c,Job_Task__r.Due_Date__c,Job_Task__r.Job__r.Name,Job_Task__r.Job__r.Job_Auto_Number__c,Job_Task__r.Job__r.Status__c from Job_Task_Role__c where Job_Task__r.Revised_Due_Date__c=: System.Today() and Job_Task__r.Job__r.Status__c=:'Active' and Job_Task__r.Status__c=:'Active' WITH SECURITY_ENFORCED ORDER BY Job_Task__r.Job__r.Job_Auto_Number__c];
        List<String> str=new LIst<String>();
        for(Job_Task_Role__c jtr:lst)
        {
            str.add(jtr.Name);
        }
        List<UserRole> uRoles=[Select Id,Name from UserRole where Name =: str  ORDER BY Name LIMIT 10000 ];//WITH SECURITY_ENFORCED
        
        for(Integer i=0;i< uRoles.size();i++)
        {
            List<Job_Task_Role__c> tempChild=[Select Id,Name,User__c, Job_Task__c, Job_Task__r.Name, Job_Task__r.Revised_Due_Date__c,Job_Task__r.Due_Date__c,Job_Task__r.Job__r.Name,Job_Task__r.Job__r.Job_Auto_Number__c from Job_Task_Role__c where Name =: uRoles[i].Name and Job_Task__r.Revised_Due_Date__c=: System.Today() and Job_Task__r.Job__r.Status__c=:'Active' and Job_Task__r.Status__c=:'Active'  WITH SECURITY_ENFORCED ORDER BY Job_Task__r.Job__r.Job_Auto_Number__c];
            hierarchy.add(new cNodes(uRoles[i],tempChild));
        }
        return hierarchy;
    }
    // End of method getMainNodes
    
    
    // Start Test Coverage Code
        
}// End of Class