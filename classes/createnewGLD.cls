// This class is used to insert new GL Department record
public with sharing class createnewGLD 
{

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
  
   public string gldeprtmentprefix {set;get;}

    // Global Variables
    private final GL_Department__c objGLD; 
    // End of Global variables 
    
    // Start Constructor
    public createnewGLD(ApexPages.StandardController controller) 
    {
      this.objGLD = (GL_Department__c)controller.getRecord(); 
   
       Schema.DescribeSObjectResult r=GL_Department__c.SObjectType.getDescribe();
       gldeprtmentprefix=r.getKeyPrefix();
       
      // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+isLtng));
      // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+gldeprtmentprefix));
    }
    // End of Constructor
    
    // Method called on to Save
    Public PageReference saveme()
    {
     try 
       { 
            insert objGLD;
       }
       Catch(System.DMLException e)
       {
           return null;
       }
        PageReference p;
       if(isLtng)
          {
              p =  new Pagereference('/'+gldeprtmentprefix+'/o');
          }
       else
           {
             p =  new Pagereference('/apex/AdminListView?intFocus=9');
           }   
             p.setRedirect(true);
             return p;
          
    }       
    // End of Save method
    
    //Cancel Method
     Public PageReference cancelme()
              {
                  PageReference p;
                 if(isLtng)
                  {
                       p=  new Pagereference('/'+gldeprtmentprefix+'/o');
                      
                  }
               else
                   {
                    p = new Pagereference('/apex/AdminListView?intFocus=9');
                      
                   
                   }   
                      p.setRedirect(true);
                      return p;
              }
    //End of Cancel Method             
       
    
    // Test Coverage Code 
        static testMethod void insertGLDept()
        {
            GL_Department__c testGLD1=new GL_Department__c(Name='Test GL Dept 001');
          
            ApexPages.StandardController con1=new ApexPages.StandardController(testGLD1);
            
            createnewGLD ext1=new createnewGLD(con1);
           
            ApexPages.Pagereference result1=ext1.saveme();
            result1=ext1.cancelme();
            
            System.assertEquals('Test GL Dept 001',testGLD1.Name);
            
            
            GL_Department__c testGLD2=new GL_Department__c(Name='Test GL Dept 001');
            try
            {
                insert testGLD2;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
            }
        
              // Instantiate the extention instance with the standard controller
              
            ApexPages.StandardController con2=new ApexPages.StandardController(testGLD2);
            
            createnewGLD ext2=new createnewGLD(con2);
            
            // Invoke the save method
            ApexPages.Pagereference result2=ext2.saveme();
            
            // To cover trigger code
        } // End Test Coverage
}
// End of Class