// This class is used to display tasks in Calendar for selected Client
public with sharing class DisplayCalendarFilterByClientExtension {
    /*
    // Global variables
        public JsonObject json{get;set;}
        public List<Job_Task__c> lstJT{get;set;}
        public List<Job__c> lstJob{get;set;}
        public string jsonString{get;set;}
        public Id clientId{get;set;}
        public String strClient{get;set;}
        Set<Id> stJobId=new Set<Id>();
        public Client__c objClient{get;set;}
        public List<Document> lstDoc;
        public String imageBody{get;set;}
        public String imageURL{get;set;}
        public boolean imageNotFound{get;set;}
    // End of Global variable
    
    // Start Constructor
    public DisplayCalendarFilterByClientExtension(ApexPages.StandardController controller) 
    {
         // Code to display Subsriber Organization Logo
         // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed

       imageURL = '/servlet/servlet.FileDownload?file='; 
       lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
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
        // End of code to display Subscriber Organization Logo
        
        clientId=ApexPages.CurrentPage().getParameters().get('id');
        objClient=[Select id,Name from Client__c where id =: clientId];
        strClient=objClient.Name;
        
        // Retrieve active jobs related to Client
        lstJob=[Select id,Name,JS_Client__r.Name from Job__c where Status__c=: 'Active' and JS_Client__c=:clientId];
        
        for(Job__c j:lstJob)
        {
            stJobId.add(j.id);
        }
        
        // Retrieve Active Task from Active Jobs
        
        lstJT=[Select Id,Name,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Revised_Due_date__c from Job_Task__c where Job__c IN : stJobId and Status__c=: 'Active'];
        json=new JsonObject();
        List<JsonObject.Value> values=new List<JsonObject.Value>();
        
        if(!lstJt.isEmpty())
        {
            for(Job_Task__c jt:lstJT)
            {
                try
                {
                    JsonObject cjson=new JsonObject();
                    cjson.putOpt('"id"',new JsonObject.value(jt.id));
                    
                    String strJobName = jt.Job__r.Name;
                    String strTaskName = jt.Name;
                    if(strJobName.contains('"'))
                    {
                        strJobName = strJobName.replaceAll('"','\'');
                    }
                    
                    if(strTaskName.contains('"'))
                    {
                        strTaskName = strTaskName.replaceAll('"','\'');
                    }
                    
                    String strJob_Task=strJobName +' : '+strTaskName;
                    cjson.putOpt('"title"',new JsonObject.value(strJob_Task));
                    cjson.putOpt('"staff"',new JsonObject.value(jt.Assigned_Users__c));
                    DateTime dt=DateTime.newInstance(jt.Revised_Due_Date__c.Year(),jt.Revised_Due_Date__c.month(),jt.Revised_Due_Date__c.Day());
                    Long lngTime=dt.getTime()/1000;
                    cjson.putOpt('"start"',new JsonObject.value(lngTime.intValue()));
                    values.add(new JsonObject.value(cjson));
                }
                catch(Exception e)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception occurred'));
                }
            }
        }
        else
        {
            // If there is no Active Task associated to Client
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'This Client has no Tasks to display on Calendar'));
        }
        // Prepare JSONString to display Task in Calendar 
        json.putOpt('events',new JsonObject.value(values));
        jsonString=json.ValueToString();
        jsonString = jsonString.replace('{events: [' , '[');
        jsonString = jsonString.replace('}]}' , '}]');
        System.debug('My Json String is : '+jsonString );
    }
    // End Constructor
    
    // This method is used to navigate User to Client Detail Page
    public pagereference clientView()
    {
         Pagereference p=new Pagereference('/apex/ClientViewPage?id='+clientId);
         p.setRedirect(true);
         return p;
    }
    // End of Method clientView
    
        //Start Test Coverage Code
    static testMethod void displayCalendarFilterByClient()
    {
            Job_Number_Setting__c customSetting953 = new  Job_Number_Setting__c(Name= 'yy');

                   insert customSetting953;
            
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 806');
             
                insert testMedia;
             
             Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 806',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 806');
                
                 insert testSpec;
                
              Client__c testClient=new Client__c(Name='Test Client 806');
                 
                 insert testClient;      
                
             Job__c testJob1=new Job__c(Name='Test Job 806',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,JS_Client__c=testClient.id,Status__c='Active');
         
                 insert testJob1;
             
             System.assertEquals('Test Job 806',testJob1.Name);    
                 
             Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 806',Status__c='Active',Job__c=testJob1.id,Revised_Due_Date__c=System.Today());
             
                 insert testJT; 
                 
             System.assertEquals('Test Job Task 806',testJT.Name);       
                 
             ApexPages.currentPage().getParameters().put('id',testClient.Id);
             
              // Instantiate the standard controller with the Client
              
             ApexPages.StandardController con=new ApexPages.standardController(testClient);
             
             // Instantiate the extention instance with the standardcontroller
             DisplayCalendarFilterByClientExtension obj=new DisplayCalendarFilterByClientExtension(con);
             
             ApexPages.Pagereference result=obj.ClientView();

             Client__c testClient1=new Client__c(Name='Test Client 807');
             insert testClient1;  
              
             ApexPages.currentPage().getParameters().put('id',testClient1.Id);
             
              // Instantiate the standard controller with the Client
             ApexPages.StandardController con1=new ApexPages.standardController(testClient1);
             
              // Instantiate the extention instance with the standardcontroller
             DisplayCalendarFilterByClientExtension obj1=new DisplayCalendarFilterByClientExtension(con1);
      }*/
    // End of Test Coverage Code
}
// End of Class