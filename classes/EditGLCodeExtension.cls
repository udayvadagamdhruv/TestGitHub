// Extension Class for EditGLCode
public with sharing class EditGLCodeExtension 
{

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            } 

   public string glcodeprefix {set;get;}
    // Global variables
    String GLDName;
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }
    private final GL_Code__c objGLCode;
    // End of Global variables
    
    // Standard Controller Constructor
    public EditGLCodeExtension(ApexPages.StandardController con) 
    {
        this.objGLCode=(GL_Code__c)con.getrecord();
        GL_Code__c glc = [select id,Name,GL_Department__c from GL_Code__c where id =: objGLCode.id];
        GLDName = glc.GL_Department__c;
        
        Schema.DescribeSObjectResult r=GL_code__c.SobjectType.getDescribe();
        glcodeprefix=r.getKeyPrefix();
    }
    // End of Standard Controller Constructor
    
    // Populate GL Departments into picklist
   public List<selectOption> getGLDepartments() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (GL_Department__c gld : [SELECT Id, name FROM GL_Department__c order by Name]) 
        {  
            optionList.add(new selectOption(gld.Id, gld.Name));  
        }
        return optionList;  
    }
    // End getGLDepartments method

    // Method called on to Update GLCode
    Public PageReference saveme()
    {
        try 
        {
            if(GLDName == null)
               {
                 String stringGLD = Schema.GL_Code__c.fields.GL_Department__c.getDescribe().getLabel();
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLD+' : You must select a '+stringGLD+'.');
                 ApexPages.addMessage(myMsg);
                 return null;
               }
             else
              {
                  GL_Department__c gd1 = [SELECT Id, name FROM  GL_Department__c where id =: GLDName];  
                  objGLCode.GL_Department__c = gd1.id;        
                  update objGLCode;
              }
        }
        catch(System.DMLException e)
        {
            return null; 
        }
     // After updating the GLCode navigate to the GLCode Tab
     
     
       if(isLtng)
              {
               PageReference p =  new Pagereference('/'+glcodeprefix+'/o');
               p.setRedirect(true);
               return p;
               }
         else   
              {
              PageReference p =  new Pagereference('/apex/AdminListView?intFocus=1');
               p.setRedirect(true);
               return p;
               
              }     
     
     
     
      
    }
    // End of Method Update GLCode

    //Cancel Method
    Public PageReference cancelme()
     {
               if(isLtng)
              {
               PageReference p =  new Pagereference('/'+glcodeprefix+'/o');
               p.setRedirect(true);
               return p;
               }
         else   
              {
              PageReference p =  new Pagereference('/apex/AdminListView?intFocus=1');
               p.setRedirect(true);
               return p;
               
              }    
      }

//End of Cancel Method

    // Test Coverage 

    static testMethod void updateGLCodePositiveTest()
    {
       GL_Department__c testGLD = new GL_Department__c(Name='GLD011');
       try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GLC011',GL_ID__c='GLC011',GL_Department__c = testGLD.id);
            try
             {
               insert testGL;
             }
             catch(System.DMLException e)
             {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
        // Instantiate the standard controller with the GLCode 
        ApexPages.StandardController con=new ApexPages.StandardController(testGL);
        
        // Instantiate the extention instance with the standardcontroller 
        
        EditGLCodeExtension ext=new EditGLCodeExtension(con);
        
        ext.GLDName=null; // Check GLDepartment as NULL
        ApexPages.PageReference result=ext.saveme();  
        System.assertEquals('GLC011',testGL.Name); 
         
        ext.GLDName = testGLD.id;
        String GLDName = ext.getGLDName();
        ext.setGLDName(GLDName);
        List<SelectOption> options = ext.getGLDepartments(); 
        
        result=ext.saveme();
        
        delete testGL; // To Cover catch block in Save method
        result=ext.saveme();
        result=ext.cancelme();
    }  // End of Test Coverage
}
// End of Class