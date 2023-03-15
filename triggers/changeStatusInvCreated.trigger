trigger changeStatusInvCreated on Invoice_Line_Item__c (before delete) {
    Set<id> id_InvLI = new Set<id>();
    Set<id> id_INV = new Set<id>();
    Set<id> id_PO = new Set<id>();
    Integer count;
    
    for(Invoice_Line_Item__c ILI : Trigger.old)
    {
        id_InvLI.add(ILI.id);
        id_INV.add(ILI.Invoice__c);
          system.debug('----set of id of ILI---- '+ILI.Invoice__r.Purchase_Order__r.Name);
    }
    system.debug('----set of id of ILI---- '+id_InvLI);

//creating list of invoice line items
    list<Invoice_Line_Item__c> list_ILI = [SELECT Estimate_Line_Item__c,Invoice__r.Purchase_Order__c FROM Invoice_Line_Item__c WHERE ID IN : id_InvLI WITH SECURITY_ENFORCED];
    system.debug('----list of ILI---- ******* '+list_ILI );

//creating list of invoice with po number
    list<Invoice__c> list_INV = [SELECT id, Name, Purchase_Order__c FROM Invoice__c WHERE ID IN : id_INV WITH SECURITY_ENFORCED];
    system.debug('----list of ILI---- ******* '+list_INV );
    
//creating set of PO
    for(Invoice__c var_INV : list_INV ){
        if(var_INV.Purchase_Order__c != null){
            id_PO.add(var_INV.Purchase_Order__c);
        }
    }
    system.debug('----set of PO---- +++++++ '+id_PO);
     
    if(id_PO.size() > 0){
//creating list of PO line item.    
        list<PO_Line_Item__c> list_POLI = [SELECT Invoice_Created__c, Estimate_Line_Item__c, Purchase_Order__c FROM PO_Line_Item__c  WHERE Purchase_Order__c IN : id_PO WITH SECURITY_ENFORCED];
        system.debug('----list of POLI---- +++++++ '+list_POLI );
        
//creating map of PO line item with estimate line item as key.
        map<id,PO_Line_Item__c> map_POLI = new map<id,PO_Line_Item__c>();
        for(PO_Line_Item__c var_POLI : list_POLI){
            map_POLI.put(var_POLI.Estimate_Line_Item__c ,var_POLI);
        }
        system.debug('----map of POLI---- /////// '+map_POLI );


//creating list of PO.
    list<Purchase_Order__c> list_PO = [SELECT Invoice_Created__c, Name, Id FROM  Purchase_Order__c WHERE ID IN : id_PO WITH SECURITY_ENFORCED];
    system.debug('----list of POLI---- +++++++ '+list_PO );

//creating map of PO.        
    map<id,Purchase_Order__c> map_PO = new map<id,Purchase_Order__c>();

    for(Purchase_Order__c var_JPO : list_PO ){
        map_PO.put(var_JPO.id ,var_JPO);
        system.debug('map of PO--***************--'+map_PO);
    }
    system.debug('***************map of PO created***************');
            
//iterate through map of PO line item to change the status of Invoice created to false.
    for(Invoice_Line_Item__c JILI : list_ILI){
       // if(map_POLI.get(JILI.Estimate_Line_Item__c) !=null){
        PO_Line_Item__c this_POLI = map_POLI.get(JILI.Estimate_Line_Item__c);
        system.debug('-----------this_POLI--------------'+this_POLI );
         if(Schema.sObjectType.PO_Line_Item__c.fields.Invoice_Created__c.isUpdateable()){
             this_POLI.Invoice_Created__c =false;}
        system.debug('-----------this_POLI = false --------------'+this_POLI.Invoice_Created__c  );
       // }
    }
    
//iterating through PO map to change value of invoice created to No.
    for(Purchase_Order__c JPO1 : list_PO){
        count = 0;
        for(PO_Line_Item__c this_poli : list_POLI){
            if(this_poli.Invoice_Created__c == true){
                count = count + 1 ;
            }
        }
        system.debug('count value ########### '+count);
        Purchase_Order__c this_PO = map_PO.get(JPO1.id);
        system.debug('-----------this_PO--------------'+this_PO );
        if(count > 0){
            if(Schema.sObjectType.Purchase_Order__c.fields.Invoice_Created__c.isUpdateable()){
                this_PO.Invoice_Created__c = 'Partially';}
        }
        else{
           if(Schema.sObjectType.Purchase_Order__c.fields.Invoice_Created__c.isUpdateable()){
               this_PO.Invoice_Created__c = 'No';}
        }
        system.debug('-----------this_PO = No --------------'+this_PO.Invoice_Created__c);
    }
    system.debug('***************value of PO changed to NO***************');

// updating status of invoice created to "No" in PO object.                
   if(Schema.sObjectType.Purchase_Order__c.isUpdateable()){
       update map_PO.values(); }
                
// updating status of invoice created to "false" in PO line item object.
    if(Schema.sObjectType.PO_Line_Item__c.isUpdateable()){
        update map_POLI.values();}
}
}