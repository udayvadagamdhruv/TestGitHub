// Extension Class to Delete Job 
public  class DeleteJob
{
    // Global Variables 
    private final Job__c objJob;
    public Boolean isError{get;set;}
    String strJobId;
    public Job__c j;
    public String OId{get;set;}
    // End of Global Variables
    
   
    // Standard Controller Constructor 
    public DeleteJob(ApexPages.StandardController con) 
    {
        isError = False;
        this.objJob=(Job__c)con.getrecord();
        j = [select id,Name from Job__c where id =: objJob.id];
        strJobId = j.id;
        
        Schema.DescribeSObjectResult r = Job__c.sObjectType.getDescribe();
        oId = r.getKeyPrefix();
    }
    
    // End of Standard Controller Constructor 
    
    public pagereference ContinueToDeleteAll(){
        
        String Job_JT_Ids = strJobId;
        
        list<Job_Task__c> a = [SELECT Id,Name,Job__c FROM Job_Task__c WHERE Job__c =:Job_JT_Ids];
        list<Job_Spec__c> a1 = [SELECT Id,Name,Job__c FROM Job_Spec__c WHERE Job__c =:Job_JT_Ids ];
        list<Quote__c> a2 = [SELECT Id,Name,Job__c FROM Quote__c WHERE Job__c =:Job_JT_Ids ];
        list<Estimate_Line_Items__c> a3 = [SELECT Id,Name,Job__c FROM Estimate_Line_Items__c WHERE Job__c =:Job_JT_Ids ];
        list<PO_Line_Item__c> a6 = [SELECT Id, Purchase_Order__c, Estimate_Line_Item__c  FROM PO_Line_Item__c where Purchase_Order__r.Job__c = :Job_JT_Ids or Estimate_Line_Item__r.Job__c = :Job_JT_Ids ];
        list<Purchase_Order__c> a4 = [SELECT Id,Name,Job__c FROM Purchase_Order__c WHERE Job__c =:Job_JT_Ids ];
        list<Invoice__c> a5 = [SELECT Id,Name,Job__c FROM Invoice__c WHERE Job__c =:Job_JT_Ids ];
        
        delete a;
        delete a1;
        delete a2;
                delete a6;

        delete a3;
        delete a4;
        delete a5;
        
        Job__c obj = [select id,Name from Job__c where id =: Job_JT_Ids];
        
        delete obj;
        
        PageReference p =  new Pagereference('/'+oId);
        p.setRedirect(true);
        return p;
    }
    
    // Method called on to Delete Holiday 
     public PageReference checkDelete()
     {
      Job__c obj = [select id,Name from Job__c where id =: strJobId];   
        try
        {
            Database.delete(obj);        
        }
        catch(System.DMLException e)
        {
           isError = True;
           return null;
        }
        // After deletion navigate to Job List
        //PageReference p =  new Pagereference('/apex/JobsTabOverride');
        PageReference p =  new Pagereference('/'+oId);
        p.setRedirect(true);
        return p;
     }
     // End of Delete Method
     
      // Start Test Coverage
    
        static testMethod void Test_DeleteJob()
         {
             Job_Number_Setting__c customSetting9870 = new  Job_Number_Setting__c(Name='yy');

            insert customSetting9870;
            
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 9870');
                insert testMedia;
                
                Campaign__c testCampaign1=new Campaign__c(Name='Test Campaign 9870');
                insert testCampaign1;
             
                Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 9870',Media_Types__c=testMedia.Id);
                insert testST;
                 
                 Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 9870',Schedule_Template__c=testST.Id);
                 insert testSCT1;
                 
                 Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 9870');
                 insert testSpec;
                
                 Spec_Item__c testSPI=new Spec_Item__c(Name='Test Spec Item 9870',Specification_Template__c=testSpec.Id); 
                 insert testSPI;
                
                 Job__c testJob1=new Job__c(Job_Auto_Number__c='9870',Flag__c=True,Name='Test Job 9870',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
                  
                        insert testJob1;
                  
                 System.assertEquals('Test Job 9870',testJob1.Name);  
                   
                // Instantiate the standard controller with the Job
                ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
                // Instantiate the extention instance with the standardcontroller
                DeleteJob ext=new DeleteJob(con);
        
                // Invoke the Delete method on the extension 
                ApexPages.PageReference result=ext.CheckDelete();
                
                // Test for Navigation Code after deletion
                Media_Type__c testMedia1=new Media_Type__c(Name='Test Media 9871');
                insert testMedia1;
                
                Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 9871',Media_Types__c=testMedia1.Id);
                insert testST1;
                 
                Job__c testJob2=new Job__c(Name='Test Job 9871',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id);
                  
                        insert testJob2;
                        // Instantiate the standard controller with the Job
                ApexPages.StandardController con1=new ApexPages.StandardController(testJob2);
        
                // Instantiate the extention instance with the standardcontroller
                DeleteJob ext1=new DeleteJob(con1);
        
                // Invoke the Delete method on the extension 
                
              
                   result=ext1.ContinueToDeleteAll();     
                
                
    }
    // End of Test Coverage
}
// End of Class