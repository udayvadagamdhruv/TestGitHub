// This class is used to add new Task at the bottom of the list
public with sharing class insertScheduleTaskLastExtension 
{
    // Global variables
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    public String GLCName{get;set;}
    public String getGLCName(){return GLCName;}
    public void setGLCName(String s){this.GLCName=s;}
    public Id SchTempid{get;set;}
    public String TaskName{get;set;}
    public String getTaskName(){return TaskName;}
    public void setTaskName(String s){this.TaskName=s;}
    public String STemplate{get;set;}
    
  //  public list<Schedule_Task__c> SchedTaskList{get;set;}

    public Schedule_Task__c objScheduleTask
    {
        get{if(objScheduleTask==NULL)
        objScheduleTask=new Schedule_Task__c();
        objScheduleTask.GL_Code__c=GLCName;
        
        return objScheduleTask;
        }
        set;
    }
    
     // End Global variables
    
      // Start Constructor
    public insertScheduleTaskLastExtension(ApexPages.StandardController controller)
    {
        this.objScheduleTask = (Schedule_Task__c)controller.getRecord();    
        SchTempid=ApexPages.CurrentPage().getParameters().get('ScheduleTempId');
        STemplate=[Select Name from Schedule_Template__c where id=: SchTempid].Name;
        System.debug('@@@@@'+SchTempid);
      //  SchedTaskList=[select id,name,Schedule_Template__c from Schedule_Task__c where Schedule_Template__c=:SchTempid];
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
    
    // This method is called on to insert SChedule Task at the last
    
    public Pagereference save()
    {
       
        System.debug('@@@@@'+SchTempid);
        Double task_order_no;
        List<Schedule_Task__c> lstST=[Select id from Schedule_task__c where Schedule_Template__c=: SchTempid];
        
        if(!lstST.isEmpty())
        {
            Schedule_Task__c objScheduleTask1=[Select id,Name,Task_Order__c,Schedule_Template__c from Schedule_Task__c where Schedule_Template__c=:SchTempid order by Task_Order__c DESC limit 1];
            task_order_no=objScheduleTask1.Task_Order__c;
        }
        else
        {
            task_order_no=0;
        }    
        try
        {  
        String taskName=objScheduleTask.Name;
            Double days=objScheduleTask.Days__c;
            Boolean locked=objScheduleTask.Locked__c;
            Boolean report=objScheduleTask.Report__c;
            
            
           /** if(GLCName == null)
            {
                String stringGLC = Schema.Schedule_Task__c.fields.GL_Code__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
                ApexPages.addMessage(myMsg);
                return null;
                //objScheduleTaskInsert.GL_Code__c = null;
                
            }**/
          //else
           // {
                 
             Schedule_Task__c objScheduleTaskInsert=new Schedule_Task__c(Name=taskName,Task_Order__c=task_order_no+1,Schedule_Template__c=SchTempid,Locked__c=locked,Report__c=report,Days__c=days,GL_Code__c = GLCName);   
             try
             {
                 insert objScheduleTaskInsert;  
             }
             catch(System.DMLException e)
             {
                 return NULL;
             }
             //}
                     
      //}
          // AFter inserting Schedule Tas, navigate to Schedule Template detail page
      
            if(isLtng)
            {
                    Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+SchTempid);
                    p.setRedirect(true);
                    return p;
            }
            else
            {
                    Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverride?id='+SchTempid);
                    p.setRedirect(true);
                    return p;
            }
      
      
      
        
      }
      catch(System.DMLException e)
      {
        return NULL;
      }
    }
    // ENd Save method
    
    // This method is called on to handle Cancel button 
    
    public Pagereference Cancel()
    {
        if(isLtng)
        {
                Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+SchTempid);
                p.setRedirect(true);
                return p;
        }
        else
        {
                Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverride?id='+SchTempid);
                p.setRedirect(true);
                return p;
        }
    }
    // End of Cancel method

    // Start Test Coverage
    static testMethod void Test_insertScheduleTaskLastExtension()
    {
     // Insert all required data to test functionality 
        Schedule_Template__c testST1=new Schedule_Template__c(Name='Testing Schedule Template 1101',Active__c=True);
        try
        {
            insert testST1;
            System.debug('Schedule Template record inserted successfully@@@ '+testST1);
        }
        catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Schedule Template with same name Exists'));
        }
        
        GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1101');
        try
        {
            insert testGLD;
        }
        catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
        
        GL_Code__c testGL=new GL_Code__c(Name='GL Code 1101',GL_ID__c='TestGL9988',GL_Department__c = testGLD.id);
        try
        {
            insert testGL;
            System.debug('GL Code inserted successfully@@@ '+testGL);
        }
        catch(System.DMLException e)
        {
            System.debug(e.getMessage());
        }
        
        Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 1101',Schedule_Template__c=testST1.Id,GL_Code__c = testGL.id,Days__c=2,Task_Order__c=1);
        
        try
        {
            insert testSCT1;
            System.debug('Schedule Task record inserted successfully@@@ '+testSCT1);
        }
        catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Schedule Task with same name Exists'));
        } 
            
         
         System.assertEquals('Test Schedule Task 1101',testSCT1.Name);
         
         // Instantiate the standard controller with the Schedule Task 
         ApexPages.CurrentPage().getParameters().put('ScheduleTempId',testST1.id);
         ApexPages.StandardController con=new ApexPages.StandardController(testSCT1);
        
        // Instantiate the extention instance with the standard controller
        insertScheduleTaskLastExtension ext=new insertScheduleTaskLastExtension(con);
        
        ext.setTaskName(testSCT1.id);
        ext.getTaskName();
        ext.GLCName = NULL; // to check GLCode as NULL
        String GLCName1 = ext.getGLCName();
        ext.setGLCName(GLCName1);
        List<SelectOption> options1 = ext.getGLCodes(); 
        ApexPages.PageReference result=ext.save();
        
        ext.GLCName = testGL.id;
        String GLCName = ext.getGLCName();        
        ext.setGLCName(GLCName);
        List<SelectOption> options = ext.getGLCodes(); 
        
        // Invoke the primary method on the extension
        result=ext.save();
        result=ext.cancel();
    }
    // End of Test Method
}
// End of Class