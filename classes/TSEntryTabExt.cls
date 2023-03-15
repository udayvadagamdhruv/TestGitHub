public with sharing class TSEntryTabExt{

   /* public integer totalRecs{get;set;}    
    private integer index = 0;
    public integer blockSize {set;get;}  
    public List<Timesheet_Entries__c> lstTsEntry{get;set;}
    public integer pageNo {set;get;}
    public integer totalpages {set;get;}
    public decimal totalHrs {get;set;}
    public decimal  TotalThisWeekTime {get;set;}
    public string Timesheetid{get;set;}
    

    public TSEntryTabExt(ApexPages.StandardSetController controller)
    {
        blockSize=10;
        pageNo=1;
        String strGetUserName=UserInfo.getUserName();
         User u=[Select id,Name from User where Username=: strGetUserName];
         String strId=u.id;
         
        /*  lstTsEntry= [select id,name,Task_Name__c,CreatedById from Timesheet_Entries__c  where CreatedById=:strId order by name  LIMIT :blockSize OFFSET :index];*/
       /*  totalRecs = [select count() from Timesheet_Entries__c  where CreatedById=:strId];
        // totalHrs = double.valueOf([select sum(Hours_Worked__c) from Timesheet_Entries__c where CreatedById=:strId]);
         
         AggregateResult[] groupedResults = [SELECT sum(Hours_Worked__c)Totalhrs from Timesheet_Entries__c where CreatedById=:strId];
         totalHrs =  groupedResults[0].get('Totalhrs')==null?0:(decimal)groupedResults[0].get('Totalhrs');
         
         AggregateResult[] groupedResultsThisWeek = [SELECT sum(Hours_Worked__c)ThisWeekHours from Timesheet_Entries__c where CreatedById=:strId and  Date__c = THIS_WEEK];
         TotalThisWeekTime = groupedResultsThisWeek[0].get('ThisWeekHours')==null?0:(decimal) groupedResultsThisWeek [0].get('ThisWeekHours');
    }
    
  /*
     public ApexPages.StandardSetController setCon {
        get {
            if (setCon == null) {
                  String strGetUserName=UserInfo.getUserName();
                    User u=[Select id,Name from User where Username=: strGetUserName];
                    String strId=u.id;
                blockSize= 20;
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [select id,name,Task_Name__c,Job__c,Job__r.Job_Auto_Number__c,Date__c,Hours_Worked__c,CreatedById from Timesheet_Entries__c  where CreatedById=:strId  order by name DESC]));
                setCon.setPageSize(blockSize);
                totalRecs= setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }
    */
    
  /*   public List<Timesheet_Entries__c> getTsEnty() 
    {
    
         String strGetUserName=UserInfo.getUserName();
         User u=[Select id,Name from User where Username=: strGetUserName];
         String strId=u.id;
         lstTsEntry= [select id,name,Task_Name__c,Job__c,Job__r.Job_Auto_Number__c,Date__c,Hours_Worked__c,CreatedById from Timesheet_Entries__c  where CreatedById=:strId  order by name DESC];
        
         totalpages=(Integer)((Decimal)totalRecs/blockSize).round(RoundingMode.UP);
         
           AggregateResult[] groupedResults = [SELECT sum(Hours_Worked__c)Totalhrs from Timesheet_Entries__c where CreatedById=:strId];
         totalHrs =  groupedResults[0].get('Totalhrs')==null?0:(decimal)groupedResults[0].get('Totalhrs');
         
         AggregateResult[] groupedResultsThisWeek = [SELECT sum(Hours_Worked__c)ThisWeekHours from Timesheet_Entries__c where CreatedById=:strId and  Date__c = THIS_WEEK];
         TotalThisWeekTime = groupedResultsThisWeek[0].get('ThisWeekHours')==null?0:(decimal) groupedResultsThisWeek [0].get('ThisWeekHours');
         
         
        return lstTsEntry;
    }  
    
    
    public PageReference NewMethod()
    {
        PageReference p = new PageReference('/apex/TimesheetEntriesMobile?page=TimesheetListTab');
        p.setRedirect(true); 
        return p;
    }
    
    public PageReference EditMethod()
    {
        PageReference p = new PageReference('/apex/EditTimesheetEntryMobile?id='+Timesheetid);
        p.setRedirect(true); 
        return p;
    }
    
  /*  public void DelMethod()
    {
         Timesheet_Entries__c objTime = [select id,name,Task_Name__c,Job__c,Job__r.Job_Auto_Number__c,Date__c,Hours_Worked__c,CreatedById from Timesheet_Entries__c where id=:Timesheetid];
       //  delete objTime;
    }*/
    
    
  /*  public void beginning()
    {
        index = 0;
        pageNo=1;
    }
    
    public void previous()
    {
        index = index - blockSize;
        pageNo-=1;
    }
    
    public void next()
    {
        index = index + blockSize;
        pageNo+=1;
    }

    public void end()
    {
       if(math.mod(totalRecs,blockSize)!=0){
        index = totalrecs - math.mod(totalRecs,blockSize);
        }
        else{
        index = totalrecs -blockSize;
        }
        
        pageNo=totalpages;
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
    
    public void setindex(){
    
    index=0;
    pageNo=1;
    }
    
    
*/
}