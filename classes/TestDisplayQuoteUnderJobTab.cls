@isTest
public class TestDisplayQuoteUnderJobTab {
    
   /* static testMethod void DisplayQuote()
    {
          //DisplayQuoteUnderJobTab ext=new DisplayQuoteUnderJobTab();
           
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 348');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 348',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 348');
                insert testSpec;
       
          Job__c testJob1=new Job__c(Name='Test Job 348',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
          System.assertEquals('Test Job 348',testJob1.Name);
           
          GL_Department__c testGLD = new GL_Department__c(Name='TestGLD348');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }

           GL_Code__c testGL=new GL_Code__c(Name='Test GL Code 348',GL_ID__c='Test GL348',GL_Department__c=testGLD.id);
               insert testGL;
               
            Quote__c testQ=new Quote__c(Name='Quote 348',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
            insert testQ;
        
            Quote__c testQ1=new Quote__c(Name='Quote 348',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Approved__c=true,Quantity__c=5000.00,GL_Code__c=testGL.Id);
            insert testQ1;
            
              system.assertEquals(true,testQ1.Approved__c);
            
            
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
           // Instantiate the extention instance with the Custom Controller
           
           DisplayQuoteUnderJobTab ext1=new DisplayQuoteUnderJobTab();
          
           // Invoke the primary method on the extension
           boolean x=ext1.isMob;
           ApexPages.PageReference result1=ext1.CreateQuote();
           
           ext1.ShowLessQuote();
           ext1.ViewAllQuote();
           ext1.Del();
           ext1.ViewAll=true;
           ext1.Del();
          result1=ext1.save();
           ext1.rowIndex=1;
           ext1.qtEditField='QuoteRequestDate';
          result1=ext1.inlineQuoteEdit();
          result1=ext1.inlineQuoteSave();
            ext1.rowIndex=1;
           ext1.qtEditField='QuoteDueDate';
          result1=ext1.inlineQuoteEdit();
          result1=ext1.inlineQuoteSave();
                 
    }  */
}