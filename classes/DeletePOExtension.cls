// This Class is used in Delete Purchase order 
public with sharing class DeletePOExtension 
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
  
    // Global variables   
    public Id JobId;
    private final Purchase_Order__c objPO; 
    // End of Global variables
    
    // Constructor
    public DeletePOExtension(ApexPages.StandardController controller) 
    {
        this.objPO=(Purchase_Order__c)controller.getrecord();
        JobId = [Select Id, Job__c from Purchase_Order__c where Id =:objPO.Id limit 1].Job__c;
    }
    // End of Constructor 
    
    // CheckDelete Method 
    public PageReference checkDelete()
     {
       try
        {
            Database.delete(objPO);        
        }
        catch(System.DMLException e)
        {
            return null;
        }
        // After deletion navigate to PO Tab
        if(isLtng)
                    {
                    PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobcost'+'&section=purchaseorders');
                    p.setRedirect(true);
                    return p;
                    }
           else{
                    PageReference p =  new Pagereference('/apex/JobListViewSwitchPage?id='+Jobid+'&intFocus=6');
                    p.setRedirect(true);
                    return p;
           
              }
     }
    // End of CheckDelete Method 
     
   /* // Start Test Coverage Code
    static testMethod void Test_DeletePOExtension()
     {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 624');
              insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 624',Media_Types__c=testMedia.Id);
              insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 624');
              insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 624',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
           try
           {
                insert testJob1;
           }
           catch(System.DMLException e)
           {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
           }
           
          System.assertEquals('Test Job 624',testJob1.Name);
          
          
          
          
          
          
          
          
          
        
          
           GL_Department__c testGLD = new GL_Department__c(Name='TestGLD9987');
            try
             {
                 insert testGLD;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
          
           GL_Code__c testGL=new GL_Code__c();
            testGL.Name='TGL9987';
            testGL.GL_Id__c='GL Code9987';
            testGL.Unit_Cost__c=2500;
            testGL.Unit_Type__c='Days';
            testGL.GL_Department__c=testGLD.id;
            try
             {
             insert testGL;
             }
            catch(System.DMLException e)
             {
             System.assert(e.getMessage().contains('Record already exist with same GLCode'));
             }
             
             Vendor__c testVendor=new Vendor__c(Name='TV 9987');
             insert testVendor;
           
             Vendor_GL_Code__c testVGLCode = new Vendor_GL_Code__c(GL_Code__c = testGL.id,Vendor__c = testVendor.id);
             insert testVGLCode;
        
         
         
           Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 20',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Approved__c=True,GL_Code__c=testGL.id,Amount__c=2000,Quantity__c=120);
           insert testELI;
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
      
          Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today().AddDays(1),Invoice_Created__c='No',Vendor__c = testVendor.id,Name=' 000040');
          insert testPO;
          
          PO_Line_Item__c testPOLI = new PO_Line_Item__c(Purchase_Order__c = testPO.id,Invoice_Created__c = false,Estimate_Line_Item__c = testELI.id,Amount__c = testELI.Total_Amount__c);
          insert testPOLI;   
          // Instantiate the extention instance with the standard controller 
          
          ApexPages.StandardController con=new ApexPages.StandardController(testPO);
          ApexPages.currentPage().getParameters().put('Id',testPO.Id);
          DeletePOExtension ext=new DeletePOExtension(con);
        
          // Invoke the saveme method on the extension
          ApexPages.PageReference result1=ext.checkDelete();
          result1=ext.checkDelete();
        }
 // End of Test Coverage */
}
// End of Apex class