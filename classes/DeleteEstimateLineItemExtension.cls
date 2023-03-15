// This class is used to Delete Estimate Line Item
public with sharing class DeleteEstimateLineItemExtension 
{

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    // Global variables
    public Id JobId;
    private final Estimate_Line_Items__c objELI; 
    // End of Global variables
    
    // Start Constructor 
    public DeleteEstimateLineItemExtension(ApexPages.StandardController controller) 
    {
       this.objELI=(Estimate_Line_Items__c)controller.getrecord();
       JobId = [Select Id, Job__c from Estimate_Line_Items__c where Id =:objELI.Id limit 1].Job__c;
    }
    // End Constructor 

    // Method called on to Delete Estimate Line Item
     public PageReference checkDelete()
     {
        try
        {
            Database.delete(objELI);        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deleting Estimate Line Item navigate to Estimates Tab
        
        if(isLtng)
        {
             PageReference p =   new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&tab=Jobcost'+'&section=estimate');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=5');
                p.setRedirect(true);
                return p;
        }
        
      
     }
     // End Delete Method

      // Test Coverage Code
     static testMethod void Test_DeleteEstimateLineItemExtension()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 601');
             
                insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 601',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
              Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 602',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 601');
               
                  insert testSpec;
                
             Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 602');
             
                  insert testSpec1;
           
             Job__c testJob1=new Job__c(Job_Auto_Number__c='J 601',Name='Test Job 601',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
             
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
               
               
             System.assertEquals('Test Job 601',testJob1.Name);
               
            GL_Department__c testGLD = new GL_Department__c(Name='TestGLD993');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
            GL_Code__c testGL=new GL_Code__c(Name='GL Code 9983',GL_ID__c='TestGL9983',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }    
               
              Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 601',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
              try
               {
                   insert testELI;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' ,e.getDmlStatusCode(0));
               }
               // Instantiate the extention instance with the standard controller 
                
              ApexPages.StandardController con=new ApexPages.StandardController(testELI);
              ApexPages.currentPage().getParameters().put('Id',testELI.Id);
              DeleteEstimateLineItemExtension ext=new DeleteEstimateLineItemExtension(con);
        
                // Invoke the saveme method on the extension 
           
                ApexPages.PageReference result1=ext.checkDelete();
                result1=ext.checkDelete();
          }
          // End of Test Coverage 
}
// End of Class