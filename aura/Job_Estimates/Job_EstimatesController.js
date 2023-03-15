({
    doInit : function(component, event, helper) {
        console.log('>>>>>> doInit Method >>>>>>>>');
        var checkCreate=component.get("c.getEstPermiossions");
        checkCreate.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[0]")){
                    helper.CreateEstRecord(component, event, helper);
                    helper.getFieldLabels(component, event, helper); 
                    helper.fetchJobEst(component, event, helper);
                    helper.getGLDepartment(component, event, helper);
                }                            
            }
        });
        $A.enqueueAction(checkCreate);
        
        
        
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
        
    },
    
    
    
    RedirectEstimateReport : function (component, event, helper) {
        console.log('>>>>>> RedirectEstimateReport Method >>>>>>>>');
        var jobid=component.get("v.jobrecordId");
        window.open('/one/one.app#/alohaRedirect/apex/EstimateReport?id='+jobid,'_blank'); 
    },
    
    recordsUpdateforchanges: function (cmp, event, helper) {
        console.log('>>>>>> recordsUpdateforchanges Method >>>>>>>>');
        // alert('fireing in estimate section after records delete and insert');
        helper.fetchJobEst(cmp, event, helper);
    },
    
    
    updateColumnSorting: function (cmp, event, helper) {
        console.log('>>>>>> updateColumnSorting Method >>>>>>>>');
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onSave : function (component, event, helper) {
        console.log('>>>>>> onSave Method >>>>>>>>');
        helper.saveDataTable(component, event, helper);
    },
    
    EstCreate:function (component, event, helper) {
        console.log('>>>>>> EstCreate Method >>>>>>>>');
        if(component.get("v.isAccess[1]")){
            component.set("v.isEstOpen", true);
        }
        else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Estimate has insufficient access to create'
            });   
        }   
    },
    
    OnChangeGLDepatment:function(component, event, helper) {
        console.log('>>>>>> OnChangeGLDepatment Method >>>>>>>>');
        //component.set("v.GL_CodeRecords", null); 
        component.find("GLCodeSelectId").set('v.value',null);
        component.set("v.VendorRecords", null); 
        component.find("VendorId").set('v.value',null);
        component.set('v.Amount', null);
        helper.getGLCode(component, event, helper, null, null);
    },
    
    OnchangeGLCode:function(component, event, helper) {
        console.log('>>>>>> OnchangeGLCode Method >>>>>>>>');
        component.find("VendorId").set('v.value',null); 
        var GLCodeVal=component.find("GLCodeSelectId").get('v.value');
        console.log('--GLCodeVal-'+GLCodeVal);
        helper.getVendor(component, event, helper, GLCodeVal, null);
    },
    
    closeModel: function(component, event, helper) {
        console.log('>>>>>> closeModel Method >>>>>>>>');
        component.set("v.isEstOpen", false);
        component.set('v.EstRecordid', null);
        component.set('v.Amount', null);
    },
    
    /*   CreatePO : function(component, event, helper){
        var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        var JobId = component.get("v.jobrecordId");
        evt.setParams({
            componentDef  : "c:Job_Purchase_Orders" ,
            componentAttributes : {
                jobrecordId : JobId,
                isPOOpen : true,
                isPOContentClose:true
            }
        });
        evt.fire();
    },
    */
    
   jobEstload:  function(component, event, helper) { 
        console.log('===record Load Starts===');
        var recId=component.get("v.EstRecordid");
        console.log('===Recordid after==='+recId);           
        if(recId!=null){
            var Estfilds = event.getParam("recordUi");
            //helper.CreateEstRecord(component, event, helper); 
            //helper.getGLDepartment(component, event, helper);
            component.find("GLDSelectId").set("v.value",Estfilds.record.fields.GL_Department__c.value);
            
            var GLCodeVal=Estfilds.record.fields.GL_Code__c.value;
            
           // component.find("GLCodeSelectId").set("v.value",GLCodeVal);
            var VendorVal=Estfilds.record.fields.Vendor__c.value;
            
            helper.getGLCode(component, event,helper, GLCodeVal, VendorVal); 
            
            /*setTimeout($A.getCallback(function() {
                component.find("GLCodeSelectId").set("v.value",Estfilds.record.fields.GL_Code__c.value);
                console.log('==GL_Code__c Onload Id=='+component.find("GLCodeSelectId").get("v.value"));
                helper.getVendor(component, event, helper);
            }), 1500);
           
            setTimeout($A.getCallback(function() {
                component.find("VendorId").set("v.value",Estfilds.record.fields.Vendor__c.value);
                console.log('==Vendor__c Onload Id=='+component.find("VendorId").get("v.value"));
            }), 2500);*/
            console.log('===record Load Endss===');
        }
    },
    
    jobEstOnsubmit : function(component, event, helper) {
        console.log('===record Onsubmit Starts===');
        event.preventDefault(); // Prevent default submit
        var Estfields = event.getParam("fields");
        console.log('========'+component.get("v.jobrecordId"));
        Estfields["Job__c"]=component.get("v.jobrecordId");
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('JobEstField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var EstName = inputCmp.get("v.value");
                if (EstName == null || EstName == '') 
                    missField = "Name";
            } 
            
            else if(inputCmp.get("v.fieldName") == "Quantity__c"){
                var EstName1 = inputCmp.get("v.value"); 
                if (EstName1 == null || EstName1 == '') 
                    missField1 = "Quantity";
            }
                else if(inputCmp.get("v.fieldName") == "Amount__c"){
                    var EstUnit = inputCmp.get("v.value"); 
                    if (EstUnit == null || EstUnit == '') 
                        missField2 = "Unit Cost";
                }
        }, true);
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
        var ToastMsg2 = $A.get("e.force:showToast");
        ToastMsg2.setParams({
            "title": missField1,
            "type": "error",
            "message": missField1 + " Field is required."
            
        }); 
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": missField2,
            "type": "error",
            "message": missField2 + " Field is required."
        }); 
        if (missField == "Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        
        else if(component.find("GLDSelectId").get("v.value")==null || component.find("GLDSelectId").get("v.value")==""){
            var ToastMsg3=$A.get("e.force:showToast");
            ToastMsg3.setParams({
                "title":"GL Depatment",
                "type": "error",
                "message":"GL Depatment Field is required."
                
            });   
            ToastMsg3.fire();
            event.preventDefault();   
        }
            else if(component.find("GLCodeSelectId").get("v.value")==null || component.find("GLCodeSelectId").get("v.value")==""){
                var ToastMsg4=$A.get("e.force:showToast");    
                ToastMsg4.setParams({
                    "title":"GLCode",
                    "type": "error",
                    "message":"GLCode Field is required."
                    
                });   
                ToastMsg4.fire();
                event.preventDefault();   
            }
                else if(component.find("VendorId").get("v.value")==null || component.find("VendorId").get("v.value")==""){
                    var ToastMsg5=$A.get("e.force:showToast");    
                    ToastMsg5.setParams({
                        "title":"Vendor",
                        "type": "error",
                        "message":"Vendor Field is required."
                        
                    });   
                    ToastMsg5.fire();
                    event.preventDefault();   
                }
        
                    else if (missField1 == "Quantity"){
                        ToastMsg2.fire();
                        event.preventDefault();
                    }
                        else if (missField2 == "Unit Cost"){
                            ToastMsg1.fire();
                            event.preventDefault();
                        }
        
                            else{
                                Estfields["GL_Department__c"]=component.find("GLDSelectId").get("v.value");
                                console.log('===GL_Department__c On submit==='+component.find("GLDSelectId").get("v.value"));
                                Estfields["GL_Code__c"]=component.find("GLCodeSelectId").get("v.value");
                                console.log('===Code  On submit==='+component.find("GLCodeSelectId").get("v.value"));
                                Estfields["Vendor__c"]=component.find("VendorId").get("v.value");
                                console.log('===Ven  On submit==='+component.find("VendorId").get("v.value"));
                                component.find("JobEstEditform").submit(Estfields);
                                console.log('===form Estfields==='+JSON.stringify(Estfields));
                                //component.set("v.isEstOpen", false);
                                // component.set('v.EstRecordid', null);
                            }
        
        console.log('===record Onsubmit Ends===');
        
    },
    
    onEstRecordSuccess: function(component, event, helper) { 
        
        console.log('====Estimate record Success Starts====');
        
        var EstId=component.get('v.EstRecordid');
        var msg;
        if(EstId=='undefined' || EstId==null ){
            msg='Successfully Inserted Job Estimate Record';
        }
        else{
            msg='Successfully Updated Job Estimate Record';
        }
        console.log('===record Success Id==='+EstId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Success",
            "type": "success",
            "message":msg
            
        });
        
        setTimeout($A.getCallback(function() {
            component.set("v.isEstOpen", false);
            component.set("v.EstRecordid",null);
            helper.fetchJobEst(component, event, helper);
        }), 2500);
        ToastMsg11.fire();
        console.log('========Estimate record Success Ending===');
    },
    
    
    handleRowAction: function(component, event, helper) {
        console.log('>>>>>> handleRowAction Method >>>>>>>>');
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_Estimate':
                if(component.get("v.isAccess[2]")==true){
                    component.set("v.isEstOpen", true);
                    component.set('v.EstRecordid',row.Id);
                }                
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Estimate has insufficient access to edit/update'
                    });   
                }        
                break;
                
            case 'Delete_Estimate':
                helper.deleteJobEst(component, event, helper);
                break;
                
            case 'Dup_Estimate':
                helper.duplicateJobEst(component, event, helper);
                break;
                
            case 'Approve_Estimate':
                helper.approveJobEst(component, event, helper);
                break;
                
            case 'UnApprove_Estimate':
                helper.unapproveJobEst(component, event, helper);
                break;
        }
    },
    
    /************** Mobile Action ******************************/
    
    handleEstQuickAction : function(component, event, helper) {
        console.log('====handleEstQuickAction Method Starts====');
        var selectOption=event.getParam("value");
        var selectEstId=event.getSource().get("v.name");
        console.log('---selectEstId-'+selectEstId+'---selectOption--'+selectOption);
        
        switch (selectOption) {
                
            case 'Edit_Estimate':
                component.set("v.isEstOpen", true);
                component.set('v.EstRecordid',selectEstId);
                break;
                
            case 'Delete_Estimate':
                helper.deleteJobEst(component, event, helper, selectEstId);
                break;
                
            case 'Dup_Estimate':
                helper.duplicateJobEst(component, event, helper, selectEstId);
                break;
                
            case 'Approve_Estimate':
                helper.approveJobEst(component, event, helper, selectEstId);
                break;
                
            case 'UnApprove_Estimate':
                helper.unapproveJobEst(component, event, helper, selectEstId);
                break;
        }
    }
})