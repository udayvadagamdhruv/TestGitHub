({
    doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
        console.log('===do init==='+sObj);
        var recId = component.get("v.recordId");
        console.log('===record Id==='+recId);
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
        helper.getFieldLabels(component, event, helper);
    },
    
    Conloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        console.log('===record Id==='+recId);
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
    
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var GDfields = event.getParam("fields");
        console.log('========'+component.get("v.recordId"));
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
            
            
            //GDfields["Start_Time__c"]=component.find("StartTime").get("v.value");
            //GDfields["End_Time__c"]=component.find("EndTime").get("v.value");
            component.find("GDEditform").submit(GDfields);
        }
        
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
            "message": "Successfully Updated Record"
            
        });
        ToastMsg1.fire();
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