({
	doInit : function(component, event, helper) {
       // component.set('v.MIUIColumns', 
        helper.getColumnDefinitionsForMIUI(component, event, helper);
        // component.set('v.MInvColumns', 
        helper.getColumnDefinitionsMIInv(component, event, helper);
        helper.fetchFieldSet(component, event, helper);
        helper.fetchMaterialUsageItems(component, event, helper);
        helper.fetchMaterialInventory(component, event, helper);
    },
    
   
    addMaterailUsageLineItem:function(component, event, helper) {
       // alert('Working');
        component.set("v.isMIUIOpen",true);
    },
    
     closeModelMIUI :function(component, event, helper) {
          component.set("v.isMIUIOpen",false);
    },
    
    addMaterailInventory: function(component, event, helper) {
        component.set("v.isMInvOpen",true);
    },
    
    closeModelMInv :function(component, event, helper) {
          component.set("v.isMInvOpen",false);
    },
    
    MIUIOnSubmit :function(component, event, helper) {
        event.preventDefault();
        var MIUIfields=event.getParam("fields");
        MIUIfields["Material_Item__c"]=component.get("v.recordId");
        var MIrec=component.get("v.simpleRecord");
        console.log('===CalUnit====='+MIrec.Calc_Unit__c);
        console.log('===Fields in simpler Record===='+JSON.stringify(MIrec));
        var allMIUIRecords=component.get("v.MaterialUsageItems");
        var LatestMIUIRecord;
        for(var i=0; i<allMIUIRecords.length; i++){
            if(allMIUIRecords[i].rowIndexNo==0){
                LatestMIUIRecord=allMIUIRecords[i];
            }
        }
        console.log('====Latest MIUI Record After=='+JSON.stringify(LatestMIUIRecord));
        var qtyonhand;
        if(LatestMIUIRecord!=null){
            //qtyonhand=parseInt(LatestMIUIRecord.Qty_On_Hand__c);
            qtyonhand=LatestMIUIRecord.Qty_On_Hand__c;
        }
        
        else{
            qtyonhand=0;
        }
        //console.log('>>>>Qty on Hand before parsing negative values>>>'+parseInt(-0.5));
        //console.log('>>>>Sheet Calc Qty on Hand before parsing>>>'+LatestMIUIRecord.Qty_On_Hand__c);
        //console.log('>>>>Sheet Calc Qty on Hand>>>'+qtyonhand);
        //console.log((MIUIfields.Credit__c != null));
        console.log('====MIUIf Roll LF======'+MIrec.Roll_LF__c);
        console.log('====MIUIf Casepack======'+MIrec.Case_Pack__c);
        console.log('====MIUIf Roll LF type======'+ (typeof(MIrec.Roll_LF__c)));
        console.log('====MIUIf Casepack type======'+(typeof(MIrec.Case_Pack__c)));
        //console.log('====differnce for Each======'+ ((qtyonhand) +((MIUIfields.Credit__c != null ? MIUIfields.Credit__c : 0) - (MIUIfields.Debit__c != null ? MIUIfields.Debit__c : 0))));
        //console.log('====differnce for size======'+ ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c : 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c : 0))));
        //console.log('====differnce for Sheet======'+((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c: 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0))));
       
        if(MIrec.Calc_Unit__c=='Size'){
            MIUIfields["Qty_On_Hand__c"]= ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c : 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c : 0)));
            //objMaterial.Qty_On_Hand__c=(qtyonhand +(MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c: 
            //0))- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c: 0);
            MIUIfields["Credit__c"]=(MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c : 0);
            MIUIfields["Debit__c"]=(MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c: 0);
        }
        
        else if(MIrec.Calc_Unit__c=='Sheet'){
            console.log('>>>>Sheet Calc Qty on Hand>>>'+qtyonhand);
            MIUIfields["Qty_On_Hand__c"]= ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c: 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0)));
            //objMaterial.Qty_On_Hand__c=((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c: 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0)));
            MIUIfields["Credit__c"]=(MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c : 0);
            MIUIfields["Debit__c"]=(MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0);
        }
        
            else{
                MIUIfields["Qty_On_Hand__c"]= ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c : 0) - (MIUIfields.Debit__c != null ? MIUIfields.Debit__c : 0)));
               //objMaterial.Qty_On_Hand__c=((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c : 0) - (MIUIfields.Debit__c != null ? MIUIfields.Debit__c : 0)));
            } 
        
        component.find("MIUIEditform").submit(MIUIfields);
        console.log('===Material Usage Items OnSubmit fields===='+JSON.stringify(MIUIfields));
    },
    
    MIUIOnSuccess :function(component, event, helper) {
        helper.showToast({
            "type":"success",
            "message":"Record Inserted Successfully."
        });
       // helper.fetchMaterialInventory(component, event, helper);
        helper.updateMaterailItemQtyOnHandField(component, event, helper);
        helper.fetchMaterialUsageItems(component, event, helper);
        component.set("v.isMIUIOpen",false);
        //helper.reloadData();
    },
    
    MInvOnSubmit :function(component, event, helper) {
        event.preventDefault();
        var MInvfields=event.getParam("fields");
        MInvfields["Material_Item__c"]=component.get("v.recordId");
        MInvfields["Name"]='Inventory-('+component.get('v.today')+')';
        MInvfields["Mfg_Item_Number__c"]=component.get("v.simpleRecord.Manufacturer_Item_No__c");
        var missField;
        var missField1;
        var reduceReutrn = component.find('MInvField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name"){
                var MInvName = inputCmp.get("v.value");
                if (MInvName == null || MInvName == ''){
                    missField = "Name";
                }
            } 
            else if(inputCmp.get("v.fieldName") == "Qty_On_Shelf__c" ){
                var QtyOnSelf = inputCmp.get("v.value");
                if (QtyOnSelf == null ) {
                    missField1= "Qty_On_Shelf";
                }
            } 
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");    
        if(missField=="Name"){
            ToastMsg.setParams({
                "title":"Name",
                "type": "error",
                "message":"Name Field is required."
            }); 
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(missField1=="Qty_On_Shelf"){
            ToastMsg.setParams({
                "title":"Qty On Shelf",
                "type": "error",
                "message":"Qty On Shelf Field is required."
            }); 
            ToastMsg.fire();
            event.preventDefault();
        }
        else{
             component.find("MInvEditform").submit(MInvfields);
             console.log('===Material Invenotry OnSubmit fields===='+JSON.stringify(MInvfields));
           }
    },
    
    MInvOnSuccess :function(component, event, helper) {
        helper.showToast({
            "type":"success",
            "message":"Record Inserted Successfully."
        });
        helper.fetchMaterialInventory(component, event, helper);
        helper.fetchMaterialUsageItems(component, event, helper);
        component.set("v.isMInvOpen",false);
       
    },
    
     updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    }, 
    
    updateColumnSortingForMInventory :function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortDataMInv(cmp, fieldName, sortDirection);
    }, 
    
    handleRowActionForMIUI:function(component, event, helper) {
        var action=event.getParam('action');
        var row=event.getParam('row');
        switch(action.name){
            case 'Delete_MIUI':
                    helper.deleteMaterialUsageLineItem(component, event, helper,row.Id);
                    break;
        }
    },
    
    handleRowActionMInv:function(component, event, helper) {
        var action=event.getParam('action');
        var row=event.getParam('row');
        switch(action.name){
            case 'Delete_MUInv':
                    helper.deleteMaterialInventory(component, event, helper,row.Id);
                    break;
        }
    }
})