// This class is used to Unaprrove Estimate Line Item
public with sharing class UnapproveELI 
{/*
    // Global variables
    private final Estimate_Line_Items__c ELI;
    String theId,Jobid;
    // End of Global variables

    // Start Constructor
    public UnapproveELI(ApexPages.StandardController controller) 
    {
        this.ELI=(Estimate_Line_Items__c)Controller.getRecord();
        theId = ApexPages.currentPage().getParameters().get('id');
        Estimate_Line_Items__c ELI1 = [select id,name,Job__c from Estimate_Line_Items__c where id =: theId];
        Jobid = ELI1.Job__c;
    }
    // End of Constructor

    // This method is called on to unapprove ELI
    public PageReference autoRun() 
     {
     try
      {
          if(schema.SobjectType.Estimate_Line_Items__c.Fields.Approved__c.isUpdateable()){ 
              ELI.Approved__c = False;}
          if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){ 
              update ELI;}
          Job__c job = [select id,Name,Estimate_Total__c from Job__c where Id =: Jobid];
          Estimate_Line_Items__c eli = [select id,Name,Total_Amount__c from Estimate_Line_Items__c where id=: ELI.Id];
          if(schema.SobjectType.Job__c.Fields.Estimate_Total__c.isUpdateable()){ 
              job.Estimate_Total__c = job.Estimate_Total__c - eli.Total_Amount__c;}
          if(Schema.sObjectType.Job__c.isUpdateable()){ 
              update job;}
      }
     catch(System.DMLException e)
     {
         return null;
     }
        // After unapprove, navigate to Estimate Tab 
        PageReference pageRef =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=5');
        pageRef.setRedirect(true);
        return pageRef;
      }  
      // End of method autoRun
      */
    
}// End of Class