({
	doInit : function(component, event, helper) {
        console.log('>>>>>>>>>>>Do init>>>>>>>>>>>>>>>>>>>>');
        var recId = component.get("v.recordId");
        var sObj = 'Campaign__c';
        helper.getFieldsforObject(component, sObj);
    },
    
    onloadrecord : function(component, event, helper){
        var StartDate=component.get("v.startDate");
         component.find("CmpStartDate").set("v.value",StartDate);
    },
    
    RecordSubmit : function(component, event, helper) {
       
        var Cmpname =component.find("CmpName").get("v.value");
        
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
    
    onRecordSuccess: function(component, event, helper) 
    { 
        console.log("====responseid==="+event.getParam("response").id);
        var navEvt = $A.get("e.force:navigateToSObject"); 
        var resultsToast = $A.get("e.force:showToast");
        
       /* var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Calendars",
        });
        evt.fire();*/
        
       //  window.history.back();
        
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
         navEvt.setParams({
            "recordId": event.getParam("response").id,
             "slideDevName": "detail"          
        });
        navEvt.fire();
    },
    
    doCancel:function(component, event, helper) {
        
        if(component.get("v.recordId")!=null){
            /*var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Calendars",
              /*  componentAttributes: {
                    ShowCampCal : true
                }
            });
            evt.fire();*/
           window.history.back();
        }
        else
        {
           /* var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Calendars",
               /* componentAttributes: {
                    ShowJobCal : false,
                    ShowCampCal : true
                }
            });
            evt.fire();*/
            
            window.history.back();
        }
        
    }
})