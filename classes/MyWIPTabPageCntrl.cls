global with sharing class MyWIPTabPageCntrl {
 /*  public string tskid{get;set;}
   transient public list<String> mts = new list<String>();
   transient public list<calEvent> events {get;set;}
   transient Public string strJobName{get;set;}
   transient public string strCampaignName{get;set;}
   transient public string strClientName{get;set;}
   transient public List<string> strstaff{get;set;}
   transient public List<string> strrole{get;set;}
   transient Public string JobStatusString {get;set;}
   transient Public list<Job_Task__c> jobTask{get;set;}
   transient Public list<Job_Task__c> progressTask{get;set;}
   transient Public string  soqlJobTask{get;set;}
   transient Public map<integer,string> colormap{get;set;}
   transient public boolean Task{get;set;}
   public String strGetUserName,strName;
   public map<id,integer> jobcolormap{get;set;}
   Public String regExp = '["\']';
   public string prsTaskId{get;set;}
   public List<Job_Task_Role__c> lstTR{get;set;}
   public List<Job_Team__c> jTeam{get;set;}
   public List<Timesheet_Entries__c> timeSheets{get;set;}
   public boolean newTimeSheetEntryBool{get;set;}
   public Timesheet_Entries__c tse{get;set;}
   public string filter{get;set;}
   public string selectedTask{get;set;}
   public string selectedTab{get;set;}
   public List<SelectOption> filters{get;set;}
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE- yyyy d MMM HH:mm:ss z';
    
    public date startDayOfWeek {get;set;}
    public date endDayOfWeek {get;set;}
    public date weekStart {get;set;}
    // moment().format();
    public Set<Date> holidaysNew;
    public string ptjId{get;set;}
    //constructor
    public MyWIPTabPageCntrl() 
    {
        calEvent Jjjj = new calEvent();
        tse = new Timesheet_Entries__c();
        holidaysNew= new Set<Date>();
         
         for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
         {
             holidaysNew.add(hc.Date__c);
         }
    
        Date myDate = Date.today();
        weekStart = myDate.toStartofWeek();
    
        startDayOfWeek = weekStart.addDays(0);
        endDayOfWeek = weekStart.addDays(6);
        
        filter = apexpages.currentpage().getparameters().get('filter');
        if(filter == null){
            filter = '1';
        }
        
        
        filters = new List<SelectOption>();
        filters.add(new selectOption('1', 'My Tasks - Ready'));
        filters.add(new selectOption('2', 'All My Tasks'));
        
        
        
        newTimeSheetEntryBool=false;
        lstTR = new List<Job_Task_Role__c>();
        jTeam= new List<Job_Team__c>();
        timeSheets = new List<Timesheet_Entries__c>();
        strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName];
        strName=u.Name;
    
         colormap=new map<integer,string>();
         jobcolormap = new map<id,integer>();
        strstaff = new List<string>();
        strrole= new List<string>();
        
        progressTask = new list<Job_Task__c>();
        String p = 'In Progress';
        string namecheck1 = '%'+strName+'%';
        progressTask = Database.query('Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false and Assigned_Users__c like :namecheck1 ');
       
        
        jobtask();
        
        selectedTask = apexpages.currentpage().getparameters().get('selectedTask');
        if(selectedTask != null){
            prsTaskId = selectedTask;
            Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:prsTaskId WITH SECURITY_ENFORCED];
            ptjId = jtsk.job__c;
            lstTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: prsTaskId WITH SECURITY_ENFORCED order by CreatedDate];
            timeSheets = [select id, name, Date__c, End_Watch__c, GL_Code__c, Hours_Worked__c, Notes__c, Roles__c, Staff__c, Start_Watch__c, User__c, Task_Name__c, Job__c from Timesheet_Entries__c where Task_Name__c = :jtsk.name and Job__c =:jtsk.Job__c WITH SECURITY_ENFORCED];
            set<String> teamNames = new set<String>();
            for(Job_Task_Role__c tr:lstTR){
                teamNames.add(tr.User__c);
            }
            jTeam = [select id, name, Role__c, Staff__c, Job__c from Job_Team__c where Job__c =: jtsk.job__c and Staff__c Not in :teamNames WITH SECURITY_ENFORCED];
        }
        
        selectedTab = apexpages.currentpage().getparameters().get('selectedTab');
        if(selectedTab == null){
            selectedTab = 'tab-scoped-1__item';
        }
        
    }
    
    Public void updateJSCampaign1() 
    {
       String name = Apexpages.currentPage().getParameters().get('namess');
       String cntid = Apexpages.currentPage().getParameters().get('cntidss');
       String endate = Apexpages.currentPage().getParameters().get('endatess');
       String stdate = Apexpages.currentPage().getParameters().get('stdate');
       string jn = Apexpages.currentPage().getParameters().get('jnss');
       
       list<Campaign__c> campList = new list<Campaign__c>();
       list<job__c> jobList = new  list<job__c>();
       //String id1 = cntid.Substring(cntid.length()-18,cntid.length());
       String id1 = cntid;
       Campaign__c cam = new Campaign__c();
       integer eyear = integer.valueof(endate.substring(0,4));
       integer emonth = integer.valueof(endate.substring(5,7));
       integer eday = integer.valueof(endate.substring(8,10));
      
       integer syear = integer.valueof(stdate.substring(0,4));
       integer smonth = integer.valueof(stdate.substring(5,7));
       integer sday = integer.valueof(stdate.substring(8,10));
     //  Date ed = Date.newInstance(eyear,emonth,eday-1);
      // Date sd = Date.newInstance(syear,smonth,sday-1);
       
      //if(name.Substring(name.length()-8,name.length()) == 'campaign' )
      
      System.debug('::::::::::::::Hello before IF::::::::::::::::::::'+name.substring(0, 11));
      
     // name.substring(0, 11) != 'JS Campaign'
     // name.Substring(0,3) != 'Job'
      
            System.debug(':::::::::::::Entered:::::::::::::::'+name.substring(0, 11));
            Date sd = Date.newInstance(syear,smonth,sday);
            Date ed = Date.newInstance(eyear,emonth,eday-1);
            String taskID = jn.Substring(jn.indexof('id=')+3,jn.indexof('id=')+3+18);
            system.debug('<<<<<<<<<Task ID is>>>>>>>>>>>>>>>>>>>'+taskID);
            Job_Task__c jobTask= new Job_Task__c();
            jobTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id = :taskID WITH SECURITY_ENFORCED];
            
        if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable() ){
            jobTask.Revised_Due_Date__c = sd;
        }
        
      
            if( Schema.sObjectType.Job_Task__c.isUpdateable() ){ 
                update jobtask;   
            }
      
       
        
        
        strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName];
        strName=u.Name;     
        progressTask = new list<Job_Task__c>();
        String p = 'In Progress';
        string namecheck1 = '%'+strName+'%';
        progressTask = Database.query('Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false and Assigned_Users__c like :namecheck1 ');
       
       
           //return true;
       
    }
    
    public void tabSelection(){
        selectedTab = Apexpages.currentPage().getParameters().get('tabSelection');
    }
    
    public pagereference newTimeSheetEntry(){
    
        newTimeSheetEntryBool = true;
    
        String selectInProgressId = Apexpages.currentPage().getParameters().get('newTimeSheetEntry');
        
        prsTaskId = selectInProgressId;
        
        Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:prsTaskId WITH SECURITY_ENFORCED];
        ptjId = jtsk.job__c;
        
        if (Schema.sObjectType.Timesheet_Entries__c.fields.Task_Name__c.isCreateable()) {   
            tse.Task_Name__c=jtsk.name; }
        if (Schema.sObjectType.Timesheet_Entries__c.fields.Job__c.isCreateable()) {   
            tse.Job__c = jtsk.job__c; }
        if (Schema.sObjectType.Timesheet_Entries__c.fields.User__c.isCreateable()) {   
            tse.User__c = userinfo.getuserid();} 
        if (Schema.sObjectType.Timesheet_Entries__c.fields.Date__c.isCreateable()) {   
            tse.Date__c = system.today();}
        
        return null;
    }
    
    public PageReference saveNewTimeSheetEntry(){
        newTimeSheetEntryBool = false;
       if(Schema.sObjectType.Timesheet_Entries__c.isCreateable()){  insert tse;}
        
        
        Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:prsTaskId WITH SECURITY_ENFORCED];
        ptjId = jtsk.job__c;
        lstTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: prsTaskId WITH SECURITY_ENFORCED order by CreatedDate];
        timeSheets = [select id, name, Date__c, End_Watch__c, GL_Code__c, Hours_Worked__c, Notes__c, Roles__c, Staff__c, Start_Watch__c, User__c, Task_Name__c, Job__c from Timesheet_Entries__c where Task_Name__c = :jtsk.name and Job__c =:jtsk.Job__c WITH SECURITY_ENFORCED];
        set<String> teamNames = new set<String>();
        for(Job_Task_Role__c tr:lstTR){
            teamNames.add(tr.User__c);
        }
        jTeam = [select id, name, Role__c, Staff__c, Job__c from Job_Team__c where Job__c =: jtsk.job__c and Staff__c Not in :teamNames WITH SECURITY_ENFORCED];
        
        //tse = new Timesheet_Entries__c();
        Pagereference p = new Pagereference('/apex/MyWIPTabPage?filter='+filter+'&selectedTask='+prsTaskId+'&selectedTab='+selectedTab+'&section=mywip');
        p.setRedirect(true);
        return p;
    }
    
    public PageReference cancelNewTimeSheetEntry(){
        newTimeSheetEntryBool = false;
        //tse = new Timesheet_Entries__c();
        
        Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:prsTaskId WITH SECURITY_ENFORCED];
        ptjId = jtsk.job__c;
        lstTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: prsTaskId WITH SECURITY_ENFORCED order by CreatedDate];
        timeSheets = [select id, name, Date__c, End_Watch__c, GL_Code__c, Hours_Worked__c, Notes__c, Roles__c, Staff__c, Start_Watch__c, User__c, Task_Name__c, Job__c from Timesheet_Entries__c where Task_Name__c = :jtsk.name and Job__c =:jtsk.Job__c WITH SECURITY_ENFORCED];
        set<String> teamNames = new set<String>();
        for(Job_Task_Role__c tr:lstTR){
            teamNames.add(tr.User__c);
        }
        jTeam = [select id, name, Role__c, Staff__c, Job__c from Job_Team__c where Job__c =: jtsk.job__c and Staff__c Not in :teamNames WITH SECURITY_ENFORCED];
        return null;
    }
    
    public pagereference makeInProgress(){
        String makeInProgressId=Apexpages.currentPage().getParameters().get('makeInProgressId');
        
        Job_Task__c jts = [select id, name, status__c from Job_Task__c where id = :makeInProgressId WITH SECURITY_ENFORCED];
       if(schema.SobjectType.Job_Task__c.Fields.status__c.isUpdateable()){ 
            jts.status__c = 'In Progress';}
         if(Schema.sObjectType.Job_Task__c.isUpdateable()){
            update jts;}
        
        progressTask = new list<Job_Task__c>();
        String p = 'In Progress';
        string namecheck1 = '%'+strName+'%';
        progressTask = Database.query('Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false and Assigned_Users__c like :namecheck1 ');
       
        return null;
    }
    
    public pagereference taskDone(){
        
        tskid = Apexpages.currentPage().getParameters().get('taskDone');
        Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:tskid WITH SECURITY_ENFORCED];
        ptjId = jtsk.job__c;
         if(schema.SobjectType.Job_Task__c.Fields.status__c.isUpdateable()){ 
         jtsk.Status__c = 'Completed';}
         if(schema.SobjectType.Job_Task__c.Fields.Marked_Done__c.isUpdateable()){
          jtsk.Marked_Done__c = true;}
         if(schema.SobjectType.Job_Task__c.Fields.Completion_Date__c.isUpdateable()){ 
         jtsk.Completion_Date__c=System.today();}
         if(Schema.sObjectType.Job_Task__c.isUpdateable()){
         update jtsk;}
        
        progressTask = new list<Job_Task__c>();
        String p = 'In Progress';
        string namecheck1 = '%'+strName+'%';
        progressTask = Database.query('Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false and Assigned_Users__c like :namecheck1 ');
       
        prsTaskId = null;
       
        return null;
    }
    
    public pagereference notWip(){
        
        tskid = Apexpages.currentPage().getParameters().get('notWip');
        Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:tskid WITH SECURITY_ENFORCED];
        ptjId = jtsk.job__c;
         if(schema.SobjectType.Job_Task__c.Fields.status__c.isUpdateable()){ 
          jtsk.Status__c = 'Active';}
          if(Schema.sObjectType.Job_Task__c.isUpdateable()){
           update jtsk;}
        
        progressTask = new list<Job_Task__c>();
        String p = 'In Progress';
        string namecheck1 = '%'+strName+'%';
        progressTask = Database.query('Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where status__c=:p and marked_done__c=false and Assigned_Users__c like :namecheck1 ');
       
        prsTaskId = null;
       
        return null;
    }
    
    public pagereference selectInProgress(){
        String selectInProgressId=Apexpages.currentPage().getParameters().get('selectInProgressId');
        prsTaskId = selectInProgressId;
        Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:prsTaskId WITH SECURITY_ENFORCED];
        ptjId = jtsk.job__c;
        lstTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: prsTaskId WITH SECURITY_ENFORCED order by CreatedDate];
        timeSheets = [select id, name, Date__c, End_Watch__c, GL_Code__c, Hours_Worked__c, Notes__c, Roles__c, Staff__c, Start_Watch__c, User__c, Task_Name__c, Job__c from Timesheet_Entries__c where Task_Name__c = :jtsk.name and Job__c =:jtsk.Job__c WITH SECURITY_ENFORCED];
        set<String> teamNames = new set<String>();
        for(Job_Task_Role__c tr:lstTR){
            teamNames.add(tr.User__c);
        }
        jTeam = [select id, name, Role__c, Staff__c, Job__c from Job_Team__c where Job__c =: jtsk.job__c and Staff__c Not in :teamNames WITH SECURITY_ENFORCED];
        
        Pagereference p = new Pagereference('/apex/MyWIPTabPage?filter='+filter+'&selectedTask='+prsTaskId+'&selectedTab='+selectedTab+'&section=mywip');
        p.setRedirect(true);
        return p;
        //return null;
    }
    
    public void TeamDragDrop(){
    
        String parentId=Apexpages.currentPage().getParameters().get('parentId');
        String itemId=Apexpages.currentPage().getParameters().get('itemId');
        String senderId=Apexpages.currentPage().getParameters().get('senderId');
        String sName = itemId.split('###')[0];
        String sRole = itemId.split('###')[1];
        
        if(senderId == 'list1'){
            list<Job_Task_Role__c> lstTR1=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: prsTaskId and User__c =:sName and Name = :sRole WITH SECURITY_ENFORCED];
            if(Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){
                delete lstTR1;}
        }
        
        if(senderId == 'list2'){
            Job_Task_Role__c jtro = new Job_Task_Role__c();
            if(schema.SobjectType.Job_Task_Role__c.Fields.Name.isCreateable()){
                jtro.Name=sRole;}
            if(schema.SobjectType.Job_Task_Role__c.Fields.User__c.isCreateable()){jtro.User__c=sName;}
            if(schema.SobjectType.Job_Task_Role__c.Fields.Job_Task__c.isCreateable()){jtro.Job_Task__c = prsTaskId;}
            if(Schema.sObjectType.Job_Task__c.isCreateable()){insert jtro;}
        }
    }
    
    public void deleteTimeSheet(){
        String deleteTimeSheet = Apexpages.currentPage().getParameters().get('deleteTimeSheet');
        Timesheet_Entries__c tg = [select id from Timesheet_Entries__c where id = :deleteTimeSheet WITH SECURITY_ENFORCED];
        if(Timesheet_Entries__c.sObjectType.getDescribe().isDeletable()){delete tg;}
        Job_Task__c jtsk = [select id, name, job__c from job_Task__c where id =:prsTaskId WITH SECURITY_ENFORCED];
        timeSheets = [select id, name, Date__c, End_Watch__c, GL_Code__c, Hours_Worked__c, Notes__c, Roles__c, Staff__c, Start_Watch__c, User__c, Task_Name__c, Job__c from Timesheet_Entries__c where Task_Name__c = :jtsk.name and Job__c =:jtsk.Job__c WITH SECURITY_ENFORCED];
    }
    
    // This method is used to get Staff Records 
 /*   public List<SelectOption> getStaff()
    {
         string jobTaskid = ApexPages.currentPage().getParameters().get('id');
        List<SelectOption> StaffoptionList = new List<selectOption>();
       
         // StaffoptionList.add(new selectOption('', '- None -'));  
          for (Job_Task__c a : [Select Id,Name,Job__c,Assigned_Users__c from Job_Task__c where Job__r.status__c<>:'completed' and Job__c=:jobTaskid ]) 
          {  
            StaffoptionList.add(new selectOption(a.Assigned_Users__c , a.Assigned_Users__c ));    
          }
          return StaffoptionList;  
     }   
     // End of method getStaff
     
     
   // This method is used to get Roles Records 
    public List<SelectOption> getRole()
    {
        string jobTaskid = ApexPages.currentPage().getParameters().get('id');
        List<SelectOption> RoleoptionList = new List<selectOption>();
       
        //  RoleoptionList .add(new selectOption('', '- None -'));  
          for (Job_Task__c a : [Select Id,Name,Job__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c<>:'completed' and Job__c=:jobTaskid and Schedule_Roles__c <>:NULL]) 
          {  
            RoleoptionList.add(new selectOption(a.Schedule_Roles__c , a.Schedule_Roles__c ));    
          }
          return RoleoptionList;  
     }   
     // End of method getRloes
  
   //Get Task
   public PageReference JobTask() 
   {
        Task=true;
        colormap=new map<integer,string>();
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
        
        events = new list<calEvent>();
      
      integer i=0;
        
      
         jobTask= new List<Job_Task__c>();
         Date myDate = system.today();
         String Active= 'Active';
         String Fal='false';
         string jobTaskid = ApexPages.currentPage().getParameters().get('id');
         string namecheck = '%'+strName+'%';
         
         Boolean tt = true;
         if(filter == '1'){
             soqlJobTask='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c=:Active and marked_done__c=false and Assigned_Users__c like :namecheck and Next_Task_Due__c = :tt';             
         }
         if(filter == '2'){
             soqlJobTask='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c=:Active and marked_done__c=false and Assigned_Users__c like :namecheck ';
         }
       if(test.isRunningTest()){
           soqlJobTask='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c';
       }
         
         
          if(jobTaskid !=Null )
              soqlJobTask+=' And Job__c=:jobTaskid';
          
            jobTask=Database.query(soqlJobTask);
            
            
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+jobTask);
            
         //   Joblist=Database.query('select Id, Name,Job_Auto_Number__c, Start_Date__c,Due_Date__c,('+soqlJobTask+') from Job__c where status__C<>completed');
            
        
       // integer i=0;
        
        
       
       if(jobTask.size() > 0)
       {
           
            for(Job_Task__c  jobt: jobTask)
            {
                if(jobt.Assigned_Users__c.containsignorecase(strName))
                {
                 
                    strCampaignName  = jobt.Job__r.campaign__r.name;
                    JobStatusString  = jobt.Job__r.status__c;
                    strClientName  = jobt.Job__r.JS_Client__r.name;
                    strJobName  = jobt.Job__r.Name;
                   
                   DateTime endDT = jobt.Revised_Due_Date__c+1;
                   
                       calEvent J = new calEvent();
                       
                       string strTaskName = jobt.Name;
                       string strJobName = jobt.Job__r.Name;
                                 String Taskname = jobt.Name; 
                                //String regExp = '["\']';
                                if(Taskname  != NULL)
                                    Taskname = Taskname .replaceAll(regExp, '\\ ');
                           
                       J.title = Taskname +', Job - # '+jobt.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
                       J.titleNew = Taskname +' - '+jobt.Job__r.Job_Auto_Number__c;
                       J.allDay = true;
                       J.startString = endDT.format();
                       J.endString = endDT.format();
                     //  J.url = '/' + jobt.Job__c;
                       if(UserInfo.getUiTheme() == 'Theme4d'){
                           J.url = '/apex/JobdetailpageLightening07?id='+jobt.Job__c+'&section=schedules';
                       }
                       else{
                           J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
                       }
                           String TaskCampname = jobt.Job__r.campaign__r.name; 
                                //String regExp = '["\']';
                                if(TaskCampname != NULL)
                                    TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                                
                                String TaskJobname = jobt.Job__r.Name; 
                                //String regExp = '["\']';
                                if(TaskJobname != NULL)
                                    TaskJobname = TaskJobname .replaceAll(regExp, '\\ ');
                       
                       j.JN1 = TaskCampname  +' : '+TaskJobname +'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                      
                               String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                                    //String regExp = '["\']';
                                    if(TaskJobCliname != NULL)
                                    TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                       j.client1 = TaskJobCliname ;
                       
                       //j.color=colormap.get(i);
                       if(jobcolormap.containskey(jobt.job__r.id))
                       {
                           integer n = jobcolormap.get(jobt.job__r.id);
                           j.color=colormap.get(n);
                       }
                       else
                       {
                            jobcolormap.put(jobt.job__r.id,i);
                            j.color=colormap.get(i);
                       }
                       
                        String TaskUsersname = jobt.Assigned_Users__c; 
                                    //String regExp = '["\']';
                                    if(TaskUsersname != NULL)
                                    TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                       j.Staff= TaskUsersname;
                       J.className = jobt.id;
                       events.add(J);
           
           }
           if(i == 100)
                   i=0;
                else
                   i++;
         }
       }
       else
       {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'There are no Tasks to display on Calendar'));
       }
       return null;      
   } 
    
     
   
    
   public PageReference printcal() 
   {
       PageReference pageRef = new PageReference('/apex/calendarprint');
       return pageref;

   
   }
 
 */
 @RemoteAction
    global static boolean updateJSCampaign(String name, String cntid, String endate, String stdate,string jn) 
    {
       
     /*  list<Campaign__c> campList = new list<Campaign__c>();
       list<job__c> jobList = new  list<job__c>();
       String id1 = cntid.Substring(cntid.length()-18,cntid.length());
       Campaign__c cam = new Campaign__c();
       integer eyear = integer.valueof(endate.substring(0,4));
       integer emonth = integer.valueof(endate.substring(5,7));
       integer eday = integer.valueof(endate.substring(8,10));
      
       integer syear = integer.valueof(stdate.substring(0,4));
       integer smonth = integer.valueof(stdate.substring(5,7));
       integer sday = integer.valueof(stdate.substring(8,10));
     //  Date ed = Date.newInstance(eyear,emonth,eday-1);
      // Date sd = Date.newInstance(syear,smonth,sday-1);
       
      //if(name.Substring(name.length()-8,name.length()) == 'campaign' )
      
      System.debug('::::::::::::::Hello before IF::::::::::::::::::::'+name.substring(0, 11));
      
     // name.substring(0, 11) != 'JS Campaign'
     // name.Substring(0,3) != 'Job'
      
            System.debug(':::::::::::::Entered:::::::::::::::'+name.substring(0, 11));
            Date sd = Date.newInstance(syear,smonth,sday);
            Date ed = Date.newInstance(eyear,emonth,eday-1);
            String taskID = jn.Substring(jn.indexof('id=')+3,jn.indexof('id=')+3+18);
            system.debug('<<<<<<<<<Task ID is>>>>>>>>>>>>>>>>>>>'+taskID);
            Job_Task__c jobTask= new Job_Task__c();
            jobTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id = :taskID WITH SECURITY_ENFORCED];
            
        if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
            jobTask.Revised_Due_Date__c = sd;
        }
        
      //  if(Schema.sObjectType.Job_Task__c.isCreateable() && Schema.sObjectType.Job_Task__c.isUpdateable() ){ 
          //  upsert jobtask;   
     //   }
        
            if( Schema.sObjectType.Job_Task__c.isUpdateable() ){ 
                update jobtask;   
            }
       
        

      
         */
           return true;
     
    }
     
    /* 
     
    //Class to hold calendar event data
    public class calEvent
    {
        public string titleNew {get;set;}
        public String title {get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public string color{get;set;}
        public String JN1{get;set;} //jobnumber
        public String client1{get;set;}
        public String Staff{get;set;} // used for assigning task staff and used for assigning campaign of the job
        public String className {get;set;}
    }
    
    
    
    public String taskId{get;set;}
    public String updateRestScheduleRevDt{get;set;}
    public Date dt{get;set;}
    public Id jobId{get;set;}
    
    public pagereference updateRestSchedule()
    {
             System.debug('Due Date is : '+dt);
             
             dt = Date.valueOf(dt);
             prsTaskId = taskId;
             System.debug('Task Id is : '+taskId);
             System.debug('Value of updateRestScheduleRevDt : '+String.valueOf(updateRestScheduleRevDt));
         
             DateTime NextTaskStartDate;
             //code for the update of the current schedule 
             Job_Task__c jobTask1,jobTask2,objJobTask;
             
              
              
                   //taskId = Id.valueOf(taskId);
                   jobTask1 = new Job_Task__c(Id=taskId,Revised_Due_Date__c = dt);
                       if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                     update jobTask1;}
                   objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: jobTask1.Id WITH SECURITY_ENFORCED LIMIT 1];
                   jobId = objJobTask.job__c;
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
                              if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){ 
                            objJobTask.Start_Date__c = afterDaysUpdate;   }
                             if(schema.getGlobalDescribe().get('Job_Task__c').getDescribe().isUpdateable()){
                                 update objJobTask;}
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
                                      if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){
                                       lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                                    if(blnFroward)
                                     {
                                      // dtStartDate3= lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                      
                                          if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){ 
                                            lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                                          dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                       
                                     }
                                     else
                                     {
                                     //  dtStartDate3= lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;
                                       
                                          if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
                                           lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;}
                                          dtStartDate3= DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                          
                                          
                                     }
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                    if(blnFroward)
                                     {
                                      //  dtStartDate3 = lstJobTasks[i].Start_Date__c = d4;
                                         if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){
                                          lstJobTasks[i].Start_Date__c = d4;}
                                         
                                         
                                          dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                     }
                                     else
                                     {
                                      
                                      
                                      // dtStartDate3 = lstJobTasks[i].Revised_Due_Date__c = d4; 
                                         if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
                                          lstJobTasks[i].Revised_Due_Date__c = d4;}
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
                            if(schema.SobjectType.Job_Task__c.Fields.Days__c.isUpdateable()){
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
                               if(schema.getGlobalDescribe().get('Job_Task__c').getDescribe().isUpdateable()){
                         update lstJobTasks;}
                            System.debug('Updated List : '+lstJobTasks);
                         }
                
                // system.debug('$$$$$$$$$$$$$Helloooo'+Limits.getScriptStatements());
         // After updating the schedule navigate to Job --> Schedule Tab
       
        //lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        //lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate]; 
        Pagereference p = new Pagereference('/apex/MyWIPTabPage?filter='+filter+'&selectedTask='+prsTaskId+'&selectedTab='+selectedTab+'&section=mywip');
        p.setRedirect(true);
        return p;
        //return null;
    }
    
*/    

}