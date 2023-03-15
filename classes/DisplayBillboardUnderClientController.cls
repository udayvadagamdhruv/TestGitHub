public with sharing class DisplayBillboardUnderClientController {

/*
    // Start Global variables
        public list<String> strStatus{get;set;}
        public List<Billboard__c> BB{get;set;} 
        Public String theID;
        public integer count;
        public integer countstr;
    // End of Global variables
   
    public List<selectOption> getStatusList() 
    {
        List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Billboard__c.Billboard_Status__c.getDescribe();
       //  optionList.add(new selectOption('All Billboards', 'All Billboards')); 
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
        
        return optionList;  
    }
    
    // Start Constructor
     public DisplayBillboardUnderClientController()
     {
     strStatus = new list<String> ();
         strStatus.add('Active');strStatus.add('Active-Batch');
         theID = ApexPages.CurrentPage().getParameters().get('id');
         BB= [Select id,Name,Billboard_Type__c,BB_Vendor__c,Expiration_Date__c,Location__c,Client_Name__c,Title__c,Billboard_Status__c from Billboard__c where Client_Name__c=: theID AND (Billboard_Status__c=:'Active' OR Billboard_Status__c=:'Active-Batch') Order By Name limit 1000];
     }
     // End constructor

    //Method to populate BBs based upon status
    
    
    public void populatebbList()
    {
    
         BB= [Select id,Name,Billboard_Type__c,BB_Vendor__c,Expiration_Date__c,Location__c,Client_Name__c,Title__c,Billboard_Status__c from Billboard__c where Client_Name__c=: theID AND Billboard_Status__c IN : strStatus Order By Name limit 1000];
        
      
         /* count = [select count() from Billboard__c where  Client_Name__c=: theID];
           
          if(strStatus != 'All Billboards')
          {
              countstr = [select count() from Billboard__c where Client_Name__c=: theID and Billboard_Status__c = :strStatus];
          }
          
          if(strStatus == 'All Billboards')
          {
               if(count>1000)
               {
               
                     BB= [Select id,Name,Billboard_Type__c,Expiration_Date__c,Location__c,Client_Name__c,Title__c,Billboard_Status__c,BB_Vendor__c from Billboard__c where Client_Name__c=: theID  Order By Name limit 1000];
                     system.debug('BB Status & size'+bb.size()+strStatus );
               }
               else
               {
                
                    BB= [Select id,Name,Billboard_Type__c,Expiration_Date__c,Location__c,Client_Name__c,Title__c,Billboard_Status__c,BB_Vendor__c from Billboard__c where Client_Name__c=: theID  Order By Name limit 1000];
                    system.debug('BB Status & size'+bb.size()+strStatus );
               }
          }
          
          else
          {
             if(countstr >1000 )
             {
                  
                   BB= [Select id,Name,Billboard_Type__c,Expiration_Date__c,Location__c,Client_Name__c,Title__c,Billboard_Status__c,BB_Vendor__c from Billboard__c where Client_Name__c=: theID AND Billboard_Status__c=:strStatus  Order By Name limit 1000];
                   system.debug('BB Status & size'+bb.size()+strStatus );
             }
             else
             {
                  
                   BB= [Select id,Name,Billboard_Type__c,Expiration_Date__c,Location__c,Client_Name__c,Title__c,Billboard_Status__c,BB_Vendor__c from Billboard__c where Client_Name__c=: theID AND Billboard_Status__c=:strStatus  Order By Name limit 1000];
                   system.debug('BB Status & size'+bb.size()+strStatus );
               
             }
          }
     } 
    */
    
    



}