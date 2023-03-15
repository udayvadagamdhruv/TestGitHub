trigger UpdateMaterialUsage on Material_Inventory_Item__c (before update, before insert)
{
    list<Material_Inventory_Item__c> matInvItemList = trigger.new;
    Map<ID, Material_item__c > MatItemMap = new Map<ID, Material_item__c >();
    set<Id> matInvIds = new set<Id>();
    
    for(Material_Inventory_Item__c miinv: matInvItemList ){
        
        matInvIds.add(miinv.Material_Item__c);
    }
    
    for(Material_Item__c MatItem: [select id, Qty_On_Hand__c, Qty_On_Hand_roll__c,Qty_On_Hand_case__c,Case_Pack__c, Roll_LF__c,Calc_Unit__c from Material_Item__c where id IN :matInvIds WITH SECURITY_ENFORCED]){
        MatItemMap.put(MatItem.id, MatItem);
    }
    
    list<Material_Usage_line_item__c > mulitemlist = new list<Material_Usage_line_item__c >();
    list<Material_Inventory_Item__c> updateInvList = new List<Material_Inventory_Item__c>();
    list<Material_Item__c > mitemlist = new list<Material_Item__c >();
    
    for(Material_Inventory_Item__c miinv: matInvItemList ){
        if(miinv.Qty_On_Shelf__c == null){
            miinv.addError('Please provide value for Qty On Shelf field.');
        }
        else{
            if(miinv.Qty_On_Hand__c != miinv.Qty_On_Shelf__c && MatItemMap.containsKey(miinv.Material_Item__c)){
                //&& MatItemMap.containsKey(miinv.Material_Item__c)
                Material_Item__c mItem = MatItemMap.get(miinv.Material_Item__c);
                
                if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){
                    if(mItem.Qty_On_Hand__c == null){
                        mItem.Qty_On_Hand__c = 0;
                    }
                }
                if(Schema.sObjectType.Material_Item__c.fields.Case_Pack__c.isUpdateable()){
                    if(mItem.Case_Pack__c == null){
                        mItem.Case_Pack__c = 1;
                    }
                }
                Decimal diff;
                if(mItem.Calc_Unit__c=='Size'){
                    diff = mItem.Qty_On_Hand_roll__c - miinv.Qty_On_Shelf__c;
                }
                else if(mItem.Calc_Unit__c=='Sheet'){
                    diff = mItem.Qty_On_Hand_case__c - miinv.Qty_On_Shelf__c;
                    system.debug('diff==== '+diff);
                }
                else{
                    diff = mItem.Qty_On_Hand__c - miinv.Qty_On_Shelf__c;
                }
                system.debug('///////////////// Diff ////////////////'+diff);
                Material_Usage_line_item__c mulitem = new Material_Usage_line_item__c();
                if(diff > 0.0){
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                        mulitem.Material_Item__c = miinv.Material_Item__c;
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                        mulitem.Type__c = 'Reconciliation';
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                        mulitem.Debit__c = diff;
                    }
                    DateTime dT = System.now();
                    Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                        mulitem.Date__c = myDate;
                    }
                    if(mItem.Calc_Unit__c=='Size'){
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                            mulitem.Qty_On_Hand__c = mItem.Qty_On_Hand__c - (mItem.Roll_LF__c * diff);
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                            mulitem.Credit__c=mulitem.Credit__c != null ? mulitem.Credit__c * mItem.Roll_LF__c : 0;
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                            mulitem.Debit__c=mulitem.Debit__c != null ? mulitem.Debit__c * mItem.Roll_LF__c: 0;
                        }
                        if(Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isCreateable() || Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isUpdateable()){
                            miinv.Qty_On_Hand_temp__c = mItem.Qty_On_Hand_roll__c;
                        }
                        // updateInvList.add(miinv);
                    }
                    else if(mItem.Calc_Unit__c=='Sheet'){
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                            mulitem.Qty_On_Hand__c = mItem.Qty_On_Hand__c - (mItem.Case_Pack__c * diff);
                            system.debug(' mulitem.Qty_On_Hand__c=== '+ mulitem.Qty_On_Hand__c);
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                            mulitem.Credit__c=mulitem.Credit__c != null ? mulitem.Credit__c * mItem.Case_Pack__c : 0;
                             system.debug('mulitem.Credit__c=== '+mulitem.Credit__c);
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                            mulitem.Debit__c=mulitem.Debit__c != null ? mulitem.Debit__c * mItem.Case_Pack__c : 0;
                              system.debug('mulitem.Debit__c=== '+mulitem.Debit__c);
                        }
                        if(Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isCreateable() || Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isUpdateable()){
                            miinv.Qty_On_Hand_temp__c = mItem.Qty_On_Hand_case__c;
                           system.debug('miinv.Qty_On_Hand_temp__c=== '+miinv.Qty_On_Hand_temp__c);  
                        }
                        // updateInvList.add(miinv);
                    }
                    else{
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                            mulitem.Qty_On_Hand__c = mItem.Qty_On_Hand__c - diff;
                        }
                        if(Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isCreateable() || Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isUpdateable()){
                            miinv.Qty_On_Hand_temp__c = mItem.Qty_On_Hand__c;
                        }
                        // updateInvList.add(miinv);
                    }
                }
                else{
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                        mulitem.Material_Item__c = miinv.Material_Item__c;
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                        mulitem.Type__c = 'Reconciliation';
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                        mulitem.Credit__c = -1 * diff;
                        system.debug('mulitem.Credit__c==== '+mulitem.Credit__c);
                    }
                    DateTime dT = System.now();
                    Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                        mulitem.Date__c = myDate;
                    }
                    if(mItem.Calc_Unit__c=='Size'){
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                            mulitem.Qty_On_Hand__c = mItem.Qty_On_Hand__c + (mItem.Roll_LF__c * (-1*diff));
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                            mulitem.Credit__c=mulitem.Credit__c != null ? mulitem.Credit__c * mItem.Roll_LF__c : 0;
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                            mulitem.Debit__c=mulitem.Debit__c != null ? mulitem.Debit__c * mItem.Roll_LF__c: 0;
                        }
                        if(Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isCreateable() || Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isUpdateable()){
                            miinv.Qty_On_Hand_temp__c = mItem.Qty_On_Hand_roll__c;
                        }
                        //updateInvList.add(miinv);
                    }
                    else if(mItem.Calc_Unit__c=='Sheet'){
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                            mulitem.Qty_On_Hand__c = mItem.Qty_On_Hand__c + (mItem.Case_Pack__c * (-1*diff));
                            system.debug(' mulitem.Qty_On_Hand__c==='+ mulitem.Qty_On_Hand__c);
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                            mulitem.Credit__c=mulitem.Credit__c != null ? mulitem.Credit__c * mItem.Case_Pack__c : 0;
                            system.debug('mulitem.Credit__c==='+ mulitem.Credit__c);
                        }
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                            mulitem.Debit__c=mulitem.Debit__c != null ? mulitem.Debit__c * mItem.Case_Pack__c : 0;
                            system.debug('mulitem.Debit__c==='+ mulitem.Debit__c);
                            
                        }
                        if(Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isCreateable() || Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isUpdateable()){
                            miinv.Qty_On_Hand_temp__c = mItem.Qty_On_Hand_case__c;
                            system.debug(' miinv.Qty_On_Hand_temp__c==='+  miinv.Qty_On_Hand_temp__c);
                            
                        }
                        //updateInvList.add(miinv);
                    }
                    else{
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                            mulitem.Qty_On_Hand__c = mItem.Qty_On_Hand__c + (-1*diff);
                        }
                        if(Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isCreateable() || Schema.sObjectType.Material_Inventory_Item__c.fields.Qty_On_Hand_temp__c.isUpdateable()){
                            miinv.Qty_On_Hand_temp__c = mItem.Qty_On_Hand__c;
                        }
                        //updateInvList.add(miinv);
                    }
                }
                
                if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){
                    mItem.Qty_On_Hand__c = mulitem.Qty_On_Hand__c;
                    system.debug('  mItem.Qty_On_Hand__c==='+    mItem.Qty_On_Hand__c);
                    
                }
                
                mulitemlist.add(mulitem);
                system.debug('mulitemlist===== '+mulitemlist+'\n');
                mitemlist.add(mItem);
                system.debug('mitemlist===== '+mitemlist+'\n');
            }
        }
    }
    if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
        Insert mulitemlist;
    }
    if(Schema.sObjectType.Material_Item__c.isUpdateable()){
        Update mitemlist;
    }
    //upsert updateInvList;
    
}