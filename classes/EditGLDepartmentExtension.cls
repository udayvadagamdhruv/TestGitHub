// This class is used to edit GL Department 
public with sharing class EditGLDepartmentExtension {


  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
  
   public string gldeprtmentprefix {set;get;}




     // Global Variables
          private final GL_Department__c objGLDept;
     // End of Global Variables
      
      // Standard Controller Constructor
    public EditGLDepartmentExtension(ApexPages.StandardController controller)
    {
        this.objGLDept=(GL_Department__c)controller.getrecord();
        
         Schema.DescribeSObjectResult r=GL_Department__c.SObjectType.getDescribe();
         gldeprtmentprefix=r.getKeyPrefix();
    }
     // End of Standard Controller Constructor 


    // Method called on to update GL Department 
     Public PageReference save()
    {
        try
        {
            update objGLDept;
            System.debug('Media Type updated successfully@@@ '+objGLDept);
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After updating the holiday navigate to Holiday tab 
        
         PageReference p;
          if(isLtng)
          {
              p=  new Pagereference('/'+gldeprtmentprefix+'/o');
              
          }
       else
           {
            p= new Pagereference('/apex/AdminListView?intFocus=9');
                         
           }   
              p.setRedirect(true);
              return p;

    }
    // End of Method Update GL Department
    
    //Cancel Method
     public PageReference cancelme()
     {
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
   //End of Cancel Method
    
    // Start Test Coverage 
        static testMethod void Test_EditGLDepartmentExtension()
        {
            GL_Department__c testGLD1=new GL_Department__c(Name='Test GL Dept 003');
            insert testGLD1;
            
            System.assertEquals('Test GL Dept 003',testGLD1.Name);
            
            ApexPages.StandardController con1=new ApexPages.StandardController(testGLD1);
            
            EditGLDepartmentExtension ext1=new EditGLDepartmentExtension(con1);
           
            ApexPages.Pagereference result1=ext1.save();
            result1=ext1.cancelme();
            
            
            GL_Department__c testGLD2=new GL_Department__c(Name='Test GL Dept 004');
                insert testGLD2;
                
            GL_Department__c obj=[Select id,name from GL_Department__c where id=:testGLD2.id];
            testGLD2.Name='Test GL Dept 003';
            try
            {
                update testGLD2;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
            }     
            
            // To cover Catch Block
            delete testGLD1;
            
            ApexPages.Pagereference result3=ext1.save();
        }// End Test Coverage 
}// End of Class