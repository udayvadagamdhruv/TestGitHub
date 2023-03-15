({
	deleteFromDetailpage : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var SobjName = component.get("v.sObjectName");
        console.log('=======SobjName======='+SobjName);
         console.log('=======recId======='+recId);
        var delActon="";
        if(SobjName=="Quote__c"){
            delActon=component.get("c.DeleteQuote"); // completed in both section and detailpage.
            delActon.setParams({"quoteId": recId});    
        }     
        else if(SobjName=="Estimate_Line_Items__c"){
            delActon=component.get("c.deleteEst");  // completed in both section and detailpage.
            delActon.setParams({"estRecId": recId});
        }
        else if(SobjName=="Production_Estimate__c"){
            delActon=component.get("c.deleteProEst"); // completed in both section and detailpage.
            delActon.setParams({"ProEstID": recId});
        }
        
        else if(SobjName=="Purchase_Order__c"){
            delActon=component.get("c.deletePO");  // completed in both section and detailpage.
            delActon.setParams({"PORecId": recId});
        }
        else if(SobjName=="Invoice__c"){
            delActon=component.get("c.deleteInv"); // completed in both section and detailpage.
            delActon.setParams({"InvRecId": recId});
        }
        else if(SobjName=="Client_Invoice__c"){
            delActon=component.get("c.DeleteCLI"); //completed in both section and detailpage.
            delActon.setParams({"CLId": recId});
        }
        else if(SobjName=="Graphics_Deliverables__c"){
            delActon=component.get("c.DeleteGD");  //completed in both section and detailpage.
            delActon.setParams({"GDId": recId});
        }
        else if(SobjName=="Tag__c"){
            delActon=component.get("c.DeleteTag"); //completed in both section and detailpage.
            delActon.setParams({"TagId": recId});
        }
         else if(SobjName=="Job_Task__c"){
            delActon=component.get("c.DeleteTaskDetail"); //completed in both section and detailpage.
            delActon.setParams({"tskid": recId});
        }
         else if(SobjName=="Timesheet_Entries__c"){
            delActon=component.get("c.DeleteTSDetail"); //completed in both section and detailpage.
            delActon.setParams({"TSid": recId});
        }
         else if(SobjName=="Shipment__c"){
            delActon=component.get("c.DeleteShp"); //completed in both section and detailpage.
            delActon.setParams({"ShpId": recId});
        }
        
        delActon.setCallback(this, function(deleteQuoteRes) {
             console.log('===state======' + deleteQuoteRes.getState());
             var delteres=deleteQuoteRes.getReturnValue();
            console.log('======delete response from Detail page===='+JSON.stringify(delteres));
            if (deleteQuoteRes.getState() === "SUCCESS") {
                if(delteres[0]=="OK"){
                    var Jobid=delteres[1];
                    helper.showToast({
                        "type": "success",
                        "message": 'Record Deleted Successfully.'
                    });     
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": Jobid,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": delteres[1]
                    });     
                }
            }
            else{
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": delteres[1]
                });     
            }
        });
        $A.enqueueAction(delActon);
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