// This class is used to displat Tasks in Calendar of selected Job
public with sharing class DisplayTasksInCalendar
{
    // Global variables
   /* public JsonObject json{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    public String jsonString{get;set;}
    public String strName{get;set;}
    public String strJobId{get;set;}
    public Id jobId{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End of Global variables 
        
    // Start Constructor 
    
    public DisplayTasksInCalendar(ApexPages.StandardController controller)
    {
        // To display Subscriber Organization Logo
        
          imageURL = '/servlet/servlet.FileDownload?file='; 
          string logo=ESAPI.encoder().SFDC_HTMLENCODE('JobSuite_OrganizationLogo');
          lstDoc = [Select Id, Name, Body from Document where Name =:logo LIMIT 1];
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
        
        jobId=ESAPI.encoder().SFDC_HTMLENCODE(ApexPages.CurrentPage().getParameters().get('Id'));
        string Act=ESAPI.encoder().SFDC_HTMLENCODE('Active');
        lstJT=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where Job__c=:jobId and Status__c=:Act Order By Name];
        
        Job__c j=[Select Id,Name,Job_Id__c from Job__c where Id=: jobId];
        strName=ESAPI.encoder().SFDC_HTMLENCODE(j.Name);
        strJobId=j.Job_Id__c;
        
        json=new JsonObject();
        LIst<JSONObject.Value> values=new List<JSONObject.value>();
        
        if(!lstJT.isEmpty())
        {
            for(Job_Task__c c:lstJT)
            {
                try
                {
                    JSONObject cjson=new JSONObject();        
                    cjson.putOpt('"id"', new JSONObject.value(c.Id));
                    String str=c.Id;
                    
                    string strTaskName = c.Name;
                    string strJobName = c.Job__r.Name;
                    if(strTaskName.contains('"'))
                    {
                        strTaskName = strTaskName.replaceAll('"','\'');
                    }
                    if(strJobName.contains('"'))
                    {
                        strJobName = strJobName.replaceAll('"','\'');
                    }
                    
                    cjson.putOpt('"title"',new JSONObject.value(strTaskName));
                    cjson.putOpt('"staff"',new JSONObject.value(c.Assigned_Users__c));
                    cjson.putOpt('"status"',new JSONObject.value(c.Status__c));
                    cjson.putOpt('"job"',new JSONObject.value(strJobName));
                    Datetime dt1 = datetime.newInstance(c.Revised_Due_Date__c.year(), c.Revised_Due_Date__c.month(),c.Revised_Due_Date__c.day());
                    Long startDateTime = dt1.getTime()/1000;
                    cjson.putOpt('"start"', new JSONObject.value(startDateTime.intValue()));
                    values.add(new JSONObject.value(cjson));
                }
                catch(Exception e)
                {
                  
                }
            }
        }
        else
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This Job has no Tasks to display on Calendar'));
        }
        // Prepare JSONString which will be used to display Task in Calendar
        json.putOpt('events', new JSONObject.value(values));
        System.debug('Json Value :'+json);
        jsonString = json.ValuetoString();
        System.debug('jsonString : '+jsonString);
        jsonString = jsonString.replace('{events: [' , '[');
        jsonString = jsonString.replace('}]}' , '}]');
        System.debug('My Json String is'+jsonString);
       //jsonString= ESAPI.encoder().SFDC_HTMLENCODE(jsonString);
    }
    // End Constructor 

    // Method called on to handle Cancel button 
    public Pagereference cancel()
    {
        Pagereference p=new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
        p.setRedirect(true);
        return p;
    }
    // End Cancel method 
/*
    // Test Coverage 
    static testMethod void test_DisplayTasksInCalendar()
   {
         Job_Number_Setting__c customSetting952 = new  Job_Number_Setting__c(Name= 'yy');

              insert customSetting952;
        
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 905');
             
               insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 905',Media_Types__c=testMedia.Id);
             
               insert testST;
                 
         Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 905',Schedule_Template__c=testST.Id);
         
                insert testScheduleTask1;

         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 905');
         
                insert testSpec;
                
         Job__c testJob1=new Job__c(Name='Test Job 905',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c='Active');
         
                insert testJob1;
         System.assertEquals('Test Job 905',testJob1.Name);
                 
         Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 905',Status__c='Active',Revised_Due_Date__c=System.Today(),Job__c=testJob1.Id);
         
                insert testJT;    
            
            //To handle If part in constructor 
           ApexPages.currentPage().getParameters().put('id',testJob1.id);          
           
           // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.standardController(testJob1);
           
           // Instantiate the extention instance with the standardcontroller
           
           DisplayTasksInCalendar obj=new DisplayTasksInCalendar(con);
           ApexPages.Pagereference pg=obj.cancel();
       
           // To handle Else part in constructor 
           Job__c testJob2=new Job__c(Name='Test Job 906',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c='Active');
         
                 insert testJob2;
           System.assertEquals('Test Job 906',testJob2.Name);
                 
           ApexPages.currentPage().getParameters().put('id',testJob2.id);    
                 
           // Instantiate the standard controller with the Job
           ApexPages.StandardController con2=new ApexPages.standardController(testJob2);
           
           // Instantiate the extention instance with the standard controller
           DisplayTasksInCalendar obj2=new DisplayTasksInCalendar(con2);
    } // End Test Coverage*/
}// End of Class