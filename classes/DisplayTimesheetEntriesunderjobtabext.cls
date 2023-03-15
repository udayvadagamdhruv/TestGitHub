/* Displaying Client invoice under job tab */

public with sharing class DisplayTimesheetEntriesunderjobtabext{

    public boolean isLtng{private set; get{
                                    String theme = UserInfo.getUITheme();
                                    return (theme=='Theme4d')?true:false;
                                  }
    }  
   
   
   
   // Global variables
    public string strID{get;set;}
    public String ciid{get;set;}
    public List<Timesheet_Entries__c> TimeSheetEnt{get;set;} 
    Public String theID;
    
    Public integer totalRecs = 0;
    Public integer OffsetSize =0;
    Public integer LimitSize= 50;
    public Integer noOfRecords {set;get;}
    public Integer size {set;get;}
   
    

   // Start constructor
    public DisplayTimesheetEntriesunderjobtabext()
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        totalRecs = [select count() from Timesheet_Entries__c where Job__c =: theID];
        TimeSheetEnt= [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name desc LIMIT :LimitSize OFFSET :OffsetSize];
    }
    

    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) { 
                size=30;               
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name desc]));
                setCon.setPageSize(size);  
                noOfRecords=setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
     
    //Changes the size of pagination
    
 
    // Initialize setCon and return a list of record    
     
    public List<Timesheet_Entries__c > getTimeSheetList() {
         return (List<Timesheet_Entries__c >) setCon.getRecords();
    }


   
     public PageReference CreateTsEntry()
    {
         String jobid;
         String theId=ApexPages.CurrentPage().getParameters().get('id');
         
         Job__c job = [Select Id from Job__c where id =: theID];
         jobid=job.Id;
         
         
            if(isLtng)
            {
                     PageReference p = Page.NewTimesheetEntriesLightning;
                     p.setredirect(true);
                     p.getParameters().put('jobid',theID); 
                     return p; 
            }
            else
            {
                     PageReference p = Page.NewTimesheetEntries;
                     p.setredirect(true);
                     p.getParameters().put('jobid',theID); 
                     return p;
            }
            
    }
     
     
      Sobject sumhrs; 

   public double getSumhrs()
   { 
        sumhrs= [SELECT SUM(Hours_Worked__c) sum FROM Timesheet_Entries__c WHERE Job__c =: [Select id from Job__c where id =: theID]];   
        return double.valueOf(sumhrs.get('sum')); 
    }  
    // End of method getSumCash
     
     
    
    public PageReference save()
    {
       try
       {
           update TimeSheetEnt;
       }
       catch(System.DMLException e){return null;}
     
           
      
      PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=15');
      p.setRedirect(true);
      return p; 
      
      
    }
    
    
    //Method to Delete  
    public Void del()
    {
       System.Debug('CIID======================='+ciid);
     try
     {
     
       Timesheet_Entries__c delci = [Select id,Name from Timesheet_Entries__c where id =: ciid];
       delete delci; 
       setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name desc]));
       TimeSheetEnt= [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name LIMIT :LimitSize OFFSET :OffsetSize];
       
    }
    catch(System.DMLException e)
    {
      
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
    }
     
     
      
        
       /*PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=15');
       p.setRedirect(true);
       return p;*/
       
    }
    

    //Method For Cancel button    
     public PageReference cancelme()
     {
        PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=15');
        p.setRedirect(true);
        return p;     
        
     }
     
     
     
    public void FirstPage()
    {
        OffsetSize = 0;
        TimeSheetEnt= [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public void previous()
    {
        OffsetSize = OffsetSize-LimitSize;
        TimeSheetEnt= [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public void next()
    {
        OffsetSize = OffsetSize+LimitSize;
        TimeSheetEnt= [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public void LastPage()
    {
        OffsetSize = totalrecs-math.mod(totalRecs,LimitSize);
        TimeSheetEnt= [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: theID Order BY Name LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public boolean getprev()
    {
        if(OffsetSize == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > totalRecs)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

}