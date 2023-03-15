Public with sharing class PrintBatchInvoicesExt 
{
   /* public list<Client_Invoice__c> lstinvoice{get;set;}
    public list<Client_Invoice__c> lstinv{get;set;}
    
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    Public Boolean ShowProductionEstimate{get;set;}

    
    public PrintBatchInvoicesExt(ApexPages.StandardController controller) 
    {
        
    }
    
    
    public PageReference updateMethod()
    {
       
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }
       
       
         string status= 'Open';
        
        lstinvoice=[select id,name,Invoice_Status__c,Client_Name__r.Billing_Postal_Code__c ,Client_Name__r.Billing_State__c,Client_Name__r.Billing_Street__c,Client_Name__r.Billing_City__c,Taxable_Total_field__c,Sales_Tax__c,Invoice_Total_new__c,Invoice_Date__c,Job__r.Job_Auto_Number__c,(select id,Name,Production_Estimate__c,Equipment_Type__c,Production_Estimate__r.name,Billable_Amount__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,GL_Code__c,Quantity__c,GL_Code_No__c,GL_Code__r.Name,Unit_Type__c,GL_Code__r.GL_ID__c,Client_Invoice__c from Client_Invoice_Line_Items__r),Job__r.name,Notes__c from Client_Invoice__c where Invoice_Status__c=:status WITH SECURITY_ENFORCED];
        
       // string sid=lstinvoice.id;
        lstinv = new list<Client_Invoice__c>();
        
        for(Client_Invoice__c Inv:lstinvoice)
        {
            
               if(schema.SobjectType.Client_Invoice__c .Fields.Invoice_Status__c.isUpdateable()){ 
            inv.Invoice_Status__c='Paid';}
               if(schema.SobjectType.Client_Invoice__c .Fields.Invoice_Date__c.isUpdateable()){ 
            inv.Invoice_Date__c=system.today();}
            lstinv.add(inv);

        }
             if(Schema.sObjectType.Client_Invoice__c.isUpdateable()){
                update lstinv;}
       
       return null;

    }
    
    */

}