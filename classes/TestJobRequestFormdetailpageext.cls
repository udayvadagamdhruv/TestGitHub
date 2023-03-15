//@isTest
public class TestJobRequestFormdetailpageext {
   /* static testMethod void TestJobRequestFormdetailpageext(){
       
          Job_Detail_Tab_Controls__c tc = new Job_Detail_Tab_Controls__c(Disable_Job_Cost_Tab__c=true,Disable_Job_Billing_Tab__c=true,Disable_Quip__c=true,Enable_WorkDocs__c=true,Disable_Chatter__c=true);
                 insert tc;  
       
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 301');
        insert testMedia;
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 301',Media_Types__c=testMedia.Id);
        insert testST;
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 301');
        insert testSpec;
        Job__c testJob1=new Job__c(Name='Test Job 301',Flag__c=True,Job_Auto_Number__c='Job12347',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        insert testJob1;
        
        System.assertEquals('Test Job 301',testJob1.Name);
        ApexPages.StandardController con1=new ApexPages.StandardController(testJob1);
        JobRequestFormdetailpageext ext1=new JobRequestFormdetailpageext(con1);
        
        Job_Task__c jtask = new Job_Task__c(Name='Task1', Job__c=testJob1.Id, Marked_Done__c=true);
        insert jtask;
        ext1.strJTID = jtask.id;
        
        
        System.assertEquals('Test Job 301',testJob1.Name);
        
        
        ext1.editmethod();
        ext1.deleteMethod();
        ext1.TSEntryMethod();
        ext1.DupMethod();
        ext1.assignMarkedDone1();
        ext1.editLight();
        ext1.deleteLight();
        ext1.editJobTask();
        ext1.AddStaffs();
        ext1.getjobspecs();
        ext1.getjobTasks();
    }*/
}