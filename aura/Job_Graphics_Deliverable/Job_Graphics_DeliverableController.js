({
    doInit : function(component, event, helper) {
        helper.FetchFieldsfromFS(component, event, helper); 
        helper.getDataTableRespone(component, event);
        helper.getFieldLabels(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
        
        var helpTextRec= component.get("c.getHelpTextrecords"); 
        helpTextRec.setCallback(this, function(helpTextResponse){
            if (helpTextResponse.getState() === "SUCCESS") {
                console.log('=Help Text Values=='+JSON.stringify(helpTextResponse.getReturnValue()));
                component.set("v.helpText",helpTextResponse.getReturnValue());
            }
        }); 
        $A.enqueueAction(helpTextRec); 
        
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_GD':
                component.set("v.isGDOpen", true);
                component.set('v.GDRecordid',row.Id);
                break;
                
            case 'Delete_GD':
                helper.deleteJobGD(component, event, helper);
                break;
                
            case 'Duplicate_GD':
                helper.duplicateJobGD(component, event, helper);
                break;
                
        }
    },
    
    recordsUpdateforchanges: function (cmp, event, helper) {
        helper.getDataTableRespone(cmp, event);
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    GDCreate:function (component, event, helper) {
        component.set("v.isGDOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isGDOpen", false);
        component.set('v.GDRecordid', null);
    },
    
    jobGDload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.GDRecordid");
        console.log('===Recordid after==='+recId); 
        if(recId!=null){
            var GDfilds = event.getParam("recordUi");
            if(component.find("StartTime")!=null){
                component.find("StartTime").set("v.value",GDfilds.record.fields.Start_Time__c.value);
                
            }
            if(component.find("EndTime")!=null){
                component.find("EndTime").set("v.value",GDfilds.record.fields.End_Time__c.value);
            }
        }
    },
    
    jobGDOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var GDfields = event.getParam("fields");
        console.log('========'+component.get("v.recordId"));
        GDfields["Job__c"]=component.get("v.recordId");
        var missField = "";
        var reduceReutrn = component.find('JobGDField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var GDName = inputCmp.get("v.value");
                if (GDName == null || GDName == '') 
                    missField = "Name";
            } 
            
        }, true);
        
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
        
        if (missField == "Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else
        {
            
            var starttimeval;           
            if(component.find("StartTime")!=null){
                starttimeval=component.find("StartTime").get("v.value");
                console.log('>>>>>>>> Start time >>>>>>>>>>>>>>'+ starttimeval);
                if(starttimeval!=null){
                    if(starttimeval.length==0){
                        GDfields["Start_Time__c"]=null; 
                    }
                    else{
                        GDfields["Start_Time__c"]=starttimeval;
                    }
                }else{
                    GDfields["Start_Time__c"]=null;
                }
            }
            var EndTimeval;
            if(component.find("EndTime")!=null){
                EndTimeval=component.find("EndTime").get("v.value");
                console.log('>>>>>>>> End time >>>>>>>>>>>>>>'+ EndTimeval);                
                if(EndTimeval!=null){
                    if(EndTimeval.length==0){
                        GDfields["End_Time__c"]=null; 
                    }
                    else{
                        GDfields["End_Time__c"]=EndTimeval;
                    }
                } 
                else{
                    GDfields["End_Time__c"]=null;
                }
            }           
            
            
            component.find("GDEditform").submit(GDfields);
        }
        
    },
    
    onGDRecordSuccess: function(component, event, helper) { 
        var GDId=component.get('v.GDRecordid');
        var msg;
        if(GDId=='undefined' || GDId==null ){
            msg='Successfully Inserted Record';
        }
        else{
            msg='Successfully Updated Record';
        }
        console.log('===record Success==='+GDId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        component.set('v.GDRecordid',null);
        component.set("v.isGDOpen", false);
        helper.getDataTableRespone(component, event);
        ToastMsg11.fire();
    },
    /****mobiel actions********/
    handleGdQuickAction : function(component, event, helper) { 
        var selectOption=event.getParam("value");
        var selectGdId=event.getSource().get("v.name");
        console.log('---selectGdId-'+selectGdId+'---option--'+selectOption);
        if(selectOption=='Edit'){
            component.set("v.isGDOpen", true);
            component.set('v.GDRecordid',selectGdId);
        }
        else if(selectOption=='Delete'){  
            helper.deleteJobGD(component, event, helper,selectGdId);
        }
            else{
                helper.duplicateJobGD(component, event, helper,selectGdId);
            }
    }
})