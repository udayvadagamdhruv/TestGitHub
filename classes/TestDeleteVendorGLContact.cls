@istest
public class TestDeleteVendorGLContact {
    @istest static void DeleteVendorGLContact(){
       /*  GL_Department__c testGLD = new GL_Department__c(Name='GLD016');
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
        DeleteVendorGLContact VGLcode=new DeleteVendorGLContact(new ApexPages.StandardController(vgc));
            VGLcode.CheckDelete();
        */
        
    }
}