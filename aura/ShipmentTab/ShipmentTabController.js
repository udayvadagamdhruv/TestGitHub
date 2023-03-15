({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var sObj = component.get("v.sObjectName");
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
        helper.getFieldLabels(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
    },
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        var JobPopulate=component.get("v.JobPopulate");
        console.log('===JobPopulate===='+JobPopulate);
        if(JobPopulate!=null && JobPopulate!=''){
            console.log('===JobPopulate after if===='+JSON.stringify(JobPopulate));
            component.find("JobauraId").sampleMethod(JobPopulate);
        }
        
        if (recId != null) {
            var Shpfilds = event.getParam("recordUi");
            
            var simRec=component.get("v.simpleRecord");
            console.log('===Simple Record Data Load==='+JSON.stringify(simRec));
          
            if(simRec.Job__c!=null ){
                var JobObj={"Id":simRec.Job__c, "Name":simRec.Job__r.Name};
                component.find("JobauraId").sampleMethod(JobObj);
            }
        }
        
    },
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        
        var Shpfields = event.getParam("fields");
       // Shpfields["Job__c"] = component.get("v.JobauraId");
        var NameField = "";
        var JobField = component.get("v.selectedLookUpRecord_Job"); 
        
        var reduceReturn=component.find('JobShpField').reduce(function(validFields, inputCmp){
            if(inputCmp.get("v.fieldName") == "Shipment_Name__c")
            {
                var ShpName= inputCmp.get("v.value");
                if(ShpName == null || ShpName == '')
                    NameField="Name";
            }
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": NameField,
            "type": "error",
            "message": NameField + " Field is required."
        });
        
        if (NameField == "Name") {
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(JobField==="undefined" || JobField==null)
        {
             var ToastMsg1=$A.get("e.force:showToast");
            ToastMsg1.setParams({
                    "title":"Job",
                    "type": "error",
                    "message":"Job Field is required."
                    
                });   
                ToastMsg1.fire();
                event.preventDefault();  
        }
        else {
            Shpfields["Job__c"]=component.get("v.selectedLookUpRecord_Job").Id;  
            console.log('===fields finaal with confiramtion of submit=='+JSON.stringify(Shpfields));
            component.find("ShpEditform").submit(Shpfields);
        }
    },
    onRecordSuccess: function(component, event, helper) {
        console.log("====responseid==="+event.getParam("response").id);
        var navEvt = $A.get("e.force:navigateToSObject"); 
        var resultsToast = $A.get("e.force:showToast");
        navEvt.setParams({ 
            "recordId": event.getParam("response").id, 
            "slideDevName": "detail" }); 
        navEvt.fire(); 
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
    },

   
    doCancel: function(component, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
        }
        navEvt.fire();
    }
    
    
    
})