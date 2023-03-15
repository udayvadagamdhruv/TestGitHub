@istest
public class Test_CreateNewTagExtensions{
/*
static testMethod void Test_CreateNewTagExtensions()
    {
        Job_Number_Setting__c customSetting351 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting351;
            
          Media_Type__c testMedia1 = new Media_Type__c(Name='Test Media 351');
             
                insert testMedia1;
             
          Schedule_Template__c testST1 = new Schedule_Template__c(Name='Test Schedule Template 351',Media_Types__c=testMedia1.Id);
             
                 insert testST1;
                 
         Specification_Template__c testSpec1 = new Specification_Template__c(Name='Testing Spcification Template 351');
                insert testSpec1;
                
         Job__c testJob1 = new Job__c(Name='Test Job 351',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
         
                 insert testJob1;
                 
         System.assertEquals('Test Job 351',testJob1.Name);        
         
         Tag__c testTag1=new Tag__c(Name = 'Test Tag 351',Job__c = testJob1.Id);   
         
         
         ApexPages.CurrentPage().getParameters().put('jobId',testJob1.id);     
       
       // Instantiate the standard controller with the Job
        ApexPages.StandardController con = new ApexPages.StandardController(testTag1);
            
        // Instantiate the extention instance with the standardcontroller
        CreateNewTagExtensions ext=new CreateNewTagExtensions(con);
 
        // Invoke the primary method on the extension
        ApexPages.PageReference result = ext.saveme();  
        
        result = ext.cancelme();     
        
        delete testTag1;
        
        result = ext.saveme();
    }*/
    }