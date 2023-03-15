// This class is used to create new Spec Item
public with sharing class SpecItemExtension 
{

 public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
  public string cretivebrieftemp {set;get;}
  
  
    // Global variables 
    private final Spec_Item__c spec;
    public string theid;
    public string  thetempname{get;set;}
    // End of Global variables
    
    // Standard Controller Constructor 
    public SpecItemExtension(ApexPages.StandardController controller) 
    {
        this.spec=(Spec_Item__c)controller.getrecord();
        theID = ApexPages.CurrentPage().getParameters().get('Parentid');
        Specification_Template__c creativetemp=[select id,name from Specification_Template__c where id =:theID];
        thetempname=creativetemp.name;
        
        cretivebrieftemp =Specification_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End Controller Constructor
     
   
  /*  public PageReference SaveandNew() 
    {
    spec.Name = spec.Name;
    spec.Specification_Template__c = spec.Specification_Template__c;
    insert spec;
    PageReference SpecItemPage = Page.CreateNewSpecItem;
    SpecItemPage.setRedirect(true);
    return SpecItemPage;
    }
*/
    // This method is called on to save Spec Item
    Public PageReference saveme()
    {
        try
        {
            String strid;
            spec.Specification_Template__c =theid;
            insert spec;
            strid = spec.Specification_Template__c; 
            
            if(isLtng){
                PageReference p =  new Pagereference('/apex/SpecificationTemplateTabOverrideLti?id='+strid);
                p.setRedirect(true);
                return p;
            
            }
            
          else
              {         
                PageReference p =  new Pagereference('/apex/SpecificationTemplateTabOverride?id='+strid);
                p.setRedirect(true);
                return p;
               }
        }
        catch(System.DMLException e)
        {
            return null;
        }
    }
    //  End of method Save
    
    
     Public PageReference cancelme()
    {
       if(isLtng)
                {
                PageReference p =  new Pagereference('/apex/SpecificationTemplateTabOverrideLti?id='+theid);
                p.setRedirect(true);
                return p;
                
                }
    
        else
           {
                PageReference p =  new Pagereference('/apex/SpecificationTemplateTabOverride?id='+theid);
                p.setRedirect(true);
                return p;
            }
        
    }
    
    
    
    
    
    // Test Coverage 
   /* static testMethod void Test_SpecItemExtension()
    {
         Specification_Template__c testST1=new Specification_Template__c(Name='Testing Specification Template');
         try
         {
            insert testST1;
            System.debug('Specification Template record inserted successfully@@@ '+testST1);
         }
         catch(System.DMLException e)
         {
            System.assert(e.getMessage().contains('Spec Item with same name Exists'));
         }
         
         Spec_Item__c testSPI1=new Spec_Item__c(Name='Test Spec Item 1',Specification_Template__c=testST1.Id);
        
         
         // Instantiate the standard controller with the Spec Item 
        ApexPages.StandardController con=new ApexPages.StandardController(testSPI1);
        
        // Instantiate the extention instance with the standardcontroller 
        SpecItemExtension ext=new SpecItemExtension(con);
        
        // Invoke the primary method on the extension 
        ApexPages.PageReference result=ext.saveme();
        
        delete testSPI1;
        result=ext.saveme();
     }
    // End Test Coverage */
}
// End of Class