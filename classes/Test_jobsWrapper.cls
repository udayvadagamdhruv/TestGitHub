@isTest
public class Test_jobsWrapper{ 
    static testMethod void Test_jobsWrapper(){
    	jobsWrapper jw = new jobsWrapper();
        object other;
        
        jw.compareTo(other);
        jw.compareToClient(other);
        jw.compareTojobDuedate(other);
        jw.compareTojobNo(other);
        jw.compareTojobtaskDuedate(other);
        jw.compareToName(other);
        jw.compareTotaskName(other);
        jw.clientDisplay = '';
        jw.Client = '';
        jw.date1 = '';
        jw.date2 = '';
        jw.jobName = '';
        jw.jobName1 = '';
        jw.jobNo = '';
        jw.sortBy ='';
        jw.taskName = '';
        jw.taskName1 = '';
        jw.task = new job_task__c();
        jw.status = '';
        jw.jobDuedate = system.today();
        jw.jobtaskDuedate = system.today();
      	
    }
}