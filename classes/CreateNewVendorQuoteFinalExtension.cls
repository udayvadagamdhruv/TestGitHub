public with sharing class CreateNewVendorQuoteFinalExtension 
{
    // Global variables 
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    
    
    private final Vendor_Quote__c vq;
    public String qid{get;set;}
    public String vqid{get;set;}
     String vendorName;
    public String getVendorName() { 
        return VendorName; 
    }
    public void setVendorName(String s) {  
        this.Vendorname = s; 
    }
    String strid;
    // End Globale variables

    // Start Constructor
    public CreateNewVendorQuoteFinalExtension(ApexPages.StandardController controller) 
    {
        this.vq=(Vendor_Quote__c)controller.getRecord();
        vq.Date__c=System.Today();
        qid=ApexPages.CurrentPage().getParameters().get('qid');
      vq.Quote__c=qid;
      vqid=vq.id;
    }
    // End Global variables
    
    // Method called on to save New Vendor Quote
      public PageReference saveme()
      {
        try
         {
              strid = vq.Quote__c;
              if(vendorName == null)
              {
                String strVendor = Schema.Vendor_Quote__c.fields.Vendor__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strVendor+' : You must select a '+strVendor+'.');
                ApexPages.addMessage(myMsg);
                return null;
              }
            else
            {
              vq.Vendor__c=vendorName;  insert vq; 
            }
         }      
        catch(System.DMLException e)
        {
            return null;
            
            
        }  
        if(isLtng){
        PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+strid+'&section=vendorquote');
        p.setRedirect(true);   return p; 
        }
        
        else{
        
        PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+strid);
        p.setRedirect(true);   return p; 
        
        
        }
     }
     // End Save method
        
        
       public PageReference cancelme()
       {  
          strid = vq.Quote__c;
          if(isLtng)
          {
            PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+strid+'&section=vendorquote');
            p.setRedirect(true);  return p; 
          }
        
        else{
        
        PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+strid);
        p.setRedirect(true);
        return p; 
        
        
        }
      }
       
       // Populate vendor into picklist
        public List<selectOption> getVendor()
        {
            List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
            options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
            Quote__c q11 = [select id,Name,GL_Code__c from Quote__c where id =: qid Limit 1];
            String glid = q11.GL_Code__c;
            List<Vendor_GL_Code__c> ven = [SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: glid];
      
            for (Vendor_GL_Code__c ar : ven)  
           {     
               options.add(new selectOption(ar.Vendor__c,ar.Vendor__r.Name)); //for all records found - add them to the picklist options
           }
            return options; //return the picklist options
        }
        // End getVendor method
       
         // Test Coverage Code
        /*
        static testMethod void CreateNewVendorQuotePositiveTest()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 357');
             
                 insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 357',Media_Types__c=testMedia.Id);
             
                 insert testST;
    
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 357');
             
                 insert testSpec;
  
              Job__c testJob1=new Job__c(Name='Test Job 357',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
            
              GL_Department__c testGLD = new GL_Department__c(Name='TestGLD');
              try
              {
                insert testGLD;
              }
              catch(System.DMLException e)
              {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
        
              Quote__c testQ=new Quote__c(Name='Quote 357',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
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
               
              System.assertEquals('Quote 357',testQ.Name);
               
              Quote_Spec_Item__c QSI=new Quote_Spec_Item__c(Name='Test QSI',Description__c='Des Test',Quote__c=testQ.Id);
               insert QSI;
              Quote_Spec_Item__c QSI1=new Quote_Spec_Item__c(Name='Test QSI1',Description__c='Des Test1',Quote__c=testQ.Id);
               insert QSI1;
               
              Vendor__c testVendor=new Vendor__c(Name='Vendor 357');
                insert testVendor;
             
              Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
              
              ApexPages.currentPage().getParameters().put('qid',testQ.id);
              ApexPages.StandardController con=new ApexPages.StandardController(testVQ);
            
              // Instantiate the extention instance with the standard controller
            
              CreateNewVendorQuoteFinalExtension  ext=new CreateNewVendorQuoteFinalExtension (con);
          
             //Example of calling a public method in the controller apex class
             List<SelectOption> options = ext.getVendor();
           
            // Invoke the primary method on the extension
            ApexPages.PageReference result1=ext.saveme();
            ApexPages.PageReference result2=ext.cancelme();
            
            System.assertEquals(testQ.Id,testVQ.Quote__c);

           } */
    // End of Positive Test Case
} // End of Class