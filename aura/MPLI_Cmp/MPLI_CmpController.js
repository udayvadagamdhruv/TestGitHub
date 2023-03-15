({
    doInit : function(component, event, helper) {
        var checkPEpermisson=component.get("c.getMPLIPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[0]")){
                    helper.CreateMPLIRecord(component, event, helper); 
                }
                if(component.get("v.isAccess[3]")){
                    helper.CreateMPLIReceiptRecord(component, event, helper);
                }
            }
        });
        $A.enqueueAction(checkPEpermisson); 
        helper.getFieldLabels(component, event, helper);
        helper.fetchMPLI(component, event, helper); 
        helper.fetchMOLIReceiptRecords(component, event, helper);
        
    },
    
    handleRowActionReceipt :function(component, event, helper) {
        var action=event.getParam("action");
        var row=event.getParam("row"); 
        component.set('v.MPLIName',row.Material_Purchase_Line_Item__c);
        switch(action.name){
            case 'Edit_MOLIReceipt':
                component.set("v.isMOLIReceiptOpen", true);
                component.set('v.MPLIReceiptRecordid',row.Id);
                break;
                
            case 'Delete_MOLIReceipt':
                //helper.deleteMO(component, event, helper,row.Id);
                break;
        }
    },
    
    handleRowAction :function(component, event, helper) {
        var action=event.getParam("action");
        var row=event.getParam("row");
        component.set('v.MPLIRecordid',row.Id);
        switch(action.name){
            case 'Edit_MPLI':
                component.set("v.isMPLIOpen", true);
                break;
                
            case 'Delete_MPLI':
                helper.deleteMO(component, event, helper,row.Id);
                break;
                
            case 'New_MPLI_Receipt':
                component.set("v.isMOLIReceiptOpen", true);
                component.set("v.MPLIRowId",row.Id);
                component.set("v.MPLIName", row.Name);
                helper.CreateMPLIReceiptRecord(component, event, helper,row.Id);
                break;
                
                //This is commented for moli receipt on 15 - 04 - 2022
                /*  case 'Mark_Received_Done':        
                helper.MarkReceivedDone(component, event, helper,row.Id);
                break;*/
        }
    },
    
    statuschange : function(component, event, helper) {
        
    },
    
    CalUnitChange : function(component, event, helper) {
        var recId=component.get("v.ProEstRecordId");
        if(recId==null)
        {
            var CalUnit=component.find("CalUnitFieldId").get("v.value");
            console.log("========CalUnit===="+CalUnit);
            console.log("========CalUnit true===="+(CalUnit!=''));
            console.log("========CalUnit true===="+(CalUnit==''));
            
            if(CalUnit=='Each'){
                component.set("v.isCalUnitEach",true);
                component.set("v.isCalUnitSheet",false);
                component.set("v.isCalUnitSize",false);
                console.log("========Each=======");
            }
            if(CalUnit=='Sheet'){
                component.set("v.isCalUnitEach",false);
                component.set("v.isCalUnitSheet",true);
                component.set("v.isCalUnitSize",false);
                console.log("========Sheet=======");
            }
            if(CalUnit=='Size'){
                component.set("v.isCalUnitEach",false);
                component.set("v.isCalUnitSheet",false);
                component.set("v.isCalUnitSize",true);
                console.log("========Size=======");
            }
            component.set('v.materialitemfieldvalues',null);
            helper.getMaterialItems(component, event, helper,CalUnit);
        }
    },
    
    MPLICreate : function(component, event, helper) {
        if(component.get("v.isAccess[1]")){
            component.set("v.isMPLIOpen",true);
        }
    },
    MPLIload :  function(component, event, helper) {
        var MPLIfilds = event.getParam("recordUi");
        var  MaterialItemvalue = MPLIfilds.record.fields.Material_Item__c.value; 
    },
    
    materialitemchange : function(component, event, helper) {
        var mivalue = component.find('MISelectId').get('v.value');   
        var action = component.get("c.getMatereialItemsFieldvalues");
        action.setParams({
            rcdids : mivalue
        });
        action.setCallback(this, function(response) {
            console.log("=====Response====", response.getReturnValue());
            if (response.getState() === "SUCCESS") 
            {
                var mifieldsvalues  = response.getReturnValue(); 
                component.set('v.materialitemfieldvalues',mifieldsvalues);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    MPLIOnsubmit :  function(component, event, helper) {
        event.preventDefault();
        var MIPLIfields=event.getParam("fields");
        var MIrec=component.get("v.simpleRecord");
        var MPLIRecordid=component.get("v.MPLIRecordid");
        var QtyField = '';
        var  MaterialItemvalue = '';
        var Statusvalue = '';
        var Calcunitval = '';
        if(MPLIRecordid == null || MPLIRecordid == 'undefined'){
            MIPLIfields["Material_Order__c"]=component.get("v.recordId");
            MIPLIfields["Material_Item__c"]=component.find("MISelectId").get("v.value");  
            QtyField =   component.find('MPLIQty').get('v.value');
            MaterialItemvalue = component.find('MISelectId').get('v.value');
            Statusvalue = component.find('statusFieldId').get('v.value');
            Calcunitval = component.find('CalUnitFieldId').get('v.value');
            if(Calcunitval == null || Calcunitval == 'undefined' || Calcunitval == ''){
                var ToastCalMsg = $A.get("e.force:showToast");
                ToastCalMsg.setParams({
                    "title": "Calc Unit",
                    "type": "error",
                    "message":"Calc Unit  Field is required."
                });
                ToastCalMsg.fire(); 
            }
            else if(QtyField == null || QtyField == 'undefined' || QtyField == ''){
                var ToastCalMsg = $A.get("e.force:showToast");
                ToastCalMsg.setParams({
                    "title": "Qty",
                    "type": "error",
                    "message":"Qty Field is required."
                });
                ToastCalMsg.fire();  
            }
                else if(Statusvalue == null || Statusvalue == 'undefined' || Statusvalue == ''){
                    var ToastCalMsg = $A.get("e.force:showToast");
                    ToastCalMsg.setParams({
                        "title": "Status",
                        "type": "error",
                        "message":"Status Field is required."
                    });
                    ToastCalMsg.fire();  
                }
                    else if(MaterialItemvalue == null || MaterialItemvalue == 'undefined' || MaterialItemvalue == ''){
                        var ToastCalMsg = $A.get("e.force:showToast");
                        ToastCalMsg.setParams({
                            "title": "Status",
                            "type": "error",
                            "message":"Material Item Field is required."
                        });
                        ToastCalMsg.fire();  
                    }
                        else{
                            component.find("JobMPLIEditform").submit(MIPLIfields);
                            console.log('===Material Invenotry OnSubmit fields===='+JSON.stringify(MIPLIfields));
                        }
        }
        else if(MPLIRecordid != null || MPLIRecordid != 'undefined'){
            var MPLIfilds = event.getParam("recordUi"); 
            QtyField =   component.find('MPLIQty').get('v.value');
            Statusvalue = component.find('statusFieldId').get('v.value');
            if(QtyField == null || QtyField == 'undefined' || QtyField == ''){
                var ToastCalMsg = $A.get("e.force:showToast");
                ToastCalMsg.setParams({
                    "title": "Qty",
                    "type": "error",
                    "message":"Qty Field is required."
                    
                });
                ToastCalMsg.fire();  
            }
            else if(Statusvalue == null || Statusvalue == 'undefined' || Statusvalue == ''){
                var ToastCalMsg = $A.get("e.force:showToast");
                ToastCalMsg.setParams({
                    "title": "Status",
                    "type": "error",
                    "message":"Status Field is required."
                    
                });
                ToastCalMsg.fire();  
            }
                else{
                    component.find("JobMPLIEditform").submit(MIPLIfields);
                    // alert('===Material Invenotry OnEdit fields===='+JSON.stringify(MIPLIfields));
                }
        }
    },
    
    onMPLIRecordSuccess :  function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        var MPLIRecordid=component.get("v.MPLIRecordid");
        var Statusvalue = component.find('statusFieldId').get('v.value');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();
        
        helper.showToast({
            "type":"success",
            "message":  "Material Purchase Line Item Record Inserted Successfully."
        }); 
        
        component.set("v.isMPLIOpen",false);
    },
    
    MPLIReceiptload : function(component,event,helper){
        var MPLIReceiptRecordid=component.get("v.MPLIReceiptRecordid");
        if(MPLIReceiptRecordid == 'undefined' || MPLIReceiptRecordid == null || MPLIReceiptRecordid == ''){
          component.set('v.NewrcdOrEditrcd',false);  
        }
        else{
         component.set('v.NewrcdOrEditrcd',true);   
        }
        /*var MOLIReceiptfilds = event.getParam("recordUi");   
        if(MOLIReceiptfilds.record.fields.Material_Purchase_Line_Item__c != null){
            var mpliid = MOLIReceiptfilds.record.fields.Material_Purchase_Line_Item__c.value;
        }*/
    },
    
    MPLIReceiptOnsubmit : function(component,event,helper){
        var mpliid = component.get('v.MPLIRowId');
        event.preventDefault();
        var MIPLIReceiptfields=event.getParam("fields");
        var MPLIReceiptRecordid=component.get("v. MPLIReceiptRecordid");
        var QtyField = '';
        var Statusvalue = '';
        if(MPLIReceiptRecordid == null || MPLIReceiptRecordid == 'undefined'){
            MIPLIReceiptfields["Material_Purchase_Line_Item__c"] = component.get("v.MPLIRowId");
            component.find("JobMPLIReceiptEditform").submit(MIPLIReceiptfields);
        }
        else{
             component.set('v.NewrcdOrEditrcd',true);
            component.find("JobMPLIReceiptEditform").submit(MIPLIReceiptfields);  
        }
    },
    
    onMPLIReceiptRecordSuccess : function(component,event,helper){
        component.set("v.isMOLIReceiptOpen",false);
        var record = event.getParam("response");
        var myRecordId = record.id; // ID of updated or created record
        var Statusvalue = component.find('statusFieldReceiptId').get('v.value');
       var neworedit = component.get('v.NewrcdOrEditrcd');
      //  alert(neworedit);
        if(Statusvalue == 'Received' && !neworedit){
            helper.createandupdatematerialusage(component, event, helper,myRecordId);
        }
        if(Statusvalue == 'Received' && neworedit){
            helper.createandupdatematerialusage(component, event, helper,myRecordId);
        }
        if(Statusvalue == 'Outstanding' && neworedit){
    helper.createandupdatematerialusage(component, event, helper,myRecordId);
        }
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();
        helper.showToast({
            "type":"success",
            "message":  "Material Order Line Item Receipt Record Inserted Successfully."
        });  
    },
    
    closeModel : function(component, event, helper) {
        
        component.set("v.isMPLIOpen", false);
        component.set('v.MPLIRecordid', null); 
        
        component.set("v.isMOLIReceiptOpen",false);
        component.set('v.MPLIReceiptRecordid', null); 
        
        component.set('v.materialitemfieldvalues',null);
    }
})