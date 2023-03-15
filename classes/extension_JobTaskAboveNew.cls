// This class is used when user inserts new task above the current task 
public with sharing class extension_JobTaskAboveNew 
{
   // Global variables 
    public Double task_order_no{get;set;}
    
    Public String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    Boolean isFirst=true;
    public Id taskid{get;set;} 
    public Job_Task__c objJobTask1{get;set;}
    public Job__c objJob{get;set;}
    Public String Taskid1;
    Public List<Job_Team__c> listjobteam ;
    Public String strid;
    public Job_Task__c objJobTask
    {
         get {
      if (objJobTask == null)
        objJobTask = new Job_Task__c();
        objJobTask.GL_Code__c = GLCName;
      return objJobTask;
    }
    set;
    }
    // End of Global variables
    
    
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
    
    
    
    
    
   // Start Constructor 
     public extension_JobTaskAboveNew ()
     {
        taskid=ApexPages.CurrentPage().getParameters().get('id');
        System.debug('tId1@@@@'+taskid);
        objJobTask1=[Select Job__c,Task_Order__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c,Email__c  from Job_Task__c where Id=: taskid]; 
        task_order_no=objJobTask1.Task_Order__c;
        
          strid = objJobTask1.Job__c; 
         listjobteam =[select id,name, Role__c,staff__c,Email__c from Job_Team__c  where job__c =:strid];
        //objJobTask.Job__c=objJobTask1.Job__c; 
     }
     // End Constructor 


    

   
   // Retrieve GL Codes into Picklist
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

   // This method is called on to handle Save button operation 
   public pagereference saveme()
    {
        system.debug('Roles======' + RolesList);
        String Roleslist1=RolesList.replaceAll(',',';');
        String Roleslist2=RolesList1.replaceAll('\\[','');
        String Roleslist3=RolesList2.replaceAll('\\]','');
       
       system.debug('Roleslist3======' + Roleslist3);
          
          
          
          System.debug('tId1@@@@'+taskid);
       
          String Name1=objJobTask.Name;
          Double days=objJobTask.Days__c;
          String strGLCode=objJobTask.GL_Code__c;
       
          try
          {
            Datetime NTSD;
            Set<Date> holidays=new Set<Date>();
            
             // Add Holiday Dates to Set, so that holidays will be skipped while calculating Schedule dates
             for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null])
            {
                holidays.add(hc.Date__c );
            }
            
             Boolean blnFroward = true;
            if(objJobTask1.Job__r.Schedule_Calc__c == 'End Date')
            {
               blnFroward = false;
            }
            /**** check for the schedule calc  to change the remaing tasks**************/
         //   if(objJobTask1.Job__r.Schedule_calc__c == 'Start Date')
          //  {
           Date d;
           // if(blnFroward)
           // {
            d=Date.newInstance(objJobTask1.Start_date__c.Year(),objJobTask1.Start_date__c.Month(),objJobTask1.Start_date__c.Day());
           // }
          //  else{
         //   d=Date.newInstance(objJobTask1.Revised_Due_date__c.Year(),objJobTask1.Revised_Due_date__c.Month(),objJobTask1.Revised_Due_date__c.Day());
           // }            
           // Date db = Date.newInstance(objJobTask1.Revised_Due_date__c.Year(),objJobTask1.Revised_Due_date__c.Month(),objJobTask1.Revised_Due_date__c.Day()); 
            //for the new value the revised due date will be the stsrt date of the below value
            Datetime dtStartDate=DateTime.newInstance(d.Year(),d.Month(),d.Day());
            Integer jCount=0;
             // To Calculate Due Date, Revised Due Date
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
                      //if end calulate by -
                      if(blnFroward)
                     {
                      dtStartDate=dtStartDate.addDays(1);
                     }
                     else
                     {
                         dtStartDate=dtStartDate.addDays(-1);
                     }
                      system.debug('After adding 1 day : ' +dtStartDate);

                 }
                   else
                     {
                          system.debug('==========' + dtStartDate);
                            //if end calulate by -
                        if(blnFroward)
                         {
                          dtStartDate=dtStartDate.addDays(1);
                         }
                         else
                         {
                             dtStartDate=dtStartDate.addDays(-1);
                         }
                              continue;
                       }
             }
             system.debug('Calculation============' +dtStartDate);
            
                 Date d1 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                system.debug('D1============' +dtStartDate);
              
               
               //objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no,Due_Date__c=d,Revised_Due_date__c=d,GL_Code__c=strGLCode);
               
               
                 if(blnFroward)
                     {
                      objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d,Task_Order__c=task_order_no,Due_Date__c=d1,Revised_Due_date__c=d1,GL_Code__c=strGLCode,Schedule_Roles__c=Roleslist3);
                     }
                     else
                     {
                         objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no,Due_Date__c=d,Revised_Due_date__c=d,GL_Code__c=strGLCode,Schedule_Roles__c=Roleslist3);
                     }
                     
               //here assign the new task the statrt date of next job and the calulated start date
               /**if(GLCName == null || GLCName == '-None-' )
                  {
                    
                    /*** Change Gl code as not mandatory
                    String strGLCode1 = Schema.Job_Task__c.fields.GL_Code__c.getDescribe().getLabel();
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, strGLCode1 + ' : You must select a '+ strGLCode1+'.');
                    ApexPages.addMessage(myMsg);
                    return null;****/
                    //objJobTask.GL_Code__c = null;
                    //insert objJobTask;
                 // }**/
               // else
               // {
                     insert objJobTask;
                     Taskid1=objJobTask.id;
                     /******insertTask upTask = new insertTask();
                     upTask.blnFroward = blnFroward;
                     upTask.objJobTask = objJobTask;
                     upTask.isFirst = isFirst;
                     upTask.strid = strid;
                     upTask.d1 = d1;
                     upTask.holidays = holidays;***********/
                     
                     
                     
         List<Job_Task__c> lst=new List<Job_Task__c>();
         //if(end date do desc)
          if(blnFroward)
                     {
                           lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c  from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: objJobTask.Id ORDER BY Task_Order__c];
                     }
                     else
                     {
                         lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c  from Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no-1 AND Id !=: objJobTask.Id ORDER BY Task_Order__c DESC ];
                     }
         
        System.debug('Size of lst '+lst.size());
        
        List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
        Date NTSD1;
        
        Double a=task_order_no+1;
        
        for(Job_Task__c jt1:lst)
        {
              //if() start date 
              if(blnFroward)
                     {
                        jt1.Task_Order__c=a;
                        a++;
                     }
             
                if(isFirst)
                {
                    System.debug('This is First');
                    
                    
                     if(blnFroward)
                         {
                           jt1.Start_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());
                         }
                         else
                         {
                            jt1.Revised_Due_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());
                         }
                    isFirst=false;
                }
                else
                {
                    
                    if(blnFroward)
                         {
                           jt1.Start_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());
                         }
                         else
                         {
                            jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());
                         }
                }
            
                System.debug('task Name'+jt1.Name);
                System.debug('ST Date'+jt1.Start_Date__c);
                 Datetime dtStartDate1;
               if(blnFroward)
                 {
                  dtStartDate1 =Datetime.newInstance(jt1.Start_Date__c.Year(),jt1.Start_Date__c.Month(),jt1.Start_Date__c.Day());
               }
                else
                {
                
                dtStartDate1=Datetime.newInstance(jt1.Revised_Due_Date__c.Year(),jt1.Revised_Due_Date__c.Month(),jt1.Revised_Due_Date__c.Day());
                }
                System.debug('Start Date is :'+dtStartDate1);
                Integer jCount1=0;
                System.debug('jCount value'+jCount1);
            
                while(true)
                {
                    Date d4=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                    
                             if((dtStartDate1.format('E')!='Sat' && dtStartDate1.format('E')!='Sun')&&(!holidays.contains(d4)))
                             {
                                  jCount1=jCount1 +1;
                                  if(jCount1>jt1.Days__c)
                                  {
                                      break;
                                  }
                                  system.debug('jCount======' + jCount1);
                                  system.debug('==========' + dtStartDate1);
                          
                                  system.debug('===========' + dtStartDate1.format('E'));
                                  if(blnFroward)
                                         {
                                                  dtStartDate1=dtStartDate1.addDays(1);
                                         }
                                          else
                                         {
                                              dtStartDate1=dtStartDate1.addDays(-1);
                                         }
                                  system.debug('after adding 1 day==========' + dtStartDate1);
                                  
                             }
                            else
                               {
                                system.debug('==========' + dtStartDate1);
                                //system.debug('===========' + dtStartDate.format('E'));
                                if(blnFroward)
                                         {
                                               dtStartDate1=dtStartDate1.addDays(1);
                                         }
                                          else
                                         {
                                              dtStartDate1=dtStartDate1.addDays(-1);
                                         }
                               continue;
                             }
    
                    
                }   
            
                    Date  d5 = Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                        System.debug('D5 is as follows : '+d5);
                    if(blnFroward)
                             {
                                  jt1.Revised_Due_Date__c=d5;
                             }
                              else
                             {
                                 jt1.Start_Date__c=d5;
                             }
                    NTSD1=d5;
                    system.debug('NTSD '+NTSD1);
                    lstJobTask.add(jt1);
                     // update jt1;
            }
         update lstJobTask;
          //update the task order of the below tasks
         List<Job_Task__c> lstbelow =new List<Job_Task__c>();
         //if(end date do desc)
         lstbelow=[Select Id,Name,Task_Order__c,Email__c from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: objJobTask.Id ORDER BY Task_Order__c];
         //if(!blnFroward)
                    // {
                        for(Job_Task__c jt1:lstbelow)
                        {
                              //if() start date 
                              if(!blnFroward)
                                     {
                                        jt1.Task_Order__c=a;
                                        a++;
                                     }
                                     
                                       // jt1.Task_Order__c=a;
                                      //  a++;
                        }
                        update lstbelow;
               // }
        
      
                     //}
                     
        
        
         // } 
 
          
       }
       catch(DMLException e)
       {
   //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
       return null;
       } 
       
       
        List<Job_Task__c > listtasks=[select id,name,Schedule_Roles__c,Email__c from Job_Task__c  where id=:Taskid1];
        List<Job_Task_Role__c> JobTaskRoleNew  = new List<Job_Task_Role__c>();
       
       for(Job_Team__c Jteam :listjobteam ){
       
       for(Job_Task__c  Jtask :listtasks){
       
        if(Jtask.Schedule_Roles__c!=NULL && Jtask.Schedule_Roles__c.contains(''+Jteam.role__c)){
         
          Job_Task_Role__c J2 = new Job_Task_Role__c ();
                 J2.Email__c =Jteam.Email__c; 
                 J2.User__c=Jteam.Staff__c;
                 J2.Name=Jteam.Role__c;
                 J2.Job_Task__c = Taskid1;
                 JobTaskRoleNew.add(J2);
       
       }
       
       
       }
       }
       
       insert JobTaskRoleNew;
       String th = userinfo.getUiTheme();
       PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strid+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=2');
        p.setRedirect(true);
        return p;
  }
  // End Save method 
  
    //This method is called on to handle Cancel button operation 
    public pagereference cancelme()
    {
        String strid1 = ApexPages.CurrentPage().getParameters().get('id');
        Job_task__c jt = [select id,Job__c from Job_task__c where id =: strid1 Limit 1];
        
       String th = userinfo.getUiTheme();
       PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strid+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=2');            
       p.setRedirect(true);
       return p;
    }
    // End Cancel method 



    // Start Coverage
   /* static testMethod void Test_extension_JobTaskAboveNew ()
    {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1040');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1040',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schedule Task 1040',Days__c=2,Schedule_Template__c=testST.id);
              insert testSchedule;       
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1040');
                insert testSpec;
                
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 1040');    
              insert testCamp;  
   
          Client__c testClient=new Client__c(Name='Test Account 1040');
               insert testClient;
               
          Client_Contact__c testContact=new Client_Contact__c(Name='Test Client ENG',First_Name__c='Test Client',Last_Name__c='ENG',Client__c=testClient.id,Email__c='test1040@SFDC.com');
               insert testContact;    
                      
          Job__c testJob1=new Job__c(Job_Auto_Number__c='1040',Name='Test Job 1040',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id,Schedule_Calc__c='Start Date');
               insert testJob1;
          System.assertEquals('Test Job 1040',testJob1.Name);     
               
          GL_Department__c testGLD = new GL_Department__c(Name='GLD020');
           
               insert testGLD;
           
          GL_Code__c testGL=new GL_Code__c(Name='GL1040',GL_ID__c='GLC1040',GL_Department__c = testGLD.id);
           
                 insert testGL;
           
           Job_Task__c testJT=new Job_Task__c(Name='Test JT 1040',Days__c=2,GL_Code__c=testGL.id,Job__c=testJob1.id,Start_Date__c=System.Today());
           insert testJT;
          
           Job_Task__c testJT11=new Job_Task__c(Name='TestJT1189',Days__c=2,GL_Code__c=testGL.id,Job__c=testJob1.id,Start_Date__c=System.Today());
               
           ApexPages.currentPage().getParameters().put('id',testJT.id);    
           
           extension_JobTaskAboveNew  ext=new extension_JobTaskAboveNew ();
         
           ext.getGLCodes();
           ext.getGLCName();
           ext.setGLCName(testGL.id);
           ext.objJobTask=testJT11;
           ApexPages.Pagereference result1=ext.saveme();
           ApexPages.Pagereference result=ext.cancelme();  
           
          Job__c testJob2=new Job__c(Name='Test Job 1012',Start_Date__c=System.Today(),Due_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id,Schedule_Calc__c='End Date');
          insert testJob2;
          
            Job_Task__c testJobTask2=new Job_Task__c(Name='JT019',Job__c=testJob2.Id,Days__c=3,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask2;
         // Job_Task__c testJobTask4=new Job_Task__c(Name='JT029',Job__c=testJob2.Id,Days__c=5,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
         // insert testJobTask4;
         // Job_Task__c testJobTask5=new Job_Task__c(Name='JT021',Job__c=testJob2.Id,Days__c=1,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
         // insert testJobTask5;
         
          Job_Task__c testJobTask3=new Job_Task__c(Name='JT020',GL_Code__c=TestGL.id,Days__c=2);
           
            ApexPages.currentPage().getParameters().put('id',testJobTask2.Id);
        // con=new ApexPages.StandardController(testJobTask3);
        
       // Instantiate the extention instance with the standardcontroller 
           //ext=new extension_JobTask(con);
              ext=new extension_JobTaskAboveNew ();
         
         ext.getGLCodes();
           ext.getGLCName();
           ext.setGLCName(testGL.id);
            ext.objJobTask=testJobTask3;
           result1=ext.saveme();    
           result=ext.cancelme();
           
          
  }  */
// End of Test Method
}
// End of Class