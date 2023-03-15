// This class is used to display tasks in Calendar for selected Role 
public with sharing class DisplayRoleCalendarExtension
{
   /* // Global variables 
    public JsonObject json{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    public List<Job_Task_Role__c> lstJTR{get;set;}
    public List<Job__c> lstJob{get;set;}
    public String jsonString{get;set;}
    public String strRole{get;set;}
    public String strCampaignId{get;set;}
    Set<Id> stJobId=new Set<Id>();
    Set<Id> stJobTaskId=new Set<Id>();
    Set<Id> stJobTaskRoleId=new Set<Id>();
    public List<Job_Task__c> lstJT1{get;set;}
    public Id roleId{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End of Global variables 
    
    // Start Constructor
    public DisplayRoleCalendarExtension(ApexPages.StandardController controller)
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
       roleId=ApexPages.CurrentPage().getParameters().get('id');
       
       lstJob=[Select Id,Name from Job__c where Status__c=: 'Active'];
       for(Job__c j:lstJob)
       {
           stJobId.add(j.id);
       }
       lstJT=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' Order By Name];
       
       for(Job_Task__c jt: lstJT)
       {
           stJobTaskId.add(jt.id);
       } 
       
       UserRole u=[Select Id,Name from UserRole where Id=: roleId];
       strRole=u.Name;
       System.debug('Select Role : '+strRole);
       lstJTR=[Select Id,Job_Task__r.Name,Job_Task__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and Name =: strRole];
       
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
                    
                    //cjson.putOpt('"job"',new JSONObject.value(c.Job__r.Name)); added for double quote escape
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
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This Role has no Tasks to display on Calendar'));
        }
        // Prepare JSONSTring which will be used to display Tasks in Calendar
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
         Pagereference p=new Pagereference('/apex/RoleDetailPage?id='+roleId);
         p.setRedirect(true);
         return p;
    }
    // End Cancel method 

    // Start Test Coverage 
    static testMethod void Test_DisplayRoleCalendarExtension()
    {
      User u1 = [select id,IsActive from User where IsActive =: True Limit 1];
       System.RunAs(u1)
        {
        
        Job_Number_Setting__c customSetting1003 = new  Job_Number_Setting__c(Name= 'NO');

            insert customSetting1003;
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 825');
             
                 insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 825',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 825');
            
                 insert testSpec;
                
         Client__c testClient=new Client__c(Name='Test Client 825');
         
                  insert testClient;      
                
         Job__c testJob1=new Job__c(Name='Test Job 825',Job_Auto_Number__c ='J 825', Flag__c = True,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,JS_Client__c=testClient.id,Status__c='Active');
         
                 insert testJob1;
                 
         System.assertEquals('Test Job 825',testJob1.Name);        
                 
         Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 825',Status__c='Active',Job__c=testJob1.id,Revised_Due_Date__c=System.Today());

                 insert testJT; 
                 
         UserRole testRole = new UserRole(Name='CEO1');
         insert testRole;                
                 
         Job_Task_Role__c testJTR=new Job_Task_Role__c(Name=testRole.Name,User__c='Ajay Kumar',Job_Task__c=testJT.id);
         
                 insert testJTR;    
                 
        
       
         // Test Code to cover If condition in Constructor 
         ApexPages.currentPage().getParameters().put('id',testRole.Id);
         
         // Instantiate the standard controller with the Role
           
         ApexPages.StandardController con=new ApexPages.standardController(testRole);
         
         // Instantiate the extention instance with the standard controller
          
         DisplayRoleCalendarExtension ext=new DisplayRoleCalendarExtension(con);
         
         // Invoke the primary method on the extension
         ApexPages.Pagereference result1=ext.cancel();
         
         UserRole UR12 = new UserRole(Name='Designer');
         insert UR12;
            
          // Test Code to cover Else condition in Constructor
         UserRole testRole1=[select id,name from UserRole where Name=: UR12.Name Limit 1]; 
         ApexPages.currentPage().getParameters().put('id',testRole1.Id);
         ApexPages.StandardController con1=new ApexPages.standardController(testRole1);
         DisplayRoleCalendarExtension ext1=new DisplayRoleCalendarExtension(con1);
     
     }//End of RunAs
   
    }// End Test Coverage*/
} // End of Class