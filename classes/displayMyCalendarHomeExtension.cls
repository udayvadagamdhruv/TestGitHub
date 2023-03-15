// This Class is used to display active Task associated with logged in User
public with sharing class displayMyCalendarHomeExtension {

    // Global variables
   /* public String strName{get;set;}
    public List<Job__c> lstJob{get;set;}
    public JsonObject json{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    public List<Job_Task__c> lstJT1{get;set;}
    public List<Job_Task_Role__c> lstJTR{get;set;}
    public String jsonString{get;set;}
    Set<Id> stJobId=new Set<Id>();
    Set<Id> stJobTaskId=new Set<Id>();
    Set<Id> stJobTaskRoleId=new Set<Id>();
    public String strGetUserName{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End of Global variables

    // Start Constructor Code
    public displayMyCalendarHomeExtension(ApexPages.StandardController controller)
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
        
        strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName];
        strName=u.Name;
        System.debug('Logged in User is :'+strname);
        
        // Retrieve Active Jobs and put their Ids into Set
        lstJob=[Select Id,Name from Job__c where Status__c=: 'Active'];
        
       for(Job__c j:lstJob)
       {
           stJobId.add(j.id);
       }
       
       // Retrieve Active Tasks which belongs to Active Jobs
       
       lstJT=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' Order By Name];
       
       for(Job_Task__c jt: lstJT)
       {
           stJobTaskId.add(jt.id);
       } 
        
           lstJTR=[Select Id,Job_Task__r.Name,Job_Task__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strName];
       
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
                    //code commented and added by sushma 11 march for the removal of the special characters.
                   // String str1=c.Job__r.Name+' : '+c.Name;
                    //code added by sushma 11 march for the removal of the special characters.
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
                    
                    String str1=strJobName +' : '+strTaskName;
                    
                    
                    cjson.putOpt('"title"',new JSONObject.value(str1));
                    cjson.putOpt('"staff"',new JSONObject.value(c.Assigned_Users__c));
                    cjson.putOpt('"status"',new JSONObject.value(c.Status__c));
                    // cjson.putOpt('"job"',new JSONObject.value(c.Job__r.Name));
                     //code added by sushma 11 march for the removal of the special characters.
                    cjson.putOpt('"job"',new JSONObject.value(strJobName));
                    Datetime dt1 = datetime.newInstance(c.Revised_Due_Date__c.year(), c.Revised_Due_Date__c.month(),c.Revised_Due_Date__c.day());
                    System.debug('Start Date' + dt1 );
                    Long startDateTime = dt1.getTime()/1000;
                    System.debug('Start Date Time' + startDateTime );
                    cjson.putOpt('"start"', new JSONObject.value(startDateTime.intValue()));
                     System.debug('Start Date Int value' + startDateTime.intValue() );
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
        // Prepare JSONString which will display Tasks in Calendar
        json.putOpt('events', new JSONObject.value(values));
        System.debug('Json Value :'+json);
        jsonString = json.ValuetoString();
        jsonString = jsonString.replace('{events: [' , '[');
        jsonString = jsonString.replace('}]}' , '}]');
        System.debug('My Json String is'+jsonString);
     }
     // End Constructor 
    
    // This method is called on to bring user on Home Page
    public pagereference returnHome()
    {
        Pagereference p=new Pagereference('/home/home.jsp');
        p.setRedirect(true);
        return p;
    }
    // End of method returnHome
    
    // Start Test Coverage 
        static testMethod void displayHomeCalendar()
        {
             Job_Number_Setting__c customSetting1007 = new  Job_Number_Setting__c(Name= 'NO');

                    insert customSetting1007;
        
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 815');
             
                insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 815',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
              Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 815',Schedule_Template__c=testST.Id);
              
                    insert testScheduleTask1;

              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 815');
              
                    insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 815', Job_Auto_Number__c = 'J 815', Flag__c = True,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c='Active');
         
                 insert testJob1;
              
              System.assertEquals('Test Job 815',testJob1.Name);
                 
              Job_Task__c testJT1=new Job_Task__c(Name='Test Job Task 815',Status__c='Active',Revised_Due_Date__c=System.Today(),Job__c=testJob1.id);
         
                  insert testJT1;
   
              Job_Task_Role__c testJTR1=new Job_TAsk_Role__c(Name='Designer',User__c=UserInfo.getName(),Job_Task__c=testJT1.id);              
             
                   insert testJTR1;
              String strGetUserName1=UserInfo.getUserName();
              User testUser1=[Select id,Name from User where Username=: strGetUserName1];
       
              ApexPages.currentPage().getParameters().put('id',testUser1.id);
               
               // Instantiate the standard controller with the User
               
              ApexPages.StandardController con1=new ApexPages.standardController(testUser1);
              
              // Instantiate the extention instance with the standard controller
              displayMyCalendarHomeExtension obj1=new displayMyCalendarHomeExtension(con1);
              
              // Invoke the primary method on the extension
              ApexPages.Pagereference result=obj1.returnHome();
        }*/
        // End Test Coverage
}
// End of Class