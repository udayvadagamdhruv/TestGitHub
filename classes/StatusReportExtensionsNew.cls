// This class is used to generate Status Report
//Status Report displays all Active Jobs with their Next Active Task Due

public with sharing class StatusReportExtensionsNew 
{
   // Start Global variables
    public DateTime today{get;set;}
    String NextTaskDue;
    public String JName {get; set;}
   // public Map<string, List<Job__c> > jbmap {get; set;}
   // public String getNextTaskDue() { return NextTaskDue; }
   // public void setNextTaskDue(String s) {  this.NextTaskDue = s; }
    
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End Global variables

  //  public List<Client__c> allClients {get; set;}
    
    // Start Constructor
    public StatusReportExtensionsNew()
     {
         today=System.Today();
         
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
        // End of code to display Subscriber Logo
       //   allClients=[select id,Name,(Select Id,Job_Id__c,Name,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c from jobs__r Order By Name Limit 5000) from Client__c limit 5000];
     }
     // End of Constructor

    public class cNodes
    {
        public List<Job__c> parent {get; set;}
        Public string gparent {get;set;}

     public cNodes(string gp, List<Job__c> p)
     {
         parent = p;
         gparent = gp;
     }
    }


    public List<cNodes> hierarchy;

    // This method is called on to retrieve Jobs to display on Report
 
    
     public Map<string, List<Job__c> > getjbmap()
    {
        hierarchy = new List<cNodes>();
        set<String> clset = new set<String>();
        set<String> clntSet = new set<String>();
        List<Client__c> tempparent = [Select Id,Name from Client__c where Id IN ( select JS_Client__c from Job__c where JS_Client__c != NULL and Status__c='Active') WITH SECURITY_ENFORCED Order By Name LIMIT 1000];
        for(Client__c cl:tempparent)
        {
           clset.add(cl.id);
           clntSet.add(cl.Name);
        }
        System.debug('Id Set size+======= ' + clset.size());  
        System.debug('TempParent size ' + tempparent.size());
        List<Job__c> tempchildren1 = [Select Id,Name,Job_Id__c,Flag__c,Job_Auto_Number__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c,(select id,Name,Due_Date__c,Revised_Due_Date__c from Job__c.Job_Task__r abc where Status__c =: 'Active' order by Task_Order__c,Revised_Due_Date__c Limit 1) from Job__c where JS_Client__r.Id IN: clset and Status__c='Active' and Js_Client__c != '' WITH SECURITY_ENFORCED  Order By Name];
        system.debug('$$$$$$$$$'+ tempchildren1.size() );
       /* for (Integer i =0; i< tempparent.size() ; i++)
        {
                 System.debug('TempParent name ' + tempparent[i].Name);
            List<Job__c> tempchildren = [Select Id,Name,Job_Id__c,Flag__c,Job_Auto_Number__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c,(select id,Name,Due_Date__c from Job__c.Job_Task__r abc where Status__c =: 'Active' order by Due_Date__c Limit 1) from Job__c where JS_Client__c = :tempparent[i].Id and Status__c='Active' Order By Name];
           // if (tempchildren.size() > 0)
           // {
                hierarchy.add(new cNodes(tempparent[i],tempchildren));
           // }
            
         }*/
         Map<string, List<Job__c> > jbmap1  = new  Map<string, List<Job__c> >();
         
         for(Job__c jb: tempchildren1 )
         {
             if( jbmap1.get(jb.JS_Client__r.Name)!=Null)
             {
               list<Job__c> jobs = jbmap1.get(jb.JS_Client__r.Name);
               jobs.add(jb);
               jbmap1.put(jb.JS_Client__r.Name,jobs);
             }
             else
             {
                 jbmap1.put(jb.JS_Client__r.Name,new List<Job__c>{jb});
             }
         
         }
        integer int1 = jbmap1.size();
        system.debug('!!!!!!!!'+int1);
        //Set<string> clientSet = jbmap.get()//new Set<String>();
        for(string str : clntSet)
        {
          if(jbmap1.get(str)!=null)
            hierarchy.add( new cNodes(str,jbmap1.get(str)));
        }
         
          
        return jbmap1;   
    } 
    
    
  /*    public List<cNodes> getmainnodes()
    {
        hierarchy = new List<cNodes>();
        set<String> clset = new set<String>();
        set<String> clntSet = new set<String>();
        List<Client__c> tempparent = [Select Id,Name from Client__c where Id IN ( select JS_Client__c from Job__c where JS_Client__c != NULL and Status__c='Active') Order By Name LIMIT 1000];
        for(Client__c cl:tempparent)
        {
           clset.add(cl.id);
           clntSet.add(cl.Name);
        }
        System.debug('Id Set size+======= ' + clset.size());  
        System.debug('TempParent size ' + tempparent.size());
        List<Job__c> tempchildren1 = [Select Id,Name,Job_Id__c,Flag__c,Job_Auto_Number__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c,(select id,Name,Due_Date__c from Job__c.Job_Task__r abc where Status__c =: 'Active' order by Due_Date__c Limit 1) from Job__c where JS_Client__r.Id IN: clset and Status__c='Active' and Js_Client__c != '' Order By Name];
        system.debug('$$$$$$$$$'+ tempchildren1.size() );
       // for (Integer i =0; i< tempparent.size() ; i++)
       // {
       //          System.debug('TempParent name ' + tempparent[i].Name);
       //     List<Job__c> tempchildren = [Select Id,Name,Job_Id__c,Flag__c,Job_Auto_Number__c,JS_Client__c,JS_Client__r.Name,Campaign__c,Completion_Date__c,Start_Date__c,Due_Date__c,(select id,Name,Due_Date__c from Job__c.Job_Task__r abc where Status__c =: 'Active' order by Due_Date__c Limit 1) from Job__c where JS_Client__c = :tempparent[i].Id and Status__c='Active' Order By Name];
           // if (tempchildren.size() > 0)
           // {
                hierarchy.add(new cNodes(tempparent[i],tempchildren));
           // }
            
        // }
         //jbmap  = new  Map<string, List<Job__c> >();
         
         for(Job__c jb: tempchildren1 )
         {
             if( jbmap.get(jb.JS_Client__r.Name)!=Null)
             {
               list<Job__c> jobs = jbmap.get(jb.JS_Client__r.Name);
               jobs.add(jb);
               jbmap.put(jb.JS_Client__r.Name,jobs);
             }
             else
             {
                 jbmap.put(jb.JS_Client__r.Name,new List<Job__c>{jb});
             }
         
         }
        integer int1 = jbmap.size();
        system.debug('!!!!!!!!'+int1);
        //Set<string> clientSet = jbmap.get()//new Set<String>();
        for(string str : clntSet)
        {
          if(jbmap.get(str)!=null)
            hierarchy.add( new cNodes(str,jbmap.get(str)));
        }
         
          
        return hierarchy;   
    } */
    
    // End of method getmainnodes
    
   
}
// End Class