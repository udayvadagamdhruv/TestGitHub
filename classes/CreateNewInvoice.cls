// This class is used to create New Invoice 

public with sharing class CreateNewInvoice 
{
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            } 
    
    // Global variables  
    public string vendor1 {set;get;}
    private final Invoice__c invoice;
    public String jobid{get;set;}
    // End of Global variables 
    
    // Standard Controller Constructor
    public CreateNewInvoice(ApexPages.StandardController controller) 
    {
        this.invoice=(Invoice__c)controller.getRecord();
        jobid=ApexPages.CurrentPage().getParameters().get('jobid');
        invoice.Job__c = jobid;
    }
    // End Controller Constructor
    
    // Retrieve List of Vendors
    public List<selectOption> getVendor() 
        {
        List<selectOption> optionList = new List<selectOption>();
       
        optionList.add(new selectOption('', '- None -')); 
        
        for (Vendor__c a : [SELECT Id, name FROM Vendor__c order by Name Limit 5000]) 
        {  
        optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
        }
     //End of get Vendors   

    // This method is called to create New Invoice
    public PageReference saveme() 
    { 
        string strInvoiceId;
        try
        {   
           
           
           if(Vendor1==null)
              {
                 String vendor11= Schema.Invoice__c.fields.Vendor__c.getDescribe().getLabel();
                  ApexPages.addMessage(New Apexpages.Message(ApexPages.Severity.error,vendor11+' : You must select a '+vendor11+'.'));
                  return null;
               }
          
          else
          {
                invoice.vendor__c=vendor1;
                insert invoice;
                strInvoiceId = invoice.id;
            
             if(isLtng)
                {
                     PageReference pageRef = new PageReference('/apex/InvoiceDetailPageLightning?id='+strInvoiceId);
                     pageRef.setRedirect(true);
                     return pageRef; 
                }
                else
                {
                      PageReference pageRef = new PageReference('/apex/InvoiceDetailPage?id='+strInvoiceId);
                      pageRef.setRedirect(true);
                      return pageRef;
                }
         
           } 
       }
       
       
        catch(DMLException e)
        {
            return null;
        }
       
   
     } 
     // End of Save method 
     
     // This method is called to handle Cancel button click
       Public PageReference cancelme()
        {
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid+'&tab=Jobcost'+'&section=vendorinvoices');
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                 PageReference p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=7');
                 p.setRedirect(true);
                 return p;    
            }   
        }
        // End of Cancel method 
     
     // Start Test Coverage 
        static testMethod void CreateNewInvoicePositiveTest()
         {
           Job_Number_Setting__c customSetting994 = new  Job_Number_Setting__c(Name= 'yy');
           insert customSetting994;
            
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 623');
           insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 623',Media_Types__c=testMedia.Id);
           insert testST;
         
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 623');
           insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 623',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                 insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
             }
           System.assertEquals('Test Job 623',testJob1.Name);  
               
           Vendor__c testVendor=new Vendor__c(Name='Vendor 623');
           insert testVendor;  
   
           Invoice__c testI=new Invoice__c(Job__c=testjob1.Id,Date_Received__c=System.Today(),Vendor__c=testVendor.Id);

           ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testI);
     
           // Instantiate the extention instance with the standard controller
           CreateNewInvoice   ext=new CreateNewInvoice(con);
           
           // Invoke the primary method on the extension 
           ApexPages.PageReference result1=ext.saveme();
           ApexPages.PageReference result2=ext.cancelme();
               ext.vendor1=''+testVendor.id;
             ApexPages.PageReference result5=ext.saveme();
            
            
           // Negative Test
           Invoice__c testI1=new Invoice__c();
           ApexPages.StandardController con1=new ApexPages.StandardController(testI1);
           CreateNewInvoice   ext1=new CreateNewInvoice(con1);
           
           ApexPages.PageReference result3=ext.saveme();
           ApexPages.PageReference result4=ext.cancelme();
           ext.getVendor();
             
        }    
    // End of Positive Test Case
}
// End of Class