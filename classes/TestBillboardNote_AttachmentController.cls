//@isTest
public class TestBillboardNote_AttachmentController {
/*	static testMethod void Test_JobNote_Attachment_Controller()
        {
            Profile p=[Select Id from Profile where Name='System Administrator' limit 1];
            
           User u=[Select Id from User where IsActive=: True and profileId=: p.Id Limit 1];
            
            System.runAs(u)
           {
           
          
           Client__c testClient=new Client__c(Name='Client 623');
           insert testClient;  
           
           Vendor__c testvendor=new Vendor__c (Name='Test vendor',Vendor_Type__c ='Outdoor');
           insert testvendor; 
           
           Billboard__c  testI=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI;
               
            Billboard__c  testI2=new Billboard__c(Client_Name__c=testClient.Id,name='test 123',BB_Vendor__c=testvendor.id);
           insert testI2;    
           
               Note n=new Note(parentId=testI.Id,Title='Test Title 352',IsPrivate=True,Body='Test Note Body');
                   insert n;
               
                Note n1=new Note(parentId=testI2.Id,Title='Test Title 352',IsPrivate=True,Body='Test Note Body');
                   insert n1;
               
              
               
               System.assertEquals('Test Title 352',n.Title);
              
               // Instantiate the standard controller with the Job
               ApexPages.StandardController con=new ApexPages.StandardController(testI);
                   
               ApexPages.currentPage().getParameters().put('Id', testI.Id);
               
               // Instantiate the extention instance with the standard controller 
               
               BillboardNote_AttachmentController ext= new BillboardNote_AttachmentController(con);
                
               // Invoke the primary method on the extension
               
               ApexPages.Pagereference pr=ext.CreateNote();
               pr=ext.AttachFile();
           
               ApexPages.Pagereference pg1=ext.editNote();
               ApexPages.Pagereference pg2=ext.editAttachment();
               ApexPages.Pagereference pg3=ext.deleteNote();
               ApexPages.Pagereference pg4=ext.deleteAttachment();
               ApexPages.Pagereference pg5=ext.deleteFeedAttachment();
               
               System.currentPagereference().getParameters().put('id',n1.id);  
              DeleteBillboardNoteExtension ext1=new DeleteBillboardNoteExtension(new ApexPages.StandardController(n1));
              Apexpages.pagereference pp= ext1.checkDelete();
               pp=ext1.checkDelete();
               
               
               
               }
        }
    static testMethod void TestDeleteCampaignNoteExtension(){
        
        Profile p=[Select Id from Profile where Name='System Administrator' limit 1];
            
           User u=[Select Id from User where IsActive=: True and profileId=: p.Id Limit 1];
            
            System.runAs(u)
           {
         Campaign__c  testC=new Campaign__c(name='test 123');
          insert testC;    
           Note n2=new Note(parentId=testC.Id,Title='Test Title 352',IsPrivate=True,Body='Test Note Body');
           insert n2; 
        
              System.currentPagereference().getParameters().put('id',n2.id);  
             DeleteCampaignNoteExtension ext11=new DeleteCampaignNoteExtension(new ApexPages.StandardController(n2));
              
              Apexpages.pagereference pp1= ext11.checkDelete();
               pp1=ext11.checkDelete(); 
           }
        
    } 
      static testMethod void TestDeleteCampaignAttachmentExtension(){
        
        Profile p=[Select Id from Profile where Name='System Administrator' limit 1];
            
           User u=[Select Id from User where IsActive=: True and profileId=: p.Id Limit 1];
            
            System.runAs(u)
           {
         Campaign__c  testC=new Campaign__c(name='test 123');
          insert testC;
               
          Blob b = Blob.valueOf('Test Data');
    	
    	Attachment attachment = new Attachment();
    	attachment.ParentId = testC.id;
    	attachment.Name = 'Test Attachment for Parent';
    	attachment.Body = b;
               insert attachment;
        
              System.currentPagereference().getParameters().put('id',attachment.id);  
             DeleteCampaignAttachmentExtension ext11=new DeleteCampaignAttachmentExtension(new ApexPages.StandardController(attachment));
              Apexpages.pagereference pp1= ext11.checkDelete();
               pp1=ext11.checkDelete();
           }
          
    }
    
    
    // End Test Coverage */
}