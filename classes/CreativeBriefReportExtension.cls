// This class is used to generate CreativeBriefReportExtension
public with sharing class CreativeBriefReportExtension 
{
    // Global variables
    public DateTime today{get;set;}
    String jobid;
    public List<Job_Team__c> JobTeam{get;set;} 
    public List<Job_Spec__c> JobSpec{get;set;} 
   // public List<Shipment__c> Shipment{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
     public map<string,list<Job_Spec__c>> MapCB{get;set;}
    
    // End Global variables
    
    // Start Constructor
    public CreativeBriefReportExtension(ApexPages.StandardController controller) 
    {
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId;  imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }
         jobid = ApexPages.currentpage().getParameters().get('id');
         JobTeam = [select id,Name,Role__c,Staff__c from Job_Team__c where Job__c =: jobid WITH SECURITY_ENFORCED];
         JobSpec = [select id,Name,Description__c,Creative_Brief_Template__c  from Job_Spec__c where Job__c =: jobid WITH SECURITY_ENFORCED order by sort_order__c];
      //   Shipment=[select id,name,Shipment_Phone__c,Shipment_Street_Address__c,Shipment_Address_2__c,Shipment_City__c,Shipment_State__c,Shipment_Zip_code__c from Shipment__c where Job__c =: jobid];
         
           MapCB = new map<string,list<Job_Spec__c>>();
         
         for(Job_Spec__c JS:JobSpec)
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
    // End of Constructor
    
    // Test Coverage Code
 /*   static testMethod void creativeReport()
    {
            Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting001;
            
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1008');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1008',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1008');
                insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='Test Spec Item 1008',Specification_Template__c=testSpec.id);
              insert testSPI;              
                
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 1008');    
              insert testCamp;  
   
           Client__c testClient=new Client__c(Name='Test Account 1008');
               insert testClient;
               
           Client_Contact__c testContact=new Client_Contact__c(Name='Test Client AUS',First_Name__c='Test Client',Last_Name__c='AUS',Client__c=testClient.id,Email__c='test1008@SFDC.com');
               insert testContact;    
                      
                
          Job__c testJob1=new Job__c(Name='Test Job 1008',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id);
               insert testJob1;
               
           System.assertEquals('Test Job 1008',testJob1.Name);    
               
           ApexPages.currentPage().getParameters().put('id',testJob1.id);
               
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                       
           CreativeBriefReportExtension ext=new CreativeBriefReportExtension(con);
    }
    // End Test Coverage*/
}
// End of Class