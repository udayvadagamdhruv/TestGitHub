//@isTest
Public class Test_JobRequestFormdetailpageMobile{
/*
 
    // Test Coverage 
         static testMethod void Test_JobRequestFormdetailpageMobile()
        {
             Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
              
                 insert customSetting001; 
             
              Graphics_Setting__c customGraphics= new Graphics_Setting__c(Name = 'YES');
              
                  insert customGraphics;
                  
              Session_Setting__c customSession= new Session_Setting__c(Name = 'YES');
                  
                  insert customSession;
                  
               Tag_Setting__c customTag = new Tag_Setting__c(Name = 'YES');
                   
                   insert customTag;  
                   
                Job_Detail_Tab_Controls__c tc = new Job_Detail_Tab_Controls__c(Disable_Job_Cost_Tab__c=true,Disable_Job_Billing_Tab__c=true,Disable_Quip__c=true,Enable_WorkDocs__c=true,Disable_Chatter__c=true);
                 insert tc;  
                   
               Music_Usage_Setting__c  customMusic = new Music_Usage_Setting__c(Name = 'YES');  
                   
                    insert customMUsic;   
                  
               Media_Type__c testMedia=new Media_Type__c(Name='Test Media 301');
             
                     insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 301',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
              Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 302',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 301');
                insert testSpec;
                
                Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 302');
                insert testSpec1;
           
               Job__c testJob1=new Job__c(Name='Test Job 301',Flag__c=True,Job_Auto_Number__c='Job12347',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
             
                   insert testJob1;
            ApexPages.StandardController con1=new ApexPages.StandardController(testJob1);
            JobRequestFormdetailpageext  ext1=new JobRequestFormdetailpageext(con1);  
                   Job_Task__c jtask = new Job_Task__c(Name='Task1', Job__c=testJob1.Id, Marked_Done__c=true);
                   insert jtask;
                   ext1.strJTID = jtask.id;
               
               
               System.assertEquals('Test Job 301',testJob1.Name);
               
              
              
              
              ext1.editmethod();
              ext1.deleteMethod();
              ext1.TSEntryMethod();
              ext1.DupMethod();
              ext1.assignMarkedDone1();
             // ext1.editJobTask();
              
         }*/
         
}