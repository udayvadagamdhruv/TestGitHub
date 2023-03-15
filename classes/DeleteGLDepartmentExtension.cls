/* This class is used to delete GL Department */
public with sharing class DeleteGLDepartmentExtension 
{
  public boolean isLtng{private set;get{
     string theme=UserInfo.getUITheme();
     return (theme=='Theme4d')?true:false;
 }}
 public string gldPrefix {set;get;}

public Boolean isError{get;set;}

      /* Global Variables */
    private final GL_Department__c objGLDept;
    /* End of Global Variables */
    
    /* Standard Controller Constructor */
    public DeleteGLDepartmentExtension(ApexPages.StandardController con)
    {
         isError = False;
         objGLDept=NULL;
         this.objGLDept=(GL_Department__c)con.getrecord();
         gldPrefix=GL_Department__c.SobjectType.getDescribe().getKeyPrefix();
    }
    /* End of Standard Controller Constructor */
    
    /* Method called on to Delete GL Department */
     public pagereference checkDelete()
     {
        try
        {
            Database.delete(objGLDept);        
        }
        catch(System.DMLException e)
        {
      //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
        isError = True;
        return NULL;
        }
        PageReference p;
        if(isLtng)
            {
               p=new Pagereference('/'+gldPrefix+'/o');
            }
        else
            {
            p =  new Pagereference('/apex/AdminListView?intFocus=9');
            }
             p.setRedirect(true);
            return p; 
     }   
/*        
 PageReference p =  new Pagereference('/apex/AdminListView?intFocus=9');
 p.setRedirect(true);
 try
 {
  Database.delete(objGLDept);        
 }
 catch(System.DMLException e)
 {
  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
  return null;
 }

If(p != null)
{
return p;
}
else
{
 return null;
}
*/


   public pageReference gldpageBack()
   {
      PageReference p; 
      if(isLtng)
            {
            p=new Pagereference('/'+gldPrefix+'/o');
             
            }
        else
            {
            p = new Pagereference('/apex/AdminListView?intFocus=9');
            }
             p.setRedirect(true);
             return p; 
   
   }
   



     /* End of Delete method */
     
     /* Start Test Coverage */
         static testMethod void Test_DeleteGLDepartmentExtension()
         {
            GL_Department__c testGLD1=new GL_Department__c(Name='Test GL Dept 002');
            insert testGLD1;
            
            System.assertEquals('Test GL Dept 002',testGLD1.Name);
            
            ApexPages.StandardController con1=new ApexPages.StandardController(testGLD1);
            
            DeleteGLDepartmentExtension ext1=new DeleteGLDepartmentExtension(con1);
           
            ApexPages.Pagereference result1=ext1.checkDelete();
            
            /* To cover catch block */
            ApexPages.StandardController con2=new ApexPages.StandardController(testGLD1);
            
            DeleteGLDepartmentExtension ext2=new DeleteGLDepartmentExtension(con2);
           
            result1=ext1.checkDelete();
            ext1.gldpageBack();
         }
     /* End od Test Coverage */

}
/* ENd of Class */