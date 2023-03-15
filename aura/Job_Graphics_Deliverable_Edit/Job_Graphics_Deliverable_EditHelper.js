({
   
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Graphics_Deliverables__c'
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
            sObjName : sObj,
            fieldsetname : "Graphics_Deliverables_Fieldset"
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("list of field names" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.fieldSet", response.getReturnValue());
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
    }
    
})