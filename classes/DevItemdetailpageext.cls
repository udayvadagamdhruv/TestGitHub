public with sharing class DevItemdetailpageext 
{
    
    /* Public Development_Item__c D{get;set;}
     String strJobId;
     public Development_Item__c Dev;
    
    
    public DevItemdetailpageext(ApexPages.StandardController controller) 
    {
            this.D=(Development_Item__c)controller.getrecord();
            
            Dev = [select id,Name from Development_Item__c where id =: D.id];
            strJobId = Dev.id;
    }
    
    public List<Item_Tracking__c> getItemTracking()
    { 
        return [select Id, Name,Development_Item__c,Comment__c  from Item_Tracking__c where Development_Item__c =:D.Id];
    }
    
   */

}