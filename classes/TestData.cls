public class TestData 
{
       public list<Job_Number_Setting__c> jobNumSettings = new list<Job_Number_Setting__c>();
       public list<Client__c> clients= new list<Client__c>();
       public list<Vendor__c> vendors= new list<Vendor__c>();
       public list<Media_Type__c> mediaTypes= new list<Media_Type__c>();
       public list<Schedule_Template__c> scheduleTemplates= new list<Schedule_Template__c>();
       public list<GL_Code__c> glCodes= new list<GL_Code__c>();
       public list<Schedule_Task__c> scheduleTasks= new list<Schedule_Task__c>();
    
       /****************************************  JobNumSettings   ******************************************/  
    
        public void generateJobNumSettings()
        {
            if(jobNumSettings.isempty())
            {
                Job_Number_Setting__c customSetting997 = new  Job_Number_Setting__c(Name= 'yy');		 
                jobNumSettings.add(customSetting997);
                insert jobNumSettings;
            }
        }
    
       /******************************************  Clients   ***********************************************/  
    
        public void generateClients()
        {
            if(clients.isempty())
            {
                Client__c c=new Client__c(name='test client');
                clients.add(c);
                insert clients;
            }
        }
    
        /******************************************  Vendors   ***********************************************/
    
        public void generateVendors()
        {
            if(vendors.isempty())
            {
                Vendor__c v=new Vendor__c(name='test Vendor');
                vendors.add(v);
                insert vendors;
            }
        }
    
        /******************************************  Media Types   ***********************************************/
    
        public void generateMediaTypes()
        {
            if(mediaTypes.isempty())
            {
                Media_Type__c testMedia=new Media_Type__c(Name='Test Media 358');
                mediaTypes.add(testMedia);
                insert mediaTypes;
            }
        }
    
        /******************************************  Schedule Templates   ***********************************************/
    
        public void generateScheduleTemplates()
        {
            if(mediaTypes.isempty())
            {
                generateMediaTypes();
            }
            if(scheduleTemplates.isempty())
            {
                Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 358',Media_Types__c=mediaTypes.get(0).Id);
                scheduleTemplates.add(testST);
                insert scheduleTemplates;
            }
        }
    
       /******************************************  Gl Codes   ***********************************************/
    
        public void generateGlCodes()
        {
            if(glCodes.isempty())
            {
                GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL009');
                glCodes.add(testGL);
                insert glCodes;
            }
        }
    
      /******************************************  ScheduleTasks   ***********************************************/
    
        public void generateScheduleTasks()
        {
            if(glCodes.isempty())
            {
                generateGlCodes();
            }
            if(scheduleTemplates.isempty())
            {
                generateScheduleTemplates();
            }
            if(scheduleTasks.isempty())
            {
                Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 358',Schedule_Template__c=scheduleTemplates.get(0).id,Days__c=5,GL_Code__c=glCodes.get(0).Id);
            	Schedule_Task__c testSCT2=new Schedule_Task__c(Name='Test Schedule Task 359',Schedule_Template__c=scheduleTemplates.get(0).id,Days__c=3,GL_Code__c=glCodes.get(0).Id);
                scheduleTasks.add(testSCT1);
                scheduleTasks.add(testSCT2);
                insert scheduleTasks;
            }
        }

}