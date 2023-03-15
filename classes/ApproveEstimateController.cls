// This Class is Used in Approve_Estimate vf Page 
public with sharing class ApproveEstimateController 
{
   // Global variables
  /*  private final Estimate_Line_Items__c est;
    public Id JobId;
    // End of Global variables
    
    // Start Constructor
    public ApproveEstimateController(ApexPages.StandardController controller)
    {
         this.est=(Estimate_Line_Items__c)controller.getRecord();
         JobId = [Select Id, Job__c from Estimate_Line_Items__c where Id =:est.Id limit 1].Job__c;
    }
    // End of Constructor
    
   // AutoRun method used to update Estimate Line Items field 
    
    public PageReference autoRun() 
     {
       try
        {
            if(schema.SobjectType.Estimate_Line_Items__c.Fields.Approved__c.isUpdateable()){
                est.Approved__c=true;
            }
            if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable())
            {
                update est;
            }
            
            Job__c job = [select id,Name,Estimate_Total__c from Job__c where Id =: JobId];
            Estimate_Line_Items__c eli = [select id,Name,Total_Amount__c from Estimate_Line_Items__c where id=: est.Id];
            
            if(schema.SobjectType.Job__c.Fields.Estimate_Total__c.isUpdateable()){
                job.Estimate_Total__c = job.Estimate_Total__c + eli.Total_Amount__c;
            }
            if(Schema.sObjectType.Job__c.isUpdateable())
            {
                update job;
            }
        }
       
       catch(System.DMLException e)
        {
        return null;
        }
        PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=5');
        p.setRedirect(true);
        return p;
     }
   // End of AutoRun Method
   
    // Test Coverage
    private static testMethod void Test_ApproveEstimateController()
   {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 608');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 608',Media_Types__c=testMedia.Id);
             
                insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 608');
          
                insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 608',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
               insert testJob1;
             }
            catch(System.DMLException e)
             {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           System.assertEquals('Test Job 608',testJob1.Name);  
               
            GL_Department__c testGLD = new GL_Department__c(Name='TestGLD998');
              try
               {
                insert testGLD;
               }
              catch(System.DMLException e)
               {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               } 
          
             GL_Code__c testGL=new GL_Code__c(Name='GL Code 9989',GL_ID__c='TestGL9989',GL_Department__c = testGLD.id,Unit_Type__c='Project');
              try
               {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
               }
              catch(System.DMLException e)
               {
                 System.debug(e.getMessage());
               } 
                 
             Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Est 608',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id,Quantity__c=100,Amount__c=1200);
              try
               {
                   insert testELI;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
          
             Estimate_Line_Items__c editELI = [select id,name,Job__c from Estimate_Line_Items__c where id =: testELI.Id];    
             
             // Instantiate the extention instance with the standard controller 
              ApexPages.StandardController con=new ApexPages.StandardController(editELI);
              ApexPages.currentPage().getParameters().put('Id',editELI.Id);
              ApproveEstimateController ext=new ApproveEstimateController(con);
        
            // Invoke the saveme method on the extension 
            ApexPages.PageReference result1=ext.autoRun();
            delete editELI;
            result1=ext.autoRun();
     }*/
    // End of Test Coverage 
}
// End of Class