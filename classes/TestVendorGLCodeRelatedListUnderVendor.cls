//@istest
public class TestVendorGLCodeRelatedListUnderVendor {
/*
    @istest static void TestvendorGLcode(){
        
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
           insert vgc;
        
        VendorGLCodeRelatedListUnderVendor VGLcode=new VendorGLCodeRelatedListUnderVendor();
        VGLcode.CreateQuote();
        vGLcode.Showless();
        vGLcode.ViewAll();
        boolean x=vGLcode.isLtng;
        boolean y=vGLcode.isMob;
        
        
        
    }*/
    
}