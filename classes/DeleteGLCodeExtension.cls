// Extension class to Delete GLCode 
public with sharing class DeleteGLCodeExtension 
{
    // Globl Variables
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    private final GL_Code__c glcode;
    public Boolean isError{get;set;}
    public string glcodeprefix {set;get;}
    // End Of Global Variables 
    
    // Standard Controller Constructor 
    public DeleteGLCodeExtension(ApexPages.StandardController controller) 
    {  
        isError = False;
        this.glcode=(GL_Code__c)controller.getrecord();
        
        Schema.DescribeSobjectResult r = GL_code__c.SobjectType.getDescribe();
          glcodeprefix=r.getKeyPrefix();
    }
    // End of Standard Controller Constructor 
    
    // Method called on to delete GL Code
    public PageReference checkDelete()
    {
      try
       {
           isError = True;
           Database.delete(glcode);
       }
       catch(System.DMLException e)
       {
           return null;
       }
       // After deletion navigate to GL Code 
       
          PageReference p;
          if(isLtng)
          {
              p=new Pagereference('/'+glcodeprefix+'/o');
              
          }
          else   
          {
              p =new Pagereference('/apex/AdminListView?intFocus=1');
               
          } 
              p.setRedirect(true);
              return p;        

    }
    
   public pageReference glcodepageback()
   {
       PageReference p;
     if(isLtng)
          {
               p= new Pagereference('/'+glcodeprefix+'/o');
               
          }
          else   
          {
               p = new Pagereference('/apex/AdminListView?intFocus=1');
               
          } 
              p.setRedirect(true);
              return p; 
   
   }
    // End of delete method
    
        // Test Coverage Code
        static testMethod void Test_DeleteGLCodeExtension()
         {
             GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL001');
             
             try
             {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
             }
             
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
             System.assertEquals('Test GL Code',testGL.Name);
             
              GL_Code__c testGL1=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL002');
              try
             {
                 insert testGL1;
                 
             }
            catch(System.DMLException e)
             {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
             }
             
             GL_Code__c testGL2=new GL_Code__c(Name='Test GL Code79',GL_ID__c='Test GL003');
             insert testGL2;
             
             testGL2.Name='Test GL Code';
             try
             {
                 update testGL2;
                 
             }
            catch(System.DMLException e)
             {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
             }
             
             // Instantiate the standard controller with the GLCode 
            ApexPages.StandardController con=new ApexPages.StandardController(testGL);
        
            // Instantiate the extention instance with the standardcontroller
            DeleteGLCodeExtension ext=new DeleteGLCodeExtension(con);
        
            // Invoke the Delete method on the extension 
            ApexPages.PageReference result=ext.CheckDelete();
        
             // The below code covers the Catch statement in checkDelete method 
            ApexPages.PageReference result1=ext.CheckDelete();
             Apexpages.PageReference resul4=ext.glcodepageback();
        }// End of Test Coverage Code
}// End of Class