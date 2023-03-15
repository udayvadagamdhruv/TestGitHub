global class BatchStaffNameUpdateforTaskrole implements Database.Batchable<Job_Task_Role__c> {
	global List<Job_Task_Role__c> JobTaskRolelist = new List<Job_Task_Role__c>(); 
    global BatchStaffNameUpdateforTaskrole(List<Job_Task_Role__c> listJobTaskRole) { 
        JobTaskRolelist = listJobTaskRole; 
    }
    
    global Iterable<Job_Task_Role__c> start(Database.BatchableContext BC) {
        //list<Client_Contact__c> query = [select id, name,Salesforce_User__c,Client__c,UserName__c from Client_Contact__c where id in :MainAccounts];
        return JobTaskRolelist;
    }
   
    global void execute(Database.BatchableContext BC, List<Job_Task_Role__c> scope) {
          if(Schema.sObjectType.Job_Task_Role__c.isUpdateable()){
              update scope;}
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}