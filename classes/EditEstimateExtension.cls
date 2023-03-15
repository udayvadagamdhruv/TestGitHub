// This class is used in EditEstimateLineitem visual force page which is used to implement edit functionality of Estimate Line Item

public with sharing class EditEstimateExtension 
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    
    // Global variables
    String GLDName, EstId,GLCName,VName;
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    public String getVName() { return VName; }
    public void setVName(String s) {  this.Vname = s; }
    private final Estimate_Line_Items__c est;
    // End of Global variables

    // Constructor 
    public EditEstimateExtension(ApexPages.StandardController controller) 
    {
         this.est=(Estimate_Line_Items__c)controller.getRecord();
         EstId=ApexPages.CurrentPage().getParameters().get('id');
        
         Estimate_Line_Items__c abc = [select id,Name,GL_Code__c,GL_Department__c,Vendor__c,Amount__c from Estimate_Line_Items__c  where id =: est.id Limit 1];
         GLDName = abc.GL_Department__c;
         GLCName = abc.GL_Code__c;
         VName = abc.Vendor__c; 
          
        // Estimate_Line_Items__c est1 = [select id,Name,Vendor__c,Job__c from Estimate_Line_Items__c where id =: EstId];
    }
    // End of Constructor
    
    // This method is called on to retrieve All GLDepartments into dropdown list
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
     // ENd of method getGLDepartments
    
     // This method is called on to retrieve All GLCodes into dropdown list
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
     // End of method getGLCodes  
  
      // This method is called on to retrieve All Vendor into dropdown list
     public List<selectOption> getVendors()
      {
          List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
          options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
         
          List<Vendor_GL_Code__c> ven = [SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: GLCName];
       
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
         
         Estimate_Line_Items__c abc = [select id,Name,GL_Code__c,GL_Department__c,Vendor__c,Amount__c from Estimate_Line_Items__c  where id =: est.id Limit 1];
         if(GLCName==abc.GL_Code__c)
         {
             est.Amount__c=abc.Amount__c; 
         }
         
         else if(GLCName!=null)
         {
             Glcode =[SELECT Id,GL_Id__c,Name,Unit_Cost__c FROM GL_Code__c where id=: GLCName];
             est.Amount__c=Glcode.Unit_Cost__c; 
         }
         else
         {
             est.Amount__c=0.00;
         }
   }
   
   
    // This method is called on to Save Estimate
    Public PageReference saveme()
    {   
       try
       {
              if(GLDName == null)
               {
                   String stringGLD = Schema.Estimate_Line_Items__c.fields.GL_Department__c.getDescribe().getLabel();
                   ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLD+' : You must select a '+stringGLD+'.');
                   ApexPages.addMessage(msg1);
                   return null;
               }
               
             if(GLCName == null)
             {
                 String stringGLC = Schema.Estimate_Line_Items__c.fields.GL_Code__c.getDescribe().getLabel();
                 ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
                 ApexPages.addMessage(msg2);
                 return null;
             }
             
             if(VName == null)
             {
                  String stringV = Schema.Estimate_Line_Items__c.fields.Vendor__c.getDescribe().getLabel();
                  ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.ERROR,stringV+' : You must select a '+stringV+'.');
                  ApexPages.addMessage(msg3);
                  return null;
             }
             else
             {          
                 GL_Code__c glc1 = [select id,Name from GL_Code__c where id =: GLCName];
                 GL_Department__c gd1 = [SELECT Id, name FROM  GL_Department__c where id =: GLDName];
                 Vendor__c v1 = [select id,name from Vendor__c where id =: VName];
                 est.GL_Department__c = gd1.id;
                 est.GL_Code__c = glc1.id;
                 est.Vendor__c = v1.id;
                 update est;        
            } 
        }    
       catch(system.DMLException e)
       {
           return null;
       }
      
       
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/EstimatedetailpageLightning?id='+EstId);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/Estimatedetailpage?id='+EstId);
                p.setRedirect(true);
                return p;
        }
       
    }
    // End of method Save
    
    // This method called on to handle Cancel button
      public PageReference cancelme()
      {
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/EstimatedetailpageLightning?id='+EstId);
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                    PageReference p =  new Pagereference('/apex/Estimatedetailpage?id='+EstId);
                    p.setRedirect(true);
                    return p;
            }    
       }
    // End Cancel method


    // Start Test Coverage
     private static testMethod void EditEstimateTest()
     {
          Job_Number_Setting__c customSetting987 = new  Job_Number_Setting__c(Name= 'yy');
          insert customSetting987;
            
          Media_Type__c testMedia=new Media_Type__c(Name='MT010');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST010',Media_Types__c=testMedia.Id);
             
                 insert testST;
       
          Specification_Template__c testSpec=new Specification_Template__c(Name='ST010');
                insert testSpec;
      
          Job__c testJob1=new Job__c(Name='J010',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
           System.assertEquals('J010',testJob1.Name);     
          
          GL_Department__c testGLD = new GL_Department__c(Name='GLD010');
            try
            {
                 insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GLC010',GL_ID__c='GLC010',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
             }
             catch(System.DMLException e)
             {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
           Vendor__c testVendor=new Vendor__c(Name='TV010',Email__c='abcd@gmail.com',Zip__c='12345');
             try
              {
                  insert testVendor;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }  
            
            
          Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote010',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=TestGL.id,Vendor__c=testVendor.id);
             try
              {
                  insert testELI;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
              
            
          ApexPages.StandardController con=new ApexPages.StandardController(testELI);     
          EditEstimateExtension   ext=new EditEstimateExtension(con);  
          
          // To check GLDepartment as NULL and calll Save method
          
          ext.GLDName = NULL;
          String GLDName1 = ext.getGLDName();
          ext.setGLDName(GLDName1);
          List<SelectOption> options1 = ext.getGLDepartments(); 
          
          ext.GLCName = testGL.id;
          String GLCName2 = ext.getGLCName();
          ext.setGLCName(GLCName2);
          List<SelectOption> options2 = ext.getGLCodes(); 
          
          ext.VName = testVendor.Id;
          String VName3 = ext.getVName();
          ext.setVName(VName3);
          List<SelectOption> options3 = ext.getVendors();  
          
          ApexPages.Pagereference result1=ext.saveme();     
          
          // To check GLCode as not NULL and calll Save method
          
          ext.GLDName = testGLD.id;
          String GLDName4 = ext.getGLDName();
          ext.setGLDName(GLDName4);
          List<SelectOption> options4 = ext.getGLDepartments(); 
          
          ext.GLCName = NULL;
          String GLCName5 = ext.getGLCName();
          ext.setGLCName(GLCName5);
          List<SelectOption> options5 = ext.getGLCodes(); 
          
          ext.VName = testVendor.Id;
          String VName6 = ext.getVName();
          ext.setVName(VName6);
          List<SelectOption> options6 = ext.getVendors();  
       
          result1=ext.saveme();     
          
       // To check Vendor as NULL and calll Save method
       
          ext.GLDName = testGLD.id;
          String GLDName7 = ext.getGLDName();
          ext.setGLDName(GLDName7);
          List<SelectOption> options7 = ext.getGLDepartments(); 
          
          ext.GLCName = testGL.id;
          String GLCName8 = ext.getGLCName();
          ext.setGLCName(GLCName8);
          List<SelectOption> options8 = ext.getGLCodes(); 
          
          ext.VName = NULL;
          String VName9 = ext.getVName();
          ext.setVName(VName9);
          List<SelectOption> options9 = ext.getVendors(); 
          result1=ext.saveme();     
           
          ext.GLDName = testGLD.id;
          String GLDName10 = ext.getGLDName();
          ext.setGLDName(GLDName10);
          List<SelectOption> options10 = ext.getGLDepartments(); 
          
          ext.GLCName = testGL.id;
          String GLCName11 = ext.getGLCName();
          ext.setGLCName(GLCName11);
          List<SelectOption> options11 = ext.getGLCodes(); 
          
          ext.VName = testVendor.Id;
          String VName12 = ext.getVName();
          ext.setVName(VName12);
          List<SelectOption> options12 = ext.getVendors();  
           
          result1=ext.saveme();        
          result1=ext.cancelme();  

        // To cover catch block inside save method
          Delete testELI; 
          result1=ext.saveme();
    }// End of Test Coverage    
}
// End of Apex class