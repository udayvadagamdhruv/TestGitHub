public  without sharing class UnFollowJobRecordHandler
{
    public static void UnfollowJobRecord(Map<Id, Job__c> newJobMap, String operation)
    {
        List<Id> entitySubIdsToBeDelete = new List<Id>();
        if(operation.equalsIgnoreCase('update')) 
        {
            for(Job__c currJob : newJobMap.values())
            {
                entitySubIdsToBeDelete.add(currJob.id);
            }
        }
        if(!entitySubIdsToBeDelete.isEmpty())
        {
            List<EntitySubscription> entitySubDelete = new List<EntitySubscription>();
            for(EntitySubscription currEntity : [select id from EntitySubscription where ParentId=:entitySubIdsToBeDelete WITH SECURITY_ENFORCED Limit 1000])
            {
                EntitySubscription ent = new EntitySubscription();
                ent.ID = currEntity.Id;   entitySubDelete.add(ent);
            }
             if(EntitySubscription.sObjectType.getDescribe().isDeletable()){
            Delete entitySubDelete;
            }
        }
    }
}