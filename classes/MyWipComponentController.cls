public with sharing class MyWipComponentController {
    
    
    @AuraEnabled
    public static List<Object> getFiltersForCalenders(){
        list<Object> filterList=new  list<Object>();
        List<SObject> campList=[SELECT Id, name FROM Campaign__c where Status__c='Active' WITH SECURITY_ENFORCED order by Name limit 10000];
        List<SObject> JobList=[SELECT Id, Name FROM Job__c where Status__c='Active' WITH SECURITY_ENFORCED order by Name limit 10000];
        List<SObject> sTempList=[SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True WITH SECURITY_ENFORCED order by Name limit 10000];
        List<String> staffList=new List<String>();
        for (Staff__c st : [SELECT Id, Name FROM Staff__c where Active__c=:true WITH SECURITY_ENFORCED limit 10000]) 
        {  
            staffList.add(st.Name);  //Role__c 
        }
        
        for (Vendor_Contact__c vc : [SELECT Id, Name FROM Vendor_Contact__c where Active__c=:true WITH SECURITY_ENFORCED]) 
        {  
            staffList.add(vc.Name); //Role__c    
        }
        
        for (Client_Contact__c cc : [SELECT Id, Name FROM Client_Contact__c where Active__c=:true WITH SECURITY_ENFORCED]) 
        {  
            staffList.add(cc.Name);  //Client_Contact_Role__c    
        }
        staffList.sort();
        
        List<SObject> rolelist=[SELECT Id,Name From UserRole  Order by Name LIMIT:10000 ];//WITH SECURITY_ENFORCED
        filterList.add(campList);
        filterList.add(sTempList);
        filterList.add(staffList);
        filterList.add(rolelist);
        return filterList;
    }
    
    
    @AuraEnabled
    public static list<calEvent> getMyWIPTasks(string tasksFilter,String campFilter,String sTempFilter,String StaffFilter,String roleFilter){
        List<calEvent> calEvents=new List<calEvent>();
        List<Job_Task__c> jobTasks= new List<Job_Task__c>();
        Map<Integer,String> colormap=new Map<Integer,String>();
        Map<Id,Integer> jobcolorMap=new Map<Id,Integer>();
        String soqlJobTask;
        String regExp = '["\']';
        Integer i=0;
        
        colormap.put(0,'#000000');colormap.put(1,'#006633');colormap.put(2,'#330033');colormap.put(3,'#66CC66');colormap.put(4,'#000066');colormap.put(5,'#6A5ACD');colormap.put(6,'#6B8E23');colormap.put(7,'#708090');colormap.put(8,'#800000');colormap.put(9,'#800080');
        colormap.put(10,'#00CC00');colormap.put(11,'#CCCCCC');colormap.put(12,'#FF0099');colormap.put(13,'#FF66CC');colormap.put(14,'#DA70D6');colormap.put(15,'#006400');colormap.put(16,'#FF8C00');colormap.put(17,'#4B0082');colormap.put(18,'#808000');colormap.put(19,'#D8BFD8');
        colormap.put(20,'#33CC00');colormap.put(21,'#6666FF');colormap.put(22,'#2E8B57');colormap.put(23,'#996633');colormap.put(24,'#3399FF');colormap.put(25,'#336633');colormap.put(26,'#6666CC');colormap.put(27,'#CC0066');colormap.put(28,'#336699');colormap.put(29,'#330066');
        colormap.put(30,'#00CC99');colormap.put(31,'#3366CC');colormap.put(32,'#CC6633');colormap.put(33,'#3366FF');colormap.put(34,'#660066');colormap.put(35,'#99CC66');colormap.put(36,'#00CCCC');colormap.put(37,'#99CCCC');colormap.put(38,'#66CC33');colormap.put(39,'#CC66CC');
        colormap.put(40,'#006699');colormap.put(41,'#990033');colormap.put(42,'#666699');colormap.put(43,'#990000');colormap.put(44,'#336600');colormap.put(45,'#66CCCC');colormap.put(46,'#660033');colormap.put(47,'#9900FF');colormap.put(48,'#666666');colormap.put(49,'#FF00FF');
        colormap.put(50,'#330000');colormap.put(51,'#66CCFF');colormap.put(52,'#9900CC');colormap.put(53,'#33CCFF');colormap.put(54,'#990099');colormap.put(55,'#0066CC');colormap.put(56,'#33CC66');colormap.put(57,'#66CC00');colormap.put(58,'#00CC33');colormap.put(59,'#99CCFF');
        colormap.put(60,'#666600');colormap.put(61,'#CC0099');colormap.put(62,'#99CC99');colormap.put(63,'#6600FF');colormap.put(64,'#CCCC66');colormap.put(65,'#FF6699');colormap.put(66,'#CCCC99');colormap.put(67,'#FF6666');colormap.put(68,'#9966CC');colormap.put(69,'#CC66FF');
        colormap.put(70,'#990066');colormap.put(71,'#99CC33');colormap.put(72,'#FF6600');colormap.put(73,'#CC6699');colormap.put(74,'#FF66FF');colormap.put(75,'#3300FF');colormap.put(76,'#CCCCFF');colormap.put(77,'#006666');colormap.put(78,'#CC00CC');colormap.put(79,'#996666');
        colormap.put(80,'#99CC00');colormap.put(81,'#FFCC99');colormap.put(82,'#33CC33');colormap.put(83,'#FF00CC');colormap.put(84,'#33CC99');colormap.put(85,'#FF0066');colormap.put(86,'#660099');colormap.put(87,'#0000CC');colormap.put(88,'#CC00CC');colormap.put(89,'#006600');
        colormap.put(90,'#FF0000');colormap.put(91,'#3300CC');colormap.put(92,'#996699');colormap.put(93,'#FFCC00');colormap.put(94,'#00CCFF');colormap.put(95,'#66CC99');colormap.put(96,'#00CC66');colormap.put(97,'#9966FF');colormap.put(98,'#330099');colormap.put(99,'#FFCCFF');
        
        User u=[SELECT Id,Name From User Where Id=:Userinfo.getUserId() ];//WITH SECURITY_ENFORCED
        List<String> listStaff=new list<String>();
        if(roleFilter!=null){
            List<AggregateResult> aa=[SELECT Name,User__c FROM Job_Task_Role__c where Name=:roleFilter WITH SECURITY_ENFORCED Group By User__c,Name ];
            for(AggregateResult a:aa){
                listStaff.add('%'+a.get('User__c')+'%');
            }
        }
         System.debug('====listStaff=='+listStaff);
        
        String namecheck='%'+u.Name+'%';
        String Active='Active';
        if(tasksFilter == '1'){
            soqlJobTask='Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c=:Active and marked_done__c=false and Assigned_Users__c like :namecheck and Next_Task_Due__c=true';             
        }
        if(tasksFilter == '2'){
            soqlJobTask='Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c=:Active and marked_done__c=false and Assigned_Users__c like :namecheck';
        }
        if(tasksFilter == '3'){
            soqlJobTask='Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.Schedule_Template__r.Name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c=:Active and marked_done__c=false';
            if(StaffFilter!=''){
                String StaffFilterCheck='%'+StaffFilter+'%';
                soqlJobTask+=' and Assigned_Users__c like :StaffFilterCheck';
            }
            else if(roleFilter!=''){
                soqlJobTask+=' and Assigned_Users__c like :listStaff';
            }
        }
        if(campFilter!=''){
            soqlJobTask+=' and Job__r.campaign__r.name=:campFilter';
        }
        if(sTempFilter!=''){
            soqlJobTask+=' and Job__r.Schedule_Template__r.Name=:sTempFilter ';
        }
        soqlJobTask +=' WITH SECURITY_ENFORCED';
        jobTasks=Database.query(soqlJobTask);
        
        for(Job_Task__c tsk:jobTasks){
            calEvent e=new calEvent();
            DateTime startDate=tsk.Start_Date__c+1;
            DateTime endDate=tsk.Revised_Due_Date__c+2;
            String TaskName=tsk.Name;
            String TaskCampname=tsk.Job__r.campaign__r.name;
            String TaskJobname=tsk.Job__r.name;
            String TaskUsersname=tsk.Assigned_Users__c;
            String TaskClientName=tsk.Job__r.JS_Client__r.name;
            if(TaskName!=NULL)TaskName.replaceAll(regExp, '\\ ');
            if(TaskCampname!=NULL)TaskCampname.replaceAll(regExp, '\\ ');
            if(TaskJobname!=NULL)TaskJobname.replaceAll(regExp, '\\ ');
            if(TaskUsersname!=NULL)TaskUsersname.replaceAll(regExp, '\\ ');
            if(TaskClientName!=NULL)TaskClientName.replaceAll(regExp, '\\ ');
            
            e.title = Taskname +', Job - # '+tsk.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
            e.taskStatus =tsk.Status__c;
            e.url='/'+tsk.Job__c;
            e.Staff=TaskUsersname;
            e.color='red';
            e.className=tsk.Id;
            e.startString =startDate.format();
            e.endString =endDate.format();
            e.JN = TaskCampname  +' : '+TaskJobname +'id='+tsk.id;
            e.client=TaskClientName;
            if(jobcolorMap.containsKey(tsk.Job__r.Id)){
                e.color=colormap.get(jobcolorMap.get(tsk.Job__r.Id));
            }
            else{
                jobcolorMap.put(tsk.Job__r.Id,i);
                e.color=colormap.get(i);
            }
            
            calEvents.add(e);
            i=(i==99)?0:i+1;
        }
        return calEvents;
    }
    
    public class calEvent
    {
        @AuraEnabled   public string taskStatus {get;set;}
        @AuraEnabled   public String title {get;set;}
        @AuraEnabled   public String startString {get;set;}
        @AuraEnabled   public String endString {get;set;}
        @AuraEnabled   public String url {get;set;}
        @AuraEnabled   public string color{get;set;}
        @AuraEnabled   public String JN{get;set;} //jobnumber
        @AuraEnabled   public String client{get;set;}
        @AuraEnabled   public String Staff{get;set;} // used for assigning task staff and used for assigning campaign of the job
        @AuraEnabled   public String className {get;set;}
    }
    
    @AuraEnabled 
    public static string taskUpdatebyDragDrop(String taskId,String startDate,String dueDate,String taskFilter){
        System.debug('===tasId====='+taskId);
        System.debug('===startDate====='+startDate);
        System.debug('===dueDate====='+dueDate);
        System.debug('===taskFilter====='+taskFilter);
        try{ 
            Job_Task__c jobTask=[Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c Where Id =:taskId WITH SECURITY_ENFORCED];
               if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){ jobTask.Start_Date__c =Date.valueOf(startDate);}
               if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){ jobTask.Revised_Due_Date__c =Date.valueOf(dueDate)-1;}
               if(Schema.sObjectType.Job_Task__c.isUpdateable()){update jobtask;}
        }
        Catch(Exception e){
            return ''+e.getMessage();
        }
       
       return 'OK';
    }
    
    @AuraEnabled 
    public static string taskUpdatewithResizing(String taskId,String dueDate){
        System.debug('===tasId====='+taskId);
        System.debug('===dueDate====='+dueDate);
        try{ 
            Job_Task__c jobTask=[Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c Where Id =:taskId WITH SECURITY_ENFORCED];
               if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){ jobTask.Revised_Due_Date__c =Date.valueOf(dueDate)-1;}
                 if(Schema.sObjectType.Job_Task__c.isUpdateable()){update jobtask;  }    
        }
        Catch(Exception e){
            return ''+e.getMessage();
        }
       
       return 'OK';
    }
    
    @AuraEnabled 
    public static list<Timesheet_Entries__c> getTaskTimeSheets(String taskId){
        Job_Task__c jbtask = [SELECT Id, Name, Status__c,Job__c FROM Job_Task__c where Id =:taskId WITH SECURITY_ENFORCED];
        return [select id, Name, Date__c, End_Watch__c, GL_Code__c, Hours_Worked__c, Notes__c, Roles__c, Staff__c, Start_Watch__c, User__c,User__r.Name, Task_Name__c, Job__c from Timesheet_Entries__c where Task_Name__c = :jbtask.Name and Job__c =:jbtask.Job__c WITH SECURITY_ENFORCED];
    }
    @AuraEnabled
    public static string deleteTimeSheet(String timeSheetId){
        Timesheet_Entries__c ts=[select id, Name, Date__c From Timesheet_Entries__c Where Id=:timeSheetId WITH SECURITY_ENFORCED];
        try{
             if(Timesheet_Entries__c.sObjectType.getDescribe().isDeletable()){
                 delete ts;}
        }
        Catch(DMLException e){
            return e.getMessage();
        }
        return 'OK';
    }
    
    @AuraEnabled
    public static List<Job_Task__c> getProgressTaskstoMyWIp(String taskId,String taskFilter,String campFilter,String sTempFilter,String StaffFilter,String roleFilter){
        System.debug('===tId====='+taskId);
        Job_Task__c jbtask = [SELECT Id, Name, Status__c FROM Job_Task__c where Id =:taskId WITH SECURITY_ENFORCED];
        System.debug('===jbtask='+jbtask);
          if(schema.SobjectType.Job_Task__c.Fields.Status__c.isUpdateable()){jbtask.Status__c = 'In Progress';}
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){ update jbtask;}
        return MyWipComponentController.getAllProgressTasks(taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
    }
    
    @AuraEnabled
    public static List<Job_Task__c> removeTaskFromMyWIpSection(String taskId,String taskFilter,String campFilter,String sTempFilter,String StaffFilter,String roleFilter){
        System.debug('===tId=for remove===='+taskId);
        Job_Task__c jbtask = [SELECT Id, Name, Status__c FROM Job_Task__c where Id =:taskId WITH SECURITY_ENFORCED];
        System.debug('===jbtask='+jbtask);
         if(schema.SobjectType.Job_Task__c.Fields.Status__c.isUpdateable()){jbtask.Status__c = 'Active';}
        if(Schema.sObjectType.Job_Task__c.isUpdateable()){ update jbtask;}
        return MyWipComponentController.getAllProgressTasks(taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
    }
    
    @AuraEnabled
    public static List<Job_Task__c> makeMarkDoneTask(String taskId,String taskFilter,String campFilter,String sTempFilter,String StaffFilter,String roleFilter){
        System.debug('===task Id for complte===='+taskId);
        Job_Task__c jbtask = [SELECT Id, Name, Status__c FROM Job_Task__c where Id =:taskId WITH SECURITY_ENFORCED];
        System.debug('===complete task='+jbtask);
        if(schema.SobjectType.Job_Task__c.Fields.Status__c.isUpdateable()){ jbtask.Status__c = 'Completed';}
        if(schema.SobjectType.Job_Task__c.Fields.Marked_Done__c.isUpdateable()){jbtask.Marked_Done__c = true;}
        if(schema.SobjectType.Job_Task__c.Fields.Completion_Date__c.isUpdateable()){jbtask.Completion_Date__c=System.today();}
             if(Schema.sObjectType.Job_Task__c.isUpdateable()){update jbtask;}
        return MyWipComponentController.getAllProgressTasks(taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
    }
    
    @AuraEnabled
    public static Job_Task__c fetchUpdatedTaskInformation(String taskId){
        return Database.query('Select Id,Name,(select Id,Name,User__c,Email__c from Job_Task_Roles__r),Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Id=:taskId WITH SECURITY_ENFORCED LIMIT 1');
    } 
    
    
    @AuraEnabled
    public static List<Job_Task__c> getAllProgressTasks(String tasksFilter,String campFilter,String sTempFilter,String StaffFilter,String roleFilter){
        List<Job_Task__c> taskList=new List<Job_Task__c>();
        User u=[SELECT Id,Name From User Where Id=:Userinfo.getUserId() ];//WITH SECURITY_ENFORCED
        String p = 'In Progress';
        string namecheck1 = '%'+u.Name+'%';
        
        List<String> listStaff=new list<String>();
        if(roleFilter!=null){
            List<AggregateResult> aa=[SELECT Name,User__c  FROM Job_Task_Role__c where Name=:roleFilter WITH SECURITY_ENFORCED Group By User__c,Name];
            for(AggregateResult a:aa){
                listStaff.add('%'+a.get('User__c')+'%');
            }
        }
        System.debug('====listStaff=='+listStaff);
        String soqlJobTask;
        if(tasksFilter=='1'){
            soqlJobTask='Select Id,Name,(select Id,Name,User__c,Email__c from Job_Task_Roles__r),Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false and Assigned_Users__c like :namecheck1 and Next_Task_Due__c=true';  
        }
        if(tasksFilter=='2'){
            soqlJobTask='Select Id,Name,(select Id,Name,User__c,Email__c from Job_Task_Roles__r),Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false and Assigned_Users__c like :namecheck1';  
        }
        if(tasksFilter=='3'){
           soqlJobTask='Select Id,Name,(select Id,Name,User__c,Email__c from Job_Task_Roles__r),Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false'; 
            if(StaffFilter!=''){
                String StaffFilterCheck='%'+StaffFilter+'%';
                soqlJobTask+=' and Assigned_Users__c like :StaffFilterCheck';
            }
            else if(roleFilter!=''){
                soqlJobTask+=' and Assigned_Users__c like :listStaff';
            }
        }
        if(campFilter!=''){
            soqlJobTask+=' and Job__r.campaign__r.name=:campFilter';
        }
        
        if(sTempFilter!=''){
            soqlJobTask+=' and Job__r.Schedule_Template__r.Name=:sTempFilter';
        }
        soqlJobTask +=' WITH SECURITY_ENFORCED';
        return Database.query(soqlJobTask);
    }
    
    @AuraEnabled
    public static string updateRestSchedule(String taskId,String DueDate, boolean updateRestScheduleRevDt )
    {
       Set<Date> holidaysNew= new Set<Date>();
         
         for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
         {
             holidaysNew.add(hc.Date__c);
         }
        
        try{
             System.debug('Due Date is : '+DueDate);
             
             Date dt = Date.valueOf(DueDate);
             System.debug('Task Id is : '+taskId);
             System.debug('Value of updateRestScheduleRevDt : '+String.valueOf(updateRestScheduleRevDt));
         
             DateTime NextTaskStartDate;
             
             //code for the update of the current schedule 
             Job_Task__c jobTask1,jobTask2,objJobTask;
             
              
              
                   //taskId = Id.valueOf(taskId);
            jobTask1 = new Job_Task__c();
            jobTask1.Id=taskId;
            if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
                jobTask1.Revised_Due_Date__c = dt;
            }
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                update jobTask1;
            }
                   objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: jobTask1.Id WITH SECURITY_ENFORCED LIMIT 1];
                   String jobId = objJobTask.job__c;
                        Boolean blnFroward = true;
                        if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
                        {
                           blnFroward = false;
                        }  
                    if(!blnFroward )
                    {
                       System.debug('Job Name is : '+ objJobTask.Job__r.Name);
                                                 //code for updating the start date of the current task
                        Integer jCount = 0;
                        //Integer newDaysValue = objJobTask.Days__c;
                     Datetime dtStartDate=DateTime.newInstance(dt.Year(),dt.Month(),dt.Day());
                        System.debug('jCount value '+jCount);
                                    
                         while(true)
                            {
                                Date d3=Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                                if(dtStartDate.format('E')!='Sat' && dtStartDate.format('E')!= 'Sun'&& (!holidaysNew.contains(d3)))
                                {
                                     jCount = jCount + 1;
                                     if(jCount > objJobTask.Days__c)
                                      {
                                          break;
                                      }
                                      dtStartDate = dtStartDate.addDays(-1);
                                           
                                }
                                else
                                  {
                                      dtStartDate = dtStartDate.addDays(-1);                                          
                                      continue;
                                  }
                             }
                           Date afterDaysUpdate = Date.newInstance(dtStartDate .Year(), dtStartDate .Month(), dtStartDate .Day());
                             if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){ objJobTask.Start_Date__c = afterDaysUpdate;} 
                                if(Schema.sObjectType.Job_Task__c.isUpdateable()){update objJobTask;}
                      } 
                    
                  
                   System.debug('Update current Job Task : '+jobTask1);
                   
                   if(String.valueOf(updateRestScheduleRevDt) == 'true')
                   {                        
                    
                         // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current job
                        Date startDateForNextTask ;
                        if(blnFroward)
                         {
                            startDateForNextTask = Date.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.month(),objJobTask.Revised_Due_Date__c.Day());
                         }
                         else
                         {
                            startDateForNextTask = Date.newInstance(objJobTask.Start_Date__c.Year(),objJobTask.Start_Date__c.month(),objJobTask.Start_Date__c.Day());
                         }
                    
                        List<Job_Task__c> lstJobTasks ;//= [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                        
                        if(blnFroward)
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
                         }
                         else
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c DESC];
                         }
                        System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                        
                        System.debug('Size of Update Tasks : '+lstJobTasks.size());
                         
                        for(Integer i = 0; i <lstJobTasks.size(); i++)
                        {
                            System.debug('Value of i' +i);
                          DateTime dtStartDate3;
                                if(i == 0)
                                {
                                    if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                                    if(blnFroward)
                                     {
                                      // dtStartDate3= lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                      
                                           if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                                          dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                       
                                     }
                                     else
                                     {
                                     //  dtStartDate3= lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;
                                       
                                          if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){  lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;}
                                          dtStartDate3= DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                          
                                          
                                     }
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                    if(blnFroward)
                                     {
                                      //  dtStartDate3 = lstJobTasks[i].Start_Date__c = d4;
                                        
                                          if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){ lstJobTasks[i].Start_Date__c = d4;}
                                         
                                         
                                          dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                     }
                                     else
                                     {
                                      
                                      
                                      // dtStartDate3 = lstJobTasks[i].Revised_Due_Date__c = d4; 
                                         if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){ lstJobTasks[i].Revised_Due_Date__c = d4;}
                                         dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                     }
                                    
                                }
                               
                            
                               //  if(blnFroward)
                                //     {
                                //        dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                                //     }
                                //     else
                               //      {
                                //         dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
                                //     }
                               
                                System.debug('Day is:'+dtStartDate3.format('E'));
                            
                                System.debug('Start Date is : ' +dtStartDate3);
                             if(schema.SobjectType.Job_Task__c.Fields.Days__c .isUpdateable()){ 
                                lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;}
                            
                                Integer jCount=0;
                                 
                                 // To calculate Due Date, Revised Due Date
                                 while(true)
                                 {
                                     Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                                     
                                     // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                                      if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                                      {
                                         jCount=jCount+1;
                                         if(jCount>lstJobTasks[i].Days__c)
                                         {
                                             break;
                                         }
                                          system.debug('jCount======' + jCount);
                                          system.debug('==========' + dtStartDate3);
                  
                                          system.debug('===========' + dtStartDate3.format('E'));
                                          
                                          if(blnFroward)
                                             {
                                                 dtStartDate3=dtStartDate3.addDays(1);
                                             }
                                             else
                                             {
                                                  dtStartDate3=dtStartDate3.addDays(-1);
                                             }                                   
                                          system.debug('After adding 1 day : ' +dtStartDate3);
                                        }
                                       else
                                       {
                                          system.debug('==========' + dtStartDate3);                                     
                                          if(blnFroward)
                                             {
                                                  dtStartDate3=dtStartDate3.addDays(1);
                                             }
                                             else
                                             {
                                                  dtStartDate3=dtStartDate3.addDays(-1);
                                             }  
                                          continue;
                                        }
                                    }
                                 system.debug('Calculation============' +dtStartDate3);
                                 
                                 Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                                 system.debug('D1============' +dtStartDate3);
                                 
                                  if(blnFroward)
                                   {
                                      if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
                                      lstJobTasks[i].Revised_Due_Date__c=d1;}
                                       system.debug('Revise due============' +lstJobTasks[i].Revised_Due_Date__c); 
                                   }
                                  else
                                   {
                                       if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){
                                        lstJobTasks[i].Start_Date__c=d1;}
                                   }    
                                 NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                              }
                                 if(Schema.sObjectType.Job_Task__c.isUpdateable()){update lstJobTasks;}
                            System.debug('Updated List : '+lstJobTasks);
                         }
        }
        Catch(Exception e){
            return e.getMessage();
        }
           return 'OK';
    }
    
}