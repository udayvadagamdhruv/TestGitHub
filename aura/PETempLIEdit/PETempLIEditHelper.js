({
	 
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Production_Estimate_Temp_Line_Items__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                // console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
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
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
    },
    
    getMaterialItems :function(component, event, helper,CalUnit){
        //var CalUnit=component.find("CalUnitFieldId").get("v.value");
        //
        console.log("========CalUnit===="+CalUnit);
            var miaction = component.get("c.getMatereialItems");
            miaction.setParams({
                CalUnit :CalUnit 
            });
            miaction.setCallback(this, function(res) {
                console.log("=====Materail Items records===="+ res.getReturnValue());
                if(res.getState() === "SUCCESS"){
                    component.set("v.MItem_Records", res.getReturnValue()); 
                } 
            });
            $A.enqueueAction(miaction);  
    },
    
    getGLDepartment: function(component, event, helper){
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(res) {
            console.log("=====GLD List===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                component.set("v.GL_DepartmentRecords", res.getReturnValue()); 
            } 
        });
        $A.enqueueAction(action1);
    },
    
     getGLCode: function(component, event, helper){
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
            } 
        }); 
        $A.enqueueAction(actionCC);  
    },
    
    getVendor:  function(component, event, helper){
        var GLCId=component.find("GLCodeSelectId").get('v.value');
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
            } 
        }); 
        $A.enqueueAction(actionVen);  
    }
})