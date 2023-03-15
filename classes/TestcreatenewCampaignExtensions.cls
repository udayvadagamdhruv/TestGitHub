@isTest
Public Class TestcreatenewCampaignExtensions{

  /*static Testmethod void TestcreatenewCampaignExtensions(){
  
   Campaign__c testCampaign1=new Campaign__c(Name='TC001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
    
        Campaign__c testCampaign2=new Campaign__c(Name='TC002',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=1000,Actual_Cost__c=2000);
         try
        {
            insert testCampaign2;
        }
        catch(System.DMLException e)
        {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
    
        // Instantiate the standard controller with the Campaign 
       
        ApexPages.StandardController con=new ApexPages.StandardController(testCampaign1);
        
        // Instantiate the extention instance with the standardcontroller
        createnewCampaignExtensions ext=new createnewCampaignExtensions(con);
        
        // Invoke the primary method on the extension
        ApexPages.PageReference result=ext.saveme(); 
       
        
        System.assertEquals('TC001',testCampaign1.Name);
        
        // To check for Duplicate Campaign
        Campaign__c testCampaign3=new Campaign__c(Name='TC003',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=1000,Actual_Cost__c=2000);
            try
            {
                insert testCampaign3;
            }
            catch(System.DMLException e)
            {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
        
        Campaign__c Camp = [Select id,Name from Campaign__c where id =: testCampaign3.Id];
        Camp.name = 'TC001';
            try
            {
                update Camp;
            }
            catch(System.DMLException e)
            {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
            
        Campaign__c testCampaign5=new Campaign__c(Name='TC005');
        insert testCampaign5;
        
        ApexPages.StandardController con5=new ApexPages.StandardController(testCampaign5);
        
        // Instantiate the extention instance with the standardcontroller
        createnewCampaignExtensions ext5=new createnewCampaignExtensions(con5);
        
        ApexPages.Pagereference result5=ext5.saveme();
        
        delete testCampaign5;
        
        result5=ext5.saveme();  
       ApexPages.Pagereference  result6= ext5.cancelme();  
       
       }    */
  
  }