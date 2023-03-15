//@isTest
Public Class TestDisplayInvoiceunderjobtabExtension{

/*
    // Start Test Coverage Code 
      static testMethod void DisplayInvoiceWhenApproved()
      {
           DisplayInvoiceunderjobtabExtension ext=new DisplayInvoiceunderjobtabExtension();
           
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 313');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 313',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 314',Media_Types__c=testMedia.Id);
               insert testST1;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 313');
               insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 314');
               insert testSpec1;
           
           Job__c testJob1=new Job__c(Name='Test Job 314',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('Test Job 314',testJob1.Name);  
           
            Invoice__c  testI=new Invoice__c  (Job__c=testjob1.Id);
            insert testI;
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
           // Instantiate the extention instance with the Custom Controller
           
           DisplayInvoiceunderjobtabExtension ext1=new DisplayInvoiceunderjobtabExtension();
          
          // Invoke the CreateInvoice method on the extension
           ext1.CreateInvoice();
           
           // Instantiate the extention instance with the Custom Controller
           
           DisplayInvoiceunderjobtabExtension ext2=new DisplayInvoiceunderjobtabExtension();
           
           Double result2=ext2.getSumCash3();
           Double result3=ext2.getSumCash4();
           ext1.Delinvid= testI.Id;
             
           // Invoke the Save and Cancel method on the extension
           
          ext2.save();
           ext2.cancelme();
          
          ext1.invrowIndex = 0;
          ext1.inlineEditInv();
          ext1.inlinesaveInv();
          ext1.ViewAllInv();
          ext1.ShowLessInv();
          
            ext1.del();
    } 
 // End of test Method

 */


}