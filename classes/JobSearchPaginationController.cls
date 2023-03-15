// This page is used to Search Jobs based on criteria set by user
public with sharing class JobSearchPaginationController 
{
    // Global variables
     
   /*   Map<Id,EntitySubScription> mpJobs;

     public Id userId;
     
     String jobId;
     
     public List<Job__c> jobs1{get;set;}
     
     Set<Id> stJobIds;
   
    Transient List<JobWrapper> jobsW{get;set;} // Our collection of the class/wrapper objects JobWrapper 
    
     private String soql {get;set;}       // the soql without the order and limit
     
     private List<Job__c> pageJobs;
     
     private List<Job__c> jobs;      // the collection of contacts to display
     
     public String strId{get;set;}

     public Pagereference pg;
    
     //private Integer pageNumber;

     private Integer pageSize;

     private Integer totalPageNumber;
     
     public DateTime today{get;set;}
     
     public List<Document> lstDoc;
     
     public String imageBody{get;set;}
     
     public String imageURL{get;set;}
     
     public boolean imageNotFound{get;set;}
     
     // End of Global variables
    
    // This method is used to retrieve pageNumber  
     public Integer getPageNumber()
     {
          return pageNumber;
     }
     // End of method getPageNumber

    // This method is used to retrieve filtered jobs
     public List<Job__c> getJobs()
     {
         return pageJobs;
     }
     // End of method getJobs

    // This method is called on to retrieve number of rows per page
    public Integer getPageSize()
    {
        return pageSize;
    }
    // End of method getPageSize

    // This method is called on check if Previous button to keep in Diable or Enable state
    public Boolean getPreviousButtonEnabled()
    {
        return !(pageNumber > 1);
    }
    // End of method getPreviousButtonEnabled

    // This method is called on check if Next button to keep in Diable or Enable state
    public Boolean getNextButtonDisabled()
    {
        if (jobs == null) return true;

        else

        return ((pageNumber * pageSize) >= jobs.size());
    }
    // End of method getNextButtonDisabled

    // This method is called on to retrieve TotalPageNumber
    public Integer getTotalPageNumber()

    {
        if (totalPageNumber == 0 && jobs !=null)
        {

            totalPageNumber = jobs.size() / pageSize;

            Integer mod = jobs.size() - (totalPageNumber * pageSize);

            if (mod > 0)

            totalPageNumber++;

        }
        return totalPageNumber;
    }
    // End of method getTotalPageNumber

        // This method is called on to navigate to Next Search Result layout
    public PageReference nextBtnClick() 
    {
        runQuery(pageNumber+1);

        return null;
    }
    // End of method nextBtn

    // This method is called on to navigate to Previous Search Result layout
    public PageReference previousBtnClick() 
    {
        runQuery( pageNumber - 1);

        return null;
    }
    // End of method previousBtnClick

   // the current sort direction. defaults to asc
    public String sortDir 
    {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
 
   // the current field to sort by. defaults to last name
   public String sortField {
    get  { if (sortField == null) {sortField = 'Job_Auto_Number__c'; } return sortField;  }
    set;
   }
 
    // format the soql for display on the visualforce page
    public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 10000'; }
    set;
  }    
    
  // This method is called on to handle follow-unfollow job records
  //function commented for subscription issue
 // public pagereference followRecord()
  //{
       // jobId = Apexpages.currentPage().getParameters().get('jobId');
       // String checkBoxValue=ApexPages.CurrentPage().getParameters().get('ip');
       /// System.debug('CheckBoxValue : '+checkBoxValue);
       // System.debug('sNew : '+jobId);
        
        //Commented by yogini on 10-Sep-12         
       // List<EntitySubscription> lstES=[Select Id From EntitySubscription where parentId=: jobId and subscriberid =: UserInfo.getUserId() limit 1];
      
       // if(lstES.size() == 1)
       // {
       //       delete lstES;
       // }
       // else
       // {
            //  EntitySubscription follow = new EntitySubscription (parentId = jobId ,subscriberid = UserInfo.getUserId()); //your User Id
            //  try
              //{
            // insert follow;
             // }
             // Catch(System.Exception e)
             // {
             // ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,String.Valueof(e));
             // ApexPages.addMessage(myMsg1);
             // return null;
             // }
       // }
        //End Yogini
         // return NULL;
    // }

  // End of method followRecord
  
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery(1);
  }
  
  
   // runs the actual query
  private void runQuery(Integer newPageIndex) 
  {    
      totalPageNumber = 0;
        try 
        {
          //  jobs = Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + ' limit 10000');
         //   jobs1 = Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + ' limit 10000');
        //jobs = Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + ' limit 500');
       // jobs1 = Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + ' limit 500');
        
        jobs = Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + ' LIMIT '+queryLimit+' OFFSET '+offset);
        jobs1 = Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + 'LIMIT '+queryLimit+' OFFSET '+offset);

            pageJobs = new List<Job__c>();
    
            Transient Integer counter = 0;

            Transient Integer min = 0;

            Transient Integer max = 0;

            if (newPageIndex > pageNumber)

            {

                min = pageNumber * pageSize;

                max = newPageIndex * pageSize;

            }

            else

            {

                max = newPageIndex * pageSize;

                min = max - pageSize;
            }
      
            for(Job__c a : jobs)

            {
                counter++;

                if (counter > min && counter <= max)

                pageJobs.add(a);
            }
       
            pageNumber = newPageIndex;
        
            System.debug('Page Number : '+pageNumber);
        
            getPreviousButtonEnabled();
    
            getNextButtonDisabled();
      
        } 
        catch (Exception e) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
        }
  }
  
     // runs the search with parameters passed via Javascript
  public PageReference runSearch() 
  {
      String jobName, clientName, campaignName, startdate1, startdate2, dueDate1, dueDate2, compdate1, compdate2;
      Date dtStartDt1,dtStartDt2, dtDueDt1, dtDueDt2, dtCompDt1, dtCompDt2;
      
        jobName = Apexpages.currentPage().getParameters().get('jobName');
    
        clientName = Apexpages.currentPage().getParameters().get('clientName');
    
        campaignName = Apexpages.currentPage().getParameters().get('campaignName');
    
        String status = Apexpages.currentPage().getParameters().get('status');
    
        startdate1=ApexPages.currentPage().getParameters().get('startdt1');
        startdate2=ApexPages.currentPage().getParameters().get('startdt2');
    
        duedate1= ApexPages.currentPage().getParameters().get('duedt1');
        duedate2= ApexPages.currentPage().getParameters().get('duedt2');
    
        compdate1=ApexPages.CurrentPage().getParameters().get('compdt1'); 
        compdate2=ApexPages.CurrentPage().getParameters().get('compdt2');  
 
        System.debug('Start Date 1 : '+startdate1); 
        System.debug('Start Date 2 : '+startdate2); 

        System.debug('Due Date 1 : '+duedate1); 
        System.debug('Due Date 2 : '+duedate2); 

        String s,s1,sNew,sNew1;
        String strStartDt2, strDueDt1, strDueDt2, strCompDt1, strCompDt2;//strStartDt1,
        Date d8,d9;
 
    
       soql = 'select Id,Job_Auto_Number__c,Name, Status__c, JS_Client__r.Name, Campaign__r.Name, Start_Date__c, Due_Date__c, Completion_Date__c, Job_Id__c from Job__c where name != null';
  
       if (!jobName.equals(''))
          soql += ' and name LIKE \''+String.escapeSingleQuotes(jobName)+'%\'';

       if (!clientName.equals(''))
          soql += ' and JS_Client__r.Name LIKE \''+String.escapeSingleQuotes(clientName)+'%\'';
      
       if (!campaignName.equals(''))
          soql += ' and Campaign__r.Name LIKE \''+String.escapeSingleQuotes(campaignName)+'%\'';  
      
       if (!status.equals(''))
          soql += ' and Status__c LIKE \''+String.escapeSingleQuotes(status)+'\'';
  
      
       if(!startdate1.equals('') && startdate1.length() >=8)
        {
              String[] st1=startdate1.split('/');
              Integer m1=Integer.valueOf(st1[0]);
              Integer d1=Integer.valueOf(st1[1]);
              Integer y1=Integer.valueOf(st1[2]);
              s= y1 +'-'+ m1 +'-'+d1;
              dtStartDt1=Date.newInstance(y1,m1,d1);
             //strStartDt1=String.valueOf(dtStartDt1);
              soql += ' and Start_Date__c >= '+ String.valueOf(dtStartDt1)+' '; 
              
            st1 = NULL;
            m1= NULL;
            d1= NULL;
            y1= NULL;  
        }    
        
       if(!startdate2.equals('') && startdate2.length() >=8)
        {
             String[] st2=startdate2.split('/');
             Integer m2=Integer.valueOf(st2[0]);
             Integer d2=Integer.valueOf(st2[1]);
             Integer y2=Integer.valueOf(st2[2]);
       
             dtStartDt2=Date.newInstance(y2,m2,d2);
             //strStartDt2=String.valueOf(dtStartDt2); 
             soql += ' and Start_Date__c <= '+String.valueOf(dtStartDt2)+' '; 
            st2 = NULL;
            m2= NULL;
            d2= NULL;
            y2= NULL;   
        }
        
        if(!dueDate1.equals('') && dueDate1.length() >=8)
        {
            String[] st3=dueDate1.split('/');
            Integer m3=Integer.valueOf(st3[0]);
            Integer d3=Integer.valueOf(st3[1]);
            Integer y3=Integer.valueOf(st3[2]);
            
            dtDueDt1=Date.newInstance(y3,m3,d3);
            //strDueDt1=String.valueOf(dtDueDt1);
            soql+= ' and Due_Date__c >= '+String.valueOf(dtDueDt1)+' ';
            
            st3 = NULL;
            m3= NULL;
            d3= NULL;
            y3= NULL; 
        }
        
         if(!dueDate2.equals('') && dueDate2.length() >=8)
        {
            String[] st4=dueDate2.split('/');
            Integer m4=Integer.valueOf(st4[0]);
            Integer d4=Integer.valueOf(st4[1]);
            Integer y4=Integer.valueOf(st4[2]);
            
            dtDueDt2=Date.newInstance(y4,m4,d4);
            //strDueDt2=String.valueOf(dtDueDt2);
            soql+= ' and Due_Date__c <= '+String.valueOf(dtDueDt2)+' ';
            
            st4 = NULL;
            m4= NULL;
            d4= NULL;
            y4= NULL; 
        }
        
         if(!compdate1.equals('') && compdate1.length() >=8)
        {
            String[] st5=compdate1.split('/');
            Integer m5=Integer.valueOf(st5[0]);
            Integer d5=Integer.valueOf(st5[1]);
            Integer y5=Integer.valueOf(st5[2]);
            
            dtCompDt1=Date.newInstance(y5,m5,d5);
            strCompDt1=String.valueOf(dtCompDt1);
            soql+= ' and Completion_Date__c >= '+strCompDt1+' ';
            
            st5 = NULL;
            m5= NULL;
            d5= NULL;
            y5= NULL;
        }
        
         if(!compdate2.equals('') && compdate2.length() >=8)
        {
            String[] st6=compdate2.split('/');
            Integer m6=Integer.valueOf(st6[0]);
            Integer d6=Integer.valueOf(st6[1]);
            Integer y6=Integer.valueOf(st6[2]);
            
            dtCompDt2=Date.newInstance(y6,m6,d6);
            strCompDt2=String.valueOf(dtCompDt2);
            soql+= ' and Completion_Date__c <= '+strCompDt2+' ';
            
            st6 = NULL;
            m6= NULL;
            d6= NULL;
            y6= NULL;
            }
         
    // run the query again
    runQuery(1);
 
    return null;
  }
 
  // use apex describe to build the picklist values
  public List<String> status {
    get {
      if (status == null) {
 
        status = new List<String>();
        Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
              status.add(f.getLabel());
 
      }
      return status;          
    }
    set;
  }

  // This method is called on to navigate user to selected Job
  public pagereference navigate()
  {
      Pagereference pg=new Pagereference('/apex/JobListView?id='+strId);
      pg.setRedirect(true);
      return pg;
  }
  // End of method navigate
  
  // This method is called on to create New Job
  public pagereference createNewJob()
  {
      pg=new Pagereference('/apex/CreateNewJob');
      pg.setRedirect(true);
      return pg;
  }
  // End of method createNewJob
  
  // This method is called on to navigate user to edit Job page
  public pagereference editJob()
  {
      pg=new Pagereference('/apex/EditJob?id='+strId);
      pg.setRedirect(true);
      return pg;
  }
  // End of method editJob
  
  
  // This method is called on to delete Job
  public pagereference deleteJob()
  {
     pg=new Pagereference('/apex/DeleteJob?id='+strId);
     pg.setRedirect(true);
     return pg;
  }
  // End of method deleteJob
 
//commented by sushma  
 public PageReference CreatePDF() 
 {
     pg = new PageReference('/apex/Job_Search_Result_InPDF');
     pg.setRedirect(false);
    return pg;
 }
 
 public pagereference viewData()
 {
     jobs=NULL;
     
     totalPageNumber=0;
     
     runQuery(1);
     
     return NULL;
 }
  
// init the controller and display some sample data when the page loads
  public JobSearchPaginationController() 
  {
      // Code to display Subscriber Logo
       firstOff = false;
        queryLimit = 10;
        offset = 0;
        limits = '10';
        pageNumber = 1;
        Integer listSize;     
      pageJobs = new List<Job__c>();
        aggregateResult res = [select COUNT(id) cnt from Job__c];
        
        // fill size of all Job_
        listSize = Integer.valueOf(res.get('cnt'));
        
        // initialy check page more then 1 or not
        if(listSize > queryLimit) lastOff = true;
        else lastOff = false;
      
      imageURL = '/servlet/servlet.FileDownload?file='; 
      lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
      if(!lstDoc.isEmpty())
      {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
      }    
      else
      {
           imageNotFound = True;
      }
      // End of Code to display Subscriber Logo
      
      userId=UserInfo.getUserId();
      stJobIds=new Set<Id>();
      List<Job__c> lstJ=[Select Id from Job__c LIMIT 50000];

       
       for(Job__c j1:lstJ)
       {
           stJobIds.add(j1.Id);
       }
      
       pageNumber = 0;

       totalPageNumber = 0;

       pageSize = 50;
  
       soql = 'select Id, Name,Job_Auto_Number__c, Status__c, JS_Client__r.Name, Client__r.Id,Campaign__r.Name, Start_Date__c, Due_Date__c, Completion_Date__c, Job_Id__c from Job__c where name != null';
    
       today=System.NOW();
    
       ViewData();
      
  }
 
    // This is our wrapper/container class.
    
    //In this example a wrapper class contains both the job object Contact and a Boolean value checked
    public class JobWrapper
    {
        public Transient  Boolean checked{get;set;}
        public Transient  Job__c objJob{get;set;}
        
        
        public JobWrapper()
        {
            objJob=new Job__c();
            checked=false;
        }
        
        //This is the contructor method. We also set the checked value based on user has already followed the record
        public JobWrapper(Job__c j,boolean f)
        {
            objJob=j;
            checked=f;
        }
      }  
    
//This method returns List of jobs based on search criteria use has sepcified on layout
    public List<JobWrapper> getJobsW()
    {
        jobsW=new List<JobWrapper>();
       
         mpJobs=new Map<Id,EntitySubscription>();
         //system.debug('User id -----------' + UserInfo.getUserId());
        // system.debug('Jobs -----------' + stJobIds );
         //code commneted for the issue in all the org for the subscription
        // List<EntitySubScription> lstES=[Select Id,parentId from EntitySubScription where SubscriberId =: UserInfo.getUserId() and ParentId In: stJobIds LIMIT 1000];
            
          //  for(EntitySubScription es:lstES)
          //  {
           //     mpJobs.put(es.ParentId,es);
           // } 
//        system.debug('List of Jobs:'+stJobIds);
        for(Job__c j:pagejobs)
           // jobsW.add(new JobWrapper(j,mpJobs.containsKey(j.Id)));
           jobsW.add(new JobWrapper(j,false));
        return jobsW;    
    }
    
    
    
    /*************** This Code For Pagination *************/
    
  /*  Integer queryLimit;
    Integer offset;
    Integer listSize;
    
    // for active and deactive page naviagator
    public Boolean firstOff{set;get;}    // previous part
    public Boolean lastOff{set;get;}     // next part
    
    public String limits{set;get;}
    public Integer pageNumber{set;get;}
    
    
    
    
    // get record according to limit and offset
    //public List<Job__c> getRecords(){
      // return (List<Job__c>)database.query(queryString+' LIMIT '+queryLimit+' OFFSET '+offset);
    //}
    
    // navigate on next page
    public void next(){
        offset += queryLimit;
        if(offset+queryLimit >= listSize) lastOff = false;
        firstOff = true;
        pageNumber++;
    }
    
    // navigate on previous page
    public void previous(){
        if(offset-queryLimit <= 0){
            offset = 0;
            firstOff = false;
        }
        else offset -= queryLimit;
        lastOff = true;
        pageNumber--;
    }
    
    // switch on first page
    public void first(){
        offset = 0;
        firstOff = false;
        lastOff = true;
        
        pageNumber = 1;
    }
    
    // switch on last page
    public void last(){
        // set page number of and offset
        if(Math.Mod(listSize,queryLimit) == 0){
            offset = listSize-queryLimit;
            pageNumber = listSize/queryLimit;
        }
        else{
            offset = (listSize/queryLimit)*queryLimit;
            pageNumber = (listSize/queryLimit)+1;
        }
        
        lastOff = false;
        firstOff = true;
    }
    
    // for record limits
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        return options;
    }
    
    // change query limit
    public void changeLimit(){
        // set query limit
        queryLimit = Integer.valueOf(limits);
        
        offset = 0;
        firstOff = false;
        
        // initialy check page more then 1 or not
        if(listSize > queryLimit) lastOff = true;
        else lastOff = false;
        
        // set page number
        pageNumber = 1;
    }
    
    // for show current record numbers
    public String getRecordInfo(){
        integer lastLimit;
        if(offset+queryLimit > listSize) lastLimit = listSize;
        else lastLimit = offset+queryLimit;
        return (offset+1) + ' - ' + lastLimit + ' of '+listSize;
    }
    
    // return total page number
    public Integer getTotalPage(){
        if(Math.Mod(listSize,queryLimit) == 0) return listSize/queryLimit;
        else return (listSize/queryLimit)+1;
    }
    
    // for direct page switching
    public void pageNavigation(){
    
        /* if user enter more then number ot total page number than
           set the value last page number in PageNumber. */
  /*      if(Math.Mod(listSize,queryLimit) == 0 && pageNumber > listSize/queryLimit)
            pageNumber = listSize/queryLimit;    
        else if(pageNumber > (listSize/queryLimit)+1)
            pageNumber = (listSize/queryLimit)+1;
        
        // set offset according to pageNumber    
        if((pageNumber-1)*queryLimit < 0) offset = 0;
        else offset = (pageNumber-1)*queryLimit;    
        
        /* if pageNumber is 1 than deactive previous navigator
           else if pageNumber is o tha set the value of pageNumber is 1
           else if pageNumber is more than 1 active next navigator
        */
    /*    if(pageNumber == 1) firstOff = false;
        else if(pageNumber == 0) pageNumber = 1;
        else if(pageNumber > 1) firstOff = true;
        
        // user enter last number of pagenumber than deactive next navigator
        if(Math.Mod(listSize,queryLimit) == 0){
            if(pageNumber == listSize/queryLimit) lastOff = false;
            else lastOff = true;
        }
        else{
            if(pageNumber == (listSize/queryLimit)+1) lastOff = false;
            else lastOff = true;
        }
    }
    
   /********* End Of Code For Pagination  **************/ 
   
   
  /* 

     // Start Test Method    
     static TestMethod void Test_JobSearchPaginationController()
     {
         Job_Number_Setting__c customSetting988 = new  Job_Number_Setting__c(Name= 'yy');
         insert customSetting988;
            
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 858');
          Media_Type__c testMedia=new Media_Type__c(Name='Media Type 858');
              insert testMedia;
              
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST858',Media_Types__c=testMedia.Id);
              insert testST;
   
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT858');
              insert testSpec;
                
          Campaign__c testCampaign1=new Campaign__c(Name='Camp858',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
              insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account858');
              insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 858',Last_Name__c='Contact 858',Client__c=a.id,Email__c='testEmail858@sfdc.com',Salesforce_User__c=False);
              insert c;
                
          Job__c testJob1=new Job__c(Name='Job858',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
             
              insert testJob1;
              
          System.assertEquals('Job858',testJob1.Name);    
            
          ApexPages.CurrentPage().getParameters().put('jobName',testJob1.Name);
          ApexPages.CurrentPage().getParameters().put('clientName',a.Name);
          ApexPages.CurrentPage().getParameters().put('campaignName',testCamp.Name);
          ApexPages.CurrentPage().getParameters().put('status','Active');
          ApexPages.currentPage().getParameters().put('startdt1','11/0/2012');
          ApexPages.currentPage().getParameters().put('startdt2','11/02/2012');
          ApexPages.currentPage().getParameters().put('duedt1','11/0/2012');
          ApexPages.currentPage().getParameters().put('duedt2','11/0/2012');
          ApexPages.CurrentPage().getParameters().put('compdt1','11/0/2012'); 
          ApexPages.CurrentPage().getParameters().put('compdt2','11/0/2012');  
          JobSearchPaginationController ext=new JobSearchPaginationController();
          //ext.jobName='ABC';
          ext.getPageNumber();
          ext.getTotalPageNumber();
          ext.runQuery(1);
          ext.toggleSort();
          ext.previousBtnClick();
          ext.nextBtnClick();
          ext.createNewJob();
          ext.editJob();
          ext.deleteJob();
          ext.getJobs();
          ext.navigate();
          ext.createPDF();
          ext.getPageSize();
          ext.getPreviousButtonEnabled();
          ext.getNextButtonDisabled();
        
          //ext.getJObsW();    //commented by yogini on 10-sep-12
          List<String> a1=ext.status;
          Pagereference result1=ext.runSearch();
          String strDebug=ext.debugSOQL;
          
          Apexpages.currentPage().getParameters().put('jobId',testJob1.id);
          ApexPages.CurrentPage().getParameters().put('ip','false');
          
         // result1=ext.followRecord();
        
          List<Job__c> lst=new List<Job__c>();
          // Bulk Record Insert
          for(Integer i=0;i< 200;i++)
          {
             Job__c obj=new Job__c(Name='Job '+i,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
             
             lst.add(obj);
          }
           insert lst;
           JobSearchPaginationController ext1=new JobSearchPaginationController();
           ext1.runQuery(1);
           //ext1.getJObsW();        //commented by yogini on 10-sep-12
           Apexpages.currentPage().getParameters().put('jobId',testJob1.id);
           ApexPages.CurrentPage().getParameters().put('ip','false');
          
         // result1=ext1.followRecord();
           
         
     } // End of Test Method*/
}// End of Class