@IsTest
Public Class TestAmcTvReportExt_Test{
   static testMethod void TestAmcTvReportExt_Test()
   {
      Media_Type__c objMedia = new Media_Type__c (Name = 'Test Media type-00001');
      insert objMedia;
      
      Schedule_Template__c objSchedule = new Schedule_Template__c(Name = 'Test Schedule Template-00001', Media_Types__c = objMedia.id);
      insert objSchedule;
       
      Schedule_Task__c objScheduletask = new Schedule_Task__c(Name = 'Test Schedule Template Task', Schedule_Template__c = objSchedule.id);
      insert objScheduletask;
       
      list<Schedule_Task__c> jt= new list<Schedule_Task__c>();
      jt.add(objScheduletask);
      
      Campaign__c objCampaign = new Campaign__c(Name = 'Test Campaign -00001',Dummy_Date_1__c=system.today(),Status__c='Active');
      insert objCampaign;
      
      GL_Department__c objGLDept = new GL_Department__c(Name = 'Test GL dept - 00001');
      insert objGLDept;
      
      GL_Code__c objGLCode = new GL_Code__c(Name = 'Test GL Code - 00001', GL_Department__c  = objGLDept.id, GL_ID__c = '00001');
      insert objGLCode ;
      
            
      Client__c objClient=new Client__c(Name='Test Client 0001');
      insert objClient;
               
     
      Job__c objJob1 = new Job__c(Name= 'Test Job - 00001', Media_Types__c= objMedia.Id, Schedule_Template__c = objSchedule.id, Campaign__c  = objCampaign.Id,JS_Client__c = objClient.id,Start_Date__c = System.Today(),Completion_Date__c=System.Today(),Due_Date__c=System.Today(),Job_Auto_Number__c = '00001',Dummy_Picklist_1__c = 'AD SALES', Status__c = 'Active');
      insert objJob1 ;
               
      System.assertEquals('Test Job - 00001',objJob1.Name);   
      
      Job_Task__c objTask1 = new  Job_Task__c(Name = 'Test Task1',GL_Code__c = objGLCode.id, Days__c = 2,Job__c = objJob1.id,Revised_Due_Date__c=system.today());
      insert objTask1;
      
      Job_Task__c objTask2 = new  Job_Task__c(Name = 'Test Task2', GL_Code__c = objGLCode.id, Days__c = 4,Job__c = objJob1.id,Revised_Due_Date__c=system.today());
      insert objTask2; 
     
      tag__C objTag1 = new  tag__C(Name = 'Test Tag1',Job__c = objJob1.id);
      insert objTag1; 
      
      tag__C objTag2 = new  tag__C(Name = 'Test Tag2',Job__c = objJob1.id);
      insert objTag2;      
      
      
      TestAmcTvReportExt ext = new TestAmcTvReportExt();
      List<String> strCampaignName = ext.strJobname;
      List<String> strJobname = ext.strJobname;
      
      
      Schema.DescribeFieldResult field = Job__c.Dummy_Picklist_1__c.getDescribe();
                
    
         ext.search();
         ext.printpdf();
         ext.getcampaigns();
         ext.getjobs();
    
       ApexPages.Pagereference result2 =ext.clear();
      
   }    
}