// Extension Class to Update Production Spec Item 
public with sharing class EditProductionSpecItemExtension
{
/*
   public boolean isLtng {set;get{
   
    return (UserInfo.getUITheme()=='Theme4d')?true:false;
   }}
   
   

     // Global Variables 
     private final Production_Spec_Item__c spec;
     public string prospectempid;
     // End of Global Variables 

    // Standard Controller Constructor
    public EditProductionSpecItemExtension(ApexPages.StandardController controller) 
    {
    this.spec=(Production_Spec_Item__c)controller.getrecord();
    prospectempid=spec.Production_Spec_Template__c;
    }
    // End of Standard Controller Constructor
     
    // Method called on to update Production Spec Item
    Public PageReference saveme()
    {
        try
        {
            String strid;
            update spec;
            strid = spec.Production_Spec_Template__c;        

            // After update navigate to the Production Spec Template Parent Record
            PageReference p;
            if(isLtng)
                {
                 p=new Pagereference('/apex/ProductionSpecTemplateDetailLightning?id='+strid);
                }
                
           else
                {
                p=new Pagereference('/apex/ProductionSpecTemplateDetail?id='+strid);
                }
                p.setRedirect(true);
                return p;
        }
        catch(System.DMLException e)
        {
            return null;
        }
    }
    
    public pageReference cancel() {
     PageReference p;
        if(isLtng)
                {
                 p =  new Pagereference('/apex/ProductionSpecTemplateDetailLightning?id='+prospectempid);
                }
             else
                {
                p =  new Pagereference('/apex/ProductionSpecTemplateDetail?id='+prospectempid);
                }
               p.setRedirect(true);
               return p;
    }
    
    
    
    
    // End of Update Method 

    // Test Coverage 
    static testMethod void Test_EditProductionSpecExtension()
    {
         Production_Spec_Template__c testPST1=new Production_Spec_Template__c(Name='PST0006');
         try
         {
            insert testPST1;
         }
         catch(System.DMLException e)
         {
            System.assert(e.getMessage().contains('Error'));
         }
         system.assertEquals('PST0006',testPST1.Name);
         
         Production_Spec_Item__c testPSI=new Production_Spec_Item__c(Name='TestPSI0009',Production_Spec_Template__c=testPST1.Id);
            try
             {
                 insert testPSI;
             }
             catch(System.DMLException e)
             {
                 System.assert(e.getMessage().contains('Error'));
             }   
                 
        // Instantiate the standard controller with the Production Spec Item 
        ApexPages.StandardController con=new ApexPages.StandardController(testPSI);
        
        // Instantiate the extention instance with the standardcontroller 
        EditProductionSpecItemExtension ext=new EditProductionSpecItemExtension(con);
        
        // Invoke the primary method on the extension 
        ApexPages.PageReference result=ext.saveme();
        
        delete testPSI;
        result=ext.saveme();
        ApexPages.PageReference result3=ext.cancel();
     }*/
    // End Test Coverage
}
// End of Class