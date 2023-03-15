({
    UnApproveQuote : function(component, event, helper) {
        
        var QuotRecId = component.get("v.recordId");
         console.log('===QuotRecId======' + QuotRecId);
        
        var vqUnapp = component.get("c.vendorUnapproved");
        vqUnapp.setParams({
            quoteId: QuotRecId
        });
        
        vqUnapp.setCallback(this, function(vqUnappRes) {
            console.log('===state======' + vqUnappRes.getState());
            var VqUnstate = vqUnappRes.getState();
            var ToastMsg = $A.get("e.force:showToast");
            if (VqUnstate === "SUCCESS") {
                if(vqUnappRes.getReturnValue()=='OK'){
                    helper.reloadDataTable();
                    ToastMsg.setParams({
                        "type": "success",
                        "message": 'Quote is Unapproved successfully.'
                        
                    });
                     $A.get("e.force:closeQuickAction").fire(); 
                    ToastMsg.fire();
                   //$A.get("e.c:UpdateRecordsforChanges").fire();
                }
                else{
                    ToastMsg.setParams({
                        "type": "error",
                        "message": vqUnappRes.getReturnValue()
                        
                    });
                    ToastMsg.fire();
                   
                }
            }
        });
        
        $A.enqueueAction(vqUnapp); 
        
    },
    
    reloadDataTable : function(){

        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
})