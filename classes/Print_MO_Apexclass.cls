public class Print_MO_Apexclass {
    
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public List<Document> lstDoc;
    Public Boolean ShowProductionEstimate{get;set;}
    public list<Material_Purchase_Line_Item__c> molircds{get;set;}
    public list<Material_Order_Line_Item_Receipt__c>moliReceiptrcds{get;set;}
    String MOid;
    
    
    public Print_MO_Apexclass(ApexPages.StandardController controller){
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        // Code to display Subsriber Organization Logo
        
        // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
        
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
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
        
        MOid = ApexPages.currentpage().getParameters().get('id');
        
        molircds =   [select id,name,Material_Item__c, Material_Item__r.name,Material_Order__c, Material_Order__r.name,MPLI_Status__c, Calc_Unit__c,Qty__c,Qty_Outstanding__c from Material_Purchase_Line_Item__c where Material_Order__c =: MOid WITH SECURITY_ENFORCED Order By CreatedDate desc];
        
        moliReceiptrcds =[select id,name,Material_Purchase_Line_Item__c,Material_Purchase_Line_Item__r.name,MOLI_Receipt_Date__c,MOLI_Receipt_Qty__c,MPLI_Receipt_Status__c from Material_Order_Line_Item_Receipt__c where Material_Purchase_Line_Item__c =: molircds WITH SECURITY_ENFORCED Order By CreatedDate desc];   
        
    }
    
}