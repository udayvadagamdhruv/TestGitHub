public with sharing class schedulesViewExtension {
    // Global variables
    public Id JobId;
    private final Job_Task__c objJobTask; 
    public Double Task_Order_No{get;set;}
    // End of Global variables
    public schedulesViewExtension(ApexPages.StandardController controller) {
        this.objJobTask=(Job_Task__c)controller.getrecord();
         JobId = [Select Id, Job__c from Job_Task__c where Id =:objJobTask.Id limit 1].Job__c; 
         Task_Order_No= [Select Id, Task_Order__c from Job_Task__c where Id =:objJobTask.Id limit 1].Task_Order__c;
    }
    public PageReference checkDelete()
    {
       String th = userinfo.getUiTheme();
       PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+JobId+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+JobId+'&intFocus=2'); 
       p.setRedirect(true);
       return p;
    }
}