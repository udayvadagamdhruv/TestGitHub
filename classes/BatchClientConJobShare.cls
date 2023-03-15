global with sharing class BatchClientConJobShare implements Database.Batchable<Client_Contact__c> {
    
    global List<Id> MainAccounts = new List<Id>(); 
    global BatchClientConJobShare(List<Id> listMainAccounts) { 
        MainAccounts = listMainAccounts; 
    }
    
    global Iterable<Client_Contact__c> start(Database.BatchableContext BC) {
        list<Client_Contact__c> query = [select id, name,Salesforce_User__c,Client__c,UserName__c from Client_Contact__c where id in :MainAccounts WITH SECURITY_ENFORCED];
        return query;
    }
   
    global void execute(Database.BatchableContext BC, List<Client_Contact__c> scope) {
          List<Job__share> jobShares = new List<Job__share>();
          
        
         for(Client_Contact__c  CC: scope)
         {
                if(CC.Salesforce_User__c==true)
                 {
                       system.debug('CC.UserName__c ------>>>>>>>>>>'+CC.UserName__c );
                       List<Client_Contact__c> ClientCon = [select id, name,Client__c,UserName__c from Client_Contact__c where UserName__c=:CC.UserName__c WITH SECURITY_ENFORCED];
                      
                       set<String> ClientId = new set<String>();
                       
                       for(Client_Contact__c CCC:ClientCon )
                       {
                           ClientId.add(CCC.Client__c);
                       }
                       
                     system.debug('ClientId------>>>>>>>>>>'+ClientId);
                     
                       list<user> user=[select id,name,IsActive, Profile.name from user where Username=:CC.UserName__c and IsActive=:true  ];//WITH SECURITY_ENFORCED
                       
                       List<Job__c> ClientJobs = [select id, name,JS_Client__c from Job__c where JS_Client__c in :ClientId and ownerId!=:user[0].id WITH SECURITY_ENFORCED order by LastModifiedDate desc Limit 9950];
                       set<Id> jobIds = new set<Id>();
                       
                       for(Job__c jt:ClientJobs)
                       {
                           jobIds.add(jt.id);
                       }
                         system.debug('JobIds------>>>>>>>>>>'+jobIds);
                       
                      
                   
                           set<Id> UId= new set<Id>();
                           
                           for(user uu:user)
                           {
                               UId.add(uu.id);
                           }
                               
                         system.debug('UId------>'+UId);
                      
                     
                       for(Id a:jobIds)
                       {
                         if(user.size()>0){
                           Job__share JobRecord= new Job__share();                   
                           if(Schema.sObjectType.Job__share.fields.ParentId.isCreateable()){ JobRecord.ParentId = a;}
                             if(Schema.sObjectType.Job__share.fields.UserOrGroupId.isCreateable()){ JobRecord.UserOrGroupId = user[0].id;}                    
                             if(Schema.sObjectType.Job__share.fields.AccessLevel.isCreateable()){ JobRecord.AccessLevel = 'Read';    }                
                             if(Schema.sObjectType.Job__share.fields.RowCause.isCreateable()){ JobRecord.RowCause = Schema.Job__share.RowCause.Manual; }   
                           jobShares.add(JobRecord);  
                           }  
                       }
                   
                      
                   }
        }
        if(jobShares.size() > 0){
            if(Schema.sObjectType.Job__share.isCreateable()){ insert jobShares;}}
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}