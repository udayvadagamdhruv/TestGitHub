// This class is used to delete Spec Item
public with sharing class DeleteProductionSpecItem 
{
   public boolean isLtng {set;get{
   
    return (UserInfo.getUITheme()=='Theme4d')?true:false;
   }}
   
   

    // Start Global variables
    public Id PSTId;
    private final Production_Spec_Item__c objPSI;
    // End of Global variables
    
    // Start Constructor
    public DeleteProductionSpecItem(ApexPages.StandardController controller) 
    { 
    this.objPSI=(Production_Spec_Item__c)controller.getrecord();
    PSTId = [Select Id,Production_Spec_Template__c from Production_Spec_Item__c where Id =:objPSI.Id].Production_Spec_Template__c;
    }
    // End of Constructor
    
    // This method is called on to delete Production Spec Item    
     public PageReference checkDelete()
     {
        try
        {
            Database.delete(objPSI);        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deletion of Production Spec Item, navigate to Production Spec Template Detail Page
      Pagereference p;
         if(isLtng)
              {
               p =new Pagereference('/apex/ProductionSpecTemplateDetailLightning?id='+PSTId);
              }
        else
            {
              p =new Pagereference('/apex/ProductionSpecTemplateDetail?id='+PSTId);
             }
             p.setRedirect(true);
             return p;
     }
     // End of delete method

     // Start Test Coverage
        static testMethod void deleteProductionSpecItem()
         {
            Production_Spec_Template__c testPST=new Production_Spec_Template__c(Name='PST0010');
            try
             {
                  insert testPST;
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
             
             system.assertEquals('PST0010',testPST.Name);
             
             Production_Spec_Item__c testPSI = new Production_Spec_Item__c(Name='TestPSI00011',Production_Spec_Template__c=testPST.Id);
             try
             {
                 insert testPSI;
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
             
            
             System.assertEquals('TestPSI00011',testPSI.Name);
             
            // Instantiate the standard controller with the Spec Item 
            ApexPages.StandardController con=new ApexPages.StandardController(testPSI);
        
            // Instantiate the extention instance with the standardcontroller 
            DeleteProductionSpecItem ext=new DeleteProductionSpecItem(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result=ext.checkDelete();
           ApexPages.PageReference result1=ext.checkDelete();
       }
     // End Of Test Coverage
}
// End of Class