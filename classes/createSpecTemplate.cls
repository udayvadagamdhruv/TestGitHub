// This page is used to create New Specification Template
public with sharing class createSpecTemplate 
{

  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
            
  public string cretivebrieftemp {set;get;}
    


    // Global variables
    private final Specification_Template__c st;
    // End of Global variables

    // Start Constructor
    public createSpecTemplate(ApexPages.StandardController controller) 
    {
        this.st=(Specification_Template__c)controller.getRecord();
        cretivebrieftemp=Specification_Template__c.SObjectType.getDescribe().getKeyPrefix();
       // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+cretivebrieftemp));
    }
    // End constructor
    
    //This method is used to handle Cancel button
     Public PageReference cancelme()
    {
     PageReference p;
      if(isLtng)
            p=new Pagereference('/'+cretivebrieftemp+'/o');
        else
            p=new Pagereference('/apex/AdminListView?intFocus=3');
            p.setRedirect(true);
            return p;
      
    }
    // End Cancel method

    // Test Coverage Code
     static testMethod void Test_createSpecTemplate()
     {
      
          Specification_Template__c testST=new Specification_Template__c(Name='SPT007');
          system.assertEquals('SPT007',testST.Name);
          
          ApexPages.StandardController con=new ApexPages.StandardController(testST);
          createSpecTemplate ext=new createSpecTemplate(con);
          ApexPages.PageReference result1=ext.cancelme();  
     }
     // End of Test Coverage
}
// End of Class