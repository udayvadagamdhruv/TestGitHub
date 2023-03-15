({
    doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
        console.log('===do init==='+sObj);
        if(sObj){
            helper.getFieldsforObject(component, sObj);
            helper.getGLDepartment(component, event, helper);
        }
        helper.getFieldLabels(component, event, helper);
    },
    
    OnChangeGLDepatment:function(component, event, helper) {
        component.find("GLCodeSelectId").set('v.value',null);
        component.set("v.VendorRecords", null); 
        component.find("VendorId").set('v.value',null);
        helper.getGLCode(component, event, helper);
    },
    
    OnchangeGLCode:function(component, event, helper) {
        component.find("VendorId").set('v.value',null);  
        helper.getVendor(component, event, helper);
    },
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId=component.get("v.recordId");
        console.log('===Recordid after==='+recId);      
        
        if(recId!=null){
            var ProEstfilds = event.getParam("recordUi");
            var CalUnit=ProEstfilds.record.fields.Calc_Unit__c.value;
            console.log("========CalUnit===="+CalUnit);
            console.log("========CalUnit true===="+(CalUnit!=''));
            console.log("========CalUnit true===="+(CalUnit==''));
            
            if(CalUnit=='Each'){
                component.set("v.isCalUnitEach",true);
                component.set("v.isCalUnitSheet",false);
                component.set("v.isCalUnitSize",false);
                console.log("========Each=======");
            }
            if(CalUnit=='Sheet'){
                component.set("v.isCalUnitEach",false);
                component.set("v.isCalUnitSheet",true);
                component.set("v.isCalUnitSize",false);
                console.log("========Sheet=======");
            }
            if(CalUnit=='Size'){
                component.set("v.isCalUnitEach",false);
                component.set("v.isCalUnitSheet",false);
                component.set("v.isCalUnitSize",true);
                console.log("========Size=======");
            }
            component.find("GLDSelectId").set("v.value",ProEstfilds.record.fields.GL_Department__c.value);
            //  helper.getMaterialItems(component, event, helper,CalUnit); 
            helper.getGLCode(component, event,helper); 
            
            setTimeout($A.getCallback(function() {
                // component.find("MISelectId").set("v.value",ProEstfilds.record.fields.Material_Item__c.value);
                component.find("GLCodeSelectId").set("v.value",ProEstfilds.record.fields.GL_Code__c.value);
                console.log('==GL_Code__c Onload Id=='+component.find("GLCodeSelectId").get("v.value"));
                helper.getVendor(component, event, helper);
            }), 1500);
            
            setTimeout($A.getCallback(function() {
                component.find("VendorId").set("v.value",ProEstfilds.record.fields.Vendor__c.value);
                console.log('==Vendor__c Onload Id=='+component.find("VendorId").get("v.value"));
            }), 2500);
            
        }
    },
    
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var ProEstfields = event.getParam("fields");
       // console.log('========'+component.get("v.recordId"));
        //  ProEstfields["Production_Estimate_Template__c"]=component.get("v.recordId");
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('ProEstField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var ProEstName = inputCmp.get("v.value");
                if (ProEstName == null || ProEstName == '') 
                    missField = "Name";
            } 
            
        }, true);
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
        
        if (missField == "Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
      /*  else if(component.find('CalUnitFieldId').get("v.value")==null || component.find('CalUnitFieldId').get("v.value")==""){
            var ToastCalMsg = $A.get("e.force:showToast");
            ToastCalMsg.setParams({
                "title": "Calc Unit",
                "type": "error",
                "message":"Calc Unit Field is required."
                
            });
            ToastCalMsg.fire();
            event.preventDefault();  
        }*/
        
            else if(component.find("GLDSelectId").get("v.value")==null || component.find("GLDSelectId").get("v.value")==""){
                var ToastMsg3=$A.get("e.force:showToast");
                ToastMsg3.setParams({
                    "title":"GL Depatment",
                    "type": "error",
                    "message":"GL Depatment Field is required."
                    
                });   
                ToastMsg3.fire();
                event.preventDefault();   
            }
                else if(component.find("GLCodeSelectId").get("v.value")==null || component.find("GLCodeSelectId").get("v.value")==""){
                    var ToastMsg4=$A.get("e.force:showToast");    
                    ToastMsg4.setParams({
                        "title":"GL Description",
                        "type": "error",
                        "message":"GL Description Field is required."
                        
                    });   
                    ToastMsg4.fire();
                    event.preventDefault();   
                }
                    else if(component.find("VendorId").get("v.value")==null || component.find("VendorId").get("v.value")==""){
                        var ToastMsg5=$A.get("e.force:showToast");    
                        ToastMsg5.setParams({
                            "title":"Vendor",
                            "type": "error",
                            "message":"Vendor Field is required."
                            
                        });   
                        ToastMsg5.fire();
                        event.preventDefault();   
                    }
        
                        else{
                           
                            ProEstfields["Calc_Unit__c"]=component.get("v.simpleRecord").Calc_Unit__c;
                            
                            if(ProEstfields.Qty_Up__c==null && ProEstfields.of_Pages__c==null){
                                ProEstfields["Qty_Up__c"]=1;
                            }
                            if(ProEstfields.Quantity__c==null){
                                ProEstfields["Quantity__c"]=1;
                            }
                                   
                            if(ProEstfields.Calc_Unit__c=='Sheet' && ProEstfields.Sided__c=='Double' && ProEstfields.Qty_Up__c !=null && ProEstfields.Divide_Sheets_By_Two__c==true){
                                ProEstfields["SheetQtyUpforUsed__c"]=(ProEstfields.Quantity__c/ProEstfields.Qty_Up__c)/2;
                            }
                            else if (ProEstfields.Calc_Unit__c=='Sheet' && ProEstfields.Sided__c=='Double' && ProEstfields.Qty_Up__c !=null && ProEstfields.Divide_Sheets_By_Two__c==false){
                                ProEstfields["SheetQtyUpforUsed__c"]=(ProEstfields.Quantity__c/ProEstfields.Qty_Up__c);
                            }
                                else if(ProEstfields.Calc_Unit__c=='Sheet' && ProEstfields.Sided__c=='Single' && ProEstfields.Qty_Up__c !=null){
                                    ProEstfields["SheetQtyUpforUsed__c"]=(ProEstfields.Quantity__c/ProEstfields.Qty_Up__c);
                                }
                                    else if(ProEstfields.Calc_Unit__c=='Each' && ProEstfields.Qty_Up__c !=null){
                                        ProEstfields["EachQtyUpforUsed__c"]=(ProEstfields.Quantity__c/ProEstfields.Qty_Up__c);
                                    } 
                            //ProEstfields["Material_Item__c"]=component.find("MISelectId").get("v.value");
                            ProEstfields["GL_Department__c"]=component.find("GLDSelectId").get("v.value");
                            ProEstfields["GL_Code__c"]=component.find("GLCodeSelectId").get("v.value");
                            ProEstfields["Vendor__c"]=component.find("VendorId").get("v.value");
                            console.log('===form Estfields==='+JSON.stringify(ProEstfields));
                            component.find("PEEditform").submit(ProEstfields);
                            
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
            "title": "Sucess",
            "type": "success",
            "message": "Successfully Updated Quote Record"
            
        });
        setTimeout($A.getCallback(function() {
            ToastMsg1.fire();
        }), 2000);
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