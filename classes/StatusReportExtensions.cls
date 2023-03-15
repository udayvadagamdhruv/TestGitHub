// This class is used to generate Status Report
//Status Report displays all Active Jobs with their Next Active Task Due

public with sharing class StatusReportExtensions 
{
   // Start Global variables
   /* public DateTime today{get;set;}
    String NextTaskDue;
    public String JName {get; set;}
    public String getNextTaskDue() { 
        return NextTaskDue; 
    }
    public void setNextTaskDue(String s) {  
        this.NextTaskDue = s; 
    }
    
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End Global variables
    public List<cNodes> hierarchy1{get;set;}
  //  public List<Client__c> allClients {get; set;}
    
    // Start Constructor
    public StatusReportExtensions()
     {
         today=System.Today();
         hierarchy1 = new List<cNodes>();
         cNodes ctest= new cNodes(new Client__c(), new List<Job__c>());
         // Code to display Subscriber Logo
         // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
         
         imageURL = '/servlet/servlet.FileDownload?file='; 
         lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
         if(test.isRunningTest()){
             Document d = new Document(Name='test', Body=blob.valueof('test'));
             lstDoc = [Select Id, Name, Body from Document LIMIT 1];
         }
         if(!lstDoc.isEmpty())
         {
           String imageId =  lstDoc[0].Id;imageBody = imageURL+imageId; imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }
        // End of code to display Subscriber Logo
       //   allClients=[select id,Name,(Select Id,Job_Id__c,Name,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c from jobs__r Order By Name Limit 5000) from Client__c limit 5000];
     }
     // End of Constructor

    public class cNodes
    {
        public List<Job__c> parent {get; set;}
        Public Client__c gparent {get;set;}

     public cNodes(Client__c  gp, List<Job__c> p)
     {
         parent = p;
         gparent = gp;
     }
    }


    public List<cNodes> hierarchy;

    // This method is called on to retrieve Jobs to display on Report
    public List<cNodes> getmainnodes()
    {
        hierarchy = new List<cNodes>();
        set<Id> clset = new set<id>();
        List<Client__c> tempparent = [Select Id,Name from Client__c where Id IN ( select JS_Client__c from Job__c where JS_Client__c != NULL and Status__c='Active') Order By Name LIMIT 1000];
        for(Client__c cl:tempparent)
        {
           clset.add(cl.id);
        }
        System.debug('Id Set size+======= ' + clset.size());  
        System.debug('TempParent size ' + tempparent.size());
        List<Job__c> tempchildren1 = [Select Id,Name,Job_Id__c,Flag__c,Job_Auto_Number__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c,(select id,Name,Due_Date__c from Job__c.Job_Task__r abc where Status__c =: 'Active' order by Due_Date__c Limit 1) from Job__c where JS_Client__r.Id IN: clset and Status__c='Active' and Js_Client__c != '' Order By Name];
        system.debug('$$$$$$$$$'+ tempchildren1.size() );
        for (Integer i =0; i< tempparent.size() ; i++)
        {
                 System.debug('TempParent name ' + tempparent[i].Name);
            List<Job__c> tempchildren = [Select Id,Name,Job_Id__c,Flag__c,Job_Auto_Number__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c,(select id,Name,Due_Date__c from Job__c.Job_Task__r abc where Status__c =: 'Active' order by Due_Date__c Limit 1) from Job__c where JS_Client__c = :tempparent[i].Id and Status__c='Active' Order By Name];
           // if (tempchildren.size() > 0)
           // {
                hierarchy.add(new cNodes(tempparent[i],tempchildren));
           // }
            
         }
          
         
         
          
        return hierarchy;   
    } 
    // End of method getmainnodes
    
    // Start Test Coverage
    
    static testMethod void Test_StatusReportExtensions()
    {
         Job_Number_Setting__c customSetting992 = new  Job_Number_Setting__c(Name= 'yy');

              insert customSetting992;
            
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1004');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1004',Media_Types__c=testMedia.Id);
             
                 insert testST;
          
          Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schdule Task 1004',Days__c=2,Schedule_Template__c=testST.id);
              insert testSchedule;       
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1004');
                insert testSpec;
                
           Campaign__c testCamp=new Campaign__c(Name='Test Camp 1004');    
              insert testCamp;  
   
           Client__c testClient=new Client__c(Name='Test Account 1004');
               insert testClient;
               
           Client_Contact__c testContact=new Client_Contact__c(Name='Test Client SRI',First_Name__c='Test Client',Last_Name__c='SRI',Client__c=testClient.id,Email__c='test1004@SFDC.com');
               insert testContact;    
                      
          Job__c testJob1=new Job__c(Name='Test Job 1004',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
               insert testJob1;
               
          System.assertEquals('Test Job 1004',testJob1.Name);    
               
          // Instantiate the extention instance with the Custom controller 
          StatusReportExtensions ext=new StatusReportExtensions();
          
          // Invoke the primary method on the extension
          
          ext.getmainnodes();   
        ext.getNextTaskDue();
        ext.setNextTaskDue('test');
    }   */
    // End Test Coverage
}
// End Class