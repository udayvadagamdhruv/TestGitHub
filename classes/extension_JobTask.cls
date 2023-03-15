// This class is used to insert New Task at the last in the Schedule
public with sharing class extension_JobTask
{ 

   


    // Global variables
    public  Boolean isFirst=true;
    Public String GLCName;
    public Id jobId;
    Public String Taskid;
    public Job__c objJob{get;set;}
    private final Job_Task__c objJobTask1;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    Public List<Job_Team__c> listjobteam ;
    
     public Job_Task__c objJobTask
    {
         get 
         {
         if (objJobTask == null)
         objJobTask = new Job_Task__c();
         objJobTask.GL_Code__c = GLCName;
         return objJobTask;
         }
         set;
    }
    // End Global variables

    // Start constructor
    public extension_JobTask(ApexPages.StandardController controller) 
    {
        this.objJobTask = (Job_Task__c)controller.getRecord();    
        jobid=ApexPages.CurrentPage().getParameters().get('jobid1'); 
        objJobTask.Job__c=jobid; 
        
        
         listjobteam =[select id,name, Role__c,staff__c,Email__c from Job_Team__c  where job__c =:jobid];
    }
    // End constructor

   
    public string RolesList {get; set;} 
   
    public List<SelectOption> getRoles(){
    
    List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '---- None ----')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
          for (UserRole roles :[SELECT Id,Name FROM UserRole ORDER BY Name])  
          {    
                options.add(new selectOption(roles.Name,roles.Name)); //for all records found - add them to the picklist options
          }
        return options; //return the picklist options
    } 
    
   
   
   
   
   
    // Populate GL Code into picklist
    public List<selectOption> getGLCodes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (GL_Code__c a : [SELECT Id, name FROM GL_Code__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End method getGLCodes
    
    // This method is called on to handle Save button
    Public PageReference save()
    {
       system.debug('Roles======' + RolesList);
        String  Roleslist1=RolesList.replaceAll(',',';');
        String  Roleslist2=RolesList1.replaceAll('\\[','');
        String  Roleslist3=RolesList2.replaceAll('\\]','');
       
       system.debug('Roleslist3======' + Roleslist3);
       
       String strid;
       strid = objJobTask.Job__c; 
       Set<Date> holidays=new Set<Date>();
       
      // Modified on 22 May to Sort Job Tasks on the basis of Task Order 
      
        Double task_order_no;
        List<Job_Task__c> lstJTNew=[Select id from Job_task__c where Job__c=: jobid];
        
        if(!lstJTNew.isEmpty())
        {
            Job_Task__c objjobTask1=[Select id,Name,Task_Order__c,Job__c,Job__r.Schedule_Calc__c,Email__c from Job_Task__c where Job__c=:jobid order by Task_Order__c DESC limit 1];
            task_order_no=objjobTask1.Task_Order__c;
        }
        else
        {
            task_order_no=0;
        }    
       
       try
       {
           String Name1=objJobTask.Name;
           Double days=objJobTask.Days__c;
           String strGLCode=objJobTask.GL_Code__c;
           
           Job_Task__c lstJobTask=[Select Id,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c from Job_Task__c where Job__c =: strid Order BY Revised_Due_Date__c DESC limit 1];
        
          // Add Holiday Dates to Ser, so that holidays will be skipped while calculating Schedule dates
           for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null])
           {
             holidays.add(hc.Date__c );
           }
           
           
           /*******Check for the value for schedule calc *************/
           if(lstJobTask.Job__r.Schedule_Calc__c == 'Start Date' || lstJobTask.Job__r.Due_Date__c == null)
           {
               Date d1=Date.newInstance(lstJobTask.Revised_Due_Date__c.Year(),lstJobTask.Revised_Due_Date__c.Month(),lstJobTask.Revised_Due_Date__c.Day());
               System.debug('Due Date of Last Task : '+d1);
               Datetime dtStartDate=DateTime.newInstance(d1.Year(),d1.Month(),d1.Day());
              
               Integer jCount=0;
               // Calculate Due Date, Revised Due Date
               while(true)
               {
                     Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                     
                     // Skip holidays, sat, sun while calculating Schedule Dates : Due Date, Revised Due Date
                     if((dtStartDate.format('E')!='Sat'&&dtStartDate.format('E')!='Sun') && ! (holidays.contains(d3)))
                     {
                         jCount=jCount+1;
                         if(jCount>days)
                         {
                             break;
                         }
                          system.debug('jCount======' + jCount);
                          system.debug('==========' + dtStartDate);
      
                          system.debug('===========' + dtStartDate.format('E'));
                          dtStartDate=dtStartDate.addDays(1);
                          system.debug('After adding 1 day : ' +dtStartDate);
    
                     }
                       else
                     {
                          system.debug('==========' + dtStartDate);
                          //system.debug('===========' + dtStartDate.format('E'));
                          dtStartDate=dtStartDate.addDays(1);
                              continue;
                       }
                }
             system.debug('Calculation============' +dtStartDate);
            
             Date d6 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
             system.debug('D1============' +dtStartDate);
             Job_Task__c objTaskNew=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no+1,Due_Date__c=d6,Revised_Due_date__c=d6,GL_Code__c=strGLCode,Schedule_Roles__c=Roleslist3);
             if(GLCName == null || GLCName == '-None-')
             {
                /** Gl Code mandatory removed
                String strGLCName = Schema.Job_Task__c.fields.GL_Code__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strGLCName+' : You must select a '+strGLCName+'.');
                ApexPages.addMessage(myMsg);
                return null;****/
                objTaskNew.GL_Code__c = null;
                insert objTaskNew;
                Taskid=objTaskNew.id;
            }
            else
            {
                 insert objTaskNew;
                 Taskid=objTaskNew.id;
            }
            
            
            
            
           } 
          else
          {
             Date d1=Date.newInstance(lstJobTask.Job__r.Due_Date__c.Year(),lstJobTask.Job__r.Due_Date__c.Month(),lstJobTask.Job__r.Due_Date__c.Day());
               System.debug('Due Date of Last Task : '+d1);
               Datetime dtDueDate=DateTime.newInstance(d1.Year(),d1.Month(),d1.Day());
              
               Integer jCount=0;
               // Calculate Due Date, Revised Due Date
               while(true)
               {
                     Date d3 = Date.newInstance(dtDueDate.Year(),dtDueDate.Month(),dtDueDate.Day());
                     
                     // Skip holidays, sat, sun while calculating Schedule Dates : Due Date, Revised Due Date
                     if((dtDueDate.format('E')!='Sat'&&dtDueDate.format('E')!='Sun') && ! (holidays.contains(d3)))
                     {
                         jCount=jCount+1;
                         if(jCount>days)
                         {
                             break;
                         }
                          system.debug('jCount======' + jCount);
                          system.debug('==========' + dtDueDate);
      
                          system.debug('===========' + dtDueDate.format('E'));
                          dtDueDate=dtDueDate.addDays(-1);
                          system.debug('After adding 1 day : ' +dtDueDate);
    
                     }
                       else
                     {
                          system.debug('==========' + dtDueDate);
                          //system.debug('===========' + dtStartDate.format('E'));
                          dtDueDate=dtDueDate.addDays(-1);
                              continue;
                       }
                }
             system.debug('Calculation============' +dtDueDate);
            
             Date d6 = Date.newInstance(dtDueDate.Year(),dtDueDate.Month(),dtDueDate.Day());
             system.debug('D1============' +dtDueDate);
             Job_Task__c objTaskNew=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d6,Task_Order__c=task_order_no+1,Due_Date__c=d1,Revised_Due_date__c=d1,GL_Code__c=strGLCode,Schedule_Roles__c=Roleslist3);
             if(GLCName == null)
             {
                String strGLCName = Schema.Job_Task__c.fields.GL_Code__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strGLCName+' : You must select a '+strGLCName+'.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            else
            {
                 insert objTaskNew;
                 Taskid=objTaskNew.id;
            }
            
                 List<Job_Task__c> lst1=new List<Job_Task__c>();
                  /******insertTask upTask = new insertTask();
                     upTask.blnFroward = blnFroward;
                     upTask.objJobTask = objJobTask;
                     upTask.isFirst = isFirst;
                     upTask.strid = strid;
                     upTask.d1 = d1;
                     upTask.holidays = holidays;***********/
                 // lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=:strid and Start_Date__c >=: d AND Id !=: objJobTask.Id ORDER BY Start_Date__c];
        
                 lst1=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c from Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no AND Id !=: objJobTask.Id ORDER BY Task_Order__c DESC];
         
                 System.debug('Size of lst '+lst1.size());
        
                 List<Job_Task__c> lstJobTask1=new List<Job_Task__c>();
                  Date NTSD1;
        
              Double a=task_order_no;
        
        for(Job_Task__c jt1:lst1)
        {
            jt1.Task_Order__c = a;
            a--;
             
            if(isFirst)
            {
                System.debug('This is First');
                jt1.Revised_Due_Date__c=Date.newInstance(d6.Year(),d6.Month(),d6.Day());
                isFirst=false;
            }
            else
            {
                jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());
            }
            
            System.debug('task Name'+jt1.Name);
            System.debug('ST Date'+jt1.Revised_due_Date__c);
            
            Datetime dtDueDate1=Datetime.newInstance(jt1.Revised_Due_Date__c.Year(),jt1.Revised_Due_Date__c.Month(),jt1.Revised_Due_Date__c.Day());
            System.debug('Revised Due Date is :'+dtDueDate1);
            Integer jCount1=0;
            System.debug('jCount value'+jCount1);
            
            while(true)
            {
                Date d4=Date.newInstance(dtDueDate1.Year(),dtDueDate1.Month(),dtDueDate1.Day());
                
                         if((dtDueDate1.format('E')!='Sat' && dtDueDate1.format('E')!='Sun')&&(!holidays.contains(d4)))
         {
              jCount1=jCount1 +1;
              if(jCount1>jt1.Days__c)
              {
                  break;
              }
              system.debug('jCount======' + jCount1);
              system.debug('==========' + dtDueDate1);
      
              system.debug('===========' + dtDueDate1.format('E'));
              dtDueDate1=dtDueDate1.addDays(-1);
              system.debug('after adding 1 day==========' + dtDueDate1);
              
         }
         else
           {
          system.debug('==========' + dtDueDate1);
         //system.debug('===========' + dtStartDate.format('E'));
           dtDueDate1=dtDueDate1.addDays(-1);
          continue;
         }

                
            }   
            
            Date  d5 = Date.newInstance(dtDueDate1.Year(),dtDueDate1.Month(),dtDueDate1.Day());
                System.debug('D5 is as follows : '+d5);
            
            jt1.Start_Date__c=d5;
            NTSD1=d5;
            system.debug('NTSD '+NTSD1);
            lstJobTask1.add(jt1);
          // update jt1;
          }
         update lstJobTask1;
          }     
       }
       catch(DMLException e)
       {
           return null;
       } 
       
       List<Job_Task__c > listtasks=[select id,name,Schedule_Roles__c,Email__c from Job_Task__c  where id=:Taskid];
        System.debug('===listtasks====='+listtasks);
       System.debug('===List of Task Roles====='+listtasks[0].Schedule_Roles__c);
      
        List<Job_Task_Role__c> JobTaskRoleNew  = new List<Job_Task_Role__c>();
       
       for(Job_Team__c Jteam :listjobteam ){
       
       for(Job_Task__c  Jtask :listtasks){
       
        if(Jtask.Schedule_Roles__c!=NULL ){
         if(Jtask.Schedule_Roles__c.contains(''+Jteam.role__c)){
         
          Job_Task_Role__c J2 = new Job_Task_Role__c ();
                 J2.Email__c =Jteam.Email__c; 
                 J2.User__c=Jteam.Staff__c;
                 J2.Name=Jteam.Role__c;
                 J2.Job_Task__c = Taskid;
                 JobTaskRoleNew.add(J2);
       
       
       }
       
       }
       
       
       
       }
       }
       
       insert JobTaskRoleNew;
       
       
     
         // After inserting new task navigate to the Schedule Tab      
        //PageReference p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=2');
        String th = userinfo.getUiTheme();
       PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strid+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=2'); 
        p.setRedirect(true);
        return p;
        
        
        
        
        
    }
    // End method Save
    
   // This method is called on to handle Cancel button
    Public PageReference cancelme()
    {  
       //PageReference p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=2');
       String th = userinfo.getUiTheme();
       PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=2'); 
       p.setRedirect(true);
       return p;
    } 
    // End method Cancel
  
  
  /*  static testMethod void Test_extension_JobTask()
   {
   
          Job_Number_Setting__c customSetting999 = new  Job_Number_Setting__c(Name= 'yy');
          insert customSetting999;
         
          Media_Type__c testMedia=new Media_Type__c(Name='MT018');
          insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST018',Media_Types__c=testMedia.Id);
          insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT018');
          insert testSpec;
                
          Job__c testJob1=new Job__c(Name='J018',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='Start Date');
          insert testJob1;
          
            GL_Department__c testGLD = new GL_Department__c(Name='GLD018');
            try
            {
            insert testGLD;
            }
            catch(System.DMLException e)
            {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GLC018',GL_ID__c='GLC012',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
             }
             catch(System.DMLException e)
             {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
                 
          Job_Task__c testJobTask=new Job_Task__c(Name='JT018',Job__c=testJob1.Id,Days__c=3,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today());
          insert testJobTask;
         
          Job_Task__c testJobTask1=new Job_Task__c(Name='JT019',GL_Code__c=TestGL.id,Days__c=2);
          
          
           Job__c testJob2=new Job__c(Name='J019',Start_Date__c=System.Today(),Due_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='End Date');
          insert testJob2;
          
            Job_Task__c testJobTask2=new Job_Task__c(Name='JT019',Job__c=testJob2.Id,Days__c=3,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask2;
          Job_Task__c testJobTask4=new Job_Task__c(Name='JT029',Job__c=testJob2.Id,Days__c=5,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask4;
          Job_Task__c testJobTask5=new Job_Task__c(Name='JT021',Job__c=testJob2.Id,Days__c=1,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask5;
         
          Job_Task__c testJobTask3=new Job_Task__c(Name='JT020',GL_Code__c=TestGL.id,Days__c=2);
        
          
        
       // Instantiate the standard controller with the Job 
        ApexPages.currentPage().getParameters().put('jobid1',testJob1.Id);
        ApexPages.StandardController con=new ApexPages.StandardController(testJobTask1);
        
       // Instantiate the extention instance with the standardcontroller 
          extension_JobTask ext=new extension_JobTask(con);
          ext.GLCName = testGL.id;
          String GLCName = ext.getGLCName();
          ext.setGLCName(GLCName);
          List<SelectOption> options = ext.getGLCodes(); 
        
      // Invoke the primary method on the extension 
        ApexPages.PageReference result1=ext.save();    
        ApexPages.PageReference result2=ext.cancelme();
        
         ApexPages.currentPage().getParameters().put('jobid1',testJob2.Id);
         con=new ApexPages.StandardController(testJobTask3);
        
       // Instantiate the extention instance with the standardcontroller 
           ext=new extension_JobTask(con);
               ext.GLCName = testGL.id;
          GLCName = ext.getGLCName();
          ext.setGLCName(GLCName);
          options = ext.getGLCodes() ;   
           result1=ext.save();    
           result2=ext.cancelme();
        
        Job_Task__c resultm=ext.objJobTask;
        
        delete testJobTask;
        result1=ext.save();   
          }*/
    // Test Coverage 
}
// End of Class