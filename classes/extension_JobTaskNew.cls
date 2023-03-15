// This class is used to insert New Task at the last in the Schedule
public with sharing class extension_JobTaskNew
{ 
    // Global variables
  /*  public  Boolean isFirst=true;
    String GLCName;
    public Id jobId;
    public Job__c objJob{get;set;}
    private final Job_Task__c objJobTask1;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
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
    public extension_JobTaskNew(ApexPages.StandardController controller) 
    {
        this.objJobTask = (Job_Task__c)controller.getRecord();    
        jobid=ApexPages.CurrentPage().getParameters().get('jobid1'); 
        objJobTask.Job__c=jobid; 
    }
    // End constructor

   
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
       if(GLCName == null)
        {
          String strGLCName = Schema.Job_Task__c.fields.GL_Code__c.getDescribe().getLabel();
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strGLCName+' : You must select a '+strGLCName+'.');
          ApexPages.addMessage(myMsg);
          return null;
        }
       else
        {
         String strid;
         strid = objJobTask.Job__c; 
         try
          {
              Double task_order_no;
              List<Job_Task__c> lstJTNew=[Select id from Job_task__c where Job__c=: jobid];
                
                if(!lstJTNew.isEmpty())
                {
                    Job_Task__c objjobTask1=[Select id,Name,Task_Order__c,Job__c,Job__r.Schedule_Calc__c from Job_Task__c where Job__c=:jobid order by Task_Order__c DESC limit 1];
                    task_order_no=objjobTask1.Task_Order__c;
                }
                else
                {
                    task_order_no=0;
                }              
               String Name1=objJobTask.Name;
               Double days=objJobTask.Days__c;
               String strGLCode=objJobTask.GL_Code__c;
               
               Job_Task__c lstJobTask=[Select Id,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c from Job_Task__c where Job__c =: strid Order BY Revised_Due_Date__c DESC limit 1];
            
               Boolean blnForward = false;
               if(lstJobTask.Job__r.Schedule_Calc__c == GlobalClass.START_DATE || lstJobTask.Job__r.Due_Date__c == null)
               {
                  blnForward = true;
               } 
               
               Date d1;
               if(blnForward)
               {
                d1=Date.newInstance(lstJobTask.Revised_Due_Date__c.Year(),lstJobTask.Revised_Due_Date__c.Month(),lstJobTask.Revised_Due_Date__c.Day());
               }
               else
               {
                d1=Date.newInstance(lstJobTask.Job__r.Due_Date__c.Year(),lstJobTask.Job__r.Due_Date__c.Month(),lstJobTask.Job__r.Due_Date__c.Day());
               }
               Datetime dtDate = GlobalClass.CalculateDays(d1,blnForward,days);
               Date d6 = Date.newInstance(dtDate.Year(),dtDate.Month(),dtDate.Day());
                
               Job_Task__c objTaskNew = new Job_Task__c();
               if(blnForward)
                {
                  objTaskNew=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no+1,Due_Date__c=d6,Revised_Due_date__c=d6,GL_Code__c=strGLCode);
                }
               else
                {
                  objTaskNew=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d6,Task_Order__c=task_order_no+1,Due_Date__c=d1,Revised_Due_date__c=d1,GL_Code__c=strGLCode);
                }
               insert objTaskNew;
               if(!blnForward)
               {
                List<Job_Task__c> lst1=new List<Job_Task__c>();
                lst1=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c from Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no AND Id !=: objJobTask.Id ORDER BY Task_Order__c DESC];
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
                    
                    Date dtDueDate1=Date.newInstance(jt1.Revised_Due_Date__c.Year(),jt1.Revised_Due_Date__c.Month(),jt1.Revised_Due_Date__c.Day());
                    System.debug('Revised Due Date is :'+dtDueDate1);
                 Double days1 = jt1.Days__c;
                 dtDate = GlobalClass.CalculateDays(dtDueDate1,blnForward,days1 );
                 Date  d5 = Date.newInstance(dtDate.Year(),dtDate.Month(),dtDate.Day());
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
             
            PageReference p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=2');
            p.setRedirect(true);
            return p;
         }
     }
      
    // End method Save
    
   // This method is called on to handle Cancel button
    Public PageReference cancelme()
    {  
       PageReference p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=2');
       p.setRedirect(true);
       return p;
    } 
    // End method Cancel
  
  
    static testMethod void Test_extension_JobTaskNew()
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
        
          
        
        /* Instantiate the standard controller with the Job **
        ApexPages.currentPage().getParameters().put('jobid1',testJob1.Id);
        ApexPages.StandardController con=new ApexPages.StandardController(testJobTask1);
        
        /* Instantiate the extention instance with the standardcontroller *
          extension_JobTaskNew ext=new extension_JobTaskNew(con);
          ext.GLCName = testGL.id;
          String GLCName = ext.getGLCName();
          ext.setGLCName(GLCName);
          List<SelectOption> options = ext.getGLCodes(); 
        
      /* Invoke the primary method on the extension *
        ApexPages.PageReference result2=ext.cancelme();
        
         ApexPages.currentPage().getParameters().put('jobid1',testJob2.Id);
         con=new ApexPages.StandardController(testJobTask3);
        
        /* Instantiate the extention instance with the standardcontroller *
           ext=new extension_JobTaskNew(con);
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