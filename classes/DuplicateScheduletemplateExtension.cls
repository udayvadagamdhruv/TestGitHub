// This class is used to create Duplicate Schedule Template for selected Schedule Template
public with sharing class DuplicateScheduletemplateExtension 
{
   /* //Global variables
    String ScheduleTemplateID,UserName;
    Schedule_Template__c objST{get;set;}
    public boolean isError {get;set;}
    public String oldScheduleTemplateId{get;set;} 
    string MediaType,ScheduleTemplateName;
    boolean isActive;
    //end global variables
    Public Pagereference pr {get;set;}



    //constructor
    public DuplicateScheduletemplateExtension(ApexPages.StandardController controller) 
    {
         isError=False;
         this.objST = (Schedule_Template__c)controller.getRecord();
         UserName = UserInfo.getName();
         
         pr = new ApexPages.StandardController(objST).view();
         
         //retrieve the old job data
         Schedule_Template__c objOldST = [select id,Name,Media_Types__c,Active__c from Schedule_Template__c where id =: objST.id Limit 1];
         oldScheduleTemplateId = objOldST.id;
         ScheduleTemplateName = 'Duplicate : ' + ' ' + objOldST.Name + ' ' + 'Created By :' + UserName ;
         MediaType = objOldST.Media_Types__c;
         isActive = objOldST.Active__c;
         
         System.debug('oldScheduleTemplateId '+ oldScheduleTemplateId );
         System.debug('isActive '+ isActive );
         System.debug('ScheduleTemplateName '+ ScheduleTemplateName );
         System.debug('MediaType '+ MediaType );   
         
       
    }
    //end constructor
    
    // Method called to insert duplicate of selected Schedule Template
    Public PageReference duplicateScheduleTemplate()
    {
     try
            {
            //insert the schedule template
               Schedule_Template__c dupScheduleTemplate = new Schedule_Template__c (Name=ScheduleTemplateName ,Media_Types__c=MediaType ,Active__c =isActive );  
               insert dupScheduleTemplate ;
               
               
            //insert the schedule template task   
               System.debug('Schedule Template Inserted Successfully'+ MediaType );   
                           
             List<Schedule_Task__c> insertScheduleTask = new List<Schedule_Task__c>();
             List<Schedule_Task__c> lstST=new List<Schedule_Task__c>();
             Set<Id> oldTaskId = new Set<Id>();
             Map<String,Id> map1 = new Map<String,Id>();
             Map<Id,Id> map2 = new Map<Id,Id>();
             
             
             lstST=[Select id,Name,GL_Code__c,Report__c,Locked__c,Days__c, Task_Order__c from Schedule_Task__c where Schedule_Template__c =:oldScheduleTemplateId];
             
              for(Schedule_Task__c task : lstST)
               {
                  oldTaskId.add(task.id);
                  Schedule_Task__c objSTask = new Schedule_Task__c();
                  objSTask.Name = task.Name;
                  objSTask.GL_Code__c = task.GL_Code__c;
                  objSTask.Report__c = task.Report__c;
                  objSTask.Locked__c = task.Locked__c;
                  objSTask.Days__c = task.Days__c;
                  objSTask.Task_Order__c = task.Task_Order__c;
                  objSTask.Schedule_Template__c = dupScheduleTemplate.id;
                  
                  map1.put(task.Name,task.id);
                  insertScheduleTask.add(objSTask);
               }
               insert insertScheduleTask;
               
               System.debug('Schedule task record are inserted');
               
               //insert the schedule template roles
               for(Schedule_Task__c st : insertScheduleTask)
               {
                    map2.put(map1.get(st.Name),st.Id);
               }
                
                  List<ScheduleTaskRole__c> lstSTR=[Select id,Name,Schedule_Task__c from ScheduleTaskRole__c where Schedule_Task__c IN:OldTaskId];
                    
                  List<ScheduleTaskRole__c> insertSTR=new List<ScheduleTaskRole__c>();
                    
                  for(ScheduleTaskRole__c taskRole:lstSTR)
                  {
                         ScheduleTaskRole__c objSTR=new ScheduleTaskRole__c();
                         objSTR.Name=taskRole.Name;
                         objSTR.Schedule_Task__c = map2.get(taskRole.Schedule_Task__c);
                         insertSTR.add(objSTR);
                  }
                 insert insertSTR;
                
                 System.debug('Schedule Task Roles are inserted');
               //  PageReference p =  new PageReference('https://jobsuite.cs14.visual.force.com/apex/ScheduleTemplateTabOverride?id='+dupScheduleTemplate.id  +'&intFocus=1');
               //    p.setRedirect(true);
               //    return p; 
                return new ApexPages.StandardController(dupScheduleTemplate).view();
               
            }
        catch(System.DMLException e)
            {
              isError = True;
              return NULL;
            }   
    }
    
    public PageReference AfterError() 
    {
        return new ApexPages.StandardController(objST).view();
    }
    
    static testMethod void Test_DuplicateScheduleTemplateExtension()
    {
        
         // Insert required data to test DuplicateScheduletemplateExtension class
        
           Media_Type__c testMedia=new Media_Type__c(Name='TM1232');
           insert testMedia;
          
           Schedule_Template__c testST=new Schedule_Template__c(Name='ST1232',Media_Types__c=testMedia.Id);
           insert testST;           
           
           Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST1232',Schedule_Template__c=testST.Id,Days__c=2);
           insert testSCT1;
                 
           Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST1233',Schedule_Template__c=testST.Id,Days__c=1);
           insert testSCT2;
                 
           ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Role1',Schedule_Task__c=testSCT1.Id);
           insert testSTR1;
                 
           ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='Role2',Schedule_Task__c=testSCT2.Id);
           insert testSTR2;
           
           ApexPages.CurrentPage().getParameters().put('id',testST.id);
           
           ApexPages.StandardController con=new ApexPages.StandardController(testST);
           
           // Instantiate the extention instance with the standardcontroller   
           DuplicateScheduletemplateExtension ext=new DuplicateScheduletemplateExtension(con);
         
           // Invoke methods on the extension
          
           ApexPages.Pagereference result1=ext.duplicateScheduleTemplate();
           result1=ext.AfterError(); 
           result1=ext.duplicateScheduleTemplate();
           
    }/*/
}