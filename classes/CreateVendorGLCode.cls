// This class is used to create new Vendor GL Code
public with sharing class CreateVendorGLCode 
{
    // Global variables
   /* String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    private final Vendor_GL_Code__c vgc; 
    // End Global variables
    
    // Start Constructor
    public CreateVendorGLCode(ApexPages.StandardController controller) 
    {
         this.vgc=(Vendor_GL_Code__c)controller.getrecord();
         string ven = ApexPages.currentPage().getParameters().get('vid');
         if(ven != null && ven != '')
         vgc.Vendor__c = ven;
    }
    // End Constructor
    
    
    // Populate GLCodes in picklist
    public List<selectOption> getGLCodes()     
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (GL_Code__c a : [SELECT Id, name FROM GL_Code__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }    
    // End getGLCodes method
    
    // Method called on to Save VendorGLCode
    Public PageReference saveme()
    {
        try
        {
            String strid;
            if (Schema.sObjectType.Vendor_GL_Code__c.fields.GL_Code__c.isCreateable()) {
            vgc.GL_Code__c = GLCName;}
            if(GLCName == null)
            {
                String stringGLC = Schema.Vendor_GL_Code__c.fields.GL_Code__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        
            else
            {
                insert vgc;
                strid = vgc.Vendor__c;        
                PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+strid+'&section=GLCode');
                p.setRedirect(true);
                return p;
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }
    }
    // End Save method
    
    Public PageReference cancelme()
    {
    String strid;
        strid = vgc.Vendor__c;        
        PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+strid+'&section=GLCode');
        p.setRedirect(true);
        return p;
        
    }
    
    
    
    // Start Test Coverage Here
    static testMethod void Test_CreateVendorGLCode()
    {
           GL_Department__c testGLD = new GL_Department__c(Name='GLD015');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GLC015',GL_ID__c='GLC015',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
             }
             catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
           Vendor__c testVendor=new Vendor__c(Name='TV015',Email__c='abcd@gmail.com',Zip__c='12345');
             try
              {
                  insert testVendor;
              }
              catch(System.DMLException e)
              {
                  System.assert(e.getMessage().contains('Job with same name Exists'));
              }  
    
        Vendor_GL_Code__c vgc = new Vendor_GL_Code__c(GL_Code__c=testGL.id,Vendor__c=testVendor.id);
        
        ApexPages.StandardController con=new ApexPages.StandardController(vgc);
        
        CreateVendorGLCode ext=new CreateVendorGLCode(con);
        
        ext.GLCName=null; // To check GLCodes as NULL
        
        ApexPages.PageReference result=ext.saveme();
        
        ext.GLCName = testGL.id;
        String GLCName = ext.getGLCName();
        ext.setGLCName(GLCName);
        List<SelectOption> options1 = ext.getGLCodes(); 
        result=ext.saveme();
          
        Vendor_GL_Code__c obj=[select id from Vendor_GL_Code__c where id=: vgc.id];
        delete obj;
        System.assertNOTEquals(NULL,obj.id);
        result=ext.saveme();
    }  // End Test Coverage */
} // End of Class