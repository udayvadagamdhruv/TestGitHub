public with sharing class createProductionEstimateSpecExtension {

   /* // Global variables
    private final Production_Estimate_Spec_Item__c  objESI;
    public Id ProdEstLIId {get;set;}
    // End of Global variables

    // Start Constructor
    public createProductionEstimateSpecExtension (ApexPages.StandardController controller) 
    {
        this.objESI = (Production_Estimate_Spec_Item__c)controller.getRecord(); 
        
       /*  ProdEstLIId =ApexPages.CurrentPage().getParameters().get('id');
        objESI.Production_Estimate__c= ProdEstLIId ;
        *
    }
    // End of Constructor
    
    // Method to insert Estimate Line Item 
    Public PageReference saveme()
     {
        String strid;
        strid = objESI.Production_Estimate__c;
        try
        {
            insert objESI;
        }
        catch(System.DMLException e)
        {
            return null;
        }       
        PageReference p =  new Pagereference('/apex/ProductionEstimatedetailpage?id='+strid);
        p.setRedirect(true);
        return p;
     }*/
    // End of saveme method

}