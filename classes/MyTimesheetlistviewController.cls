public with sharing class MyTimesheetlistviewController 
{

 

    public MyTimesheetlistviewController(ApexPages.StandardController controller) {
    String strGetUserName=UserInfo.getUserName();
         User u=[Select id,Name from User where Username=: strGetUserName];
         String strId=u.id;
         
        /*  lstTsEntry= [select id,name,Task_Name__c,CreatedById from Timesheet_Entries__c  where CreatedById=:strId order by name  LIMIT :blockSize OFFSET :index];*/
         totalRecs = [select count() from Timesheet_Entries__c  where CreatedById=:strId];
 

    }

    public integer totalRecs{get;set;}    
    private integer index = 0;
    private integer blockSize = 10;  
    public List<Timesheet_Entries__c> lstTsEntry{get;set;}

  public string HomePage;


    
     public List<Timesheet_Entries__c> getTsEnty() 
    {
    
         String strGetUserName=UserInfo.getUserName();
         User u=[Select id,Name from User where Username=: strGetUserName];
         String strId=u.id;
         lstTsEntry= [select id,name,Task_Name__c,GL_Code__c,Hours_Worked__c,Date__c ,Job__r.Job_Auto_Number__c,Job__r.Name,CreatedById from Timesheet_Entries__c  where CreatedById=:strId  order by name DESC LIMIT :blockSize OFFSET :index];
      
        return lstTsEntry;
    }  
    
    
    public PageReference NewMethod()
    {
        String th = userinfo.getUiTheme();
          PageReference p;
         if(th == 'Theme4d')
              p=new PageReference('/apex/TimesheetEntriesLightning?Page=HomePage');
         else
          p=new PageReference('/apex/TimesheetEntries?Page=HomePage');
          p.setRedirect(true); 
          return p;
    }
    
    
    public void beginning()
    {
        index = 0;
    }
    
    public void previous()
    {
        index = index - blockSize;
    }
    
    public void next()
    {
        index = index + blockSize;
    }

    public void end()
    {
        index = totalrecs - math.mod(totalRecs,blockSize);
    }        
    
    public boolean getprev()
    {
        if(index == 0)
        return true;
        else
        return false;
    }  
    
    public boolean getnxt()
    {
        if((index + blockSize) >= totalRecs)
        return true;
        else
        return false;
    }     
    




}