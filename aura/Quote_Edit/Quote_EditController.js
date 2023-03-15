({
    doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
      
        if(sObj){
            helper.getFieldsforObject(component, sObj);
            //helper.getLabelforAllObjects(component, event, helper);
            helper.getGLDepartment(component, event, helper);
        }
        helper.getFieldLabels(component, event, helper);
          var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
    },
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        if (recId != null) {
            var quotefilds = event.getParam("recordUi");
             if(quotefilds.record.fields.GL_Department__c.value!=null){
              var GLDObj={"Id":quotefilds.record.fields.GL_Department__r.value.fields.Id.value, "Name":quotefilds.record.fields.GL_Department__r.value.fields.Name.value};
              var GLCObj={"Id":quotefilds.record.fields.GL_Code__r.value.fields.Id.value, "Name":quotefilds.record.fields.GL_Code__r.value.fields.Name.value};
              component.find("GLD_GLC_AuraId").sampleMethod(GLDObj,GLCObj);
            }
            
           // component.find("GLDSelectId").set("v.value", quotefilds.record.fields.GL_Department__c.value);
           // helper.getGLCode(component, event);
           /* window.setTimeout(
                $A.getCallback(function() {
                    component.find("GLCodeSelectId").set("v.value", quotefilds.record.fields.GL_Code__c.value);
                }), 500
            );*/
        }
        
    },
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Quotefields = event.getParam("fields");
        Quotefields["Job__c"] = component.get("v.jobrecordId");
        
        var missField = "";
        var missField1 = "";
        var reduceReutrn = component.find('JobQuoteField').reduce(function(validFields, inputCmp) {
            if (inputCmp.get("v.fieldName") == "Name") {
                var QuoteName = inputCmp.get("v.value");
                if (QuoteName == null || QuoteName == '')
                    missField = "Quote Name";
                
            } else if (inputCmp.get("v.fieldName") == "Quantity__c") {
                var QuoteName1 = inputCmp.get("v.value");
                if (QuoteName1 == null || QuoteName1 == '')
                    missField1 = "Quantity";
                
            }
            
        }, true);
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        });
        var ToastMsg2 = $A.get("e.force:showToast");
        ToastMsg2.setParams({
            "title": missField1,
            "type": "error",
            "message": missField1 + " Field is required."
            
        });
        if (missField == "Quote Name") {
            ToastMsg.fire();
            event.preventDefault();
        } else if (missField1 == "Quantity") {
            ToastMsg2.fire();
            event.preventDefault();
        } else if(component.get("v.selectedLookUpRecord_GLD").Id==null) {
             //component.set("v.isErrorOcuur", true);
            //component.set("v.erorrMsg", 'GL Depatment Field is Required');
            var ToastMsg3 = $A.get("e.force:showToast");
            ToastMsg3.setParams({
                "title": "GL Depatment",
                "type": "error",
                "message": "GL Depatment Field is required."

            });
            ToastMsg3.fire();
            event.preventDefault();
        } else if(component.get("v.selectedLookUpRecord_GLC").Id==null) {
            //component.set("v.isErrorOcuur", true);
            //component.set("v.erorrMsg", 'GL Code Field is Required');
            var ToastMsg4 = $A.get("e.force:showToast");
            ToastMsg4.setParams({
                "title": "GLCode",
                "type": "error",
                "message": "GLCode Field is required."

            });
            ToastMsg4.fire();
            event.preventDefault();
        } else {
            
             if(component.get("v.selectedLookUpRecord_GLD").Id==null){
                  Quotefields["GL_Department__c"]="";
              }
              else{
                  Quotefields["GL_Department__c"]=component.get("v.selectedLookUpRecord_GLD").Id;  
              }
              
              if(component.get("v.selectedLookUpRecord_GLC").Id==null){
                  Quotefields["GL_Code__c"]="";
              } 
              else{
                  Quotefields["GL_Code__c"]=component.get("v.selectedLookUpRecord_GLC").Id;
              }
            component.find("QuoteEditform").submit(Quotefields);
            
        }
    },
    onRecordSuccess: function(component, event, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
            navEvt.fire();
        }
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Success",
            "type": "success",
            "message": "Successfully Updated Quote Record"
            
        });
        setTimeout($A.getCallback(function() {
           ToastMsg1.fire();
        }), 2000);
    },

    GLDepatment: function(component, event, helper) {
        helper.getGLCode(component, event, helper);
    },
    
    doCancel:function(component, event, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        navEvt.fire();
    }
})