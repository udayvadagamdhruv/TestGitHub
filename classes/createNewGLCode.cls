// This class is used to create New GL Code
public with sharing class createNewGLCode 
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
    private final GL_Code__c objGLC;
    // End Global variables 
    
    // Start Constructor
    public createNewGLCode(ApexPages.StandardController controller) 
    {
         this.objGLC = (GL_Code__c)controller.getRecord(); 
        
       
       
         Schema.DescribeSobjectResult r = GL_code__c.SobjectType.getDescribe();
          glcodeprefix=r.getKeyPrefix();
        //ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+glcodeprefix));
    }
    // End Constructor     
    
    // Populate GLDepartments with picklist
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
    
    
    // Method called on to save GLCode
     Public PageReference saveme()
    {
       String strid1;
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
                     objGLC.GL_Department__c=GLDName;         
                     insert objGLC;
                     strid1=objGLC.id; 
           }      
       }
       catch(System.DMLException e)
       {
            return null;
       }
      
      
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
    // End Save method
    
    //Start cancel Method
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
   //End Cancel Method
    
    // Start Test Coverage
    private static testMethod void Test_createNewGLCode()
         {
         GL_Department__c testGLD = new GL_Department__c(Name='Test GLD 9980');
         try
         {
           insert testGLD;
         }
        catch(System.DMLException e)
        {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }  
        GL_Code__c testGL=new GL_Code__c(Name='GL Code 9980',GL_ID__c='TestGL9980',GL_Department__c = testGLD.id,Unit_Type__c='Project',Unit_Cost__c=120);
        
         // Instantiate the extention instance with the standard controller
          ApexPages.StandardController con=new ApexPages.StandardController(testGL);
          ApexPages.currentPage().getParameters().put('Id',testGL.Id);
          createNewGLCode ext=new createNewGLCode(con);
          
           ext.GLDName = NULL; // To checl GL department as NULL
           String GLDName1 = ext.getGLDName();
           ext.setGLDName(GLDName1);
           List<SelectOption> options1 = ext.getGLDepartments();
           ApexPages.PageReference result1=ext.saveme();
             
             
           ext.GLDName = testGLD.id;
           String GLDName = ext.getGLDName();
           ext.setGLDName(GLDName);
           List<SelectOption> options = ext.getGLDepartments(); 
              
           result1=ext.saveme(); 
           
            GL_Code__c testGL1=new GL_Code__c(Name='GL Code 9979',GL_ID__c='TestGL9979',GL_Department__c = testGLD.id,Unit_Type__c='Project',Unit_Cost__c=120);
            try
             {
                 insert testGL1;
            
             }
             catch(System.DMLException e)
             {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             System.assertEquals('GL Code 9979',testGL1.Name);
            
            GL_Code__c gc1 = [Select id,Name from GL_Code__c where id =: testGL1.id];
            gc1.Name='GL Code 9980';
             try
             {
                 update gc1;
            
             }
             catch(System.DMLException e)
             {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
            delete testGL;
            result1=ext.saveme();
            result1=ext.cancelme();
          } // End of Test Coverage 
}// End of Class