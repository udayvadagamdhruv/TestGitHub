// Extension class for Edit ScheduleTask 
public with sharing class EditScheduleTaskExtension 
{
    // Global Variables
    
 /*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    @TestVisible String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    private final Schedule_Task__c sc; 
    // End of Global variables 

    // Standard Controller Extension
     public EditScheduleTaskExtension(ApexPages.StandardController con)
    {
        this.sc=(Schedule_Task__c)con.getrecord();
        Schedule_Task__c abc = [select id,Name,GL_Code__c from Schedule_Task__c  where id =: sc.id];
        GLCName = abc.GL_Code__c;
    }
    // End of Standard Controller Extension 
 
     // This method populate GLCodes into picklist
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
    // End getGLCodes method 
 
   // Method called on to update Schedule Task
    Public PageReference saveme()
    {
        try
        {
            String strid;
            
            if(GLCName == null)
            {
            
                              if(schema.SobjectType.Schedule_Task__c.Fields.GL_Code__c.isUpdateable()){ sc.GL_Code__c = null;}
            }
            else
            {     
                GL_Code__c gc=[Select Id,Name from GL_Code__c where Id=:GLCName];
                   if(schema.SobjectType.Schedule_Task__c.Fields.GL_Code__c.isUpdateable()){ sc.GL_Code__c=gc.Id;}
            } 
                   if(Schema.sObjectType.Schedule_Task__c.isUpdateable()){ update sc; }
                       
            strid = sc.Schedule_Template__c;        
            
            if(isLtng)
            {
                PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+strid);
                p.setRedirect(true);
                return p; 
            }
            else
            {
                PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverride?id='+strid);
                p.setRedirect(true);
                return p;
            }
            
            
            
        }
        catch(System.DMLException e)
        {
            return null;
        }
    }
    // End of Update Method
    
    
    
    // This method is used to handle Cancel button
    public Pagereference Cancel()
    {
    
        string strid = sc.Schedule_Template__c;       
        if(isLtng)
        {
            PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+strid);
            p.setRedirect(true);
            return p; 
        }
        else
        {
            PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverride?id='+strid);
            p.setRedirect(true);
            return p;
        }
            
    }
    // End Cancel method
    */
   
 
}// End of Class