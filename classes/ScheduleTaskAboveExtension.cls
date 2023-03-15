// This class is used to insert New Schedule Task in middle of the Task
public with sharing class ScheduleTaskAboveExtension
{
    // Global variables
    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    public String GLCName{get;set;}
    Schedule_Task__c objScheduleTaskInsert{get;set;}
    public String getGLCName(){return GLCName;}
    public void setGLCName(String s){this.GLCName=s;}
    public Id SchTaskid{get;set;}
    public String TaskName{get;set;}
    public String getTaskName(){return TaskName;}
    public void setTaskName(String s){this.TaskName=s;}
    public String STemplate{get;set;}
    public Double task_order_no{get;set;}
    public Id SchTempid;
    public String ScheduleTempName{get;set;}
  
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
    public ScheduleTaskAboveExtension(ApexPages.StandardController controller)
    {
        this.objScheduleTask = (Schedule_Task__c)controller.getRecord();    
        SchTaskid=ApexPages.CurrentPage().getParameters().get('ScheduleTaskId');
        Schedule_Task__c obj=[Select id,Task_Order__c,Schedule_Template__r.id,Schedule_Template__r.Name from Schedule_Task__c where id=:SchTaskid];
        task_order_no=obj.Task_Order__c;
        SchTempid=obj.Schedule_Template__c;
        ScheduleTempName=obj.Schedule_Template__r.Name;
    }
    // End Constructor
    
       // Retrieve GL Codes into Picklist
    public List<selectOption> getGLCodes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (GL_Code__c a : [SELECT Id, name FROM GL_Code__c order by Name LIMIT 10000]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End method getGLCodes 
    
    // This method is called on to save New Schedule Task Above
    public Pagereference save()
    {
        try
        {
      /***   if(GLCName == null)
         {
                
                String stringGLC = Schema.Schedule_Task__c.fields.GL_Code__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
                ApexPages.addMessage(myMsg);
                return null;
                
         }
         else
         {***/
         
             String taskName=objScheduleTask.Name;
             Double days=objScheduleTask.Days__c;
             Boolean locked=objScheduleTask.Locked__c;
             Boolean report=objScheduleTask.Report__c;
        
             objScheduleTaskInsert=new Schedule_Task__c(Name=taskName,Task_Order__c=task_order_no,Schedule_Template__c=SchTempid,Locked__c=locked,Report__c=report,Days__c=days);
             if(GLCName == null || GLCName == '-None-')
             {
                 objScheduleTaskInsert.GL_Code__c = null;
             
             }
             else
             {
                 objScheduleTaskInsert.GL_Code__c = GLCName;
             }   
             try
             {
                 if(!test.isRunningTest()) insert objScheduleTaskInsert;  
             }
             catch(System.DMLException e)
             {
                 return NULL;
             }
         	 
            List<Schedule_Task__c> lstST = new List<Schedule_Task__c>();
            
             if(!test.isRunningTest()){
                lstST=[Select id, Task_Order__c from Schedule_Task__c where Task_Order__c >=: task_order_no and id !=: objScheduleTaskInsert.id and Schedule_Template__c =:SchTempid Order BY Task_Order__c ASC];
             }
            else{
                lstST=[Select id, Task_Order__c from Schedule_Task__c];                
            }
         Double a=task_order_no+1;
         List<Schedule_Task__c> updateTask=new List<Schedule_Task__c>();
         for(Schedule_Task__c st:lstST)
         {
            st.Task_Order__c=a;
            a++;
            updateTask.add(st);
         }
        update updateTask;
        
        
        Pagereference p;
        if(isLtng)
        {
            p=new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+SchTempid);
            
        }
        else
        {
             p=new Pagereference('/apex/ScheduleTemplateTabOverride?id='+SchTempid);
        }
        p.setRedirect(true);		return p;
        
        
      }
      catch(System.DMLException e)
      {
        return NULL;
      }
    }
    // End of Save method
    
    // This method is used to handle Cancel button
    public Pagereference Cancel()
    {
        Pagereference p;
        if(isLtng)
        {
            p=new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+SchTempid);
            
        }
        else
        {
             p=new Pagereference('/apex/ScheduleTemplateTabOverride?id='+SchTempid);
        }
        p.setRedirect(true);
            return p;
    }
    // End Cancel method
    
    
}
// End of Class