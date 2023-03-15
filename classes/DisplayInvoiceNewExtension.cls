// This method is used to display Invoices under Job Tab
public with sharing class DisplayInvoiceNewExtension     
{

    public boolean isLtng{ set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            

//Added by Rahul starts--
    public string myClient {get; set;}
    public Invoice_Line_Item__c inv {get; set;}
    Public Boolean ShowProductionEstimate{get;set;}
//--ends

    public String getPoId() { 
        return poId;
    }

    // Global variables
   // Public String theID;
   Public ID theID;
    public List<Invoice_Line_Item__c> ILI{get;set;} 
    Invoice__c objInv{get;set;}
   // String poId{get;set;}
   ID poId{get;set;}
//Added by Rahul
    public String inSt{get; set;}
    // End of Global variables

//by rahul added code starts--
    //Delete Line Item 
    public void deleteRec(){
        string pgId = ApexPages.currentPage().getParameters().get('id');
        string ss1 = ApexPages.currentPage().getParameters().get('di1');
        system.debug('@@@@@@@@@@@@@ '+myClient);
        system.debug('************* '+pgId );
         system.debug('========================================================================================== '+ss1);


        inv = [SELECT id, Name, Invoice__c, Invoice__r.Invoice_Status__c FROM Invoice_Line_Item__c WHERE Id =: myClient];
        delete inv;
        ILI=[select id,Name,Invoice__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,Production_Estimate__r.name,Production_Estimate__c,Amount__c,GL_Code__c,Unit_Type__c,GL_Department__c,GL_Code_No__c,Quantity__c from Invoice_Line_Item__c where Invoice__c =: theID ORDER BY Name];

        /*
       PageReference newpg = new PageReference('/apex/InvoiceDetailPageLightning?id='+pgId);
        return newpg;
       */
    }

    //Edit record
    public pageReference editRec(){
        string pgId = ApexPages.currentPage().getParameters().get('id');
        string ss2 = ApexPages.currentPage().getParameters().get('di2');
        system.debug('@@@@@@@@@@@@@ '+myClient);
        system.debug('************* '+pgId );
         system.debug('==================================================================================================== '+ss2);
        inv = [SELECT id, Name, Invoice__c, Invoice__r.Purchase_Order__c, Invoice__r.Invoice_Status__c, Amount__c, GL_Code__c, Estimate_Line_Item__c FROM Invoice_Line_Item__c WHERE Id =: myClient];
       
        PageReference newpg;
        if(isLtng)
            newpg = new PageReference('/apex/EditLineItemLightning?id='+myClient);
        else
            newpg = new PageReference('/apex/EditLineItem?id='+myClient);
            newpg.setRedirect(true);
            return newpg;
        
//created this following new page.
        
    }
//added code ends here
    
    // Start Constructor
    public DisplayInvoiceNewExtension()
    {
         ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
         ShowProductionEstimate =activeSettings.Active__c;
        
         theID = ESAPI.encoder().SFDC_HTMLENCODE(ApexPages.CurrentPage().getParameters().get('id'));
         objInv=[Select Id, Name, Purchase_Order__c, Invoice_Status__c from Invoice__c where Id=: theId LIMIT 1];
         poId=ESAPI.encoder().SFDC_HTMLENCODE(objInv.Purchase_Order__c);
         ILI=[select id,Name,Invoice__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,Production_Estimate__r.name,Production_Estimate__c,Amount__c,GL_Code__c,Unit_Type__c,GL_Department__c,GL_Code_No__c,Quantity__c from Invoice_Line_Item__c where Invoice__c =: theID ORDER BY Name];
         
//added by Rahul
         inSt = objInv.Invoice_Status__c;
    }
    // End of Constructor
 
    // This method is called on to add Invoice LIne Item for selected Invoice
     public PageReference add_ILI()
    {
        
        PageReference p;
        if(isLtng)
             p =  Page.AddInvoicelineItemNewLightning;
            
        else
            p =  Page.AddInvoicelineItemNew;
            p.setRedirect(true);
            p.getParameters().put('Invid',theID);
            return p;
    } 
    // End of method
    
     // This method is called on to add PO LIne Item for selected Invoice
    public PageReference add_ILI_from_poli()
    {
       
     //   PageReference p =  Page.AddPOLineItem;
     PageReference p;
       if(isLtng)
             p =  Page.addPOLineItemLightning;
        else
            p=Page.addPOLineItem;
            p.setRedirect(true);
            p.getParameters().put('Invid',theID);
            return p;
        
    } 
    // End of method
    
    
    public PageReference save()
    {
     try
      {
           update ILI;
      }
     catch(System.DMLException e){return null;}
     
     PageReference p;
    if(isLtng)
           p = new Pagereference('/apex/InvoiceDetailPageLightning?id='+theID);
    else
         p =  new Pagereference('/apex/InvoiceDetailPage?id='+theID);
          p.setRedirect(true);
          return p; 
   
      // After updating PO, navigate to Purchase Order Tab
     
    }
    //End Of Save Method  
    
    //Method For Cancel button    
     public PageReference cancelme()
     {
       PageReference p;
       if(isLtng)
           p=new Pagereference('/apex/InvoiceDetailPageLightning?id='+theID);
        else
          p=new Pagereference('/apex/InvoiceDetailPage?id='+theID);
          p.setRedirect(true);
          return p;    
        
     }
    //End Of Cancel Buttons method  
     
    
}// End of Class