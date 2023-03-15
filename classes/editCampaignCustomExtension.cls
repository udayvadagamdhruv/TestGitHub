// Extension Class for EditCampaign
public with sharing class editCampaignCustomExtension
{
    // Global Variables 
   /* private final Campaign__c objCampaign;
    // End of Global Variables

    // Standard Controller Extension
    public editCampaignCustomExtension(ApexPages.StandardController con)
    {
      this.objCampaign=(Campaign__c)con.getrecord();
    }
    // End of Standard Controller Extension
    
    // Method called on to update Campaign
     Public PageReference saveme()
    {
        try 
        {
            update objCampaign;
        }
        catch(System.DMLException e)
         {
            return null; 
         }
     
        return null;
    }
    // End of update Campaign Method
    
   
    // Start Test Coverage
    static testMethod void EditCampaign()
    {
        Campaign__c testCampaign1=new Campaign__c(Name='C100',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
        try
        {
            insert testCampaign1;
        }
        catch(System.DMLException e)
        {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        Campaign__c tc=[select id,Name from Campaign__c where id =: testCampaign1.id];
        tc.Name='C101';
        
        ApexPages.StandardController con=new ApexPages.StandardController(tc);
        editCampaignCustomExtension ext=new editCampaignCustomExtension(con);
        ApexPages.PageReference result=ext.saveme();
        System.assertEquals('C101',tc.Name);
        
        delete tc;
        result = ext.saveme();
     
    }    */
    // End of Test Coverage
}
// End of Class