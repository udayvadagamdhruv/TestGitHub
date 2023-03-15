({
	
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Invoice__c'
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
                    "message": 'Vendors has '+errors[0].message
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
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendors has '+errors[0].message
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
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendors has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
    },
   getVendor:  function(component, event, helper){
        var actionVen = component.get("c.getInvVendors");
        actionVen.setCallback(this, function(responseVen){
            var stateVen = responseVen.getState();
            console.log("===List of Vendors===" + responseVen.getReturnValue());
            var Ven=responseVen.getReturnValue();
            var Venlist=[];
            if(stateVen === "SUCCESS"){
                for (var key in Ven) {
                    Venlist.push({
                        key: key,
                        value: Ven[key]
                    });
                }
                component.set("v.VendorRecords", Venlist); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVen.getError()[0].message);
                var errors = responseVen.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendors has '+errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVen);  
    },
    
     /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    }
})