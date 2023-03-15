({
    doInit : function(component, event, helper) {
        
        helper.getTagTemp(component, event, helper);
        helper.getDataTableRespone(component, event);
        helper.FetchFieldsfromFS(component, event);
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
                
            case 'Edit_Tag':
                component.set("v.isTagOpen", true);
                component.set('v.TagRecordid',row.Id);
                break;
                
            case 'Delete_Tag':
                helper.deleteJobTag(component, event, helper);
                break;
                
            case 'Duplicate_Tag':
                helper.duplicateJobTag(component, event, helper);
                break;
                
        }
    },
    
    ImportTemplate:function(component, event, helper) {
        
        var importaction = component.get("c.importTags");
        var ToastMsg=$A.get("e.force:showToast");
        console.log('=recid=='+component.get("v.recordId"));
        importaction.setParams({
            Jobid: component.get("v.recordId"),
            selectedTagTemp:component.find("TagTempSelectId").get("v.value")
        });
        
        importaction.setCallback(this, function(res) {
            console.log('==== ImportTemplate before=='+ res.getReturnValue());
            var state11 = res.getState();
            if (state11 === "SUCCESS"){
                if(res.getReturnValue()==="Sucessfully Imported Tag records") {
                    console.log('====ImportTemplate  sucess=='+ res.getReturnValue());
                    ToastMsg.setParams({
                        "title":"Import Tags",
                        "type": "success",
                        "message":  res.getReturnValue()
                    });
                    
                    helper.getDataTableRespone(component, event);
                    ToastMsg.fire();
                    component.find("TagTempSelectId").set("v.value", null);
                }
                else{
                    ToastMsg.setParams({
                        "title":"Error",
                        "type": "error",
                        "message":  res.getReturnValue()
                        
                    }); 
                    
                    ToastMsg.fire();
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError());
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(importaction); 
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
    
    CreateTagRecord:function (component, event, helper) {
        component.set("v.isTagOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isTagOpen", false);
        component.set('v.TagRecordid', null);
    },
    
    jobTagload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.TagRecordid");
        console.log('===Recordid after==='+recId); 
        if(recId!=null){
            var Tagfilds = event.getParam("recordUi");
        }
    },
    
    jobTagOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Tagfields = event.getParam("fields");
        console.log('========'+component.get("v.recordId"));
        Tagfields["Job__c"]=component.get("v.recordId");
        var missField = "";
        var reduceReutrn = component.find('JobTagField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var TagName = inputCmp.get("v.value");
                if (TagName == null || TagName == '') 
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
            component.find("TagEditform").submit(Tagfields);
        }
        
    },
    
    onTagRecordSuccess: function(component, event, helper) { 
        var TagId=component.get('v.TagRecordid');
        var msg;
        if(TagId=='undefined' || TagId==null ){
            msg='Successfully Inserted Record';
        }
        else{
            msg='Successfully Updated Record';
        }
        console.log('===record Success==='+TagId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        component.set('v.TagRecordid',null);
        component.set("v.isTagOpen", false);
        helper.getDataTableRespone(component, event);
        ToastMsg11.fire();
    },
    //****mobile actions******/
    handleTagQuickAction : function(component, event, helper) { 
        var selectOption=event.getParam("value");
        var selectTagId=event.getSource().get("v.name");
        console.log('---selectTsId-'+selectTagId+'---option--'+selectOption);
        if(selectOption=='Edit'){
            component.set("v.isTagOpen", true);
            component.set('v.TagRecordid',selectTagId);
        }
        else if(selectOption=='Delete'){  
            helper.deleteJobTag(component, event, helper,selectTagId);
        }
            else{
                 helper.duplicateJobTag(component, event, helper,selectTagId);
            }
    }
    
    
})