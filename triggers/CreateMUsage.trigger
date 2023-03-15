trigger CreateMUsage on Production_Estimate__c(after update) {
    
    //  system.debug('EditProductionEstimate.firstrun :' + EditProductionEstimate.firstrun + '    Started...');
    
    //if(EditProductionEstimate.firstrun){
    
    /*  If(trigger.isBefore ){

for(Production_Estimate__c pest:trigger.new){

if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==true){
pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c)/2;
}

else if (pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==false){
pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);
}

else  if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Single' && Pest.Qty_Up__c !=null){

pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);

}

else if(pest.Calc_Unit__c=='Each' && Pest.Qty_Up__c !=null){

pest.EachQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);

}

}

}*/
    
    If(trigger.IsAfter && trigger.IsUpdate) {
        
        integer qtyonhand;
        Map < id, list < Production_Estimate__c >> MaterialItemToProdMap = new Map < id, list < Production_Estimate__c >> ();
        Set < id > MaterialIds = new Set < id > ();
        
        list < String > processedProdIds = new list < String > ();
        
        for (Production_Estimate__c pe: Trigger.new) {
            if (EditProductionEstimate.processedProdIds.add(pe.id)) {
                processedProdIds.add(pe.id);
            }
        }
        system.debug('----processedProdIds---' + processedProdIds.size() + '---EditProductionEstimate.processedProdIds--' + EditProductionEstimate.processedProdIds.size());
        if (!processedProdIds.isEmpty()) {
            
            List < Material_Item__c > MaterialUpdatelist = new List < Material_Item__c > ();
            List < Material_Usage_line_item__c > Materialusagelist = new List < Material_Usage_line_item__c > ();
            
            for (Production_Estimate__c pe: [select id, name, quantity__c, Approved__c, Qty_Used__c, Lf_Used__c, Calc_Unit__c, Material_Item__c, Job__r.name, Job__r.Job_Auto_Number__c from Production_Estimate__c where id IN: processedProdIds WITH SECURITY_ENFORCED]) {
                Production_Estimate__c oldprod = Trigger.oldMap.get(pe.ID);
                
                if (pe.Approved__c && !oldprod.Approved__c) {
                    
                    MaterialIds.add(pe.Material_Item__c);
                    if (MaterialItemToProdMap.containsKey(pe.Material_Item__c)) {
                        
                        list<Production_Estimate__c> prodlist = new list <Production_Estimate__c>();
                        prodlist.add(pe);
                        list<Production_Estimate__c> newList = MaterialItemToProdMap.get(pe.Material_Item__c);
                        prodlist.addAll(newList);
                        MaterialItemToProdMap.put(pe.Material_Item__c, prodlist);
                        
                    } else {
                        MaterialItemToProdMap.put(pe.Material_Item__c, new list<Production_Estimate__c>{pe});
                    }
                    
                }
                
            }
            
            list < Material_Item__c > Materiallist = [select id, name, Qty_On_Hand__c from Material_Item__c where id IN: MaterialIds WITH SECURITY_ENFORCED];
            for (Material_Item__c Material: Materiallist) {
                system.debug(Material.Qty_On_Hand__c);
                decimal parentQuantity = (Material.Qty_On_Hand__c != null ? Material.Qty_On_Hand__c : 0);
                for (Production_Estimate__c pe: MaterialItemToProdMap.get(Material.id)) {
                    
                    system.debug('1---' + parentQuantity);
                    system.debug(pe.quantity__c);
                    system.debug(pe.name);
                    
                    Material_Usage_line_item__c mu = new Material_Usage_line_item__C();
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()) {
                        mu.Material_Item__c = Material.id;
                    }
                    if (pe.Calc_Unit__c == 'Size') {
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()) {
                            mu.Qty_On_Hand__c = parentQuantity - pe.Lf_Used__c;
                        }
                    } else {
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()) {
                            mu.Qty_On_Hand__c = parentQuantity - pe.Qty_Used__c;
                        }
                        
                    }
                    system.debug('3---' + mu.Qty_On_Hand__c);
                    
                    if (pe.Calc_Unit__c == 'Size') {
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()) {
                            mu.Debit__c = pe.Lf_Used__c;
                        }
                    } else {
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()) {
                            mu.Debit__c = pe.Qty_Used__c;
                        }
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()) {
                        mu.Type__c = 'Job';
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()) { 
                        mu.Date__c = system.today();
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Description__c.isCreateable()) {
                        mu.Description__c = pe.job__r.name + ' - ' + pe.job__r.Job_Auto_Number__c + ' - ' + pe.name;
                    }
                    if(Schema.sObjectType.Material_Usage_line_item__c.fields.Production_Estimate__c.isCreateable()) {
                        mu.Production_Estimate__c = pe.id;
                    }
                    Materialusagelist.add(mu);
                    
                    if (pe.Calc_Unit__c == 'Size') {
                        parentQuantity -= pe.Lf_Used__c;
                    } else {
                        parentQuantity -= pe.Qty_Used__c;
                    }
                    
                    system.debug('4---' + parentQuantity);
                }
                
                if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()) {
                    Material.Qty_On_Hand__c = parentQuantity;
                }
                MaterialUpdatelist.add(Material);
            }
            if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
                Insert Materialusagelist;
            }
            if(Schema.sObjectType.Material_Item__c.isUpdateable()){
                update MaterialUpdatelist;
            }
        }
    }
    
    //EditProductionEstimate.firstrun = false;
    
    //}
}