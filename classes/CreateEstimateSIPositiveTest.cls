@istest

public class CreateEstimateSIPositiveTest
{   
       /* 
        static testMethod void CreateEstimateSIPositiveTest()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 361');
             
                insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 361',Media_Types__c=testMedia.Id);
             
                 insert testST;
     
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 361');
              
                insert testSpec;
        
             Job__c testJob1=new Job__c(Name='Test Job 361',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
              try
               {
                   insert testJob1;
               }
              catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
              System.assertEquals('Test Job 361',testJob1.Name); 
               
             GL_Department__c testGLD = new GL_Department__c(Name='TestGLD3');
              try
               {
                   insert testGLD;
               }
              catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }      
       
             Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 361',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
              try
               {
                   insert testELI;
               }
              catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
               
             Estimate_Spec_Item__c testESI = new Estimate_Spec_Item__c(Name='Spec Item 361',Estimates__c=testELI.Id);
             
             // Instantiate the extention instance with the standard controller 
             
             ApexPages.StandardController con=new ApexPages.StandardController(testESI);
             
             // ApexPages.currentPage().getParameters().put('Id',testESI.Id);
             CreateEstimateLIExtension  ext=new CreateEstimateLIExtension(con);
        
             // Invoke the saveme method on the extension
             ApexPages.PageReference result1=ext.saveme();
         
            // Negative Test 
            Estimate_Spec_Item__c testESI1=new Estimate_Spec_Item__c();
             try
              {
                   insert testESI1;
              }
             catch(System.DMLException e)
              {
               System.assertEquals('REQUIRED_FIELD_MISSING' , e.getDmlStatusCode(0));
              }
             
            ApexPages.StandardController con1=new ApexPages.StandardController(testESI1);
            CreateEstimateLIExtension  ext1=new CreateEstimateLIExtension(con1);
            
            // Invoke the saveme method on the extension
            ApexPages.PageReference result2=ext1.saveme();  
            ApexPages.PageReference result=ext1.cancelme();  
      }*/
      
 }