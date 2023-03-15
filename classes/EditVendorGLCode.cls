// This method is called on to edit Vendor GL Code
public with sharing class EditVendorGLCode 
{
/*    // Global variables
    String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    private final Vendor_GL_Code__c vgc; 
    // End of Global variables
    
    // Start Constructor
    public EditVendorGLCode(ApexPages.StandardController controller) 
    {
         this.vgc=(Vendor_GL_Code__c)controller.getrecord();
         Vendor_GL_Code__c vgc1 = [select id,Name,GL_Code__c from Vendor_GL_Code__c where id =: vgc.id Limit 1];
         GLCName = vgc1.GL_Code__c;
    }
    // End of Constructor
    
    // This method is called on to retrieve all GLCodes into dropdown list
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
    // End of method getGLCodes
    
    // Method called on to Save Vendor-GLCode
    Public PageReference saveme()
    {
        try
        {
        String strid;
         if(GLCName == null)
         {
                String stringGLC = Schema.Vendor_GL_Code__c.fields.GL_Code__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
                ApexPages.addMessage(myMsg);
                return null;
         }
         else
         {    
            GL_Code__c gc=[Select Id,Name from GL_Code__c where Id=:GLCName];
               if(schema.SobjectType.Vendor_GL_Code__c.Fields.GL_Code__c.isUpdateable()){ vgc.GL_Code__c=gc.Id;}
               if(Schema.sObjectType.Vendor_GL_Code__c.isUpdateable()){update vgc;}
         }
            strid = vgc.Vendor__c;        
            PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+strid+'&section=GLCode');
            p.setRedirect(true);
            return p;
        }
        catch(System.DMLException e)
        {
            return null;
        }
    }    
    
    
    Public PageReference cancelme()
    {
        String strid;
            strid = vgc.Vendor__c;        
            PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+strid+'&section=GLCode');
            p.setRedirect(true);
            return p;
    
    }
    
    // Test Coverage Code
    static testMethod void EditVendorGLCode()
    {
           GL_Department__c testGLD = new GL_Department__c(Name='GLD016');
            try
            {
            insert testGLD;
            }
            catch(System.DMLException e)
            {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
            GL_Code__c testGL=new GL_Code__c(Name='GLC016',GL_ID__c='GLC016',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
             }
             catch(System.DMLException e)
             {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
             
           Vendor__c testVendor=new Vendor__c(Name='TV016',Email__c='abcd@gmail.com',Zip__c='12345');
             try
              {
                  insert testVendor;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }  
    
            Vendor_GL_Code__c vgc = new Vendor_GL_Code__c(GL_Code__c=testGL.id,Vendor__c=testVendor.id);
             try
              {
                  insert vgc;
              }
              catch(System.DMLException e)
              {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }  
        
            // Instantiate the standard controller with the  Vendor GL Code 
          ApexPages.StandardController con=new ApexPages.StandardController(vgc);
        
           // Instantiate the extention instance with the standard controller 
          EditVendorGLCode ext=new EditVendorGLCode(con);
        
          ext.GLCName = testGL.id;
          String GLCName = ext.getGLCName();
          ext.setGLCName(GLCName);
          List<SelectOption> options1 = ext.getGLCodes(); 
          
           // Invoke the primary method on the extension 
          ApexPages.PageReference result=ext.saveme(); 
          
          ext.GLCName=null;
          result=ext.saveme();
    }// End of Test Coverage*/
}// End of Class