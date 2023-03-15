// This page is used to create New Production Spec template
public with sharing class CreateProductionSpecTemplate 
{
 public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
  
   public string ProSpecTempprefix {set;get;}


    // Global variables
    private final Production_Spec_Template__c PST;
    // End of Global variables

    // Start Constructor
    public CreateProductionSpecTemplate(ApexPages.StandardController controller) 
    {
     this.PST=(Production_Spec_Template__c)controller.getRecord();
     ProSpecTempprefix=Production_Spec_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End constructor
    
    //This method is used to handle Cancel button
    Public PageReference cancelme()
    {
        
     PageReference p;   
     if(isLtng)
     {
        p =  new Pagereference('/'+ProSpecTempprefix +'/o');
     }
    
    else
     {
       p = new Pagereference('/apex/AdminListView?intFocus=10');
      }
       p.setRedirect(true);
       return p; 
    }
    // End Cancel method

    // Test Coverage Code
     static testMethod void Test_createProductionSpecTemplate()
     {
      
          Production_Spec_Template__c testPST=new Production_Spec_Template__c(Name='PST0001');
          system.assertEquals('PST0001',testPST.Name);
          
          ApexPages.StandardController con=new ApexPages.StandardController(testPST);
          CreateProductionSpecTemplate ext=new CreateProductionSpecTemplate(con);
          ApexPages.PageReference result1=ext.cancelme();  
     }
     // End of Test Coverage

}
//End of Class