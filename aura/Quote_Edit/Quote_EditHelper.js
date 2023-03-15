({
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Quote__c'
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
             else
            {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
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
            else
            {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
    },
    
    getLabelforAllObjects:function(component, event, helper){
        var action=component.get("c.getLabelforAllObjects");
        action.setCallback(this,function(res){
             var result=JSON.parse(res.getReturnValue());
            console.log('=====All Object Lables===='+JSON.stringify(result));
            if(res.getState()==="SUCCESS"){
                component.set("v.allObjectLabels", result);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
     getGLDepartment: function(component, event, helper){
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(response1) {
            console.log("=====GLD List====", response1.getReturnValue());
            var GLD=response1.getReturnValue();
            var GLDept=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in GLD) {
                    GLDept.push({
                        key: key,
                        value: GLD[key]
                    });
                }
                component.set("v.GL_DepartmentRecords", GLDept); 
            } 
            else
            {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    getGLCode :  function(component, event, helper){
        var GLDId=component.find("GLDSelectId").get('v.value');
        console.log('===GLDId==='+GLDId);
        var actionCC = component.get("c.getGLCodes");
        
        actionCC.setParams({
            GLDName :GLDId 
        });
        actionCC.setCallback(this, function(responseCC){
            var stateCC = responseCC.getState();
            console.log("===List of GLC===" + responseCC.getReturnValue());
            var CC=responseCC.getReturnValue();
            var CClist=[];
            if(stateCC === "SUCCESS"){
                for (var key in CC) {
                    CClist.push({
                        key: key,
                        value: CC[key]
                    });
                }
                component.set("v.GL_CodeRecords", CClist); 
            } 
            else
            {
                console.log('>>>>>> Error >>>>>>>>>>',responseCC.getError()[0].message);
                var errors = responseCC.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionCC);  
    },
    

       
    
    
})