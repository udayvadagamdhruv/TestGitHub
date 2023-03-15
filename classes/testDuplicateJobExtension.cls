//@isTest
Public class testDuplicateJobExtension{
// Start Test Coverage
   /*   static testMethod void testDuplicateJobExtension()
      {
         
          Job_Number_Setting__c customSetting990 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting990;
            
            ProductionEstimate__c jscntrls= new  ProductionEstimate__c(Active__c= True);

            insert jscntrls;
            
          // Insert required data to test DuplicateJobExtension class
          Media_Type__c testMedia=new Media_Type__c(Name='TM1232');
              insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST1232',Media_Types__c=testMedia.Id);
              insert testST;
   
          Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST1232',Schedule_Template__c=testST.Id,Days__c=2);
              insert testSCT1;
                 
          Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST1233',Schedule_Template__c=testST.Id,Days__c=1);
              insert testSCT2;
                 
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Role1',Schedule_Task__c=testSCT1.Id);
              insert testSTR1;
                 
          ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='Role2',Schedule_Task__c=testSCT2.Id);
              insert testSTR2;            
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT1232');
             insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='SI1232',Specification_Template__c=testSpec.Id); 
             insert testSPI;
         
          Campaign__c testCampaign1=new Campaign__c(Name='C1232',Active__c=True,Status__c='Active',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
             insert testCampaign1;
         
          Account a=new Account(Name='Account001');
             insert a;
             
          Client__c cl = new Client__c(Name = 'Account001');
              insert cl;   
         
          Contact c=new Contact(FirstName='Contact 001',LastName='LN001',AccountId=a.id,Email='testEmail001@sfdc.com',Salesforce_User__c=True);
             insert c;
                
          Job__c testJob1=new Job__c(Name='Job1232',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,Client__c=a.id,Client_Contact__c=c.id, JS_Client__c = cl.Id);
             insert testJob1;
            
          System.assertEquals('Job1232',testJob1.Name);
          
          Job_Team__c JT11 = new Job_Team__c(Role__c = 'Test Role', Staff__c = 'Test Staff', Job__c = testJob1.Id);
              insert JT11; 
              
          Job_Team__c JT12 = new Job_Team__c(Role__c = 'Test Role', Staff__c = 'Test Staff', Job__c = testJob1.Id);
              insert JT12; 
          
          Job_Team__c JT22 = new Job_Team__c(Role__c = 'Test Role', Staff__c = 'Test Staff', Job__c = testJob1.Id);
              insert JT22;
                    
             
          GL_Department__c testGLD = new GL_Department__c(Name='GLD1232');
                insert testGLD;
           
          GL_Code__c testGL=new GL_Code__c(Name='GLC1232',GL_ID__c='GLC1232',GL_Department__c = testGLD.id);
                 insert testGL;
          
          Job_Task__c testJT1=new Job_Task__c(Name='Test JT 12321',Days__c=2,GL_Code__c=testGL.id,Job__c=testJob1.id);
                insert testJT1;
                
          Job_Task__c testJT2=new Job_Task__c(Name='Test JT 12322',Days__c=2,GL_Code__c=testGL.id,Job__c=testJob1.id);
                insert testJT2;
                
             
          Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test Role 1232',User__c='test staff 1232',Job_Task__c=testJT1.id); 
                insert testJTR1;
                
         
          
          Tag__c testtag1 = new Tag__c(Name='Tag1 ',Job__c = testJob1.id);
          insert testtag1;
          
          Tag__c testtag2 = new Tag__c(Name = 'Tag2 ',Job__c = testJob1.id) ;
          insert testtag2;
          
          Production_Estimate__c pesttag1 = new Production_Estimate__c (Name='pe1 test',Job__c= testJob1.id);
          insert pesttag1 ;
          
          Production_Estimate__c pesttag2 = new Production_Estimate__c (Name ='pe2 test',Job__c= testJob1.id) ;
          insert pesttag2 ;
          
          ApexPages.CurrentPage().getParameters().put('id',testJob1.id);
          ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
           
          // Instantiate the extention instance with the standardcontroller   
          DuplicateJobExtension ext=new DuplicateJobExtension(con);
         
         // Invoke methods on the extension
          ApexPages.Pagereference result1=ext.cancel();
          result1=ext.navigateToOldJob();  
          result1=ext.duplicateJob(); 
          
          // Delete Job Tasks
         List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob1.Id];
         delete lstTask;
         
         // Delete Job Specs
         
         List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob1.Id];
         delete lstSpecs;
         
         Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Job1232'];
         obj1.Status__c='Cancelled';
         //update obj1;
         
         // To cover catch block
         Job__c obj2=[Select id from Job__c where Name=: 'Job1232'];
         delete obj2;
         Id iDel = obj2.Id;
         
         //Job_Team__c JT2 = new Job_Team__c(Role__c = 'Test Role', Staff__c = 'Test Staff', Job__c = iDel);
             // insert JT2;
         test.startTest();
         result1=ext.duplicateJob();
           test*.stopTest();
      }*/
      // End of Test Coverage
}