// This class is used to create Duplicate Schedule Template for selected Schedule Template
public with sharing class DuplicateScheduletemplateExtensionNew
{
    //Global variables
    String ScheduleTemplateID,UserName;
    Schedule_Template__c objST{get;set;}
    public boolean isError {get;set;}
    public String oldScheduleTemplateId{get;set;} 
    string MediaType,ScheduleTemplateName;
    boolean isActive;
    //end global variables
    Public Pagereference pr {get;set;}
    
    
    
    //constructor
    public DuplicateScheduletemplateExtensionNew(ApexPages.StandardController controller) 
    {
        isError=False;
        this.objST = (Schedule_Template__c)controller.getRecord();
        UserName = UserInfo.getName();
        
        pr = new ApexPages.StandardController(objST).view();
        
        //retrieve the old job data
        Schedule_Template__c objOldST = [select id,Name,Media_Types__c,Active__c from Schedule_Template__c where id =: objST.id WITH SECURITY_ENFORCED Limit 1];
        oldScheduleTemplateId = objOldST.id;
        // ScheduleTemplateName = 'Duplicate : ' + ' ' + objOldST.Name + ' ' + 'Created By :' + UserName ;
        ScheduleTemplateName ='Dup : '+DateTime.Now()+' '+objOldST.Name ;
        //Code modify to Concatinate the Dup Name
        if(ScheduleTemplateName.length() > 80)
        {
            ScheduleTemplateName = ScheduleTemplateName.substring(0,80);
        }
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
        System.debug('duplicateScheduleTemplate Method Enter');   
        try
        {
            //insert the schedule template
            Schedule_Template__c dupScheduleTemplate = new Schedule_Template__c ();  
            if(Schema.sObjectType.Schedule_Template__c.fields.Name.isCreateable()) {
               dupScheduleTemplate.Name=ScheduleTemplateName;  
            }
             if(Schema.sObjectType.Schedule_Template__c.fields.Media_Types__c.isCreateable()) {
                dupScheduleTemplate.Media_Types__c=MediaType;
            }
             if(Schema.sObjectType.Schedule_Template__c.fields.Active__c.isCreateable()) {
                dupScheduleTemplate.Active__c =isActive ;
            }
              
            
            if(Schema.sObjectType.Schedule_Template__c.isCreateable()){
                    insert dupScheduleTemplate ;}
            
            
            //insert the schedule template task   
            System.debug('Schedule Template Inserted Successfully'+ MediaType );   
            
            List<Schedule_Task__c> insertScheduleTask = new List<Schedule_Task__c>();
            List<Schedule_Task__c> lstST=new List<Schedule_Task__c>();
            Set<Id> oldTaskId = new Set<Id>();
            Map<String,Id> map1 = new Map<String,Id>();
            Map<Id,Id> map2 = new Map<Id,Id>();
            
            
            lstST=[Select id,Name,GL_Code__c,Report__c,Locked__c,Days__c, Task_Order__c from Schedule_Task__c where Schedule_Template__c =:oldScheduleTemplateId WITH SECURITY_ENFORCED];
            
            for(Schedule_Task__c task : lstST)
            {
                oldTaskId.add(task.id);
                Schedule_Task__c objSTask = new Schedule_Task__c();
                if(Schema.SObjectType.Schedule_Task__c.Fields.Name.isCreateable()){
                    objSTask.Name = task.Name;
                }
                if(Schema.SObjectType.Schedule_Task__c.Fields.GL_Code__c.isCreateable()){
                    objSTask.GL_Code__c = task.GL_Code__c;
                }
                if(Schema.SObjectType.Schedule_Task__c.Fields.Report__c.isCreateable()){
                    objSTask.Report__c = task.Report__c;
                }
                if(Schema.SObjectType.Schedule_Task__c.Fields.Locked__c.isCreateable()){
                    objSTask.Locked__c = task.Locked__c;
                }
                if(Schema.SObjectType.Schedule_Task__c.Fields.Days__c.isCreateable()){
                    objSTask.Days__c = task.Days__c;
                }
                if(Schema.SObjectType.Schedule_Task__c.Fields.Task_Order__c.isCreateable()){
                    objSTask.Task_Order__c = task.Task_Order__c;
                }
                if(Schema.SObjectType.Schedule_Task__c.Fields.Schedule_Template__c.isCreateable()){
                    objSTask.Schedule_Template__c = dupScheduleTemplate.id;
                }
                
                map1.put(task.Name,task.id);
                insertScheduleTask.add(objSTask);
            }
            if(Schema.sObjectType.Schedule_Task__c.isCreateable()){
                insert insertScheduleTask;
            }
            
            System.debug('Schedule task record are inserted');
            
            //insert the schedule template roles
            for(Schedule_Task__c st : insertScheduleTask)
            {
                map2.put(map1.get(st.Name),st.Id);
            }
            
            List<ScheduleTaskRole__c> lstSTR=[Select id,Name,Schedule_Task__c from ScheduleTaskRole__c where Schedule_Task__c IN:OldTaskId WITH SECURITY_ENFORCED];
            
            List<ScheduleTaskRole__c> insertSTR=new List<ScheduleTaskRole__c>();
            
            for(ScheduleTaskRole__c taskRole:lstSTR)
            {
                ScheduleTaskRole__c objSTR=new ScheduleTaskRole__c();
                if(Schema.SObjectType.ScheduleTaskRole__c.Fields.Name.isCreateable()){
                    objSTR.Name=taskRole.Name;
                }
                if(Schema.SObjectType.ScheduleTaskRole__c.Fields.Schedule_Task__c.isCreateable()){
                    objSTR.Schedule_Task__c = map2.get(taskRole.Schedule_Task__c);
                }
                insertSTR.add(objSTR);
            }
            if(Schema.sObjectType.ScheduleTaskRole__c.isCreateable()){
                insert insertSTR;
            }
            
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
    
 
}