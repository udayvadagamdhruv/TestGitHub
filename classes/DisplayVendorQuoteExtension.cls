// This class is used in Display Vendor Quote vf

public with sharing class DisplayVendorQuoteExtension 
{
    // Global variables
    /*
    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    
    
    
    
    
    public string strVQID{get;set;}
    public List<Vendor_Quote__c> vq{get;set;}
    public List<Vendor_Quote__c> vq11{get;set;}
    public String email{get;set;}
    String theID;
     public string strID{get;set;}
    // End of Global variables

      // Start constructor
    public DisplayVendorQuoteExtension() 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        vq=[select id,Name,Date__c,Amount__c,Vendor__r.Name,Restrict__c,Quote__c from Vendor_Quote__c where Quote__c =: theID ORDER BY Name ];
    }
    // End of Constructor
    
    // This method is called on to create Vendor Quote
    public PageReference CreateVQ()
     {
           String qid;
           String theId=ApexPages.CurrentPage().getParameters().get('id');
           Vendor_Quote__c vendorQuote = new Vendor_Quote__c();
           Quote__c Quote = [Select Id from Quote__c where id =: theID];
           qid=Quote.Id;
       
       
         if(isLtng)
            {
                   PageReference p = Page.createnewvendorquotefinalLightning;
                   p.setredirect(true);     p.getParameters().put('qid',theID);   return p;
            }
            else
            {
                   PageReference p = Page.createnewvendorquotefinal;
                   p.setredirect(true);
                   p.getParameters().put('qid',theID); 
                   return p;
            }
       
       
       
    }
    // End of method CreateVQ
    
    
     public PageReference Approve()
    {
    
         List<Vendor_Quote__c> updateVendorQuote=new List<Vendor_Quote__c>();
          vq=[select id,Name,Date__c,Amount__c,Vendor__r.Name,Restrict__c,Quote__c from Vendor_Quote__c where Quote__c =: theID ORDER BY Name ];
          
         List<Vendor_Quote__c> VQLI= [select id,Name,Date__c,Amount__c,Vendor__r.Name,Restrict__c,Quote__c from Vendor_Quote__c where id =: strID Limit 1];
            
         for(Vendor_Quote__c VQ:VQLI)
         {
            VQ.Restrict__c=True;
            updateVendorQuote.add(VQ);
         }
            integer count=0;
           for(Vendor_Quote__c  veq:vq){
                 
                  if(veq.Restrict__c==True){
                  count=count+1;
                  }
           
           } 
            
            
        if((count <1 && updateVendorQuote.size() >0) )   
                   
         {   
            
              //try
              //{ 
              
                  PageReference p =  new Pagereference('/apex/ApproveVendorQuote?id='+strID);
                  p.setRedirect(true);   return p; 
                  /*
                   update updateVendorQuote;
                   vq=new list<Vendor_Quote__c>();
                   vq=[select id,Name,Date__c,Amount__c,Vendor__r.Name,Restrict__c,Quote__c from Vendor_Quote__c where Quote__c =: theID ORDER BY Name ];
                   */              
                //}
          
              //catch(System.DMLException e)
              //{
               //   apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
               //   return null;
              //}
          
     /*     }
          
          else{
           if(count>=1 && updateVendorQuote.size() >0){
           
                      ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,'Vendor : You can not approve more than one vendor');
                      ApexPages.addMessage(myMsg1);   return null;
           }
          
          }
          
          Return null;
        
    }
    
    
/*   
    public PageReference sendPdf() 
    {
 
    PageReference pdf = Page.PrintQuote;
    pdf.getParameters().put('id',strVQID);
 
    // the contents of the attachment from the pdf
    Blob body;
    
    Vendor_Quote__c testVQ = [select id,Name,Quote__r.Name,Vendor__c,Vendor__r.Name,Vendor__r.Email__c from Vendor_Quote__c where id =: strVQID];
    email = testVQ.Vendor__r.Email__c; 
 
    try 
    {
     // returns the output of the page as a PDF
      body = pdf.getContent();
 
    // need to pass unit test -- current bug  
    } 
    catch (VisualforceException e) 
    {
      body = Blob.valueOf('Some Text');
    }
 
    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    attach.setContentType('application/pdf');
    attach.setFileName('QuotePdf.pdf');
    attach.setInline(false);
    attach.Body = body;
 
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    mail.setToAddresses(new String[] { email });
    mail.setSubject('PDF Email Demo');
    mail.setHtmlBody('Here is the email you requested! Check the attachment!');
    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
 
    // Send the email
   
    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    System.debug('******************************'+mail);
     for(Messaging.sendEmailResult result : r) 
     {
           if(!r[0].isSuccess()) 
           {               
               System.debug(result);
               ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'PDF of '+testVQ.Quote__r.Name+' Quote can not be sent to Vendor '+ testVQ.Vendor__r.Name +'.Because Email address is not specified for this Vendor');
               ApexPages.addMessage(msg);
           }

           else
           {
              System.debug(result);
              ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'PDF of '+testVQ.Quote__r.Name+' Quote Sent Successfully to Vendor '+ testVQ.Vendor__r.Name + ' at '+email);
              ApexPages.addMessage(msg);
           }
       }
    return null;
 
  }
  */
    
   
/*    
    // This method is called on to update Vendor Quote (Inline Editing)
    public PageReference save()
     {
       List<Vendor_Quote__c> temp=[select id,name from Vendor_Quote__c where Quote__c =: theID AND Restrict__c=true];
       // Apexpages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+temp.size()));
       Integer count=0;
         try
         {
             for(Vendor_Quote__c vqItem:vq)
             {
                 if(vqItem.Restrict__c==True)
                 {
                     count=count+1;
                 }
             }
             if(count==1)
             {
                 List<Vendor_Quote__c> updateVQ=new List<Vendor_Quote__c>();
                 List<String> vendorquoteid=new List<String>();
                 
                 for(Vendor_Quote__c vqItem:vq)
                 {
                     /*    if(vqItem.Restrict__c==True)
{
PageReference p =  new Pagereference('/apex/ApproveVendorQuote?id='+vqItem.id);
p.setRedirect(true);
return p; 
}
*/ 
                     
                 /*    if(vqItem.Restrict__c==True)
                     {
                         vendorquoteid.add(vqItem.id);
                     }
                     
                     
                     updateVQ.add(vqItem);
                 }
                 update updateVQ;
                 
                 
                 
                 if(vendorquoteid.size()>0 && temp.size()==0 ){
                     PageReference p =  new Pagereference('/apex/ApproveVendorQuote?id='+vendorquoteid[0]);
                     p.setRedirect(true);  return p; 
                     
                 }
                 
                 
                 
             }
             else
             {
                 List<Vendor_Quote__c> updateVQ=new List<Vendor_Quote__c>();
                 for(Vendor_Quote__c vqItem:vq)
                 {
                     if(schema.SobjectType.Vendor_Quote__c.Fields.Restrict__c.isUpdateable()){
                         vqItem.Restrict__c=False;
                     }
                     updateVQ.add(vqItem);
                 }
                 if(Schema.sObjectType.Vendor_Quote__c.isUpdateable()) {
                     update updateVQ;
                 }
                 if(count>1)
                 {
                     ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,'Vendor : You can not approve more than one vendor');
                     ApexPages.addMessage(myMsg1);
                     return null;
                 }
             }
         }
    
        catch(System.DMLException e)
         {
                 return null;
         }
         
     
        PageReference p =  new Pagereference('/apex/DetailQuoteSwitch?id='+theID+'&section=vendorquote');
        p.setRedirect(true);   
        return p; 
    } 
    // End of method Save

    //Method to Approve Vendor
   public Pagereference ApproveVendor()
    {
              PageReference p =  new Pagereference('/apex/ApproveVendorQuote?id='+strVQID);
              p.setRedirect(true);
              return p; 
    }  
  //End of Approve Vendor Method
    
    
    // Test Method
  /*static testMethod void DisplayVendorQuote()
    {
         DisplayVendorQuoteExtension ext=new DisplayVendorQuoteExtension();
           
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 370');
             
                insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 370',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 370');
                insert testSpec;
                
         Job__c testJob1=new Job__c(Name='Test Job 370',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
         System.assertEquals('Test Job 370',testJob1.Name);      
               
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD5');
             try
              {
               insert testGLD;
              }
             catch(System.DMLException e)
              {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
               
         Quote__c testQ=new Quote__c(Name='Quote 370',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
            try
             {
              insert testQ;
             }
            catch(System.DMLException e)
             {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
         System.assertEquals('Quote 370',testQ.Name);     
         
         
         Vendor__c testVendor=new Vendor__c(Name='Vendor2220');
           try
            {
             insert testVendor;
            }
           catch(System.DMLException e)
            {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
             
         Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500,Restrict__c=True);
         insert testVQ; 
         
         Vendor_Quote__c testVQ1=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=600,Restrict__c=True);
         insert testVQ1;  
           
           
        ApexPages.currentPage().getParameters().put('Id',testQ.Id);
           
        // Instantiate the extention instance with the Custom Controller
        DisplayVendorQuoteExtension ext1=new DisplayVendorQuoteExtension();
       
          // Invoke the primary method on the extension
        ApexPages.PageReference result1=ext1.CreateVQ();
        result1=ext1.save();
        result1=ext1.ApproveVendor();
    } */
 // End of test Method
}
// End o Apex class