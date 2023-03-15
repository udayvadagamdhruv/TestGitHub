({
    DuplicateCBT : function(component, event, helper) {
        
        var recId=component.get("v.recordId");
        
        var CBTDuplicate = component.get("c.DuplicateCBTemp");
        CBTDuplicate.setParams({
            CBTempId:recId
        })
        CBTDuplicate.setCallback(this, function(CBTDupResponse){
            
            var DupState = CBTDupResponse.getState();
            var DupReturnVal = CBTDupResponse.getReturnValue();
            console.log('>>>>>>>>>>State',DupState);
            console.log('>>>>>>>>>>Response',DupReturnVal);
            if(DupState == "SUCCESS")
            {
                if(DupReturnVal[0]=="false")
                {
                    console.log('>>>>>>>>>>False');
                   
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "message": 'Record Duplicated Successfully.'
                    });
                    toastEvent.fire();
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": DupReturnVal[1],
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                }
                else if(DupReturnVal[0]=="true"){
                  console.log('>>>>>>>>>>true');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message": DupReturnVal[2]
                    });
                    toastEvent.fire();
                    
                }    
                
            }
           else {
                console.log('>>>>>> Error >>>>>>>>>>',CBTDupResponse.getError()[0].message);
                var errors = CBTDupResponse.getError();
               var toastEvent = $A.get("e.force:showToast");
               toastEvent.setParams({
                  "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
               });
               toastEvent.fire();
            }
            
        })
        $A.enqueueAction(CBTDuplicate);
    },
    
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})