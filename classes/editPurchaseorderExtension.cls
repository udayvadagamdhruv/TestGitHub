// This class is used to edit Purchase Order
public with sharing class editPurchaseorderExtension 
{
 /*   public boolean isLtng{private set; get{
                                    String theme = UserInfo.getUITheme();
                                    return (theme=='Theme4d')?true:false;
                                  }
    }  

    // Global variables
    String StaffName,objPOId,strPOID;
    public String getStaffName() { return StaffName; }
    public void setStaffName(String s) {  this.Staffname = s; }
    private final Purchase_Order__c objPO;
    // End of Global variables
    
    // Start Controller
    public editPurchaseorderExtension(ApexPages.StandardController controller) 
    {
         this.objPO=(Purchase_Order__c)controller.getrecord();
         Purchase_Order__c abc = [select id,Name,Approved_By_Staff__c from Purchase_Order__c  where id =: objPO.id];
         objPOId = objPO.Id;
         StaffName = abc.Approved_By_Staff__c;
    }
    //End Controller
  
    // This method is called on to retrieve all The Staff members in dropdown list
    public List<selectOption> getStaffs() 
    {
        List<selectOption> optionList = new List<selectOption>();  
        optionList.add(new selectOption('', '- None -')); 
        for (Staff__c a : [SELECT Id, name FROM Staff__c where IsDeleted__c = False order by Name Limit 5000]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
    public List<selectOption> getVendorContact()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below        
        for (Vendor_Contact__c ar:[SELECT Vendor__c,Name FROM Vendor_Contact__c where Vendor__c=:objPO.Vendor__c])  
          { 
                options.add(new selectOption(ar.Id, ar.name));
               
                
          }
        return options; //return the picklist options
    }
    
    // End of method getStaffs
 
    // Method called on to Save Purchase Order
    Public PageReference saveme()
    {
       try
       {
            if(StaffName != null)
            {
                    Staff__c a1 = [SELECT Id, name FROM Staff__c where id =: StaffName];
                       if(schema.SobjectType.Purchase_Order__c.Fields.Approved_By_Staff__c.isUpdateable()){ objPO.Approved_By_Staff__c = a1.id;}
            } 
            if(StaffName == null)
            {
                     if(schema.SobjectType.Purchase_Order__c.Fields.Approved_By_Staff__c.isUpdateable()){objPO.Approved_By_Staff__c = null;} 
             }       
                  if(Schema.sObjectType.Purchase_Order__c.isUpdateable()){update objPO;}
             strPOId = objPO.Id;         
       } 
       catch(system.DMLException e)
       {
           return null;
       }
       // After updating PO, navigate to PO detail page
       
               if(isLtng){
                  PageReference pageRef = new PageReference('/apex/PODetailPageLightning?id='+strPOId);
                  pageRef.setRedirect(true);
                  return pageRef;
                  }
              else{
                  PageReference pageRef = new PageReference('/apex/PODetailPage?id='+strPOId);
                  pageRef.setRedirect(true);
                  return pageRef;
                  }
    }
    // End of method Save
    
    // This method is called on to handle Cancel button
    public PageReference cancelme()
    {       
        if(isLtng){
                  PageReference pageRef = new PageReference('/apex/PODetailPageLightning?id='+objPOId);
                  pageRef.setRedirect(true);
                  return pageRef;
                  }
              else{
                  PageReference pageRef = new PageReference('/apex/PODetailPage?id='+objPOId);
                  pageRef.setRedirect(true);
                  return pageRef;
                  }
    }  
    // End of method Cancel
    
    // Test Coverage Code
    /*
     static testMethod void EditPOPositiveTest()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 347');
             
                insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 347',Media_Types__c=testMedia.Id);
             
                 insert testST;
  
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 347');
                insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 347',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
               // Insert Staff Record
               
               Staff__c staff=new Staff__c(First_Name__c='Test',Last_Name__c='Staff 987',Name='Test Staff 987',UserName__c='test@test.com',Email__c ='Test@test.com');
               insert staff;
               System.assertEquals('Test Job 347',testJob1.Name);
   
               Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Approved_By_Staff__c=staff.id);
                    insert testPO;
             
                 // Instantiate the standard controller with the Purchase Order
               ApexPages.StandardController con=new ApexPages.StandardController(testPO);
               ApexPages.currentPage().getParameters().put('Id',testPO.Id);
              
                 // Instantiate the extention instance with the standard controller
               editPurchaseorderExtension ext=new editPurchaseorderExtension(con);
        
                // Invoke the saveme method on the extension 
           
               ApexPages.PageReference result1=ext.saveme();
            
               // Invoke the cancelme method on the extension 
               ApexPages.PageReference result2=ext.cancelme();
            
               result1=ext.saveme();
               ext.getStaffs();
      
              // Test for Staff equals NULL
            
               Purchase_Order__c testPO2=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No');
                    insert testPO2;
             
               // Instantiate the standard controller with the Purchase Order
                con=new ApexPages.StandardController(testPO2);
                ApexPages.currentPage().getParameters().put('Id',testPO2.Id);
              
                  // Instantiate the extention instance with the standard controller
               ext=new editPurchaseorderExtension(con);
        
                // Invoke the saveme method on the extension 
           
               result1=ext.saveme();
          }*/
          // End of Test Coverage Code
}// End of Class