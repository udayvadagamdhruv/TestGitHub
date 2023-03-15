// This class is used to create Work Order for selected Job
public with sharing class WorkOrderExtension 
{
    // Global variables  
    public DateTime today{get;set;}
    String jobid;
    public List<Job_Team__c> JobTeam{get;set;} 
    public List<Job_Task__c> JobTask{get;set;} 
    public List<Job_Spec__c> CreativeBrief{get;set;}
    public List<Tag__c> Tags{get;set;}
     public String imageBody{get;set;}
    public String imageURL{get;set;}
     public List<Document> lstDoc;
    public boolean imageNotFound{get;set;}
     public String queryString{get;set;}
   public boolean Tagrender{get;set;}
    public map<string,list<Job_Spec__c>> MapCB{get;set;}
  
    // End Global variables

      // Start Constructor
    public WorkOrderExtension(ApexPages.StandardController controller) 
    {
         // To display Subscriber Organization Logo
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
       jobid = ApexPages.currentpage().getParameters().get('id');
       JobTeam = [select id,Name,Role__c,Staff__c from Job_Team__c where Job__c =: jobid WITH SECURITY_ENFORCED];
       CreativeBrief = [select id,Name,Description__c,Creative_Brief_Template__c  from Job_Spec__c where Job__c =: jobid WITH SECURITY_ENFORCED order by Sort_order__c];
       JobTask = [select id,Name,Due_Date__c,Start_Date__c,Revised_Due_Date__c,Task_Order__c,Marked_Done__c,Assigned_Users__c from Job_Task__c where Job__c =: jobid WITH SECURITY_ENFORCED Order By Task_Order__c];
      // Tags = [SELECT Id,name, Job__c, Tag_Program_Title__c, Tag_Start_Date__c, Tag_End_Date__c, Tag_Due_Date__c, Tag_Air_Date__c, Tag_Air_Time__c, Tag_Lengths__c, Dummy_Date_1__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c FROM Tag__c where Job__c =: jobid];
        queryString = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Tag__c.FieldSets.TagsFieldsets.getFields()) {
         queryString += ', ' + fld.getFieldPath();
        }
        queryString += ' from Tag__c where Job__c =: jobId  WITH SECURITY_ENFORCED ORDER BY CreatedDate';
        Tags= Database.query(queryString);
        if(Tags.size()>0)
        {
        Tagrender=true;
       }
       else{
       Tagrender=false;
       }
        MapCB = new map<string,list<Job_Spec__c>>();
         for(Job_Spec__c JS:CreativeBrief)
         {
               if(MapCB.containsKey(js.Creative_Brief_Template__c))
               {
                  List <Job_Spec__c > jSpeclist =  MapCB.get(js.Creative_Brief_Template__c);
                  jSpeclist.add(js);
                  MapCB.put(js.Creative_Brief_Template__c,jSpeclist );  
                }
                else
                {
                  MapCB.put(js.Creative_Brief_Template__c, new List<Job_Spec__c >{js}) ;
                }   
         }
       today=System.NOW();
    }
    // End Constructor 
    
    // Start Test Coverage 

  /*  static testMethod void Test_WorkOrderExtension()
    {
    
       Job_Number_Setting__c customSetting950 = new  Job_Number_Setting__c(Name= 'yy');
       insert customSetting950;
            
       Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1005');
             
                insert testMedia;
             
       Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1005',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
       Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schedule 1005',Schedule_Template__c=testST.id,Days__c=2);
              insert testSchedule;       
                 
       Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1005');
                insert testSpec;
                
       Campaign__c testCamp=new Campaign__c(Name='Test Camp 1005');    
              insert testCamp;  
   
           Account testClient=new Account(Name='Test Account 1005');
               insert testClient;
               
           Contact testContact=new Contact(FirstName='Test Client',LastName='RUS',AccountId=testClient.id,Email='test1005@SFDC.com');
               insert testContact;    
                      
          Job__c testJob1=new Job__c(Name='Test Job 1005',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,Client__c=testClient.id,Client_Contact__c=testContact.id);
               insert testJob1;
               
          System.assertEquals('Test Job 1005',testJob1.Name);
               
          ApexPages.currentPage().getParameters().put('id',testJob1.id);
          ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
          WorkOrderExtension ext=new WorkOrderExtension(con);
    }
    // End Test Coverage */
}
// End of Class