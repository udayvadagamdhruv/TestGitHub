({
   getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Shipment__c'
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
    }
    
})