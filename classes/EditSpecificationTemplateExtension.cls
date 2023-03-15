// Extension Class for EditSpecificationTemplate 
public with sharing class EditSpecificationTemplateExtension 
{
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
  public string cretivebrieftemp {set;get;}


    // Global Variables
    private final Specification_Template__c objST;
    // ENd of Global Variables
    
    // Standard Controller Constructor
    public EditSpecificationTemplateExtension(ApexPages.StandardController con) 
    {
        this.objST=(Specification_Template__c)con.getrecord();
        cretivebrieftemp =Specification_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor 
    
    // Method called on to Update Specification Template 
    Public PageReference saveme()
    {   
       try
       {
            update objST;        
       } 
       catch(system.DMLException e)
       {
           return null;
       }
       // After update navigate to Specification Template Tab 
       
    PageReference p;
      if(isLtng)
            p =  new Pagereference('/'+cretivebrieftemp+'/o');
        else
            p =  new Pagereference('/apex/AdminListView?intFocus=3');
            p.setRedirect(true);
            return p; 
    }
    
    // Cancel method
     Public PageReference cancelme()
        {
          PageReference p;   
           if(isLtng)
             p =  new Pagereference('/'+cretivebrieftemp+'/o');
           else
             p = new Pagereference('/apex/AdminListView?intFocus=3');
             p.setRedirect(true);
             return p; 
        }    
    //End of cancel method          

    
    // Test Coverage Code
        static testMethod void editSpecificationTempPositiveTest()
        {
            Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 100');
            try
            {
                insert testSpec1;
                System.debug('Specification Template inserted successfully@@@ '+testSpec1);
            }
            catch(System.DMLException e)
            {
                 System.assert(e.getMessage().contains('Specification Template with same Name exist'));    
            }
            System.assertEquals('Testing Spcification Template 100',testSpec1.Name); 
            
             // Instantiate the standard controller with the Specification Template 
            ApexPages.StandardController con=new ApexPages.StandardController(testspec1);
        
            // Instantiate the extention instance with the standardcontroller 
            EditSpecificationTemplateExtension ext=new EditSpecificationTemplateExtension(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result=ext.saveme();
        
            // Retrieve the Specification Template from the DB that should have been created as a result
            // of the method invocation.  

            Specification_Template__c objST = [select Name from Specification_Template__c where Id = :testSpec1.Id];
        
            // Now assert the value
            System.assertEquals('Testing Spcification Template 100', objST.Name,'Woops, the name of Specification Template was not as expected.');
 
            Specification_Template__c objST1=[Select Name from Specification_Template__c where Id=: testSpec1.Id];
            objST1.Name='Testing ST Sample';
         
         
             ApexPages.StandardController con1=new ApexPages.StandardController(objST1);
        
            // Instantiate the extention instance with the standardcontroller
            EditSpecificationTemplateExtension ext1=new EditSpecificationTemplateExtension(con1);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result1=ext1.saveme();
        
            delete objST1;
            result1=ext1.saveme();
            result1=ext1.cancelme();
        }
        
        // test Coverage for Duplicate Specification Template
        static testMethod void duplicateSpecificationTemp()
        {
            Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 897');
                  insert testSpec1;
           
            Specification_Template__c testSpec2=new Specification_Template__c(Name='Testing Spcification Template 897');
            try
            {
                insert testSpec2;
            }    
            catch(System.DMLException e)
            {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
            }
           Specification_Template__c testSpec3=new Specification_Template__c(Name='Testing Spcification Template 797');
               insert testSpec3;
               testSpec3.Name='Testing Spcification Template 897'; 
               try
               {
                    update testSpec3;
               }    
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
        }
        // End Of Positive Test Case
}// End of Class