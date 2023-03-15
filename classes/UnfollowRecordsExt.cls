public with sharing  class UnfollowRecordsExt {
    @AuraEnabled
    public static list<Job__c> getJobRec(string status) {
        String Userid=Userinfo.getuserid();
        Map<ID,EntitySubscription > MapJobParentIdSubscription=new  Map<ID,EntitySubscription >();
        List<Job__c> EntityJobs=new List<Job__c>();
        List <EntitySubscription> ListofEntityJobs = [SELECT Id,ParentId FROM EntitySubscription WHERE SubscriberId =:Userid AND ParentId IN  (Select Id FROM Job__c WHERE status__c=:status) WITH SECURITY_ENFORCED limit 1000];
        
        for(EntitySubscription e:ListofEntityJobs){
            MapJobParentIdSubscription.put(e.ParentId,e);
        }
        
        for(Job__c  j:[Select id,name,Job_Auto_Number__c from Job__c where id In :MapJobParentIdSubscription.keyset() WITH SECURITY_ENFORCED]){
            EntityJobs.add(j);
        }
        return EntityJobs;
    }
    
    @AuraEnabled
    public static string UnfollowSelectedJobs(List<SObject> selRecords) {
        
        List<EntitySubscription> Deletelist=new List<EntitySubscription>();
        List<EntitySubscription> EntitySub=[select id,ParentId from EntitySubscription where ParentId IN : selRecords WITH SECURITY_ENFORCED];
        system.debug('Emtity Subscription>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+EntitySub);
        
        for(EntitySubscription ES:EntitySub)
        {
            Deletelist.add(ES);
        }
        if(Deletelist.size() > 0 || test.isRunningTest()) {
            try{
                if(EntitySubscription.sObjectType.getDescribe().isDeletable()){
                    delete Deletelist;}
                return 'true';
            }
            catch(Exception e){
                return ''+e.getMessage();
            }
        }
        return 'true';
    }
    
    
    @AuraEnabled
    public static list<ContentDocument > getChatterFilesRec() {
        String Userid=Userinfo.getuserid();
        Map<ID,EntitySubscription> MapFileParentIdSubscription=new  Map<ID,EntitySubscription>();
        List<ContentDocument> EntityFiles=new List<ContentDocument>();
        List <EntitySubscription> ListofEntityFiles = [SELECT Id,ParentId FROM EntitySubscription WHERE SubscriberId =:Userid AND ParentId IN (Select Id FROM ContentDocument) WITH SECURITY_ENFORCED  limit 1000 ];
        
        for(EntitySubscription e:ListofEntityFiles){
            MapFileParentIdSubscription.put(e.ParentId,e);
        }
        
        for(ContentDocument  c:[Select id,createddate,Title from ContentDocument where id In :MapFileParentIdSubscription.keyset() WITH SECURITY_ENFORCED]){
            EntityFiles.add(c);
        }
        return EntityFiles;
    }
    
    
    @AuraEnabled
    public static string UnfollowSelectedCF(List<SObject> selRecords) {
        
        List<EntitySubscription> Deletelist=new List<EntitySubscription>();
        List<EntitySubscription> EntitySub=[select id,ParentId from EntitySubscription where ParentId IN : selRecords WITH SECURITY_ENFORCED];
        system.debug('Emtity Subscription>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+EntitySub);
        
        for(EntitySubscription ES:EntitySub)
        {
            Deletelist.add(ES);
        }
        if(Deletelist.size() > 0 || test.isRunningTest()) {
            try{
                if(EntitySubscription.sObjectType.getDescribe().isDeletable()){
                    delete Deletelist;}
                return 'true';
            }
            catch(Exception e){
                return ''+e.getMessage();
            }
        }
        return 'true';
    }
    
}