// This class is used to delete Spec Item
public with sharing class DeleteSpecItem 
{
   public boolean isLtng { private set;get{
    
    string theme=UserInfo.getUITheme();
    return (theme=='Theme4d')?true:false;
}
}

    // Start Global variables
    public Id JobId;
    private final Spec_Item__c objSI;
    // End of Global variables
    
    // Start Constructor
    public DeleteSpecItem(ApexPages.StandardController con) 
    {
        this.objSI=(Spec_Item__c)con.getrecord();
        JobId = [Select Id, Specification_Template__c from Spec_Item__c where Id =:objSI.Id limit 1].Specification_Template__c;
    }
    // End of Constructor
    
    // This method is called on to delete Spec Item    
     public PageReference checkDelete()
     {
        try
        {
            Database.delete(objSI);        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deletion of Spec Item, navigate to Specification Detail Page
        if(isLtng)
            {
             PageReference p =  new Pagereference('/apex/SpecificationTemplateTabOverrideLti?id='+JobId);
             p.setRedirect(true);
             return p;
             }
        else
             {
             PageReference p =  new Pagereference('/apex/SpecificationTemplateTabOverride?id='+JobId);
             p.setRedirect(true);
             return p;
             }
     }
     // End of delete method

     // Start Test Coverage

         static testMethod void deleteScheduleTaskPositiveTest()
         {
             Specification_Template__c testST=new Specification_Template__c(Name='Test Specification Template');
             try
             {
                 insert testST;
                 System.debug('Spec Template record inserted successfully@@@ '+testST);
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
             
             Spec_Item__c testSCT=new Spec_Item__c(Name='Test Spec Item 1',Specification_Template__c=testST.Id);
             
             try
             {
                 insert testSCT;
                
                 System.debug('Schedule Task record inserted successfully@@@ '+testSCT);
               
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
             
            
             System.assertEquals('Test Spec Item 1',testSCT.Name);
             
        // Instantiate the standard controller with the Spec Item 
       
        ApexPages.StandardController con=new ApexPages.StandardController(testSCT);
        
        // Instantiate the extention instance with the standardcontroller 
        DeleteSpecItem ext=new DeleteSpecItem(con);
        
        // Invoke the primary method on the extension 
        ApexPages.PageReference result=ext.checkDelete();
        ApexPages.PageReference result1=ext.checkDelete();
       }
     // End Of Positive Test Case
      
      static testMethod void deleteScheduleTask()
         {
             Specification_Template__c testST=new Specification_Template__c(Name='Test Specification Template');
             
             try
             {
                 insert testST;
                 System.debug('Spec Template record inserted successfully@@@ '+testST);
             }
             catch(System.DMLException e)
             {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             Spec_Item__c testSCT=new Spec_Item__c(Name='Test Spec Item 1',Specification_Template__c=testST.Id);
             try
             {
                 insert testSCT;
                
                 System.debug('Schedule Task record inserted successfully@@@ '+testSCT);
             }
             catch(System.DMLException e)
             {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
              Spec_Item__c testSCT1=new Spec_Item__c(Name='Test Spec Item 2',Specification_Template__c=testST.Id);
              try
              {
                 insert testSCT1;
                
                 System.debug('Schedule Task record inserted successfully@@@ '+testSCT);
               
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
              
               Spec_Item__c testSCT2=new Spec_Item__c(Name='Test Spec Item 2',Specification_Template__c=testST.Id);
              try
              {
                 insert testSCT2;
                
                 System.debug('Schedule Task record inserted successfully@@@ '+testSCT);
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
            Spec_Item__c ST = [Select id,Name from  Spec_Item__c where id =: TestSCT1.id];
             ST.Name='Test Spec Item 1';
             try
              {
                 update ST;
                
                 System.debug('Schedule Task record inserted successfully@@@ '+testSCT);
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
         }
    // End of Test Coverage
}// End of Class