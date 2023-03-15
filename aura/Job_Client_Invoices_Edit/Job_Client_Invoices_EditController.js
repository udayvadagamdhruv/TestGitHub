({
	doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
        console.log('===do init==='+sObj);
        if(sObj){
           helper.getFieldsforObject(component, sObj);
           helper.getClient(component, event, helper);
        }
        helper.getFieldLabels(component, event, helper);
    },
   
    
     onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        if(recId!=null){
            var Clifilds = event.getParam("recordUi");
            helper.getClient(component, event, helper);
            setTimeout($A.getCallback(function() {
                component.find("ClientId").set("v.value",Clifilds.record.fields.Client_Name__c.value);
            }),500);
        }
    },
    
    RecordSubmit: function(component, event, helper) {
         event.preventDefault(); // Prevent default submit
        var CLIfields = event.getParam("fields");
        console.log('===recordId====='+component.get("v.recordId"));
       // CLIfields["Job__c"]=component.get("v.recordId");
        CLIfields["Client_Name__c"]=component.get("v.simpleRecord.JS_Client__c");
       
        var reduceReutrn = component.find('JobCLIField').reduce(function(validFields, inputCmp) {   
              }
       , true);
       
        CLIfields["Client_Name__c"]=component.find("ClientId").get("v.value");
        component.find("CLIEditform").submit(CLIfields);
        //console.log('===form CLIfields==='+JSON.stringify(CLIfields));
             
    },
    onRecordSuccess: function(component, event, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
            navEvt.fire();
        }
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message": "Successfully Updated Client Invoice Record"
            
        });
        setTimeout($A.getCallback(function() {
           ToastMsg1.fire();
        }), 2000);
    },

    doCancel:function(component, event, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        navEvt.fire();
    }
})