public with sharing class InvAllocationTempEnhancedListExt {

 /*   // Global variables
    public List<Invoice_Allocation_Template__c> lstIAT{get;set;}
    public String strIAT{get;set;}
    // End of Global variables
    
    // Start constructor
    public InvAllocationTempEnhancedListExt (ApexPages.StandardController controller) 
    {
        lstIAT= [Select Id, Name,Description__c from Invoice_Allocation_Template__c Order BY Name LIMIT 10000 ];
    }
    // End of constructor
    
    // This method is called on to handle Delete link on list of IAT
    public pagereference deleteIAT()
    {
        Pagereference pg = new Pagereference('/apex/DeleteInvAllocationTemp?id='+strIAT);
        pg.setRedirect(true);
        return pg;
    }
    // End of method delete IAT
    
    // This method is called on to handle Edit link on list of IAT
    public pagereference editIAT()
    { 
        Pagereference pg = new Pagereference('/apex/EditInvAllocationTemp?id='+strIAT);
        pg.setRedirect(true);
        return pg;
    }
    // End of method edit IAT
    
    // This method is called on to handle Create New IAT button
    public pagereference createNewIAt()
    {
        Pagereference pg = new Pagereference('/apex/CreateInvAllocationTemp');
        pg.setRedirect(true);
        return pg;
    }*/
    // End of method create IAT

}