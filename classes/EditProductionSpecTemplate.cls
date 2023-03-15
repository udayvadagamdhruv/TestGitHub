public with sharing class EditProductionSpecTemplate 
{

  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
  
   public string ProSpecTempprefix {set;get;}
    // Global Variables
    private final Production_Spec_Template__c objPST;
    // ENd of Global Variables
    
    // Standard Controller Constructor
    public EditProductionSpecTemplate(ApexPages.StandardController controller) 
    {
    this.objPST=(Production_Spec_Template__c)controller.getrecord();
    ProSpecTempprefix =Production_Spec_Template__c.SobjectType.getDescribe().getKeyPrefix();
          
    }
    
    // Method called on to Update Production Spec Template 
    Public PageReference saveme()
    {   
       try
       {
          update objPST;        
       } 
       catch(system.DMLException e)
       {
           return null;
       }
      // After update navigate to Production Spec Template Tab 
     PageReference p;  
      if(isLtng)
         {
          p =  new Pagereference('/'+ProSpecTempprefix +'/o');
         }
    
    else
         {
           p =  new Pagereference('/apex/AdminListView?intFocus=10');
         }
         p.setRedirect(true);
         return p;   
    }
    
    // Cancel method
    Public PageReference cancelme()
     {
     PageReference p;    
    if(isLtng)
            {
              p =new Pagereference('/'+ProSpecTempprefix +'/o');
            }
    
    else
         {
           p =new Pagereference('/apex/AdminListView?intFocus=10');
          }
          p.setRedirect(true);
          return p;   
  }
    //End of cancel method          
  
  
       // Test Coverage Code
        static testMethod void editProductionSpecTemplateTest()
        {
            Production_Spec_Template__c testPST=new Production_Spec_Template__c(Name='Testing Production Spec Template 0001');
            try
            {
                insert testPST;
               
            }
            catch(System.DMLException e)
            {
                 System.assert(e.getMessage().contains('Error : Not Inserted'));    
            }
            System.assertEquals('Testing Production Spec Template 0001',testPST.Name); 
            
             // Instantiate the standard controller with the Production Spec Template 
            ApexPages.StandardController con=new ApexPages.StandardController(testPST);
        
            // Instantiate the extention instance with the standardcontroller 
           EditProductionSpecTemplate ext=new EditProductionSpecTemplate(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result=ext.saveme();
        
            // Retrieve the Specification Template from the DB that should have been created as a result
            // of the method invocation.  

            Production_Spec_Template__c objPST1 = [select id,Name from Production_Spec_Template__c where Id = :testPST.Id];
      
            objPST1.Name='Testing PST Sample';
         
         
             ApexPages.StandardController con1=new ApexPages.StandardController(objPST1);
        
            // Instantiate the extention instance with the standardcontroller
            EditProductionSpecTemplate ext1=new EditProductionSpecTemplate(con1);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result1=ext1.saveme();
        
            delete objPST1;
            result1=ext1.saveme();
            result1=ext1.cancelme();
        }
      /* End of Test Method */  
}
/* End of Class */