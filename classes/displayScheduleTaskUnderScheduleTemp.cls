// This class is used to display Schedule Tasks under selected Schedule Template
public with sharing class displayScheduleTaskUnderScheduleTemp
{
    // Global variables 
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    
    public Id schId{get;set;}
    public String strSTID{get;set;}
    public string selectedTaskId{get;set;}
    public List<Schedule_Task__c> lstST{get;set;}
    // End of Global variables
   
   // Start Constructor 
    public displayScheduleTaskUnderScheduleTemp()
    {
        LoadData();
    }
    // End constructor
    
    // This method is called on to retrieve all tasks related to selected Schedule Template
     public void LoadData()
     {
       schId=ApexPages.CurrentPage().getParameters().get('Id');
       lstST=[Select Id,Name,Days__c,GL_Code__c,Locked__c,Report__c,Roles__c ,Hours__c ,Schedule_Template__c,Task_Order__c from Schedule_Task__c where Schedule_Template__c=:schId Order By Task_Order__c];
     }
   // End LoadData method
   
   // This method is called on to handle insertTask at the last
   public pagereference insertTaskBelow()
   {
      Id ScheduleTempId=ApexPages.CurrentPage().getParameters().get('id');
       Pagereference p;
        if(isLtng)
        {
              p=Page.insertScheduleTaskLastLightning;
        }
        else
        {
               p=Page.insertScheduleTaskLast;
             
        }
        p.setRedirect(true);
        p.getParameters().put('ScheduleTempId',ScheduleTempId);
        return p;
      
     
   }
   //End method insertTaskBelow
   
   // This method is called on to DeleteTask
   public Pagereference DeleteTask()
   {
       Pagereference p=new Pagereference('/apex/DeleteScheduleTask?id='+strSTID);
       p.setRedirect(true);
       return p;
   }
   // End method DeleteTask
   
   // This Edit Task method is called on to handle EditTask
   public Pagereference EditTask()
   {
        if(isLtng)
        {
               Pagereference p=new Pagereference('/apex/editScheduleTaskLightning?id='+strSTID);
               p.setRedirect(true);
               return p;
        }
        else
        {
               Pagereference p=new Pagereference('/apex/editScheduleTask?id='+strSTID);
               p.setRedirect(true);
               return p;
        }
      
   }
   // End EditTask
   
   // This Save method is called on to handle save button
   public pagereference save()
   {
     try
     {
          update lstST;
     }
     catch(System.DMLException e){return null;}
       
        if(isLtng)
        {
                Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+schId);
                p.setRedirect(true);
                return p;
        }
        else
        {
                Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverride?id='+schId);
                p.setRedirect(true);
                return p;
        }
   }
   // End Save method
   
  // This method is called on to handle Cancel button
   public Pagereference cancel()
   {
   
        if(isLtng)
        {
                Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+schId);
                p.setRedirect(true);
                return p;
        }
        else
        {
                Pagereference p=new Pagereference('/apex/ScheduleTemplateTabOverride?id='+schId);
                p.setRedirect(true);
                return p;
        }
   
       
   }
   // End cancel method
   
   // This method is called on to insertTask
   
   public pagereference insertTask()
   {
         Id ScheduleTempId=ApexPages.CurrentPage().getParameters().get('id');
         
            if(isLtng)
            {
                  Pagereference p=Page.CreateNewScheduleTaskAboveLightning;
                  p.setRedirect(true);
                  p.getParameters().put('ScheduleTaskId',strSTID);
                  return p;
            }
            else
            {
                  Pagereference p=Page.CreateNewScheduleTaskAbove;
                  p.setRedirect(true);
                  p.getParameters().put('ScheduleTaskId',strSTID);
                  return p;
            }
         
         
          
   }
   // End method insertTask
 /*  
  // Start Test Coverage Code  
    static testMethod void Test_displayScheduleTaskUnderScheduleTemp()
    {         
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1007');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1007',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schedule Task 1007',Days__c=2,Schedule_Template__c=testST.id);
                insert testSchedule;
                
          System.assertEquals('Test Schedule Task 1007',testSchedule.Name);   

          
          // Instantiate the extention instance with the Custom Controller
          
          displayScheduleTaskUnderScheduleTemp ext=new displayScheduleTaskUnderScheduleTemp();
          
          ext.LoadData();
          
      // Invoke the primary methods on the extension        
          ApexPages.pagereference result=ext.save();
            result=ext.Cancel();
            result=ext.editTask();
            result=ext.insertTask();
            result=ext.insertTaskBelow();
            ext.selectedTaskId=testSchedule.id;
            ext.DeleteTask();
            ext.selectedTaskId=NULL;
            ext.DeleteTask();
            Schedule_Task__c st=[Select id from Schedule_Task__c where id=:testSchedule.id limit 1];
            delete st;
            ext.save();
            ext.LoadData();
    }// End of Test Coverage Code */
}
// End of Class