trigger InvoiceTrigger on Invoice__c (after insert, after update, before delete) {
    
    Map<Id, Double> PO_Map = new Map<Id, Double>();
    Set<ID> PO_Selected_Ids = new Set<ID>();
    List<Invoice__c> lstInvoice = new List<Invoice__c>();
    
    if(trigger.isInsert || trigger.isUpdate) 
    {
        lstInvoice = trigger.new;
    }
    if(trigger.isUpdate || trigger.isDelete)
    {
        lstInvoice = trigger.old;
    }   
   
    For(Invoice__c objv : lstInvoice){
        PO_Selected_Ids.add(objv.Purchase_Order__c);
    }
    
    for(AggregateResult ag:[Select Purchase_Order__c, sum(Total_Amount__c) from Invoice__c where Purchase_Order__c IN : PO_Selected_Ids WITH SECURITY_ENFORCED group by Purchase_Order__c ])
    {
        system.debug(ag.get('Purchase_Order__c'));
        system.debug(ag.get('expr0'));
        
        PO_Map.Put(string.valueof(ag.get('Purchase_Order__c')),double.valueOf(ag.get('expr0')==null?0 : ag.get('expr0')));        
    }
    
    system.debug('map data --->'+PO_Map);
    
    List<Purchase_Order__c> POUpdated = new List<Purchase_Order__c>();
    
    for(Purchase_Order__c objPO:[Select Id, Dummy_Text_1__c,Total_Amount__c from Purchase_Order__c where Id IN :PO_Selected_Ids WITH SECURITY_ENFORCED]){
        double AccAmt = PO_Map.get(objPO.Id);
        if(Schema.sObjectType.Purchase_Order__c.fields.Dummy_Text_1__c.isUpdateable()) {
            objPO.Dummy_Text_1__c = String.valueOf(objPO.Total_Amount__c - AccAmt);}
        
        if(objPO.Dummy_Text_1__c == null){
             if(Schema.sObjectType.Purchase_Order__c.fields.Dummy_Text_1__c.isUpdateable()) {
                 objPO.Dummy_Text_1__c = '0.00';}
        }
        
        POUpdated.add(objPO);
    }
    
    system.debug('po list to update--->'+PoUpdated);
    
    if(PoUpdated.size() > 0){
        if(Schema.sObjectType.Purchase_Order__c.isUpdateable()){
            update PoUpdated; }
    }
}