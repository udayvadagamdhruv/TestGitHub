// This class is used for create New Estimate Line Item functionality and used in createNewEstimate vf page
public with sharing class CreateNewEstimateExtension 
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    
    
    // Start Global variables
    @testVisible String GLDName;
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }

    @testVisible String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    
    @testVisible String VName;
    public String getVName() { return VName; }
    public void setVName(String s) {  this.Vname = s; }


    public String selectedDepartment {get;set;}
    public  Quote__c user {get;set;}
    public String  UserSelectedControllingOption {get;set;}
    public String  UserSelectedDependentOption {get;set;}

    private final Estimate_Line_Items__c est;
    public String qid{get;set;}
    public String quoteid{get;set;}
    public String vqid{get;set;}
    // End of Global variables
   
   // Start of Constructor
    public CreateNewEstimateExtension(ApexPages.StandardController controller) 
     {
         this.est=(Estimate_Line_Items__c)controller.getRecord();
         qid=ApexPages.CurrentPage().getParameters().get('jobid');
         est.Job__c=qid;
     }
   // End of Constructor 
    
    // This method is used to retrieve all GLDepartments into dropdown list
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
    
    // This method is used to retrieve all GLCodes into dropdown list
    public List<selectOption> getGLCodes() 
     {
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Code__c users : [SELECT Id,GL_Id__c,Name FROM GL_Code__c where GL_Department__c =: GLDName ORDER BY Name]) 
          {  
               optionList.add(new selectOption(users.Id, users.GL_Id__c +' '+users.Name));  
          }
          return optionList;  
     }
     // End of method getGLCodes  
  
     // This method is used to retrieve all Vendors into dropdown list
    public List<selectOption> getVendors()
     {
          List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
          options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
          List<Vendor_GL_Code__c> ven = [SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: GLCName];
          for(Vendor_GL_Code__c am : ven)
          {
               System.Debug('a = '+am);
          }
     
          for (Vendor_GL_Code__c ar : ven)  
          { 
               options.add(new selectOption(ar.Vendor__c,ar.Vendor__r.Name)); //for all records found - add them to the picklist options
          }
            return options; //return the picklist options
     }
     // End of method getVendors
  
   public void getamount()
   {
         GL_Code__c Glcode=new GL_Code__c();
         if(GLCName!=null)
         {
             Glcode =[SELECT Id,GL_Id__c,Name,Unit_Cost__c FROM GL_Code__c where id=: GLCName];
             est.Amount__c=Glcode.Unit_Cost__c; 
         }
         else
         {
             est.Amount__c=0.00;
         }
   }
    
   // Save method
    public PageReference saveme() 
    { 
     string strEstimateId;
      try
       { 
        if(GLDName == null)
         { 
             String stringGLD = Schema.Estimate_Line_Items__c.fields.GL_Department__c.getDescribe().getLabel();
             ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLD+' : You must select a '+stringGLD+'.');
             ApexPages.addMessage(msg1);      return null;
         }
        
        if(GLCName == null)
         {
             String stringGLC = Schema.Estimate_Line_Items__c.fields.GL_Code__c.getDescribe().getLabel();
             ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
             ApexPages.addMessage(msg2);     return null;
         }
             
        if(VName == null)
         {
             String stringV = Schema.Estimate_Line_Items__c.fields.Vendor__c.getDescribe().getLabel();
             ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.ERROR,stringV+' : You must select a '+stringV+'.');
             ApexPages.addMessage(msg3);   return null;
         }
             
        else
         {          
             est.GL_Department__c = GLDName;
             est.GL_Code__c = GLCName;
             est.Vendor__c = Vname;
             insert est;
             strEstimateId = est.id;
         }
       }   
      catch(DMLException e)
       {
           return null;
       }
       
       
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+qid+'&tab=Jobcost'+'&section=estimate');
             p.setRedirect(true);     return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/JobListView?id='+qid+'&intFocus=5');
                p.setRedirect(true);
                return p;
        }
       
        
     
   } 
  // End of Save Method 
    
     
  
  /*   List <Estimate_Line_Item__c> lstELI=new List<Estimate_Line_Item__c>();
       List<Quote_Spec_Item__c> qsi = [select Name,Description__c from Quote_Spec_Item__c ORDER BY Name];
       for(Quote_Spec_Item__c q3:qsi)
        {
         Estimate_Line_Item__c estLI = new Estimate_Line_Item__c();
         estLI.Name = q3.Name;
         estLI.Description__c = q3.Description__c;
         estLI.Estimates__c = strEstimateId;
         lstELI.add(estLI);
        }
        insert lstELI;
        }
        catch(System.DMLException e)
        {
        return null;
        }  
  */ 
           
    // Method to deal with cancel button 
     public PageReference cancelme()
      {
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+qid+'&tab=Jobcost'+'&section=estimate');
                 p.setRedirect(true);     return p; 
            }
            else
            {
                    PageReference p =  new Pagereference('/apex/JobListView?id='+qid+'&intFocus=5');
                    p.setRedirect(true);
                    return p;
            }  
      }
      // End of method cancelme
     
       
    // Positive Test Case
  /*  private static testMethod void Test_CreateNewEstimateExtension()
     {
     
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 321');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 321',Media_Types__c=testMedia.Id);
      insert testST;
                 
      Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 321',Media_Types__c=testMedia.Id);
       try
        {
            insert testST1;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
               
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 321');
      insert testSpec;
                
      Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 321');
       try
        {
            insert testSpec1;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
            
      Job__c testJob1=new Job__c(Name='Test Job 321',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Job with same name Exists'));
        }
       System.assertEquals('Test Job 321',testJob1.Name);    
            
      GL_Department__c testGLD = new GL_Department__c(Name='TestGLD7');
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
             
      Vendor__c testVendor=new Vendor__c(Name='TestV9900',Email__c='abcd@gmail.com',Zip__c='12345');
       try
        {
            insert testVendor;
        }
       catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Job with same name Exists'));
        }  
            
      Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 321',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testELI);    
      CreateNewEstimateExtension   ext=new CreateNewEstimateExtension(con);  
      
      ext.GLDName = testGLD.id;
      String GLDName = ext.getGLDName();
      ext.setGLDName(GLDName);
      List<SelectOption> options = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.id;
      String GLCName = ext.getGLCName();
      ext.setGLCName(GLCName);
      List<SelectOption> options1 = ext.getGLCodes(); 
          
      ext.VName = testVendor.Id;
      String VName = ext.getVName();
      ext.setVName(VName);
      List<SelectOption> options2 = ext.getVendors();  
           
      ApexPages.PageReference result1=ext.saveme();
      ApexPages.PageReference result2=ext.cancelme();  
        
     // Start Negative test
      Estimate_Line_Items__c testELI3=new Estimate_Line_Items__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testELI3);
      CreateNewEstimateExtension   ext1=new CreateNewEstimateExtension(con1);
      ApexPages.PageReference result3=ext.saveme();
      ApexPages.PageReference result4=ext.cancelme();      
     // End of Negative test
           
    }  */
  // End of Test Coverage Code
}
// End of test class