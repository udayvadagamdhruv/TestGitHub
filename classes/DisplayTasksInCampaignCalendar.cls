// This class is used to display Tasks in Calendar for selected Campaign
public with sharing class DisplayTasksInCampaignCalendar
{
     // Global variables 
/*    public JsonObject json{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    List<Job__c> lstJob{get;set;}
    public String jsonString{get;set;}
    public String strCampaignName{get;set;}
    public String strCampaignId{get;set;}
    Set<Id> stJobId=new Set<Id>();
    public Id campaignId{get;set;}
    public Campaign__c j{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End of Global variables 
    
    
    // Start Constructor 
    public DisplayTasksInCampaignCalendar(ApexPages.StandardController controller)
    {
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
           campaignId=ApexPages.CurrentPage().getParameters().get('Id');
       
       // Retrieve Active Jobs associate with selected Campaign
       lstJob=[Select Id,Name from Job__c where Campaign__c=: campaignId and Status__c=: 'Active'];
       for(Job__c j:lstJob)
       {
           stJobId.add(j.id);
       }
       
       // Retrieve Task associated with Active Jobs
        lstJT=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' Order By Name];
        
     
        j=[Select Id,Name from Campaign__c where Id=: campaignId];
        strCampaignName=j.Name;

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
                     //String str1=c.Job__r.Name+' : ';
                    String strJobName = c.Job__r.Name;
                    String strTaskName = c.Name;
                    if(strJobName.contains('"'))
                    {
                        strJobName = strJobName.replaceAll('"','\'');
                    }
                    
                    if(strTaskName.contains('"'))
                    {
                        strTaskName = strTaskName.replaceAll('"','\'');
                    }
                        
                    String str1 = strJobName + ' : ' + strTaskName;
                    cjson.putOpt('"title"',new JSONObject.value(str1));
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
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'This Campaign has no Tasks to display on Calendar'));
         }
         
         // Prepare JSONString which will be used to display Tasks in Calendar
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
          Pagereference p=new Pagereference('/apex/CampaignDetailPageCustom?id='+campaignId);
          p.setRedirect(true);
          return p;
    }
    // End of Cancel
    
      // Method called on to handle Print button 
    public Pagereference print()
    {
          Pagereference p=new Pagereference('/apex/PrintCalendarFilterByCampaign?id='+campaignId);
          p.setRedirect(true);
          return p;
    }
    // End of method Print


    // Test Coverage Code
    static testMethod void test_DisplayTasksInCampaignCalendar()
    {
         Job_Number_Setting__c customSetting984 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting984;
            
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 812');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 812',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 812',Schedule_Template__c=testST.Id);
                insert testScheduleTask1;

                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 812');
                insert testSpec;
                
          Campaign__c testCamp=new Campaign__c(Name='Test Campaign 812');   
             insert testCamp;    
                
          Job__c testJob1=new Job__c(Name='Test Job 805',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.Id,Status__c='Active');
         
                 insert testJob1;
                 
          System.assertEquals('Test Job 805',testJob1.Name);
          
          Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 812',Status__c='Active',Revised_Due_Date__c=System.Today(),Job__c=testJob1.id);       
              insert testJT;
                 
         // Test Code to Execute If Part 
         ApexPages.currentPage().getParameters().put('id',testCamp.id);
         
         // Instantiate the standard controller with the Campaign
         
         ApexPages.StandardController con=new ApexPages.standardController(testCamp);

          // Instantiate the extention instance with the standardcontroller
          
         DisplayTasksInCampaignCalendar ext=new DisplayTasksInCampaignCalendar(con);
          
         ApexPages.Pagereference result1=ext.cancel();
         
         // Test Code to Execute Else part
          Campaign__c testCamp1=new Campaign__c(Name='Test Campaign 813');   
             insert testCamp1;    
             
         ApexPages.currentPage().getParameters().put('id',testCamp1.id);
         
          // Instantiate the standard controller with the Campaign
         
         ApexPages.StandardController con1=new ApexPages.standardController(testCamp1);

          // Instantiate the extention instance with the standardcontroller
          
         DisplayTasksInCampaignCalendar ext1=new DisplayTasksInCampaignCalendar(con1);
    }// ENd of Test Coverage code*/
}// End of Class