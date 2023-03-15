({
	doInit : function(component, event, helper) {
        helper.fetchFieldsetforProEstimate(component, event, helper);
        helper.getGLDepartment(component, event, helper);
        
    },
    
    CalUnitChange : function(component, event, helper) {
        var CalUnit=component.find("CalUnitFieldId").get("v.value");
        console.log("========CalUnit===="+CalUnit);
        console.log("========CalUnit true===="+(CalUnit!=''));
        
        if(CalUnit=='Size'){
            component.set("v.isCalUnitSize",true);
        }
        else{
            component.set("v.isCalUnitSize",false);
        }
        
        if(CalUnit=='Sheet'){
            component.set("v.isCalUnitSheet",true);
        }else{
            component.set("v.isCalUnitSheet",false);
        }
        helper.getMaterialItems(component, event, helper);
    },
    
    OnChangeGLDepatment:function(component, event, helper) {
        component.find("GLCodeSelectId").set('v.value',null);
        component.set("v.VendorRecords", null); 
        component.find("VendorId").set('v.value',null);
        //helper.getGLCode(component, event, helper);
        helper.getGLCode(component, event, helper,null,null);
    },
    
    OnchangeGLCode:function(component, event, helper) {
        component.find("VendorId").set('v.value',null);
        var glCodeSelect=component.find("GLCodeSelectId").get('v.value');
        //helper.getVendor(component, event, helper);
        helper.getVendor(component, event, helper,glCodeSelect,null);
    },
    closeModel: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();
    },
    
     jobProEstload:  function(component, event, helper) { 
        console.log('===record Load==in the deail page=');
        var recId=component.get("v.recordId");
        console.log('===Recordid after==='+recId);           
        if(recId!=null){
            var ProEstfilds = event.getParam("recordUi");
            component.find("GLDSelectId").set("v.value",ProEstfilds.record.fields.GL_Department__c.value);
            
            var GLCodeVal=ProEstfilds.record.fields.GL_Code__c.value;
            var MIVal=ProEstfilds.record.fields.Material_Item__c.value;
            var VendorVal=ProEstfilds.record.fields.Vendor__c.value;
            
            helper.getMaterialItems(component, event, MIVal);
            helper.getGLCode(component, event,helper,GLCodeVal,VendorVal);
            
            //helper.getGLCode(component, event,helper); 
            
           /* var CalUnit=ProEstfilds.record.fields.Calc_Unit__c.value;
            console.log("========CalUnit===="+CalUnit);
            console.log("========CalUnit true===="+(CalUnit!=''));
            if(CalUnit!=''){
                if(CalUnit=='Size'){
                    component.set("v.isCalUnitSize",true);
                }
                else{
                    component.set("v.isCalUnitSize",false);
                }
                
                if(CalUnit=='Sheet'){
                    component.set("v.isCalUnitSheet",true);
                }else{
                    component.set("v.isCalUnitSheet",false);
                }
                    
                } */
            
          /*  setTimeout($A.getCallback(function() {
                component.find("GLCodeSelectId").set("v.value",ProEstfilds.record.fields.GL_Code__c.value);
                console.log('==GL_Code__c Onload Id=='+component.find("GLCodeSelectId").get("v.value"));
                helper.getVendor(component, event, helper);
                helper.getMaterialItems(component, event, helper); 
               
            }), 500);
           
            setTimeout($A.getCallback(function() {
                component.find("MISelectId").set("v.value",ProEstfilds.record.fields.Material_Item__c.value);
                component.find("VendorId").set("v.value",ProEstfilds.record.fields.Vendor__c.value);
                console.log('==Vendor__c Onload Id=='+component.find("VendorId").get("v.value"));
            }), 1000);*/
        }
    },
    
    
    jobProEstOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var ProEstfields = event.getParam("fields");
        console.log('========'+component.get("v.simpleRecord").Job__c);
        ProEstfields["Job__c"]=component.get("v.simpleRecord").Job__c;
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('JobProEstField').reduce(function(validFields, inputCmp) {   
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
        else if(component.find('CalUnitFieldId').get("v.value")==null || component.find('CalUnitFieldId').get("v.value")==""){
            var ToastCalMsg = $A.get("e.force:showToast");
            ToastCalMsg.setParams({
                "title": "Calc Unit",
                "type": "error",
                "message":"Calc Unit Field is required."
                
            });
            ToastCalMsg.fire();
            event.preventDefault();  
        }
         /*   else if(component.find("MISelectId").get("v.value")==null || component.find("MISelectId").get("v.value")==""){
                var ToastMIMsg=$A.get("e.force:showToast");
                ToastMIMsg.setParams({
                    "title":"Material Item",
                    "type": "error",
                    "message":"Material Item Field is required."
                    
                });   
                ToastMIMsg.fire();
                event.preventDefault();   
            } */
        
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
                                
                                ProEstfields["Material_Item__c"]=component.find("MISelectId").get("v.value");
                                ProEstfields["GL_Department__c"]=component.find("GLDSelectId").get("v.value");
                                ProEstfields["GL_Code__c"]=component.find("GLCodeSelectId").get("v.value");
                                ProEstfields["Vendor__c"]=component.find("VendorId").get("v.value");
                                console.log('===form Estfields==='+JSON.stringify(ProEstfields));
                                component.find("JobProEstEditform").submit(ProEstfields);
                                
                            }
    },
    
     jobProEstRecordOnSuccess: function(component, event, helper) { 
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
            "type": "success",
            "message": "Successfully Updated Production Estimate Record."
            
        });
        setTimeout($A.getCallback(function() {
           ToastMsg1.fire();
        }), 2500);

    },
    
    
	
})