// This class is used for create New Session functionality and used in createNewSession vf page
public with sharing class EditSessionExtension 
{
   /* public Estimate_Line_Items__c est;
    
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
    
    private final Session__c session;
    public String JobId{get;set;}
    public String ssnId;
    // End of Global variables
    
    // Start of Constructor
    public EditSessionExtension(ApexPages.StandardController controller) 
    {
        this.session=(Session__c)controller.getRecord();
        ssnId=ApexPages.CurrentPage().getParameters().get('id');
        
        Session__c ssn = [select id,Name,Unit_Cost__c,Job__c,GL_Code__c,GL_Department__c,Vendor__c,Producer__c,Technician__c from Session__c  where id =: session.id];
        GLDName = ssn.GL_Department__c;
        GLCName = ssn.GL_Code__c;
        VName = ssn.Vendor__c;
        StaffProducerName = ssn.Producer__c;
        StaffTechnicianName = ssn.Technician__c;
        JobId = session.Job__c;
        
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
                Staff__c stf1,stf2;
                
                GL_Code__c glc1 = [select id,Name from GL_Code__c where id =: GLCName];
                GL_Department__c gd1 = [SELECT Id, name FROM  GL_Department__c where id =: GLDName];
                Vendor__c v1 = [select id,name from Vendor__c where id =: VName];
                if(StaffProducerName != null)
                {
                    stf1 = [select id,Name from Staff__c where id =: StaffProducerName];
                }
                if(StaffTechnicianName != null)
                {
                    stf2 = [select id,Name from Staff__c where id =: StaffTechnicianName];      
                }
                
                if(schema.SobjectType.Session__c.Fields.GL_Department__c.isUpdateable()){ session.GL_Department__c = gd1.id;}
                if(schema.SobjectType.Session__c.Fields.GL_Code__c.isUpdateable()){ session.GL_Code__c = glc1.id;}
                if(schema.SobjectType.Session__c.Fields.Vendor__c.isUpdateable()){ session.Vendor__c = v1.id;}
                
                if(StaffProducerName != null)
                {
                    if(schema.SobjectType.Session__c.Fields.Producer__c.isUpdateable()){session.Producer__c = stf1.id;}
                }
                if(StaffProducerName == null)
                {
                    if(schema.SobjectType.Session__c.Fields.Producer__c.isUpdateable()){session.Producer__c = null;}
                }
                
                
                if(StaffTechnicianName != null)
                {
                    if(schema.SobjectType.Session__c.Fields.Technician__c.isUpdateable()){ session.Technician__c = stf2.id;}
                }
                if(StaffTechnicianName == null)
                {
                    if(schema.SobjectType.Session__c.Fields.Technician__c.isUpdateable()){session.Technician__c = null;}
                }
                
                List<Estimate_Line_Items__c> approvedELI = new List<Estimate_Line_Items__c>();
                approvedELI = [select id,Name,Approved__c,Session__c from Estimate_Line_Items__c where Session__c =: ssnId and Approved__c =: True];
                
                if(approvedELI.isEmpty())
                {  
                    
                    if(Schema.sObjectType.Session__c.isUpdateable()){ 
                        update session;
                    }
                    
                    List<Estimate_Line_Items__c> updateELI = new List<Estimate_Line_Items__c>();
                    List<Estimate_Line_Items__c> elineedstoupdate = new List<Estimate_Line_Items__c>();
                    elineedstoupdate = [select id,Name,GL_Department__c,GL_Code__c,Vendor__c,Job__c,Amount__c,Quantity__c,Approved__c,Session__c from Estimate_Line_Items__c where Session__c =: ssnId and Approved__c =: False];
                    
                    for(Estimate_Line_Items__c e : elineedstoupdate)
                    {
                        if(schema.SobjectType.Estimate_Line_Items__c.Fields.Name.isUpdateable()){ 
                            e.Name = session.Name;
                        }
                        if(schema.SobjectType.Estimate_Line_Items__c.Fields.GL_Department__c.isUpdateable()){ 
                            e.GL_Department__c = session.GL_Department__c;
                        }
                        if(schema.SobjectType.Estimate_Line_Items__c.Fields.GL_Code__c.isUpdateable() || schema.SobjectType.Estimate_Line_Items__c.Fields.GL_Code__c.isCreateable()){ 
                            e.GL_Code__c = session.GL_Code__c;
                        }
                        if(schema.SobjectType.Estimate_Line_Items__c.Fields.Vendor__c.isUpdateable() || schema.SobjectType.Estimate_Line_Items__c.Fields.Vendor__c.isCreateable()){ 
                            e.Vendor__c = session.Vendor__c;
                        }
                        if(schema.SobjectType.Estimate_Line_Items__c.Fields.Amount__c.isUpdateable()){  
                            e.Amount__c = session.Unit_Cost__c;
                        }
                        if(schema.SobjectType.Estimate_Line_Items__c.Fields.Session__c.isUpdateable()){ 
                            e.Session__c = session.id;
                        }
                        if(schema.SobjectType.Estimate_Line_Items__c.Fields.Quantity__c.isUpdateable()){  
                            e.Quantity__c = session.Quantity__c;
                        }
                        updateELI.add(e); 
                    }
                    if(updateELI.Size() > 0)
                    {
                        if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){
                            update updateELI;
                        }
                    }
                    
                    
                    if(session.Session_Status__c == 'Booked')
                    {
                        
                        List<Estimate_Line_Items__c> eli = new List<Estimate_Line_Items__c>();
                        eli = [select id,Name,Approved__c,Session__c from Estimate_Line_Items__c where Session__c =: ssnId];
                        
                        Session__c ssn1 = new Session__c();
                        ssn1 = [select id,Name,GL_Department__c,GL_Code__c,Vendor__c,Job__c,Unit_Cost__c,Quantity__c from Session__c where id =: session.id];
                        if(eli.isEmpty())
                        {             
                            est = new Estimate_Line_Items__c();
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.Name.isCreateable()){
                                est.Name = ssn1.Name;
                            }
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.GL_Department__c.isCreateable()){
                                est.GL_Department__c = ssn1.GL_Department__c;
                            }
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.GL_Code__c.isCreateable() || schema.SobjectType.Estimate_Line_Items__c.Fields.GL_Code__c.isUpdateable()){
                                est.GL_Code__c = ssn1.GL_Code__c;
                            }
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.Vendor__c.isCreateable() || schema.SobjectType.Estimate_Line_Items__c.Fields.Vendor__c.isUpdateable()){
                                est.Vendor__c = ssn1.Vendor__c;
                            }
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.Job__c.isCreateable()){
                                est.Job__c = ssn1.Job__c;
                            }
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.Amount__c.isCreateable()){
                                est.Amount__c = ssn1.Unit_Cost__c;
                            }
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.Session__c.isCreateable()){ 
                                est.Session__c = ssn1.id;
                            }
                            if(Schema.SObjectType.Estimate_Line_Items__c.Fields.Quantity__c.isCreateable()){ 
                                est.Quantity__c = ssn1.Quantity__c;
                            }
                            try
                            {
                                if(Schema.sObjectType.Estimate_Line_Items__c.isCreateable()){
                                    insert est;  
                                }
                                PageReference pageref =  new Pagereference('/apex/JobListView?id='+JobId+'&intFocus=5');
                                pageRef.setRedirect(true);
                                return pageRef;
                            }
                            catch(System.DMLException e)
                            {
                                return null;
                            }
                        } 
                    }
                    
                    if(session.Session_Status__c != 'Booked')
                    {
                        List<Estimate_Line_Items__c> eli = new List<Estimate_Line_Items__c>();
                        eli = [select id,Name,Approved__c,Session__c from Estimate_Line_Items__c where Session__c =: ssnId and Approved__c =: False];
                        if(!eli.isEmpty())
                        {
                            if(Estimate_Line_Items__c.sObjectType.getDescribe().isDeletable()){
                                Database.Delete(eli);}
                        }
                    }
                }
                else
                {
                    ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'You can not update this Session, Becuase Estimate Line Item created from this Session is approved.');
                    ApexPages.addMessage(msg3);
                    return null;
                }
                
            }
        }   
        catch(DMLException e)
        {
            return null;
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
        
        Media_Type__c testMedia=new Media_Type__c(Name='TM32111');
        insert testMedia;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='TST32111',Media_Types__c=testMedia.Id);
        insert testST;
        
        Specification_Template__c testSpec=new Specification_Template__c(Name='TSPT32111');
        insert testSpec;
        
        Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='Job32111',Name='TestJobByDeveloper32111',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
        {
            insert testJob1;
        }
        catch(System.DMLException e)
        {
            //   System.assert(e.getMessage().contains('Job with same name Exists'));
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        System.assertEquals('TestJobByDeveloper32111',testJob1.Name);    
        
        GL_Department__c testGLD = new GL_Department__c(Name='TestGLD32111');
        try
        {
            insert testGLD;
        }
        catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        GL_Code__c testGL=new GL_Code__c(Name='GLC32111',GL_ID__c='TestGL32111',GL_Department__c = testGLD.id);
        try
        {
            insert testGL;
        }
        catch(System.DMLException e)
        {
            System.debug(e.getMessage());
        }
        
        Vendor__c testVendor=new Vendor__c(Name='TestV32111',Email__c='abcd@gmail.com',Zip__c='12345');
        try
        {
            insert testVendor;
        }
        catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Vendor with same name Exists'));
        }
        
        Vendor_GL_Code__c testVG = new Vendor_GL_Code__c(Vendor__c = testVendor.Id, GL_Code__c = testGL.Id);
        insert testVG;
        
        Staff__c st1=new Staff__c(User_Type__c='Staff',First_Name__c='test',Last_Name__c ='staff11',Name='test staff11',Email__c='teststaff11@gmail.com', Username__c='teststaffun11@gmail.com', Role__c='Producer');    
        try
        {
            insert st1;
        }
        catch(DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        Staff__c st2=new Staff__c(User_Type__c='Staff',First_Name__c='test1',Last_Name__c ='staff112',Name='test1 staff112',Email__c='teststaff112@gmail.com', Username__c='teststaffun1@gmail.com', Role__c='Technician');    
        try
        {
            insert st2;
        }
        catch(DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }        
        
        Session__c testSession=new Session__c(Name='Session112',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Quantity__c=10,GL_Code__c=testGL.id,Producer__c=st1.id,Technician__c=st2.id);
        try
        {
            insert testSession;
        }
        catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        ApexPages.StandardController con=new ApexPages.StandardController(testSession);    
        EditSessionExtension ext=new EditSessionExtension(con);  
        
        // To cover GLDepartment is empty, Keep GLDepartment as NULL and invoke save method
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
        
        ext.StaffProducerName = st1.Id;
        String StaffProducerName4 = ext.getStaffProducerName();
        ext.setStaffProducerName(StaffProducerName4);
        List<SelectOption> options4 = ext.getProducerStaffs();  
        
        ext.StaffTechnicianName = st2.Id;
        String StaffTechnicianName5 = ext.getStaffTechnicianName();
        ext.setStaffTechnicianName(StaffTechnicianName5);
        List<SelectOption> options5 = ext.getTechnicianStaffs();
        
        ApexPages.PageReference result1=ext.saveme();
        
        // To cover GLCode is empty, Keep GLCode as NULL and invoke save method
        ext.GLDName = testGLD.id;
        String GLDName6 = ext.getGLDName();
        ext.setGLDName(GLDName6);
        List<SelectOption> options6 = ext.getGLDepartments(); 
        
        ext.GLCName = NULL;
        String GLCName7 = ext.getGLCName();
        ext.setGLCName(GLCName7);
        List<SelectOption> options7 = ext.getGLCodes(); 
        
        ext.VName = testVendor.Id;
        String VName8 = ext.getVName();
        ext.setVName(VName8);
        List<SelectOption> options8 = ext.getVendors(); 
        
        ext.StaffProducerName = st1.Id;
        String StaffProducerName9 = ext.getStaffProducerName();
        ext.setStaffProducerName(StaffProducerName9);
        List<SelectOption> options9 = ext.getProducerStaffs();  
        
        ext.StaffTechnicianName = st2.Id;
        String StaffTechnicianName10 = ext.getStaffTechnicianName();
        ext.setStaffTechnicianName(StaffTechnicianName10);
        List<SelectOption> options10 = ext.getTechnicianStaffs();
        
        result1=ext.saveme();
        
        // To cover Vendor is empty, Keep GLDepartment as NULL and invoke save method
        ext.GLDName = testGLD.id;
        String GLDName11 = ext.getGLDName();
        ext.setGLDName(GLDName11);
        List<SelectOption> options11 = ext.getGLDepartments(); 
        
        ext.GLCName = testGL.id;
        String GLCName12 = ext.getGLCName();
        ext.setGLCName(GLCName12);
        List<SelectOption> options12 = ext.getGLCodes(); 
        
        ext.VName = NULL;
        String VName13 = ext.getVName();
        ext.setVName(VName13);
        List<SelectOption> options13 = ext.getVendors(); 
        
        ext.StaffProducerName = st1.Id;
        String StaffProducerName14 = ext.getStaffProducerName();
        ext.setStaffProducerName(StaffProducerName14);
        List<SelectOption> options14 = ext.getProducerStaffs();  
        
        ext.StaffTechnicianName = st2.Id;
        String StaffTechnicianName15 = ext.getStaffTechnicianName();
        ext.setStaffTechnicianName(StaffTechnicianName15);
        List<SelectOption> options15 = ext.getTechnicianStaffs();
        
        result1=ext.saveme();
        
        // To cover Producer field is empty, Keep Producer as NULL and invoke save method
        ext.GLDName = testGLD.id;
        String GLDName16 = ext.getGLDName();
        ext.setGLDName(GLDName16);
        List<SelectOption> options16 = ext.getGLDepartments(); 
        
        ext.GLCName = testGL.id;
        String GLCName17 = ext.getGLCName();
        ext.setGLCName(GLCName17);
        List<SelectOption> options17 = ext.getGLCodes(); 
        
        ext.VName = testVendor.id;
        String VName18 = ext.getVName();
        ext.setVName(VName18);
        List<SelectOption> options18 = ext.getVendors(); 
        
        ext.StaffProducerName = NULL;
        String StaffProducerName19 = ext.getStaffProducerName();
        ext.setStaffProducerName(StaffProducerName19);
        List<SelectOption> options19 = ext.getProducerStaffs();  
        
        ext.StaffTechnicianName = st2.Id;
        String StaffTechnicianName20 = ext.getStaffTechnicianName();
        ext.setStaffTechnicianName(StaffTechnicianName20);
        List<SelectOption> options20 = ext.getTechnicianStaffs();
        
        result1=ext.saveme();
        
        // To cover Technician field is empty, Keep Technician as NULL and invoke save method     
        ext.GLDName = testGLD.id;
        String GLDName21 = ext.getGLDName();
        ext.setGLDName(GLDName21);
        List<SelectOption> options21 = ext.getGLDepartments(); 
        
        ext.GLCName = testGL.id;
        String GLCName22 = ext.getGLCName();
        ext.setGLCName(GLCName22);
        List<SelectOption> options22 = ext.getGLCodes(); 
        
        ext.VName = testVendor.id;
        String VName23 = ext.getVName();
        ext.setVName(VName23);
        List<SelectOption> options23 = ext.getVendors(); 
        
        ext.StaffProducerName = st1.Id;
        String StaffProducerName24 = ext.getStaffProducerName();
        ext.setStaffProducerName(StaffProducerName24);
        List<SelectOption> options24 = ext.getProducerStaffs();  
        
        ext.StaffTechnicianName = NULL;
        String StaffTechnicianName25 = ext.getStaffTechnicianName();
        ext.setStaffTechnicianName(StaffTechnicianName25);
        List<SelectOption> options25 = ext.getTechnicianStaffs();
        
        result1=ext.saveme();
        
        ApexPages.PageReference result2=ext.cancelme();  
        
        Delete testSession;
        result1 = ext.saveme();
        result1 = ext.cancelme();
    }  */
    // End of Test Coverage Code
}
// End of class