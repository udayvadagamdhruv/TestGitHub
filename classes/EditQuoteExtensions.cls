// This class is used to edit Quote 
public with sharing class EditQuoteExtensions
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
   
    
    // Global variables
    String GLCName,GLDName,strid,strid1,quoteId;
     
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }
    private final Quote__c objQuote;
    // End of Global variables 
    
   // Standard Controller Constructor 
    public EditQuoteExtensions(ApexPages.StandardController controller) 
    {
        this.objQuote=(Quote__c)controller.getrecord();
        Quote__c q1 = [select id,Name,GL_Code__c,GL_Department__c from Quote__c where id =: objQuote.Id];
        quoteId=q1.id;
        GLDName = q1.GL_Department__c;
        GLCName = q1.GL_Code__c;
        
      
        
    }
    // End of Constructor 
    
     // This method is called on to retrieve all GL Departments into dropdown list
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
    // End of method getGLDepartments
    
      
     // This method is called on to retrieve all GL Codes belongs to selected GLDepartment into dropdown list
     public List<selectOption> getGLCodes() 
      {
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Code__c glcode : [SELECT Id,Name,GL_Id__c FROM GL_Code__c where GL_Department__c =: GLDName ORDER BY Name]) 
          {  
              optionList.add(new selectOption(glcode.Id,glcode.GL_Id__c +' '+glcode.Name));  
          }
      return optionList;  
     }  
     // ENd of method getGLCodes
    
    // Method called on to edit Quote 
    Public PageReference saveme()
    {
        try
        {
            if(GLDName == null)
            {
                 String strGLDepartment = Schema.Quote__c.fields.GL_Department__c.getDescribe().getLabel();
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strGLDepartment+' : You must select a '+strGLDepartment+'.');
                 ApexPages.addMessage(myMsg);
                 return null;
            }
            if(GLCName == null)
            {
                 String strGLCode = Schema.Quote__c.fields.GL_Code__c.getDescribe().getLabel();
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strGLCode+' : You must select a '+strGLCode+'.');
                 ApexPages.addMessage(myMsg);
                 return null;
            }
            else
            {
                 GL_Code__c gc1 = [SELECT Id, name FROM GL_Code__c where id =: GLCName];
                 GL_Department__c gd1 = [SELECT Id, name FROM  GL_Department__c where id =: GLDName];  
                 objQuote.GL_Code__c = gc1.id;
                 objQuote.GL_Department__c = gd1.id;        
                 update objQuote;
                 strid = objQuote.id;
             }
        }
        catch(System.DMLException e)
        {
            return null;
        }    
        // After updating Quote, Navigate to its detail page  
        
        
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+strid);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+strid);
                p.setRedirect(true);
                return p;
        }
        
          
       /* PageReference p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=4');
        PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+strid);
        p.setRedirect(true);
        return p; */
    }
    // End of edit method 
    
    // Method called on to handle Cancel button 
     Public PageReference cancelme()
    {
        String strid1;
        strid1 =  objQuote.Job__c;    
        
         if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+quoteId);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+quoteId);
                p.setRedirect(true);
                return p;
        }
        
        
      /*      
        PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+quoteId);
        p.setRedirect(true);
        return p;*/
    } 
    // End of Cancel button
    
    // Start Test Coverage
     static testMethod void Test_EditQuoteExtensions()
         {
         
             Job_Number_Setting__c customSetting955 = new  Job_Number_Setting__c(Name= 'yy');

                   insert customSetting955; 
            
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 611');
             
                    insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 611',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 611');
                insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 611',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0));
               }
              System.assertEquals('Test Job 611',testJob1.Name);
   
               GL_Department__c testGLD = new GL_Department__c(Name='TestGLD13');
                try
                {
                    insert testGLD;
                }
                catch(System.DMLException e)
                {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                }
          
               GL_Code__c testGL=new GL_Code__c(Name='GL Code 9900',GL_ID__c='TestGL9900',GL_Department__c = testGLD.id);
                try
                 {
                     insert testGL;
                     System.debug('GL Code inserted successfully@@@ '+testGL);
                 }
                 catch(System.DMLException e)
                 {
                     System.debug(e.getMessage());
                 }
            
                 Quote__c testQ=new Quote__c(Name='Quote 611',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c = testGL.id);
                     insert testQ;
             
              // Instantiate the standard controller with the Quote
              ApexPages.StandardController con=new ApexPages.StandardController(testQ);
              ApexPages.currentPage().getParameters().put('Id',testQ.Id);
              
                // Instantiate the extention instance with the standard controller 
              EditQuoteExtensions  ext=new EditQuoteExtensions(con);
              
             // To check GL Department as NULL and call Save method
              ext.GLDName = NULL;
              String GLDName1 = ext.getGLDName();
              ext.setGLDName(GLDName1);
              List<SelectOption> options1 = ext.getGLDepartments(); 
              
              ext.GLCName = testGL.id;
              String GLCName2 = ext.getGLCName();
              ext.setGLCName(GLCName2);
              List<SelectOption> options2 = ext.getGLCodes(); 
              
              ApexPages.Pagereference result=ext.saveme();
              
             // To check GLCode as NULL and call Save method
              ext.GLDName = testGLD.id;
              String GLDName3 = ext.getGLDName();
              ext.setGLDName(GLDName3);
              List<SelectOption> options3 = ext.getGLDepartments(); 
          
              ext.GLCName =NULL;
              String GLCName4 = ext.getGLCName();
              ext.setGLCName(GLCName4);
              List<SelectOption> options4 = ext.getGLCodes();
              result=ext.saveme();
              
              // Pass all required values and call save method
              
              ext.GLDName = testGLD.id;
              String GLDName5 = ext.getGLDName();
              ext.setGLDName(GLDName5);
              List<SelectOption> options5 = ext.getGLDepartments(); 
          
              ext.GLCName = testGL.id;
              String GLCName6 = ext.getGLCName();
              ext.setGLCName(GLCName6);
              List<SelectOption> options6 = ext.getGLCodes(); 
         
              result=ext.saveme();
              
              System.assertEquals('Quote 611',testQ.Name);
              result=ext.cancelme();
            
              delete testQ;
              result=ext.saveme();
          }
          // End of Test Coverage
}
// End of Class