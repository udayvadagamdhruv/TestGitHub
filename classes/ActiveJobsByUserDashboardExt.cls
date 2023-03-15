public with sharing class ActiveJobsByUserDashboardExt 
{

   /* public list<Job__c> lstjobs{get;set;}
    public integer totalRecs{get;set;}    
    private integer index = 0;
    private integer blockSize = 10;         
  

    public ActiveJobsByUserDashboardExt(ApexPages.StandardController controller) 
    {
         String strGetUserName=UserInfo.getUserName();
         User u=[Select id,Name from User where Username=: strGetUserName];
         String strId=u.id;
         totalRecs = [select count() from Job__c where (Name <> '' or Name <> Null) and Status__c='Active' and  CreatedById=:strId];   
         
    }
    
    
     public List<Job__c> getJobs() 
    {
    
         String strGetUserName=UserInfo.getUserName();
         User u=[Select id,Name from User where Username=: strGetUserName];
         String strId=u.id;
         lstjobs = [ Select id,Job_Auto_Number__c,name,Campaign__r.name,JS_Client__r.name from Job__c where (Name <> '' or Name <> Null) and Status__c='Active' and  CreatedById=:strId order by Job_Auto_Number__c LIMIT :blockSize OFFSET :index];
         
        return lstjobs ;
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
    
*/    

}