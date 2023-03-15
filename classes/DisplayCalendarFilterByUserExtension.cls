// This class is used to display tasks in calendar based on selected User from the list
public with sharing class DisplayCalendarFilterByUserExtension
 {
  /*  // Global Variables
    public JsonObject json{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    public List<Job_Task_Role__c> lstJTR{get;set;}
    public List<Job__c> lstJob{get;set;}
    public String jsonString{get;set;}
    public String strUser{get;set;}
    public String strCampaignId{get;set;}
    Set<Id> stJobId=new Set<Id>();
    Set<Id> stJobTaskId=new Set<Id>();
    Set<Id> stJobTaskRoleId=new Set<Id>();
    public List<Job_Task__c> lstJT1{get;set;}
    public Id userId{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFOund{get;set;}
    // End of Global variables
        
    // Start constructor
    public DisplayCalendarFilterByUserExtension(ApexPages.StandardController controller)
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
 
       userId=ApexPages.CurrentPage().getParameters().get('id');
       
       // Retrieve Active Jobs
       lstJob=[Select Id,Name from Job__c where Status__c=: 'Active'];
       for(Job__c j:lstJob)
       {
           stJobId.add(j.id);
       }
       // Retrieve Active Tasks
       lstJT=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' Order By Name];
       
       for(Job_Task__c jt: lstJT)
       {
           stJobTaskId.add(jt.id);
       } 
       
       User u=[Select Id,Name from User where Id=: userId];
       strUser=u.Name;
       System.debug('Select Role : '+strUser);
       lstJTR=[Select Id,Job_Task__r.Name,Job_Task__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strUser];
       
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
                    if(strJobName.contains('"'))
                    {
                     strJobName = strJobName.replaceAll('"','\'');
                     System.debug('The job name contains the double quotes :: '+ strJobName );
                    }
                    
                    String strTaskName = c.Name;
                    if(strTaskName.contains('"'))
                    {
                     strTaskName= strTaskName.replaceAll('"','\'');                      
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
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'This User has no Tasks to display on Calendar'));   
        }
        
        // Prepare JSONString which will display Tasks In Calendar
        json.putOpt('events', new JSONObject.value(values));
        System.debug('Json Value :'+json);
        jsonString = json.ValuetoString();
        jsonString = jsonString.replace('{events: [' , '[');
        jsonString = jsonString.replace('}]}' , '}]');
        System.debug('My Json String is'+jsonString);
    }
    // End Constructor

    // Method called on to handle Cancel button
    public Pagereference cancel()
    {
         Pagereference p=new Pagereference('/apex/StaffandUserDetailPage?id='+userId);
         p.setRedirect(true);
         return p;
    }
    // End Cancel method

   
    
    // Test Coverage 
    static testMethod void Test_DisplayCalendarFilterByUserExtension()
    {
        Job_Number_Setting__c customSetting1005 = new  Job_Number_Setting__c(Name= 'NO');

            insert customSetting1005;
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 820');
             
                 insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 820',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 820');
            
                 insert testSpec;
                
         Account testClient=new Account(Name='Test Client 820');
         
                  insert testClient;      
                
         Job__c testJob1=new Job__c(Name='Test Job 820',Job_Auto_Number__c = 'J 820', Flag__c = True,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Client__c=testClient.id,Status__c='Active');
         
               insert testJob1;
               
         System.assertEquals('Test Job 820',testJob1.Name);    
                 
         Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 820',Status__c='Active',Job__c=testJob1.id,Revised_Due_Date__c=System.Today());

                 insert testJT;        
                 
         Job_Task_Role__c testJTR=new Job_Task_Role__c(Name='Designer',User__c='Ajay Kumar',Job_Task__c=testJT.id);
         
                 insert testJTR;    
                 
          Profile testProfile=[select id,Name from Profile where Name='System Administrator'];
          
          //below Calcutta value replaced by Kolkata  by yogini on 14-Mar-14
          User testUser=new User(alias='tUser',FirstName='Ajay',LastName='Kumar',Email='testUser820@sfdc.com',Username='testUser820@sfdc.com',CommunityNickName='Test USer 820 Community',ProfileId=testProfile.Id, TimeZoneSidKey = 'Asia/Kolkata',LocaleSidKey = 'en_GB',EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US');
            insert testUser;    
                 
          ApexPages.currentPage().getParameters().put('id',testUser.Id);
          
          // Instantiate the standard controller with the User
          ApexPages.StandardController con=new ApexPages.standardController(testUser);
          
           // Instantiate the extention instance with the standardcontroller
          DisplayCalendarFilterByUserExtension ext=new DisplayCalendarFilterByUserExtension(con);
          
          // Invoke the primary method on the extension
          ApexPages.Pagereference result1=ext.cancel();
         
          //below Calcutta value replaced by Kolkata  by yogini on 14-Mar-14
          User testUser1=new User(alias='tUser',FirstName='Test User',LastName='821',Email='testUser821@sfdc.com',Username='testUser821@sfdc.com',CommunityNickName='Test USer 821 Community',ProfileId=testProfile.Id, TimeZoneSidKey = 'Asia/Kolkata',LocaleSidKey = 'en_GB',EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US');
            insert testUser1;
         
          ApexPages.currentPage().getParameters().put('id',testUser1.Id);
        
             // Instantiate the standard controller with the User          
          ApexPages.StandardController con1=new ApexPages.standardController(testUser1);

            // Instantiate the extention instance with the standardcontroller
          DisplayCalendarFilterByUserExtension ext1=new DisplayCalendarFilterByUserExtension(con1);
    }
    // ENd Test Coverage*/
}
// End of Class