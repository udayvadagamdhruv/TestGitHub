// This class is used to generate Job Log Sheet Report
// Job Log Sheet display all Jobs under Campaign
public with sharing class JobLogSheetTest1 
{
    // Global variables
     public String JName {get; set;}
     public DateTime dt{get;set;}
     public Date today{get;set;}
     public List<Campaign__c> allJobs {get; set;}
     public List<Document> lstDoc;
     public String imageBody{get;set;}
     public String imageURL{get;set;}
     public boolean imageNotFound{get;set;}
     // End of Global variables
 
   
  
     // Start Constructor
     public JobLogSheetTest1()
     {
        // Code to display subscriber logo in PDF header
        
        // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
        
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
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
        // End of code for Subscriber Logo
         today=System.Today();
         allJobs=[select id,Name,(Select Id,Job_Id__c,Job_Auto_Number__c,Flag__c,Name,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c from jobs__r Order By JS_Client__r.Name desc,Job_Auto_Number__c Limit 5000) from Campaign__c WITH SECURITY_ENFORCED limit 5000];
     }
     // End of Constructor
     
 /*  Public List<cNodes> hierarchy; 

   public class cNodes
    {
         public List<Job__c> parent {get; set;}
         Public Campaign__c gparent {get;set;}
         public cNodes(Campaign__c  gp, List<Job__c> p)
         {
             parent = p;
             gparent = gp;
         }
    }  
    

    

   Public List<cNodes> getmainnodes()
    {
        hierarchy = new List<cNodes>();
        List<Campaign__c> tempparent = [Select Id,Name from Campaign__c LIMIT 10000];
        for (Integer i =0; i< tempparent.size() ; i++)
        {
               List<Job__c> tempchildren = [Select Id,Name,Job_Id__c,Client__c,Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c from Job__c where Campaign__c = :tempparent[i].Id Order By Name Limit 800];
               hierarchy.add(new cNodes(tempparent[i],tempchildren));
        }   
        return hierarchy;
    } 
    
    */ 

   
}
// End of Class