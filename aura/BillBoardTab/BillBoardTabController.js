({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var sObj = component.get("v.sObjectName");
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
        helper.getFieldLabels(component, event, helper);
    },
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        
        var VenPopulate=component.get("v.VenPopulate");
        console.log('===VenPopulate===='+VenPopulate);
        if(VenPopulate!=null && VenPopulate!=''){
              console.log('===VenPopulate after if===='+JSON.stringify(VenPopulate));
            component.find("VenauraId").sampleMethod(VenPopulate);
        }
        
        var CLIPopulate=component.get("v.CLIPopulate");
        console.log('===CLIPopulate===='+CLIPopulate);
        if(CLIPopulate!=null && CLIPopulate!=''){
              console.log('===CLIPopulate after if===='+JSON.stringify(CLIPopulate));
            component.find("CLIauraId").sampleMethod(CLIPopulate);
        }
        
        if (recId != null) {
            
            var BBfilds = event.getParam("recordUi");
            
            var simRec=component.get("v.simpleRecord");
            console.log('===Simple Record Data Load==='+JSON.stringify(simRec));
          
            if(simRec.BB_Vendor__c!=null ){
                var VenObj={"Id":simRec.BB_Vendor__c, "Name":simRec.BB_Vendor__r.Name};
                component.find("VenauraId").sampleMethod(VenObj);
            }
            if(simRec.Client_Name__c!=null ){
                var CLIObj={"Id":simRec.Client_Name__c, "Name":simRec.Client_Name__r.Name};
                component.find("CLIauraId").sampleMethod(CLIObj);
            }
        }
    },
    
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        
        var BBVfields = event.getParam("fields");
        var NameField = "";
        var VenField = component.get("v.selectedLookUpRecord_Ven"); 
        var CLIField = component.get("v.selectedLookUpRecord_CLI");       
       
        var reduceReturn=component.find('BBField').reduce(function(validFields, inputCmp){
            if(inputCmp.get("v.fieldName") == "Name")
            {
                var BBName= inputCmp.get("v.value");
                if(BBName == null || BBName == '')
                    NameField="BB#";
            }
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": NameField,
            "type": "error",
            "message": NameField + " Field is required."
        });
        
        if (NameField == "BB#") {
            ToastMsg.fire();
            event.preventDefault();
        }
        else {
            
           
            if(typeof(component.get("v.selectedLookUpRecord_Ven").Id)!='undefined')
            {
                BBVfields["BB_Vendor__c"]=component.get("v.selectedLookUpRecord_Ven").Id;  
            }
            else
            {
                 BBVfields["BB_Vendor__c"]="";
            }
            if(typeof(component.get("v.selectedLookUpRecord_CLI").Id)!='undefined')
            {              
                BBVfields["Client_Name__c"]=component.get("v.selectedLookUpRecord_CLI").Id;  
            }
            else
            {
                BBVfields["Client_Name__c"]="";
            }
            
            //BBVfields["Client_Name__c"]=component.get("v.selectedLookUpRecord_CLI").Id;  
            component.find("BBEditform").submit(BBVfields);
        }
    },
    
    onRecordSuccess: function(component, event, helper) {
        console.log("====responseid==="+event.getParam("response").id);
        var navEvt = $A.get("e.force:navigateToSObject"); 
        var resultsToast = $A.get("e.force:showToast");
        navEvt.setParams({ 
            "recordId": event.getParam("response").id, 
            "slideDevName": "detail" 
        }); 
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