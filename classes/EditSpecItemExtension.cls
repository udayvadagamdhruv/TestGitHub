// Extension Class to Update Spec Item 
public with sharing class EditSpecItemExtension {

   
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
  public string theid {set;get;}

    // Global Variables 
     private final Spec_Item__c spec;
     // End of Global Variables 

    // Standard Controller Constructor
    public EditSpecItemExtension(ApexPages.StandardController con) 
    {
        this.spec=(Spec_Item__c)con.getrecord();
        theid=spec.Specification_Template__c;
       //  Apexpages.addmessage(new apexpages.message(apexpages.severity.info,''+spec));
      // Apexpages.addmessage(new apexpages.message(apexpages.severity.info,''+theid));
    }
    // End of Standard Controller Constructor
     
    // Method called on to update Spec Item
    Public PageReference saveme()
    {
        try
        {
            String strid;
            update spec;
            strid = spec.Specification_Template__c;        

            // After update navigate to the Specificate Template Parent Record
        if(isLtng)
            {
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
    
    
    
      public pagereference cancel()
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
                
    
    // End of Update Method 

  /*  // Test Coverage Code
       static testMethod void Test_EditSpecItemExtension()
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
             try
             {
                 insert testSPI1;
                 System.debug('Spec Item record inserted successfully@@@ '+testSPI1);
             }
             catch(System.DMLException e)
             {
                 System.assert(e.getMessage().contains('Spec Item with same name Exists'));
             }   
         
             // Instantiate the standard controller with the Spec Item 
            ApexPages.StandardController con=new ApexPages.StandardController(testSPI1);
        
            // Instantiate the extention instance with the standardcontroller 
            EditSpecItemExtension ext=new EditSpecItemExtension(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result=ext.saveme();
       
            delete testSPI1;
            result=ext.saveme();
       } // End Of Test Coverage Code*/
}// End of Class