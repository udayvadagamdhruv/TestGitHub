({
    getFieldLabels:  function(component, event, helper){
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Production_Estimate__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    fetchFieldsetforProEstimate:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Production_Estimate__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field sets for the ProEstimate===="+ response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
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
        
        var LabelAction = component.get("c.geLabelforObject");
        LabelAction.setParams({
            sObjName : "Production_Estimate__c"
        });
        LabelAction.setCallback(this, function(response) {
            console.log("=====Label for the ProEstimate===="+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.ProEstObjLabel", response.getReturnValue()); 
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
        $A.enqueueAction(LabelAction);
        
    },
    
    getMaterialItems :function(component, event, MIVal){
        var CalUnit=component.find("CalUnitFieldId").get("v.value");
        console.log("========CalUnit===="+CalUnit);
        var miaction = component.get("c.getMatereialItems");
        miaction.setParams({
            CalUnit :CalUnit 
        });
        miaction.setCallback(this, function(res) {
            console.log("=====Materail Items records===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                component.set("v.MItem_Records", res.getReturnValue()); 
                setTimeout($A.getCallback(function() {
                    component.find("MISelectId").set("v.value",MIVal);
                }), 1000);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(miaction);  
    },
    
    getGLDepartment: function(component, event, helper){
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(res) {
            console.log("=====GLD List===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                helper.getFieldLabels(component, event, helper);
                component.set("v.GL_DepartmentRecords", res.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    
    getGLCode: function(component, event, helper, GLCodeVal, VendorVal){
        var GLDId=component.find("GLDSelectId").get('v.value');
        console.log('===GLDId==='+GLDId);
        var actionCC = component.get("c.getGLCodes");
        actionCC.setParams({
            GLDName :GLDId 
        });
        actionCC.setCallback(this, function(res){
            console.log("===List of GLC===" + JSON.stringify(res.getReturnValue()));
            if(res.getState() === "SUCCESS"){
                component.set("v.GL_CodeRecords",res.getReturnValue()); 
                if(GLCodeVal!=null && VendorVal!=null){
                    this.getVendor(component, event,helper, GLCodeVal, VendorVal);
                }
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionCC);  
    },
    
    getVendor:  function(component, event, helper,GLCodeVal, VendorVal){
        var GLCId=GLCodeVal;//component.find("GLCodeSelectId").get('v.value');
        console.log('===Department==='+JSON.stringify(component.find("GLDSelectId").get('v.value')));
        console.log('===GLCId==='+JSON.stringify(GLCId));
        var actionVen = component.get("c.getVendors");
        actionVen.setParams({
            GLCName :GLCId 
        });
        actionVen.setCallback(this, function(res){
            console.log("===List of Vendors===" + JSON.stringify(res.getReturnValue()));
            if(res.getState() === "SUCCESS"){
                component.set("v.VendorRecords", res.getReturnValue()); 
                setTimeout($A.getCallback(function() {
                    component.find("GLCodeSelectId").set("v.value",GLCodeVal);
                    component.find("VendorId").set("v.value",VendorVal);
                }), 1000);
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVen);  
    },
    
    
})