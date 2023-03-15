// This class is used to delete Specification Template
public with sharing class DeleteSpecificationTemplateExtension 
{
 
 public boolean isLtng{private set;get{
     string theme=UserInfo.getUITheme();
     return (theme=='Theme4d')?true:false;
 }}
 
 public string CreativeBriefPrefix {set;get;}

    // Global variables
    private final Specification_Template__c objST;
    public Boolean isError{get;set;}
    // End of Global variables

    // Start constructor
    public DeleteSpecificationTemplateExtension(ApexPages.StandardController controller) 
    {
        isError = False;
        this.objST = (Specification_Template__c)controller.getRecord();
        
        CreativeBriefPrefix =Specification_Template__c.SobjectType.getDescribe().getKeyPrefix();
       // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+CreativeBriefPrefix ));
       
    }
    // End of Constructor
    
    public PageReference CheckDelete()
    {
         try
         {
             Database.Delete(objST);
         }
         catch(System.DMLException e)
         {
             isError = True;
             return null;
         }
        // After deletion Specification Template navigate to Specification Template Tab
           PageReference p;
             if(isLtng)
                p=new PageReference('/'+CreativeBriefPrefix+'/o');
             else
                p =new PageReference('/apex/AdminListView?intFocus=3');
                p.setRedirect(true);
                return p;
        
    }
    
   public PageReference pageback(){
         PageReference p;
         if(isLtng)
                p = new PageReference('/'+CreativeBriefPrefix+'/o');
             else
                p=new PageReference('/apex/AdminListView?intFocus=3');
                p.setRedirect(true);
                return p;
   }
    
    
    
    // End of Delete method
    
   // Test Coverage Code
        static testMethod void deleteSpecificationTempPositiveTest()
         {
             Specification_Template__c testST=new Specification_Template__c(Name='Test Specification Template 1');
                 insert testST;
             
            // Instantiate the standard controller with the Specification Template 
             Specification_Template__c obj=[Select Id from Specification_Template__c where Id=:testST.Id];
             ApexPages.StandardController con=new ApexPages.StandardController(obj);
        
            // Instantiate the extention instance with the standard controller 
            
            DeleteSpecificationTemplateExtension  ext=new DeleteSpecificationTemplateExtension (con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result1=ext.CheckDelete();
            ApexPages.PageReference result2=ext.CheckDelete();
           ApexPages.PageReference result3=ext.pageback();

            
             Specification_Template__c testST1=new Specification_Template__c(Name='Test Specification Template 1');
             try
             {
                 insert testST1;
                 System.debug('Specification Template record inserted successfully@@@ '+testST);
             }
             catch(System.DMLException e)
             {
                 
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
        }
        // End of Test Coverage
}// End of Class