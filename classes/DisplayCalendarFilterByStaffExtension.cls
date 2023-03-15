// This class is used to display tasks in Calendar for selected Staff
public with sharing class DisplayCalendarFilterByStaffExtension {
/*
    // Global variables
    public JsonObject json{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    public List<Job_Task_Role__c> lstJTR{get;set;}
    public List<Job__c> lstJob{get;set;}
    public String jsonString{get;set;}
    public String strStaff{get;set;}
    public String strCampaignId{get;set;}
    Set<Id> stJobId=new Set<Id>();
    Set<Id> stJobTaskId=new Set<Id>();
    Set<Id> stJobTaskRoleId=new Set<Id>();
    public List<Job_Task__c> lstJT1{get;set;}
    public Id staffId{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End of Global variables
    
    // Start Constructor 
    public DisplayCalendarFilterByStaffExtension(ApexPages.StandardController controller)
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
        
       staffId=ApexPages.CurrentPage().getParameters().get('id');
       
       // Retrieve Active Jobs
       lstJob=[Select Id,Name from Job__c where Status__c=: 'Active'];
       for(Job__c j:lstJob)
       {
           stJobId.add(j.id);
       }
       // Retrieve Active Tasks of Active Jobs
       lstJT=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' Order By Name];
       
       for(Job_Task__c jt: lstJT)
       {
           stJobTaskId.add(jt.id);
       } 
       
       Staff__c s=[Select Id,Name from Staff__c where Id=: staffId];
       strStaff=s.Name;
       System.debug('Select Role : '+strStaff);
       lstJTR=[Select Id,Job_Task__r.Name,Job_Task__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strStaff];
       
       for(Job_Task_Role__c jtr:lstJTR)
       {
           stJobTaskRoleId.add(jtr.Job_Task__c);
       }
        lstJT1=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where id In: stJobTaskRoleId and Status__c=:'Active' Order By Name];
        json=new JsonObject();
        List<JSONObject.Value> values=new List<JSONObject.value>();
        
        if(!lstJT1.isEmpty())
        {
            for(Job_Task__c c:lstJT1)
            {
                try
                {
                    JSONObject cjson=new JSONObject();        
                    cjson.putOpt('"id"', new JSONObject.value(c.Id));
                    String str=c.Id;
                    
                    //Code added for double quotes escape
                    String strJobName = c.Job__r.Name;
                    String strTaskName = c.Name;
                    if(strJobName.contains('"'))
                    {
                     strJobName = strJobName.replaceAll('"','\'');
                     System.debug('The job name contains the double quotes :: '+ strJobName );
                    }
                    if(strTaskName.contains('"'))
                    {
                        strTaskName = strTaskName.replaceAll('"','\'');
                    }
                    
                    // end of added code
                    
                    String str1=strJobName+' : '+strTaskName;
                    cjson.putOpt('"title"',new JSONObject.value(str1));
                    cjson.putOpt('"staff"',new JSONObject.value(c.Assigned_Users__c));
                    cjson.putOpt('"status"',new JSONObject.value(c.Status__c));
                    
                    //cjson.putOpt('"job"',new JSONObject.value(c.Job__r.Name));
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'This Staff has no Tasks to display on Calendar'));
        }
        // Prepare JSONString to display it into Calendar
        json.putOpt('events', new JSONObject.value(values));
        System.debug('Json Value :'+json);
        jsonString = json.ValuetoString();
        jsonString = jsonString.replace('{events: [' , '[');
        jsonString = jsonString.replace('}]}' , '}]');
        System.debug('My Json String is'+jsonString);
    }
    // End Constructor

    // Method called on handle Cancel button
    public Pagereference cancel()
    {
        Pagereference p=new Pagereference('/apex/StaffDetailPage?id='+staffId);
        p.setRedirect(true);
        return p;    
    }
    // End Cancel method

    // Start Test Coverage Code
        static testMethod void Test_DisplayCalendarFilterByStaffExtension()
        {
            Job_Number_Setting__c customSetting1006 = new  Job_Number_Setting__c(Name= 'NO');

            insert customSetting1006;
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 806');
             
                 insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 806',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
            Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 806');
            
                 insert testSpec;
                
            Client__c testClient=new Client__c(Name='Test Client 806');
         
                  insert testClient;      
                
           Job__c testJob1=new Job__c(Name='Test Job 806',Job_Auto_Number__c = 'J 806', Flag__c = True ,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,JS_Client__c=testClient.id,Status__c='Active');
         
                 insert testJob1;
                 
           System.assertEquals('Test Job 806',testJob1.Name);       
                 
           Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 806',Status__c='Active',Job__c=testJob1.id,Revised_Due_Date__c=System.Today());

                 insert testJT;        
                 
           Job_Task_Role__c testJTR=new Job_Task_Role__c(Name='Designer',User__c='Ajay Kumar',Job_Task__c=testJT.id);
         
                 insert testJTR;        
                 
          Staff__c testStaff=new Staff__c(First_Name__c='Ajay',Last_Name__c='Kumar',Name='Ajay Kumar',UserName__c='test@test.com');
                 insert testStaff;
                 
          ApexPages.currentPage().getParameters().put('id',testStaff.Id);
          
          // Instantiate the standard controller with the Staff
          ApexPages.StandardController con=new ApexPages.standardController(testStaff);
          
           // Instantiate the extention instance with the standardcontroller
          DisplayCalendarFilterByStaffExtension ext=new DisplayCalendarFilterByStaffExtension(con);
          
          // Invoke the primary method on the extension
          ApexPages.Pagereference result1=ext.cancel();
         
         Staff__c testStaff1=new Staff__c(First_Name__c='Test',Last_Name__c='User 806',Name='Test User 806',UserName__c='test@test1.com');
             insert testStaff1;
         
         ApexPages.currentPage().getParameters().put('id',testStaff1.Id);
         
         // Instantiate the standard controller with the Staff
         ApexPages.StandardController con1=new ApexPages.standardController(testStaff1);
         
          // Instantiate the extention instance with the standardcontroller
         DisplayCalendarFilterByStaffExtension ext1=new DisplayCalendarFilterByStaffExtension(con1);
        }*/
    // End Test Coverage
}
// End of Class