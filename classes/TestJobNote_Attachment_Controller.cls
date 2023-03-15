@isTest
Public class TestJobNote_Attachment_Controller{
/*
// Test Coverage
        static testMethod void TestJobNote_Attachment_Controller()
        {
            Profile p=[Select Id from Profile where Name='System Administrator' limit 1];
            
           User u=[Select Id from User where IsActive=: True and profileId=: p.Id Limit 1];
            
            
            
            System.runAs(u)
           {
           
            
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 352');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 352',Media_Types__c=testMedia.Id);
             
                insert testST;
                 
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 352');
    
                insert testSpec;
          
             Job__c testJob1=new Job__c(Flag__c = false,Job_Auto_Number__c = '2012-04-01',Name='Test Job 352',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
             insert testJob1;
              
              
              System.assertEquals('Test Job 352',testJob1.Name);   
           
               Note n=new Note(parentId=testJob1.Id,Title='Test Title 352',IsPrivate=True,Body='Test Note Body');
                   insert n;
               
               System.assertEquals('Test Title 352',n.Title);
              
               // Instantiate the standard controller with the Job
               ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                   
               ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
               
               // Instantiate the extention instance with the standard controller 
               
               JobNote_Attachment_Controller ext= new JobNote_Attachment_Controller(con);
               
               // Invoke the primary method on the extension
               
               ApexPages.Pagereference pr=ext.CreateNote();
               pr=ext.AttachFile();
           
               ApexPages.Pagereference pg1=ext.editNote();
               ApexPages.Pagereference pg2=ext.editAttachment();
               ApexPages.Pagereference pg3=ext.deleteNote();
               ApexPages.Pagereference pg4=ext.deleteAttachment();
               ApexPages.Pagereference pg5=ext.deleteFeedAttachment();
               }
        }
    // End Test Coverage
*/
}