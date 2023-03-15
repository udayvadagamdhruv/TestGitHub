// This class is used in Unapprove_Quote vf page
public with sharing class UnapproveQuote 
{

 public boolean isLtng {private set;get{
 
 return(UserInfo.getUITheme()=='Theme4d')?true:false;
 
 }}


    // Global variables
    private final Quote__c quote;
    String theId;
    Public Boolean ShowProductionEstimate{get;set;}
    // End of Global variables

   // Constructor 
    public UnapproveQuote(ApexPages.StandardController controller) 
    {
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        this.quote=(Quote__c)Controller.getRecord();
        theId = ApexPages.currentPage().getParameters().get('id');
    }
   // End of Constructor
   
   // Method to update the Quotes Approved__c field 
    public PageReference autoRun() 
    {
     try
      {     
          quote.Approved__c = False;
          update quote;
      }
     catch(System.DMLException e)
      {
          return null;
      }
      if(ShowProductionEstimate ){
      List<Production_Estimate__c> pest = [select id,Name,Quote__c from Production_Estimate__c where Quote__c =: theId];
      delete pest;
      
      }
      else{
      List<Estimate_Line_Items__c> est = [select id,Name,Quote__c from Estimate_Line_Items__c where Quote__c =: theId];
      delete est;
      }
      Vendor_Quote__c vq=[select id,Name,Quote__c,Restrict__c from Vendor_Quote__c where Quote__c =: theId and Restrict__c=true];
      vq.Restrict__c=false;
      update vq;
      
      
      if(isLtng)
      {
          PageReference pageRef =  new Pagereference('/'+theId);
          pageRef.setRedirect(true);
          return pageRef;
      }
      else
      {
          PageReference pageRef =  new Pagereference('/apex/QuoteDetailPage?id='+theId);
          pageRef.setRedirect(true);
          return pageRef;
      }
    }
   // End of autoRun Method 
    
 /*  //Test Method
        static testMethod void Test_UnapproveQuote()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 619');
              insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 619',Media_Types__c=testMedia.Id);
              insert testST;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 619');
              insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 619',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
                {
                   insert testJob1;
                }
               catch(System.DMLException e)
                {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                }
              System.assertEquals('Test Job 619',testJob1.Name);  
                
              GL_Department__c testGLD = new GL_Department__c(Name='TestGLD992');
               try
                {
                  insert testGLD;
                }
               catch(System.DMLException e)
                {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                }
              
               GL_Code__c testGL=new GL_Code__c(Name='GL Code 9982',GL_ID__c='TestGL9982',GL_Department__c = testGLD.id);
                try
                 {
                  insert testGL;
                  System.debug('GL Code inserted successfully@@@ '+testGL);
                 }
                catch(System.DMLException e)
                 {
                  System.debug(e.getMessage());
                 }
            
               Quote__c testQ=new Quote__c(Name='Quote 619',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
                try
                 {
                   insert testQ;
                 }
               catch(System.DMLException e)
                {
                   System.assertEquals('REQUIRED_FIELD_MISSING',e.getDmlStatusCode(0));
                }
               catch(Exception f)
                {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',f.getDmlStatusCode(0));
                }
               
              Vendor_Quote__c vq=new Vendor_Quote__c(Quote__c=testQ.id,Restrict__c = True);
               try
                {
                   insert vq;
                }
               catch(Exception f)
                {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',f.getDmlStatusCode(0));
                }
   
              ApexPages.StandardController con=new ApexPages.StandardController(testQ);
              ApexPages.currentPage().getParameters().put('Id',testQ.Id);
          
             // Instantiate the extention instance with the standard controller 
             UnapproveQuote ext=new UnapproveQuote(con);
        
            // Invoke the primary method on the extension
             ApexPages.PageReference result1=ext.autoRun();
            
             delete testQ;
             result1=ext.autoRun();
        } // End Test Case   */
}
// End of Apex class