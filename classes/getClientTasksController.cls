// This Class is used to display Client Jobs
public with sharing class getClientTasksController
{

    // Start Global variables
   /* 
    private String soql {get;set;}  // the soql without the order and limit
    public String str{get;set;}
    public Job__c j{get;set;}
    public String strJTID{get;set;}
    public String strClientContact{get;set;}
    public String strClient{get;set;}
    public List<Job__c> lstJob{get;set;}
    public String strStatus;
    public String status12;
    public boolean blnShow{get;set;}  
    public String clientContactName{get; set;}    //added by yogini on 29-nov-12  
    // End of Global variables

     // the current sort direction. defaults to asc
    public String sortDir 
    {
        get { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
      
    // the current field to sort by. defaults to Name
    public String sortField 
    {
        get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
        set;
    }

    // Method called on to handle New Job Button
    public String getCreateNewJob() 
    {
       String p='/apex/CreateNewJobNew';
       return p;
    }
    // End getCreateNewJob method

   // toggles the sorting of query from asc<-->desc
    public void toggleSort() 
    {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
    }
  
    // runs the actual query
     public void runQuery() 
     {
         try 
         {
              lstJob = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 10000');              
              blnShow = true;
         }
         catch (Exception e) 
         {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
              blnShow = false;
           }
      }
  
    public pagereference runSearch()
    {
        status12 = Apexpages.currentPage().getParameters().get('status1');
        //commented by yogini on 29-nov-12        
//        soql = 'Select Name,Schedule_Template__r.Name,Job_Auto_Number__c,Start_Date__c,Due_Date__c,Status__c,JS_Client__r.Name from Job__c where Name != NULL and JS_Client__r.Name LIKE \''+strClient+'\'';
        soql = 'Select Name,Schedule_Template__r.Name,Job_Auto_Number__c,Start_Date__c,Due_Date__c,Status__c,JS_Client__r.Name from Job__c where Name != NULL and JS_Client_Contact__r.Name LIKE \''+clientContactName +'\'';        
    
        if (!status12.equals(''))
            //  soql += ' and Status__c LIKE \''+status12+'\' and Client__r.Name LIKE \''+strClient+'\'';
            soql += ' and Status__c LIKE \''+String.escapeSingleQuotes(Status12)+'\'';
            //  soql += ' and Status__c LIKE \''+String.escapeSingleQuotes(status)+'\'';
 
        // run the query again
        runQuery();
        return NULL;
    }
   
    
   // Start Custom Constructor
    public getClientTasksController()
    {
            strClientContact=UserInfo.getUserName();
            
            try
            {   
               Client_Contact__c c=[select Id,Name,Client__r.Name,Email__c from Client_Contact__c where UserName__c =: strClientContact LIMIT 1];
            
                strClient=c.Client__r.Name;
                          
                // init the controller and display some sample data when the page loads
                strStatus='Active';
//                soql = 'Select Name,Schedule_Template__r.Name,Job_Auto_Number__c,Start_Date__c,Due_Date__c,Status__c,JS_Client__C, JS_Client__r.Name from Job__c where Name != NULL and JS_Client__r.Name LIKE \''+strClient+'\' and Status__c LIKE \''+strStatus+'\'';
                //added by yogini on 29-nov-12
                clientContactName = c.Name;
                system.debug('client contact : ' + c.name + 'client name : ' +strClient + 'Current user :' + strClientContact);
                soql = 'Select Name,Schedule_Template__r.Name,Job_Auto_Number__c,Start_Date__c,Due_Date__c,Status__c,JS_Client__C, JS_Client__r.Name from Job__c where Name != NULL and JS_Client_Contact__r.Name LIKE \''+clientContactName+'\' and Status__c LIKE \''+strStatus+'\'';
                system.debug(soql);
                runQuery();                
                blnShow = true;
                
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not a valid Client Contact. Please contact the administration for access.'));     
                blnShow = false;
            }
    }
    
    // End Constructor
    
    // use apex to retrieve job status picklist values
    public List<String> status
    {
        get
        {
            if(status==NULL)
                {
                    status=new List<String>();
                    Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
                    for(Schema.PickListEntry f: field.getPickListValues())
                    {
                        status.add(f.getLabel());
                    }
                }
                 return status;
        }
        set;
    }
    
    
  // format the soql for display on the visualforce page
  
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 10000'; }
    set;
  }

    // Test Coverage 

   
    static testMethod void Test_getClientTasksController()
          {
               Profile p1=[Select Id, Name From Profile where Name=: 'System Administrator' LIMIT 1]; 
               Profile p2=[Select Id, Name From Profile where Name=: 'SP Client Contact' LIMIT 1]; 
               //Set up user 
    
                User u1 = [SELECT Id,Name,FirstName,LastName FROM User WHERE ISActive =: True and ProfileId=: p1.Id limit 1];
                
                User u2 = new User(FirstName = 'Test',
                           LastName = 'AFR',
                           Email = 'testContactAFR@SFDC.com',
                           Username='testContactAFR@SFDC.com',
                           ProfileId=p2.id,
                           Alias='test',
                           emailencodingkey='UTF-8',
                           languagelocalekey='en_US',
                           localesidkey='en_US',
                           timezonesidkey='America/Los_Angeles');
                insert u2;
        
                //Run As U2 
    
               System.RunAs(u2){
            
               Job_Number_Setting__c customSetting1020 = new  Job_Number_Setting__c(Name='NO');

                insert customSetting1020;
            
        
               Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1020');
             
                insert testMedia;
             
               Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1020',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
               Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 1020',Schedule_Template__c=testST.Id);
               
                  insert testScheduleTask1;

               Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1020');
                 
                  insert testSpec;
                
               Campaign__c testCamp=new Campaign__c(Name='Test Camp 1020');    
                 
                  insert testCamp;  
   
               Client__c testClient=new Client__c(Name='Test Account 1020');
                   
                   insert testClient;
               
               Client_Contact__c testContact=new Client_Contact__c(Name=u1.Name,Client__c=testClient.Id,First_Name__c=u1.FirstName,Last_Name__c=u1.LastName,Email__c='testContactAFR@SFDC.com',UserName__c='testContactAFR@SFDC.com');
                   
                   insert testContact;    
                      
               Job__c testJob1=new Job__c(Name='Test Job 1002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
              
                   insert testJob1;
                   
               System.assertEquals('Test Job 1002',testJob1.Name);     
              
               // Instantiate the extention instance with thecustom controller 
               getClientTasksController ext=new getClientTasksController();
               
               // Invoke the primary method on the extension
                ApexPages.CurrentPage().getParameters().put('status1','Active'); 
                ApexPages.pagereference p=ext.runSearch();
               ext.getcreateNewJob();
               ext.status=NULL;
                   list<string> ss = ext.status;
               ext.toggleSort();
               ext.runQuery();
               String strDebug=ext.debugSOQL;
            }// Run as U2            
     }// End of Test Coverage*/
}
// End of Class