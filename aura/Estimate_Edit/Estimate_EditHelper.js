({
	 
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Estimate_Line_Items__c'
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
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
    getFieldsforObject : function(component, sObj){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : sObj
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("list of fiels name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.fieldSet", response.getReturnValue());
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName : sObj
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
    },
     getGLDepartment: function(component, event, helper){
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(response1) {
            console.log("=====GLD List====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                 var GLD=response1.getReturnValue();
                component.set("v.GL_DepartmentRecords", GLD); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    getGLCode :  function(component, event, helper, GLCodeVal, VendorVal){
        var GLDId=component.find("GLDSelectId").get('v.value');
        console.log('===GLDId==='+GLDId);
        var actionCC = component.get("c.getGLCodes");
        
        actionCC.setParams({
            GLDName :GLDId 
        });
        actionCC.setCallback(this, function(responseCC){
            var stateCC = responseCC.getState();
            console.log("===List of GLC===" + responseCC.getReturnValue());
            if(stateCC === "SUCCESS"){
                var CC=responseCC.getReturnValue();
                component.set("v.GL_CodeRecords", CC); 
                if(GLCodeVal!=null && VendorVal!=null){
                    this.getVendor(component, event,helper, GLCodeVal, VendorVal);
                }
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseCC.getError()[0].message);
                var errors = responseCC.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionCC);  
    },
    
    getVendor:  function(component, event, helper, GLCodeVal, VendorVal){
        var GLCId=GLCodeVal;//component.find("GLCodeSelectId").get('v.value');
        console.log('===GLCId==='+GLCId);
        var actionVen = component.get("c.getVendors");
        
        actionVen.setParams({
            GLCName :GLCId 
        });
        actionVen.setCallback(this, function(responseVen){
            var stateVen = responseVen.getState();
            console.log("===List of Vendors===" + responseVen.getReturnValue());
            if(stateVen === "SUCCESS"){
                var Ven=responseVen.getReturnValue();
                component.set("v.VendorRecords", Ven); 
                setTimeout($A.getCallback(function() {
                    component.find("GLCodeSelectId").set("v.value",GLCodeVal);
                    component.find("VendorId").set("v.value",VendorVal);
                }), 1000);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVen.getError()[0].message);
                var errors = responseVen.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVen);  
    },
      showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
})