trigger ShipmentChildUpdate on Shipment__c (after update) {
    set<Id> ShipIds = new set<Id>();
    map<Id, Shipment__c> mapShipment = new map<Id, Shipment__c>();
    list<Shipment_Line_Item__c> listShipmentitems = new list<Shipment_Line_Item__c>();
    
    for(Shipment__c ship : trigger.new) {
        ShipIds.add(ship .Id);
        mapShipment.put(ship.Id, ship);
    }
    
    listShipmentitems = [SELECT id,name,Shipment__c,Item_Status__c FROM Shipment_Line_Item__c WHERE Shipment__c IN : ShipIds WITH SECURITY_ENFORCED];
    
    if(listShipmentitems.size() > 0) {
        for(Shipment_Line_Item__c sli : listShipmentitems ) {
             if(Schema.sObjectType.Shipment_Line_Item__c.fields.Item_Status__c.isUpdateable()) {
                 sli.Item_Status__c = mapShipment.get(sli.Shipment__c).Shipment_Status__c;}
            
        }
        if(Schema.sObjectType.Shipment_Line_Item__c.isUpdateable()){
            update listShipmentitems ;}
    }
}