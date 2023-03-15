// This Class is Used for Delete Quote Spec Item Functionality 
public with sharing class DeleteQuoteSpecItemExtension 
{

    public boolean isLtng{
                         
                         private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                         }
     



      // Global variables 
      public  boolean isError{get;set;}
      public Id QuoteId;
      private final Quote_Spec_Item__c objQuoteSpecItem; 
      // End of Global variables
    
    public Id QuoteOptionId;
    
    
    /* Constructor */
    public DeleteQuoteSpecItemExtension(ApexPages.StandardController controller) 
     {
        isError = false; 
        this.objQuoteSpecItem=(Quote_Spec_Item__c)controller.getrecord();
        QuoteId = [Select Id, Quote__c from Quote_Spec_Item__c where Id =:objQuoteSpecItem.Id].Quote__c;
     }
    // End of Constructor 
    
    // Check Delete Method is Used to Delete Quote Spec Item 
    public PageReference checkDelete()
     {
      try
       {
            Database.delete(objQuoteSpecItem);        
       }
      catch(System.DMLException e)
       {
             isError = true;
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); 
             return null;
       }
        // After deletion navigate to Quote Detail Page
       /* PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+QuoteId);
        p.setRedirect(true);
        return p; */
        
        If(isLtng){        
          PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+QuoteId+'&section=estspecitems');
         p.setRedirect(true);
         return p;
         }
         
         else{
         
          PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+QuoteId);
         p.setRedirect(true);
         return p;
         
         } 
    
        
        
     }
     
    // Test Coverage Code
    /*  static testMethod void DeleteQuotePositiveTest()
   {
   
      Job_Number_Setting__c customSetting985 = new  Job_Number_Setting__c(Name= 'yy');
      insert customSetting985;
      
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 603');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 603',Media_Types__c=testMedia.Id);
      insert testST;
                 
      Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 604',Media_Types__c=testMedia.Id);
      insert testST1;
                 
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 603');
      insert testSpec;
                
      Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 604');
      insert testSpec1;
           
      Job__c testJob1=new Job__c(Name='Test Job 603',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
         {
          insert testJob1;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('DUPLICATE_VALUE'  , e.getDmlStatusCode(0));
         }
      System.assertEquals('Test Job 603',testJob1.Name);
               
      GL_Department__c testGLD = new GL_Department__c(Name='TestGLD995');
        try
         {
          insert testGLD;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }
              
      GL_Code__c testGL=new GL_Code__c(Name='GL Code 9986',GL_ID__c='TestGL9986',GL_Department__c = testGLD.id);
       try
        {
          insert testGL;
          System.debug('GL Code inserted successfully@@@ '+testGL);
        }
       catch(System.DMLException e)
        {
          System.debug(e.getMessage());
        }  
               
      Quote__c testQ=new Quote__c(Name='Quote 603',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
        try
         {
              insert testQ;
         }
        catch(System.DMLException e)
         {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
         }
      Quote_Spec_Item__c testQSI = new Quote_Spec_Item__c(Name='Spec Item 603',Quote__c=testQ.Id);
      insert testQSI; 
             
      // Instantiate the extention instance with the standard controller 
      ApexPages.StandardController con=new ApexPages.StandardController(testQSI);
      ApexPages.currentPage().getParameters().put('Id',testQSI.Id);
      DeleteQuoteSpecItemExtension ext=new DeleteQuoteSpecItemExtension(con);
        
      // Invoke the saveme method on the extension 
      ApexPages.PageReference result1=ext.checkDelete();
      ApexPages.PageReference result2=ext.checkDelete();
  }*/
// End of Test Coverage 
}
// End of Class