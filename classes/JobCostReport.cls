// This class is used to generate Job Cost Report
public with sharing class JobCostReport 
{
    // Global variables
    public DateTime today{get;set;}
    public String JName {get; set;}
    public List<Campaign__c> allAccs {get; set;}    
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    
    public static boolean firstRun = true; 
    // End of Global variable


    // Start Constructor
    public JobCostReport()
     {
         // Code to display Subscriber Logo
         
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
           // End of Code to display Subscriber Logo
           
          today=System.NOW();
          allAccs=[select id,Name,(Select Id,Job_Id__c,Flag__c,Job_Auto_Number__c,Name,Difference_PO_Invoice__c,Estimate_Total__c,PO_Amount__c,Invoice_Actual_Amounts__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c from jobs__r where Status__c=: 'Active' Order By Name Limit 5000) from Campaign__c WITH SECURITY_ENFORCED limit 5000];
     }
     // End of Constructor

 /*  
    Public List<cNodes> hierarchy;
    
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
             List<Job__c> tempchildren = [Select Id,Name,Job_Id__c,Client__c,Client__r.Name,Campaign__c,Difference_PO_Invoice__c,Estimate_Total__c,PO_Amount__c,Invoice_Actual_Amounts__c,Completion_Date__c,Start_Date__c,Due_Date__c from Job__c where Campaign__c = :tempparent[i].Id Order By Name];
             hierarchy.add(new cNodes(tempparent[i],tempchildren));
        }   
         return hierarchy;
    } 
    
    */
     
} // End of Class