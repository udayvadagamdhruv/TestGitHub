@isTest
Public class TestNotesandFilesExtension 
{
   
    static testMethod void TestNotesandFilesExtension ()
    {
    
       Job_Number_Setting__c customSetting950 = new  Job_Number_Setting__c(Name= 'yy');
       insert customSetting950;
            
       Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1005');
             
                insert testMedia;
             
       Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1005',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
       Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schedule 1005',Schedule_Template__c=testST.id,Days__c=2);
              insert testSchedule;       
                 
       Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1005');
                insert testSpec;
                
       Campaign__c testCamp=new Campaign__c(Name='Test Camp 1005');    
              insert testCamp;  
   
           Account testClient=new Account(Name='Test Account 1005');
               insert testClient;
               
           Contact testContact=new Contact(FirstName='Test Client',LastName='RUS',AccountId=testClient.id,Email='test1005@SFDC.com');
               insert testContact;    
                      
          Job__c testJob1=new Job__c(Name='Test Job 1005',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,Client__c=testClient.id,Client_Contact__c=testContact.id);
               insert testJob1;
               
          System.assertEquals('Test Job 1005',testJob1.Name);
          
           
          Note n=new Note(parentId=testJob1.Id,Title='Test Title 352.jpg',IsPrivate=True,Body='Test Note Body');
              insert n;
               
         System.assertEquals('Test Title 352.jpg',n.Title);
          
        Attachment A = new Attachment(name='test.jpg',parentId=testJob1.Id,Body=Blob.valueOf('Test Note Body'));
           insert a;
        
               
          ApexPages.currentPage().getParameters().put('id',testJob1.id);
          ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
          
         
          
          
          NotesandFilesExtension  ext=new NotesandFilesExtension (con);
    }
    // Start Test Coverage
        static testMethod void Test_POReportExtension()
        {
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1418');
          try
           {
               insert testMedia;
           }
          catch(System.DMLException e)
           {
               System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
           }
           
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1418',Media_Types__c=testMedia.Id);
          insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1418');
           insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 1418',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
             insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             } 
            System.assertEquals('Test Job 1418',testJob1.Name);    
                
           Vendor__c testVendor=new Vendor__c(Name='Test Vendor 1418');
           insert testVendor;
          
           Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Vendor__c=testVendor.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No');
           insert testPO;
          
           ApexPages.currentPage().getParameters().put('id',testJob1.Id);
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
           POReportExtension ext=new POReportExtension(con);
           
           ext.theId=testJob1.id;
           Double s=ext.getSumCash();
        }// End of Test Coverage
}