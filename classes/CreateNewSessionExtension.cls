// This class is used for create New Session functionality and used in createNewSession vf page
public with sharing class CreateNewSessionExtension 
{
/*
    public Estimate_Line_Items__c est;
    // Start Global variables
    String GLDName;
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }

    String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    
    String VName;
    public String getVName() { return VName; }
    public void setVName(String s) {  this.Vname = s; }
    
    String StaffProducerName;
    public String getStaffProducerName() { return StaffProducerName; }
    public void setStaffProducerName(String s) {  this.StaffProducerName = s; }
    
    String StaffTechnicianName;
    public String getStaffTechnicianName() { return StaffTechnicianName; }
    public void setStaffTechnicianName(String s) {  this.StaffTechnicianName = s; }


    public String selectedDepartment {get;set;}
    public  Quote__c user {get;set;}
  
    private final Session__c session;
    public String JobId{get;set;}
    // End of Global variables
   
   // Start of Constructor
    public CreateNewSessionExtension(ApexPages.StandardController controller) 
     {
         this.session=(Session__c)controller.getRecord();
         JobId=ApexPages.CurrentPage().getParameters().get('jobid');
         session.Job__c=JobId;
     }
   // End of Constructor 
    
    // This method is used to retrieve all GLDepartments into dropdown list
    public List<selectOption> getGLDepartments() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Department__c gld : [SELECT Id, name FROM GL_Department__c order by Name Limit 900]) 
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
          for (GL_Code__c GLC : [SELECT Id,GL_Id__c,Name FROM GL_Code__c where GL_Department__c =: GLDName ORDER BY Name]) 
          {  
               optionList.add(new selectOption(GLC.Id, GLC.GL_Id__c +' '+GLC.Name));  
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
     
     //This Method is used to retrive all Producer staffs 
     public List<selectOption> getProducerStaffs() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Staff__c staff : [SELECT Id, name,Role__c FROM Staff__c where Role__c =: 'Producer' and IsDeleted__c =: False order by Name Limit 900]) 
          {  
               optionList.add(new selectOption(staff.Id, staff.Name));  
          }
          return optionList;  
     }   
     //End of method getProducerStaffs
     
     //This Method is used to retrive all Technician staffs 
     public List<selectOption> getTechnicianStaffs() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Staff__c staff : [SELECT Id, name,Role__c FROM Staff__c where Role__c =: 'Technician' and IsDeleted__c =: False order by Name Limit 900]) 
          {  
               optionList.add(new selectOption(staff.Id, staff.Name));  
          }
          return optionList;  
     }   
     //End of method getTechnicianStaffs
  
    
   // Save method
    public PageReference saveme() 
    { 
     string strSessionId;
      try
       { 
        if(GLDName == null)
         {
             String stringGLD = Schema.Session__c.fields.GL_Department__c.getDescribe().getLabel();
             ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLD+' : You must select a '+stringGLD+'.');
             ApexPages.addMessage(msg1);
             return null;
         }
        
        if(GLCName == null)
         {
             String stringGLC = Schema.Session__c.fields.GL_Code__c.getDescribe().getLabel();
             ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
             ApexPages.addMessage(msg2);
             return null;
         }
             
        if(VName == null)
         {
             String stringV = Schema.Session__c.fields.Vendor__c.getDescribe().getLabel();
             ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.ERROR,stringV+' : You must select a '+stringV+'.');
             ApexPages.addMessage(msg3);
             return null;
         }
             
        else
         {          
             if (Schema.sObjectType.Session__c.fields.GL_Department__c.isCreateable()) {
                 session.GL_Department__c = GLDName;}
             if (Schema.sObjectType.Session__c.fields.GL_Code__c.isCreateable()) {
                 session.GL_Code__c = GLCName;}
             if (Schema.sObjectType.Session__c.fields.Vendor__c.isCreateable()) {
                 session.Vendor__c = Vname;}
             if (Schema.sObjectType.Session__c.fields.Producer__c.isCreateable()) {
                 session.Producer__c = StaffProducerName;}
             if (Schema.sObjectType.Session__c.fields.Technician__c.isCreateable()) {
                 session.Technician__c = StaffTechnicianName;}
             if(Schema.sObjectType.Session__c.isCreateable()){insert session;}
             strSessionId = session.id;
         }
       }   
      catch(DMLException e)
       {
           return null;
       }
       
       if(session.Session_Status__c == 'Booked')
       {
       est = new Estimate_Line_Items__c();
       if (Schema.sObjectType.Estimate_Line_Items__c.fields.Name.isCreateable()) {
           est.Name = session.Name;}
        if (Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Department__c.isCreateable()) {
            est.GL_Department__c = session.GL_Department__c;}
        if (Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Code__c.isCreateable()) {
            est.GL_Code__c = session.GL_Code__c;}
        if (Schema.sObjectType.Estimate_Line_Items__c.fields.Vendor__c.isCreateable()) {
            est.Vendor__c = session.Vendor__c;}
        if (Schema.sObjectType.Estimate_Line_Items__c.fields.Job__c.isCreateable()) {
            est.Job__c = session.Job__c;}
        if (Schema.sObjectType.Estimate_Line_Items__c.fields.Session__c.isCreateable()) {
            est.Session__c = session.id;}
    //   est.Amount__c = q1.Amount__c;
        if (Schema.sObjectType.Estimate_Line_Items__c.fields.Quantity__c.isCreateable()) {
            est.Quantity__c = session.Quantity__c;}
     //  strEstimateId = est.Id;
         try
          {
              if(Schema.sObjectType.Estimate_Line_Items__c.isCreateable()){insert est;}
            PageReference pageref =  new Pagereference('/apex/JobListView?id='+JobId+'&intFocus=5');
            pageRef.setRedirect(true);
            return pageRef;
         }
         catch(System.DMLException e)
         {
             return null;
         }
        }
        
      
        PageReference pageref =  new Pagereference('/apex/JobListView?id='+JobId+'&intFocus=10');
        pageRef.setRedirect(true);
        return pageRef;
       
      
   } 
  // End of Save Method 
           
  // Method to deal with cancel button 
  public PageReference cancelme()
   {
      PageReference p =  new Pagereference('/apex/JobListView?id='+JobId+'&intFocus=10');
      p.setRedirect(true);
      return p;     
   }
  // End of method cancelme
     
       
    // Positive Test Case
    private static testMethod void Test_CreateNewSessionExtension()
     {
      
      Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
      insert customSetting001; 
     
      Media_Type__c testMedia=new Media_Type__c(Name='TM32109');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='TST32109',Media_Types__c=testMedia.Id);
      insert testST;
               
      Specification_Template__c testSpec=new Specification_Template__c(Name='TSPT32109');
      insert testSpec;
            
      Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='Job12345',Name='TestJobByDeveloper',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
         //   System.assert(e.getMessage().contains('Job with same name Exists'));
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
       
      System.assertEquals('TestJobByDeveloper',testJob1.Name);    
            
      GL_Department__c testGLD = new GL_Department__c(Name='TestGLD32109');
       try
        {
            insert testGLD;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
              
      GL_Code__c testGL=new GL_Code__c(Name='GLC32109',GL_ID__c='TestGL32109',GL_Department__c = testGLD.id);
       try
        {
            insert testGL;
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
            System.assert(e.getMessage().contains('Vendor with same name Exists'));
        }
        
        Vendor_GL_Code__c testVG1 = new Vendor_GL_Code__c(Vendor__c = testVendor.Id, GL_Code__c = testGL.Id);
            insert testVG1;
        
       Staff__c st1=new Staff__c(User_Type__c='Staff',First_Name__c='test',Last_Name__c ='staff',Name='test staff',Email__c='teststaff@gmail.com', Username__c='teststaffun@gmail.com', Role__c='Producer');    
        try
        {
            insert st1;
        }
         catch(DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        Staff__c st2=new Staff__c(User_Type__c='Staff',First_Name__c='test1',Last_Name__c ='staff1',Name='test1 staff1',Email__c='teststaff1@gmail.com', Username__c='teststaffun1@gmail.com', Role__c='Technician');    
        try
        {
            insert st2;
        }
         catch(DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }        
            
      Session__c testSession=new Session__c(Name='Session1',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Quantity__c=10,GL_Code__c=testGL.id);
      
      ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
      ApexPages.StandardController con=new ApexPages.StandardController(testSession);    
      CreateNewSessionExtension   ext=new CreateNewSessionExtension(con);  
      
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
      
      ext.StaffProducerName = st1.Id;
      String StaffProducerName = ext.getStaffProducerName();
      ext.setStaffProducerName(StaffProducerName);
      List<SelectOption> options3 = ext.getProducerStaffs();  
      
      ext.StaffTechnicianName = st2.Id;
      String StaffTechnicianName = ext.getStaffTechnicianName();
      ext.setStaffTechnicianName(StaffTechnicianName);
      List<SelectOption> options4 = ext.getTechnicianStaffs();
           
      ApexPages.PageReference result1=ext.saveme();
      result1=ext.cancelme();  
        
     // Start Negative test
      Session__c testSession1=new Session__c ();
      ApexPages.StandardController con1=new ApexPages.StandardController(testSession1);
      CreateNewSessionExtension   ext1=new CreateNewSessionExtension(con1);
      result1=ext.saveme();
      result1=ext.cancelme();  
      
      // To cover GLDepartment is NULL, Keep GLDepartment as NULL and invoke save method
      
      ext.GLDName = NULL;
      String GLDName5 = ext.getGLDName();
      ext.setGLDName(GLDName5);
      List<SelectOption> options5 = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.Id;
      String GLCName6 = ext.getGLCName();
      ext.setGLCName(GLCName6);
      List<SelectOption> options6 = ext.getGLCodes(); 
          
      ext.VName = testVendor.Id;
      String VName7 = ext.getVName();
      ext.setVName(VName7);
      List<SelectOption> options7 = ext.getVendors(); 
      
      ext.StaffProducerName = st1.Id;
      String StaffProducerName8 = ext.getStaffProducerName();
      ext.setStaffProducerName(StaffProducerName8);
      List<SelectOption> options8 = ext.getProducerStaffs();  
      
      ext.StaffTechnicianName = st2.Id;
      String StaffTechnicianName9 = ext.getStaffTechnicianName();
      ext.setStaffTechnicianName(StaffTechnicianName9);
      List<SelectOption> options9 = ext.getTechnicianStaffs();  
      
      result1=ext.saveme(); 
      
      
     // To cover GL Code is NULL, Keep GLCode as NULL and invoke save method
      
      ext.GLDName = testGLD.Id;
      String GLDName10 = ext.getGLDName();
      ext.setGLDName(GLDName10);
      List<SelectOption> options10 = ext.getGLDepartments(); 
     
      ext.GLCName = NULL;
      String GLCName11 = ext.getGLCName();
      ext.setGLCName(GLCName11);
      List<SelectOption> options11 = ext.getGLCodes(); 
          
      ext.VName = testVendor.Id;
      String VName12 = ext.getVName();
      ext.setVName(VName12);
      List<SelectOption> options12 = ext.getVendors(); 
      
      ext.StaffProducerName = st1.Id;
      String StaffProducerName13 = ext.getStaffProducerName();
      ext.setStaffProducerName(StaffProducerName13);
      List<SelectOption> options13 = ext.getProducerStaffs();  
      
      ext.StaffTechnicianName = st2.Id;
      String StaffTechnicianName14 = ext.getStaffTechnicianName();
      ext.setStaffTechnicianName(StaffTechnicianName14);
      List<SelectOption> options14 = ext.getTechnicianStaffs();  
      
      result1=ext.saveme();  
 
 
     // To cover Vendor is NULL, Keep Vendor as NULL and invoke save method
      
      ext.GLDName = testGLD.Id;
      String GLDName15 = ext.getGLDName();
      ext.setGLDName(GLDName15);
      List<SelectOption> options15 = ext.getGLDepartments(); 
     
      ext.GLCName = testGL.Id;
      String GLCName16 = ext.getGLCName();
      ext.setGLCName(GLCName16);
      List<SelectOption> options16 = ext.getGLCodes(); 
          
      ext.VName = NULL;
      String VName17 = ext.getVName();
      ext.setVName(VName17);
      List<SelectOption> options17 = ext.getVendors(); 
      
      ext.StaffProducerName = st1.Id;
      String StaffProducerName18 = ext.getStaffProducerName();
      ext.setStaffProducerName(StaffProducerName18);
      List<SelectOption> options18 = ext.getProducerStaffs();  
      
      ext.StaffTechnicianName = st2.Id;
      String StaffTechnicianName19 = ext.getStaffTechnicianName();
      ext.setStaffTechnicianName(StaffTechnicianName19);
      List<SelectOption> options19 = ext.getTechnicianStaffs();  
      result1=ext.saveme();  
    }  */
  // End of Test Coverage Code
}
// End of test class