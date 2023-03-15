public with sharing class PagingController {
 /*
    List<JobWrapper> jobs {get;set;}
 
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name FROM Job__c Order By Name limit 1000]));
                // sets the number of records in each page set
                con.setPageSize(30);
            }
            return con;
        }
        set;
    }
 
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<JobWrapper> getCategories() {
        jobs = new List<JobWrapper>();
        for (Job__c  job: (List<Job__c >)con.getRecords())
            jobs.add(new JobWrapper(job));
 
        return jobs;
    }
 
    // displays the selected items
  //  public PageReference process() {
  //      for (CategoryWrapper cw : categories) {
  //          if (cw.checked)
  //              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.cat.name));
  //      }
  //      return null;
  //  }
 
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
 
    // returns the first page of records
    public void first() {
        con.first();
    }
 
    // returns the last page of records
    public void last() {
        con.last();
    }
 
    // returns the previous page of records
    public void previous() {
        con.previous();
    }
 
    // returns the next page of records
    public void next() {
        con.next();
    }
 
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
 
 public class JobWrapper {
 
    public Boolean checked{ get; set; }
    public Job__c job{ get; set;}
 
    public JobWrapper (){
        job = new Job__c();
        checked = false;
    }
 
    public JobWrapper (Job__c j){
        job = j;
        checked = false;
    }
 
    
 
}
public static testMethod void testMe() {
    
     Media_Type__c testMedia=new Media_Type__c(Name='TM001');
          insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST001',Media_Types__c=testMedia.Id);
          insert testST;
   
          Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST001',Schedule_Template__c=testST.Id);
          insert testSCT1;
                 
          Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST002',Schedule_Template__c=testST.Id);
          insert testSCT2;
                 
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='R001',Schedule_Task__c=testSCT1.Id);
          insert testSTR1;
                 
          ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='R002',Schedule_Task__c=testSCT2.Id);
          insert testSTR2;            
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT001');
          insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='SI001',Specification_Template__c=testSpec.Id); 
          insert testSPI;
         
          Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account001');
          insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 001',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
          insert c;
                
          Job__c testJob1=new Job__c(Name='Job001',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
             
          
 
        JobWrapper jw = new JobWrapper ();
        System.assertEquals(jw.checked,false);
 
        JobWrapper jwrap = new JobWrapper (testJob1);
        System.assertEquals(jwrap.job.name,'Job001');
        System.assertEquals(jwrap.checked,false);
 
    }*/
}