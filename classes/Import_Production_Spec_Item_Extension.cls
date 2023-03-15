public with sharing class Import_Production_Spec_Item_Extension 
{
    // Global variables
    public boolean isLtng{private set;get{
    
                                   string theme=Userinfo.getUITheme();
                                   return (theme=='Theme4d')?true:false;  
    }}
    
    
    public Id QuoteId{get;set;}
    public String ProductionSpecTempName{get;set;}
    public List<Quote_Spec_Item__c> lstQuoteSpec{get;set;}

    public Import_Production_Spec_Item_Extension(ApexPages.StandardController controller) 
    {
    QuoteId = ApexPages.currentPage().getParameters().get('Qid');
    LoadSpecs();
    }
    
     private void LoadSpecs()
    {
         QuoteId = ApexPages.currentPage().getParameters().get('Qid');       
         lstQuoteSpec=[Select id,Name,Description__c from Quote_Spec_Item__c where Quote__c =: QuoteId Order By CreatedDate];  
    }



// This method is called on to populate all Production Spec Templates into drop down list
    public List<selectOption> getProductionSpecTemplates() 
    {        
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new SelectOption('','-None-'));
        for (Production_Spec_Template__c a : [SELECT Id, name FROM Production_Spec_Template__c ORDER BY Name Limit 5000]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getProductionSpecTemplates
    
     // This method is called on to handle Cancel button
     Public PageReference cancelme()
     {
     
     
        If(isLtng){        
         PageReference p = new Pagereference('/apex/QuoteDetailPageLightning?id='+QuoteId+'&section=estspecitems');
         p.setRedirect(true);
         return p;
         }
         
         else{
         
         PageReference p = new Pagereference('/apex/QuoteDetailPage?id='+QuoteId);
         p.setRedirect(true);
         return p;
         
         } 
    
       }
    // End of Cancel method
    
    
    // This method is called on to Import Specs
    public pagereference importSpecs()
    {
        List<Quote_Spec_Item__c> insertQuoteSpecs=new List<Quote_Spec_Item__c>();    
        
        if(ProductionSpecTempName==NULL || ProductionSpecTempName=='-None-')
        {
           ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Production Spec Template : You must select a Template.');
           ApexPages.addMessage(msg1);
           return null;
        }
        else
        {
            try
            {
            List<Production_Spec_Item__c> lstSpecs=[Select id,Name,Description__c from Production_Spec_Item__c where Production_Spec_Template__c=:ProductionSpecTempName Order By CreatedDate];
            for(Production_Spec_Item__c PSI:lstSpecs)
            {
              Quote_Spec_Item__c qsi=new Quote_Spec_Item__c();
              qsi.Name=PSI.Name;
              qsi.Description__c=PSI.Description__c;
              qsi.Quote__c = QuoteId;
              insertQuoteSpecs.add(qsi);
            }
            insert insertQuoteSpecs;
            }
            catch(System.DMLException e)
            {
              return NULL;
            }
        }   
        LoadSpecs();
        
        
         If(isLtng){        
         PageReference p = new Pagereference('/apex/QuoteDetailPageLightning?id='+QuoteId+'&section=estspecitems');
         p.setRedirect(true);
         return p;
         }
         
         else{
         
         PageReference p = new Pagereference('/apex/QuoteDetailPage?id='+QuoteId);
         p.setRedirect(true);
         return p;
         
         } 
        
      
    }
    // End of method Import Specs
    
    // Start Test Coverage
    static testMethod void Test_Import_Production_Spec_Item()
    {
    
    Job_Number_Setting__c customSetting980 = new  Job_Number_Setting__c(Name= 'yy');
    insert customSetting980;
        
     Production_Spec_Template__c testPST1=new Production_Spec_Template__c(Name='PST01');
         try
         {
            insert testPST1;
         }
         catch(System.DMLException e)
         {
            System.assert(e.getMessage().contains('Error'));
         }
        
         system.assertEquals('PST01',testPST1.Name);
         
         Production_Spec_Item__c testPSI=new Production_Spec_Item__c(Name='TestPSI01',Production_Spec_Template__c=testPST1.Id);
         insert testPSI;
         
         Production_Spec_Item__c testPSI1=new Production_Spec_Item__c(Name='TestPSI02',Production_Spec_Template__c=testPST1.Id);
         insert testPSI1;
    
         Media_Type__c testMedia=new Media_Type__c(Name='TM999876');
         insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='TST999876',Media_Types__c=testMedia.Id);
         insert testST;
                 
         Specification_Template__c testSpec1=new Specification_Template__c(Name='TST999876');
         insert testSpec1;
                
         Spec_Item__c testSPI1=new Spec_Item__c(Name='Test SPI 1310',Description__c='Test Desc 1310',Specification_Template__c=testSpec1.id);
         insert testSPI1;     
             
         Specification_Template__c testSpec2=new Specification_Template__c(Name='Testing Spcification Template 1311');
         insert testSpec2;
                
         Job__c testJob1=new Job__c(Name='TJ999876',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id);
         insert testJob1;
                 
         System.assertEquals('TJ999876',testJob1.Name); 
         
         GL_Department__c testGLD = new GL_Department__c(Name='TGLD999876');
         try
          {
           insert testGLD;
          }
         catch(System.DMLException e)
          {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }

         GL_Code__c testGL=new GL_Code__c(Name='TGLC999876',GL_ID__c='TGLD999876',GL_Department__c=testGLD.id);
         insert testGL;
               
         Quote__c testQ=new Quote__c(Name='Q999876',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
         insert testQ;
           
         ApexPages.currentPage().getParameters().put('Qid',testQ.Id);
         
         // Instantiate the standard controller with the Quote
         ApexPages.StandardController con=new ApexPages.StandardController(testQ);
       
         // Instantiate the extention instance with the standard controller 
         Import_Production_Spec_Item_Extension ext1=new Import_Production_Spec_Item_Extension(con);
        
         ApexPages.Pagereference result=ext1.importSpecs();
        
         ext1.ProductionSpecTempName=testPST1.Id;
         result=ext1.importSpecs();
         List<SelectOption> lst=ext1.getProductionSpecTemplates();
         result=ext1.cancelme();
    }
   // End Test Coverage
    
}
/* End of Class */