public with sharing class multipleScheduleUpdateController {

    //Global variables
  /*  public Id RSid{get; set;}
    private Job__c RecJb{get; set;}
    public list<JobWrapper> jbWrap{get; set;}
    //End of global variables
        
    public multipleScheduleUpdateController() {
        jbWrap = new list<JobWrapper>();
        RSid = ApexPages.currentPage().getParameters().get('RSId');
        system.debug('RSid is@@@ : ' + RSid );
        jobCamp();
    }

    // Start Wrapper Class : This class will bind checkbox and its associated Job on layout
    public class JobWrapper{
         public Job__c varJb{get;set;}
         public Boolean varJbSelect{get;set;}
         public JobWrapper(){
             varJb = new Job__c();
             varJbSelect = false;
         }
     }   
     // End of Wrapper Class
     
     //Method to populate job list for Rescheduling tasks.
     public pageReference jobCamp(){
         RecJb = [SELECT id, Name, Status__c, Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c FROM Job__c WHERE id =: RSId];
         for(Job__c loopJb : [SELECT id, Name, Status__c, Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c FROM Job__c WHERE Campaign__c =: RecJb.Campaign__c AND Schedule_Calc__c =: RecJb.Schedule_Calc__c AND Status__c =:'Active' AND id <>: RSId]){
             JobWrapper varJobWrap = new JobWrapper();
             varJobWrap.varJb = loopJb;
             varJobWrap.varJbSelect = false;
             jbWrap.add(varJobWrap);
         }
         return null;
     }
     //Method ends here.
     
     public PageReference cancel() {
        PageReference p =  new Pagereference('/apex/JobListView?id='+RecJb.Id);
        p.setRedirect(true);
        return p;
    }


    public PageReference saveRsc() {
        list<Job__c> lstupdJb = new list<Job__c>();
        Job__c tmpJb = new Job__c();
        for(JobWrapper tmpJbW : jbWrap){
            tmpJb = new Job__c();
            if(tmpJbW.varJbSelect == true){
                tmpJb = tmpJbW.varJb;
                if(RecJb.Schedule_Calc__c == 'Start Date'){
                     if(schema.SobjectType.Job__c.Fields.Start_Date__c.isUpdateable()){   tmpJb.Start_Date__c = RecJb.Start_Date__c;}
                }
                else{
                     if(schema.SobjectType.Job__c.Fields.Due_Date__c.isUpdateable()){   tmpJb.Due_Date__c = RecJb.Due_Date__c;}
                }
                lstupdJb.add(tmpJb);
            }
        }
        System.debug('List of Jobs to be updated ---> ' + lstupdJb);
        try{
                 if(Schema.sObjectType.Job__c.isUpdateable()){Update lstupdJb;}
        }
        catch(exception e){
        
        }
        PageReference p =  new Pagereference('/apex/JobListView?id='+RecJb.Id);
        p.setRedirect(true);
        return p;
    }*/
}