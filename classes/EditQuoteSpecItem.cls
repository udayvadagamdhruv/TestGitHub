/* This class is used in Edit Quote_spec_item vf Page */ 
public with sharing class EditQuoteSpecItem
{
/*public boolean isLtng{private set; get{
                                    String theme = UserInfo.getUITheme();
                                    return (theme=='Theme4d')?true:false;
                                  }
    }  
    
   
   
   private final Quote_Spec_Item__c objQSI;
   Public String strid; 
   
    public EditQuoteSpecItem(ApexPages.StandardController controller) 
    {
    this.objQSI = (Quote_Spec_Item__c)controller.getRecord(); 
    }
   
    Public PageReference saveme()
    {       
        strid = objQSI.Quote__c;
        try
        {
        update objQSI;
        //strid = objQSI.Quote__c; 
        }
        catch(System.DMLException e)
        {
        return null;
        }   
        
        if(isLtng)
        {
            PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+strid+'&section=vendorquote');
            p.setRedirect(true);
            return p;
        }
        else
        {
            PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+strid);
            p.setRedirect(true);
            return p;
        }
        
        
    }
  
   
   // This method is called on to handle Cancel button
     Public PageReference cancelme()
     { 
        strid = objQSI.Quote__c;
        if(isLtng)
        {
            PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+strid+'&section=vendorquote');
            p.setRedirect(true);
            return p;
        }
        else
        {
            PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+strid);
            p.setRedirect(true);
            return p;
        }   
     }
    // End Cancel method
    
     
     static testMethod void Test_EditQuoteSpecItem()
      {
      
          Job_Number_Setting__c customSetting626 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting626;
            
       Media_Type__c testMedia=new Media_Type__c(Name='Test Media 626');
       insert testMedia;
             
       Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 626',Media_Types__c=testMedia.Id);
       insert testST;
                 
       Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 626');
       insert testSpec;
                
       Job__c testJob1=new Job__c(Name='Test Job 626',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
         {
         insert testJob1;
         }
        catch(System.DMLException e)
         {
         System.assert(e.getMessage().contains('Job with same name Exists'));
         }
       System.assertEquals('Test Job 626',testJob1.Name);
               
       GL_Department__c testGLD = new GL_Department__c(Name='TestGLD999');
        try
         {
         insert testGLD;
         }
        catch(System.DMLException e)
         {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }
           
       Quote__c testQ=new Quote__c(Name='Quote 626',Job__c=testjob1.Id,GL_Department__c=testGLD.id); 
        try
         {
         insert testQ;
         }
        catch(System.DMLException e)
         {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
         }
               
       Quote_Spec_Item__c testQSI = new Quote_Spec_Item__c(Name='Spec Item',Quote__c=testQ.Id);
        try
         {
         insert testQSI;
         }
        catch(System.DMLException e)
         {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
         }
               
       Quote_Spec_Item__c editQSI = [Select id,Name,Quote__c from Quote_Spec_Item__c where id =: testQSI.id];
       
       ApexPages.StandardController con=new ApexPages.StandardController(editQSI);
       ApexPages.currentPage().getParameters().put('Id',editQSI.Id);
       EditQuoteSpecItem  ext=new EditQuoteSpecItem(con);
        
       ApexPages.PageReference result1=ext.saveme();
       delete editQSI;
       result1=ext.saveme();
       result1=ext.cancelme();
          
      }
          /* End of Test Coverage */
}
/* End of Apex class */