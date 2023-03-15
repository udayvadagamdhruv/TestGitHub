({
    doInit : function(component, event, helper) {
        var ClientInvAcc;
       var ClientInvAccess = component.get("c.getisAccessable");
        ClientInvAccess.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('TS Accessable'+response.getReturnValue());
                component.set("v.CntInvAccess",response.getReturnValue());
                ClientInvAcc=component.get("v.CntInvAccess[0]");
                console.log('>>>>>>>>>DoInit>>>>>>>>'+ClientInvAcc);
                if(ClientInvAcc==true){
                    helper.fetchJobCLI(component, event, helper);
                    helper.FetchFieldsfromFS(component, event, helper); 
                    helper.getClient(component, event, helper);
                    helper.getFieldLabels(component, event, helper);
                }
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
        
        $A.enqueueAction(ClientInvAccess);
        

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
       // alert('The id is '+JSON.Stringify(row));
        switch (action.name) {
                
            case 'Edit_CLI':
                if(component.get("v.CntInvAccess[3]")){
                    component.set("v.isCLIOpen", true);
                    component.set('v.CLIRecordid',row.Id);
                    }else{
                        helper.showToast({
                            "title": "Error!!",
                            "type": "error",
                            "message": 'Client Invoice has insufficient access to edit'
                        });
                    }
      	  break;
                
            case 'Delete_CLI':
                helper.deleteJobCLI(component, event, helper);
                break;
                
            case 'Print_CLI':
                window.open('/one/one.app#/alohaRedirect/apex/ClientInvoicePrint?id='+row.Id,'_blank'); 
                break;
                
        }
    },
    
    
    
    recordsUpdateforchanges: function (cmp, event, helper) {
        // alert('fireing in Client Invoice section after records delete and insert');
        helper.fetchJobCLI(cmp, event, helper);
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
    
    CLICreate:function (component, event, helper) {
        if(component.get("v.CntInvAccess[3]")){
            component.set("v.isCLIOpen", true);
        } 
        else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Client Invoice has insufficient access to create'
            }); 
        }
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isCLIOpen", false);
        component.set('v.CLIRecordid', null);
    },
    
    
    jobCLIOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var CLIfields = event.getParam("fields");
        console.log('========'+component.get("v.recordId"));
        CLIfields["Job__c"]=component.get("v.recordId");
        
        if(component.get('v.CLIRecordid')==null || component.get('v.CLIRecordid')=='undefined'){ 
            CLIfields["Client_Name__c"]=component.get("v.simpleRecord.JS_Client__c");
            console.log('===On Submit====='+component.get("v.simpleRecord.JS_Client__c"));
        }
        else
        {
            CLIfields["Client_Name__c"]=component.find("ClientId").get("v.value");
            console.log('===Client==='+component.find("ClientId").get("v.value"));
        }
        var reduceReutrn = component.find('JobCLIField').reduce(function(validFields, inputCmp) {   
        }
                                                                , true);
        
        component.find("CLIEditform").submit(CLIfields);
        //console.log('===form CLIfields==='+JSON.stringify(CLIfields));
        
    },
    
    onCLIRecordSuccess: function(component, event, helper) { 
        var CLIId=component.get('v.CLIRecordid');
        var msg;
        if(CLIId=='undefined' || CLIId==null ){
            msg='Successfully Inserted Job Client Invoice Record';
        }
        else{
            msg='Successfully Updated Job Client Invoice Record';
        }
        console.log('===record Success==='+CLIId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        var newClientid = event.getParams().response.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": newClientid,
        });
        navEvt.fire();
        
        setTimeout($A.getCallback(function () {
            component.set('v.CLIRecordid',null);
            component.set("v.isCLIOpen", false);
            helper.fetchJobCLI(component, event, helper);
        }), 2000);
        ToastMsg11.fire();
    },
    
    jobCLIload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.CLIRecordid");
        console.log('===Recordid after==='+recId); 
        
        if(recId!=null){
            console.log('===Recordid 33333 after==='+recId);    
            var CLIfilds = event.getParam("recordUi");
           // alert('CLIfilds=='+ JSON.stringify(CLIfilds));
          //  helper.getClient(component, event, helper);
           // console.clear();
            setTimeout($A.getCallback(function() {
                var clientIdCmp = component.find("ClientId");
                console.log("-----clientIdCmp---"+JSON.stringify(clientIdCmp));
                var isarray = Array.isArray(clientIdCmp);
                if(isarray === true ){
                    console.log("---it might be second time--");
                    var allValid = clientIdCmp.reduce(function (validFields, inputCmp) {
                        inputCmp.set("v.value", CLIfilds.record.fields.Client_Name__c.value);
                    }, true);
                }else{
                    console.log("---it might be firstTime time--");                    
                    clientIdCmp.set("v.value", CLIfilds.record.fields.Client_Name__c.value);
                    alert('==client=='+component.find("ClientId").get("v.value"));
                }
                
                //  helper.getClient(component, event, helper);
            }), 2000);
            
            
        }
    }
})