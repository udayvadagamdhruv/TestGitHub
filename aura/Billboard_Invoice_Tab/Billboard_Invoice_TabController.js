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
        
        if (recId != null) {
            var BBInvfilds = event.getParam("recordUi");
            
            var simRec=component.get("v.simpleRecord");
            console.log('===Simple Record Data Load==='+JSON.stringify(simRec));
          
            if(simRec.Billboard_Vendor__c!=null ){
                var VenObj={"Id":simRec.Billboard_Vendor__c, "Name":simRec.Billboard_Vendor__r.Name};
                component.find("VenauraId").sampleMethod(VenObj);
            }
           
        }
    },
    
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var BBInvfields = event.getParam("fields");
        var VenField = component.get("v.selectedLookUpRecord_Ven"); 
        if(typeof(VenField.Id)!='undefined'){
           BBInvfields["Billboard_Vendor__c"]=component.get("v.selectedLookUpRecord_Ven").Id;    
        }
        else{
            BBInvfields["Billboard_Vendor__c"]="";
        }
        component.find("BBInvEditform").submit(BBInvfields);
        
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