@isTest
public class Test_Job_Search_Controller {
    
    @testSetup public static void SetupData(){
        
        Client__c c=new Client__c(name='Manikanta Kurella');
        insert c;
        
        Vendor__c v=new Vendor__c(name='test Vendor');
        insert v;
        
        GL_Department__c testGLD = new GL_Department__c(Name='GLD1232');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='GLC1232',GL_ID__c='GLC1232',GL_Department__c = testGLD.id,Unit_Cost__c=200);
        insert testGL;
        
        Campaign__c testCampaign1=new Campaign__c(Name='C1232',Active__c=True,Status__c='Active',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
        insert testCampaign1;
        
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 614');
        insert testMedia;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 614',Media_Types__c=testMedia.Id);
        insert testST;
        
        Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 914',Schedule_Template__c=testST.id,Days__c=3);
        insert testSchedule1;
        
        Schedule_Task__c testSchedule2=new Schedule_Task__C(Name='Test Schedule Task 915',Schedule_Template__c=testST.id,Days__c=3);
        insert testSchedule2;
        
        ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Designer',Schedule_Task__c=testSchedule1.id);
        insert testSTR1;
        
        Job__c testJob1=new Job__c(Name='Test Job 614',Campaign__c=testCampaign1.Id,Start_Date__c=System.Today(),Status__c='Active',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,JS_Client__c=c.id,Schedule_Calc__c='Start Date');
        insert testJob1;
        
        Job__c testJob2=new Job__c(Name='Test Job 6142',Campaign__c=testCampaign1.Id,Start_Date__c=System.Today(),Status__c='Active',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,JS_Client__c=c.id,Schedule_Calc__c='Start Date');
        insert testJob2;
        
        list<Job_Task__c> Jobtasklist=new list<Job_Task__c>();
        
        Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 616',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 2,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        Jobtasklist.add(testJobTask2);
        
        Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        Jobtasklist.add(testJobTask3);
        
        
        list<Job_Task__c> Jobtasklist2=new list<Job_Task__c>();
        
        Job_Task__c testJobTask22=new Job_Task__c(Name='Job Task 6162',Job__c=testJob2.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 2,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        Jobtasklist2.add(testJobTask22);
        
        Job_Task__c testJobTask23=new Job_Task__c(Name='Job Task 6172',Job__c=testJob2.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        Jobtasklist2.add(testJobTask23);
        
        
        insert Jobtasklist2;    
        
        Quote__c Quote=new Quote__c(Name='Quote 606',Job__c=testJob1.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
        insert Quote;
        
        Quote__c Quote11=new Quote__c(Name='Quote 6062',Job__c=testJob2.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
        insert Quote11;
        
        
        Production_Estimate__c pesttag111 = new Production_Estimate__c (Name='pe1 test111',Job__c= testJob1.id,Quote__c=Quote.Id);
        insert pesttag111 ;
        
        Production_Estimate__c pesttag222 = new Production_Estimate__c (Name ='pe2 test222',Job__c= testJob2.id,Quote__c=Quote11.Id) ;
        insert pesttag222 ;
        
    } 
    
    @isTest static void Job_Serach_Method1(){
        List<Job__c> selJobs=[select Id,Name,Media_Types__c,Campaign__c,Schedule_Template__c from Job__c];
        List<string> strCampaignName=new list<string> {'C1232','C1234'};
        List<string> strmediatype=new list<string> {'Test Media 614','Test Media 614'};
        List<string> strscheduletemp=new list<string> {'Test Schedule Template 614','Test Schedule Template 614'};
        List<string> strClientName=new list<string> {'Manikanta Kurella','Manikanta Kurella'};      
        Job_Search_Controller.getCustomSettingdata();
        Job_Search_Controller.getJobs(0);
        Job_Search_Controller.getTotalNoOfActiveJobs();
        Job_Search_Controller.getTotalNoOfJobs();
        Job_Search_Controller.showProductionEstimate();
        Job_Search_Controller.getStatusList();
        Job_Search_Controller.getStatusList();
        Job_Search_Controller.getFiltersData();
        Job_Search_Controller.getJobsForMassUpdate(0);
        Job_Search_Controller.runSearch('Test','Manikanta','C1232','Test','Test',String.valueof(System.today()),String.valueof(System.today()+12),String.valueof(System.today()),String.valueof(System.today()+12),String.valueof(System.today()),String.valueof(System.today()+12));
        Job_Search_Controller.FilterChangesJobs(strCampaignName,strmediatype,strscheduletemp,strClientName);
        Job_Search_Controller.MarkDoneCompleteJobs(selJobs ,true,true);
    }
    
    @isTest static void customLookupController(){
        Media_Type__c testMedia=[select Id,Name From Media_Type__c Where Name='Test Media 614'];
        customLookUpController.getcustomLookUpObjectLables('Client__c','Client_Contact__c');
        customLookUpController.fetchLookUpValues('Test', 'Media_Type__c', '','Order by Name');
        customLookUpController.getDependetRecords('Test',testMedia.Id,'Schedule_Template__c', 'Media_Types__c', 'Active__c=True', 'Order by Name');
    }
}