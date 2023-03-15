// This class is used to delete Production Spec Template
public with sharing class DeleteProductionSpecTemplateExtension 
{ 

 public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
  
   public string ProSpecTempprefix {set;get;}


    // Global variables
    private final Production_Spec_Template__c objPST;
    public Boolean isError{get;set;}
    // End of Global variables

    // Start constructor
    public DeleteProductionSpecTemplateExtension(ApexPages.StandardController controller) 
    {  
       isError = False;
       this.objPST = (Production_Spec_Template__c)controller.getRecord();
       ProSpecTempprefix=Production_Spec_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Constructor
    
    //Method to Delete Record
    public PageReference CheckDelete()
    {
         try
         {
             Database.Delete(objPST);
         }
         catch(System.DMLException e)
         {
             isError = True;
             return null;
         }
        // After deletion Production Spec Template navigate to Production Spec Template Tab
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
    
    
   public PageReference proSpecListView()
   {
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
    
    // End of Delete method
    
   // Test Coverage Code
        static testMethod void deleteProductionSpecTemplate_test()
         {
             Production_Spec_Template__c testPST=new Production_Spec_Template__c(Name='PST0002');
             insert testPST;
             
             system.assertEquals('PST0002',testPST.Name);
             
            // Instantiate the standard controller with the Production Spec Template 
             Production_Spec_Template__c obj=[Select Id from Production_Spec_Template__c where Id=:testPST.Id];
             ApexPages.StandardController con=new ApexPages.StandardController(obj);
        
            // Instantiate the extention instance with the standard controller 
            
            DeleteProductionSpecTemplateExtension ext=new DeleteProductionSpecTemplateExtension(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result1=ext.CheckDelete();
              ApexPages.PageReference result3=ext.CheckDelete();
            ApexPages.PageReference result2=ext.proSpecListView();
            
            
        }
        // End of Test Coverage
}
// End of Class