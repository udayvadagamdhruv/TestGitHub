({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
       // alert(recId);
        var sObj = 'Campaign__c';
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
        /*if(recId==null){
            component.find("CmpStartDate").set("v.value",StartDate);
        }*/
    },
    
    onRecordSuccess: function(component, event, helper) 
    { 
        var navEvt = $A.get("e.force:navigateToSObject"); 
        var resultsToast = $A.get("e.force:showToast");
        navEvt.setParams({ 
            "recordId": event.getParam("response").id, 
            "slideDevName": "detail" }); 
        navEvt.fire(); 
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
         resultsToast.fire();
    },
    
    handleSubmit:function(component, event, helper) {
        var oppId = document.getElementById("Name").childNodes[1].nodeName;
       var Cmpname =document.getElementById("Name").value;
        console.log('====oppId===='+oppId);
        console.log('====Cmpname===='+Cmpname);
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
                "title":"Error",
                "type": "error",
                "message": "Name Field is required."
                
            });
        if(Cmpname==null || Cmpname==''){
            ToastMsg.fire();
           event.preventDefault();
       }
       
       
    },

    doCancel: function(component, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
            "recordId": component.get("v.recordId")
        	});
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
        }
        navEvt.fire();
    }

})