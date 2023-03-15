// This class is used to Delete Quote 
public with sharing class DeleteQuoteExtension 
{
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
  
  // Global variables 
  public Id JobId;
  private final Quote__c objQuote; 
  // End of Global variables
  
  // Standard Controller Constructor 
    public DeleteQuoteExtension(ApexPages.StandardController controller) 
    {
       this.objQuote=(Quote__c)controller.getrecord();
       JobId = [Select Id, Job__c from Quote__c where Id =:objQuote.Id limit 1].Job__c;
    }
    // End of Constructor 
    
    // This method is called on to delete Quote record
     public PageReference checkDelete()
     {
        try
        {
            Database.delete(objQuote);        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deletion navigate to Quote Tab
        
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&tab=Jobcost'+'&section=jobquote');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                // After inserting Job Spec, navigate to Creative Brief Tab        
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=4');
                p.setRedirect(true);
                return p;
        }
        
        
        
       
     }
     // End of delete method
     
     // Start Test Coverage
     static testMethod void DeleteQuotePositiveTest()
     {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 306');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 307',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 308',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 307');
                insert testSpec;
                
          Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 308');
                insert testSpec1;
           
           Job__c testJob1=new Job__c(Name='Test Job 307',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
            System.assertEquals('Test Job 307',testJob1.Name);   
               
          GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }     
              
            Quote__c testQ=new Quote__c(Name='Quote 307',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
                 insert testQ;
             
               // Instantiate the extention instance with the standard controller 
               
              ApexPages.StandardController con=new ApexPages.StandardController(testQ);
              
              ApexPages.currentPage().getParameters().put('Id',testQ.Id);
              
              DeleteQuoteExtension  ext=new DeleteQuoteExtension(con);
        
            // Invoke the saveme method on the extension 
           
            ApexPages.PageReference result1=ext.checkDelete();
            ApexPages.PageReference result2=ext.checkDelete();
          }
          // End of Test Coverage Code
}// End of Class