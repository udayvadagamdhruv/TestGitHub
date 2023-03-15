global class BatchStaffNameUpdateforJobTeams implements Database.Batchable<Job_Team__c> {
	global List<Job_Team__c> JobTeamlist = new List<Job_Team__c>(); 
    global BatchStaffNameUpdateforJobTeams(List<Job_Team__c> listJobTeam) { 
        JobTeamlist = listJobTeam; 
    }
    
    global Iterable<Job_Team__c> start(Database.BatchableContext BC) {
        //list<Client_Contact__c> query = [select id, name,Salesforce_User__c,Client__c,UserName__c from Client_Contact__c where id in :MainAccounts];
        return JobTeamlist;
    }
   
    global void execute(Database.BatchableContext BC, List<Job_Team__c> scope) {
        if(Schema.sObjectType.Job_Team__c.isUpdateable()){update scope;}
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}