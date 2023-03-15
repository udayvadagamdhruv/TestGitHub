({
    doInit : function(component, event, helper) {
       
        var checkPEpermisson=component.get("c.getPEPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
            }
        });
        $A.enqueueAction(checkPEpermisson);
       
        helper.getFieldLabels(component, event, helper);
        helper.fetchJobProEstimates(component, event, helper);
        helper.fetchFieldsetforProEstimate(component, event, helper);
        helper.getGLDepartment(component, event, helper);
        helper.fetchProEstimateTemplate(component, event, helper);
       
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
    },
   
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
   
    PrintProEstimate: function(component, event, helper) {
        var jobid=component.get("v.jobrecordId");
        window.open('/one/one.app#/alohaRedirect/apex/Jobsuite__ProductionEstimateReport?Id='+jobid,'_blank');
    },
   
    recordsUpdateforchanges: function (component, event, helper) {
        // alert('fireing in Production estimate section after records delete and insert');
        helper.fetchJobProEstimates(component, event, helper);
    },
    newProEstLineItem : function(component, event, helper) {
        if(component.get("v.isAccess[0]")==true){
            component.set("v.isProEstOpen",true);
        } else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Production Estimate has insufficient access to create'
            });
        }
       
    },
   
    closeModel: function(component, event, helper) {
        component.set("v.isProEstOpen", false);
        component.set('v.ProEstRecordId', null);
    },
   
    CalUnitChange : function(component, event, helper) {
        var CalUnit=component.find("CalUnitFieldId").get("v.value");
        console.log("========CalUnit===="+CalUnit);
        console.log("========CalUnit true===="+(CalUnit!=''));
        var calcunit = component.find("CalUnitFieldId").get("v.value");
        var Equip = component.find("EquipFieldId").get("v.value");
       
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
        component.set("v.MItem_Records",null);
        if((calcunit != null && calcunit != '') && (Equip != null && Equip != '')){
            helper.getMaterialItems(component, event, helper);
        }
        else{
            component.set("v.MItem_Records",null);            
        }
    },
   
    EquipChange:function(component, event, helper) {
        var calcunit = component.find("CalUnitFieldId").get("v.value");
        var Equip = component.find("EquipFieldId").get("v.value");
        if((calcunit != null && calcunit != '') && (Equip != null && Equip != '')){
            helper.getMaterialItems(component, event, helper);
        }  
        else{
            component.set("v.MItem_Records",null);            
        }
    },
   
    OnChangeMaterialItem :function(component, event, helper) {
        var CalUnit=component.find("CalUnitFieldId").get("v.value");
        console.log('--OnChangeMaterialItem CalUnit--- '+CalUnit);  
        if(CalUnit=='Size'){
            var Miitem=component.find("MISelectId").get('v.value');
            console.log('--OnChangeMaterialItem MISelectId--- '+Miitem);  
            if(Miitem){
                helper.getMaterialItemsWidth(component,event,Miitem);
            }
        }
    },
   
    OnChangeGLDepatment:function(component, event, helper) {
        component.find("GLCodeSelectId").set('v.value',null);
        component.set("v.VendorRecords", null);
        component.find("VendorId").set('v.value',null);
        var recordUI;
        helper.getGLCode(component, event, helper,null,null);
    },
   
    OnchangeGLCode:function(component, event, helper) {
        component.find("VendorId").set('v.value',null);
        var glCodeSelect=component.find("GLCodeSelectId").get('v.value');
        console.log('--glCodeSelect-'+glCodeSelect);
        helper.getVendor(component, event, helper,glCodeSelect,null);
    },
   
    ImportProEstimateTempSpecItems: function(component, event, helper) {
        var TempId=component.find("ProEstTemplateId").get("v.value");
        if(TempId==null || TempId==''){
            helper.showToast({
                "type":"error",
                "message":"Please select the Proudction Estimate Template."
            });
        }
        else{
            helper.ImportPETempSpecItems(component, event, helper);  
        }
       
    },
   
   
    jobProEstload:  function(component, event, helper) {
        console.log('===record Load===');
        var recId=component.get("v.ProEstRecordId");
        console.log('===Recordid after==='+recId);          
        if(recId!=null){
            var ProEstfilds = event.getParam("recordUi");
            console.log('ProEstfilds--'+JSON.stringify(ProEstfilds));
            component.find("GLDSelectId").set("v.value",ProEstfilds.record.fields.GL_Department__c.value);
           
            var GLCodeVal=ProEstfilds.record.fields.GL_Code__c.value;
            var MIVal=ProEstfilds.record.fields.Material_Item__c.value;
            var VendorVal=ProEstfilds.record.fields.Vendor__c.value;
           
            helper.getMaterialItems(component, event, MIVal);
            helper.getGLCode(component, event,helper,GLCodeVal,VendorVal);
            console.log('MIVal---'+MIVal);
            helper.getMaterialItemsWidth(component,event,MIVal);
           
            /* setTimeout($A.getCallback(function() {
                component.find("MISelectId").set("v.value",ProEstfilds.record.fields.Material_Item__c.value);
                // component.find("GLCodeSelectId").set("v.value",ProEstfilds.record.fields.GL_Code__c.value);
                // helper.getVendor(component, event, helper);
            }), 2000);  
            setTimeout($A.getCallback(function() {
                //  component.find("MISelectId").set("v.value",ProEstfilds.record.fields.Material_Item__c.value);
                component.find("GLCodeSelectId").set("v.value",ProEstfilds.record.fields.GL_Code__c.value);
                helper.getVendor(component, event, helper);
            }), 1000);
            setTimeout($A.getCallback(function() {
                component.find("VendorId").set("v.value",ProEstfilds.record.fields.Vendor__c.value);
            }), 4000); */
        }
    },
   
   
    jobProEstOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
      var getmaterialitemwidth = component.get("v.Materialitemwidth");
        console.log('getmaterialitemwidth value ======== '+getmaterialitemwidth);
        if(getmaterialitemwidth > 0){
            var getmaterialitemwidthaftercal = getmaterialitemwidth - 2.5;
            console.log('getmaterialitemwidth ======== '+getmaterialitemwidth+'getmaterialitemwidthaftercal === '+getmaterialitemwidthaftercal);        
        }
        var calcunitval = component.find('CalUnitFieldId').get("v.value");
        var ProEstWidth = component.find('ProEstFieldWidth').get("v.value");
        console.log('calcunitval === '+calcunitval+''+'ProEstWidth === '+ProEstWidth);
        
        var ProEstfields = event.getParam("fields");
        console.log('========'+component.get("v.jobrecordId"));
        ProEstfields["Job__c"]=component.get("v.jobrecordId");
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
       
     if(calcunitval == 'Size'){
            console.log('if calcunitval === '+calcunitval);  
            console.log('if ProEstWidth === '+ProEstWidth+''+'getmaterialitemwidthaftercal === '+getmaterialitemwidthaftercal);
            if(ProEstWidth){
                console.log('if again ProEstWidth === '+ProEstWidth+''+'getmaterialitemwidthaftercal === '+getmaterialitemwidthaftercal);
                if(ProEstWidth > 0){
                    if(ProEstWidth > getmaterialitemwidthaftercal)  {
                        var ToastCalMsg = $A.get("e.force:showToast");
                        ToastCalMsg.setParams({
                            "title": "Width",
                            "type": "error",
                            "message" : 'Please enter width less than or equal to '+getmaterialitemwidthaftercal
                        });
                        ToastCalMsg.fire();
                        event.preventDefault();  
                    }
                }
            }
            else{
                var ToastCalMsg = $A.get("e.force:showToast");
                ToastCalMsg.setParams({
                    "title": "Width",
                    "type": "error",
                    "message" : 'Please enter width less than or equal to '+getmaterialitemwidthaftercal
                });
                ToastCalMsg.fire();
                event.preventDefault();  
            }
        }
       
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
            else if(component.find("MISelectId").get("v.value")==null || component.find("MISelectId").get("v.value")==""){
                var ToastMIMsg=$A.get("e.force:showToast");
                ToastMIMsg.setParams({
                    "title":"Material Item",
                    "type": "error",
                    "message":"Material Item Field is required."
                });  
                ToastMIMsg.fire();
                event.preventDefault();  
            }
       
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
        console.log('========Production record Sucess Starting===');
        var ProEstId=component.get('v.ProEstRecordId');
        var msg;
        if(ProEstId=='undefined' || ProEstId==null ){
            msg='Successfully Inserted Production Estimate Record';
        }
        else{
            msg='Successfully Updated Production Estimate Record';
        }
        console.log('===Production Estimate record Success==='+ProEstId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Success",
            "type": "success",
            "message":msg
           
        });
       
        setTimeout($A.getCallback(function () {
            component.set("v.ProEstRecordId",null);
            component.set("v.isProEstOpen", false);                  
            helper.fetchJobProEstimates(component, event, helper);
        }), 2500);
        ToastMsg11.fire();
        console.log('========Production Estimate record Sucess Ending===');
    },
   
    handleProEstimateRowActions :function(component, event, helper) {
        var action=event.getParam("action");
        var row=event.getParam("row");
        switch(action.name){
            case 'Edit_ProEstimate':
                if(component.get("v.isAccess[1]")==true){
                    component.set("v.isProEstOpen", true);
                    component.set('v.ProEstRecordId',row.Id);
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Production Estimates has insufficient access to edit/update'
                    });
                }
               
                break;
               
            case 'Delete_ProEstimate':
                helper.deleteJobProEst(component, event, helper);
                break;
               
            case 'Dup_ProEstimate':
                helper.duplicateJobProEst(component, event, helper);
                break;
               
            case 'Approve_ProEstimate':
                helper.approveJobProEst(component, event, helper);
                break;
               
            case 'UnApprove_ProEstimate':
                helper.unapproveJobProEst(component, event, helper);
                break;
        }
       
    },
   
   
    /************** Mobile Action ******************************/
   
    handlePEMQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectPEstId=event.getSource().get("v.name");
        console.log('---selectPEstId-'+selectPEstId+'---selectOption--'+selectOption);
       
        switch (selectOption) {
               
            case 'Edit_PEstimate':
                component.set("v.isProEstOpen", true);
                component.set('v.ProEstRecordId',selectPEstId);
                break;
               
            case 'Delete_PEstimate':
                helper.deleteJobProEst(component, event, helper, selectPEstId);
                break;
               
            case 'Dup_PEstimate':
                helper.duplicateJobProEst(component, event, helper, selectPEstId);
                break;
               
            case 'Approve_PEstimate':
                helper.approveJobProEst(component, event, helper, selectPEstId);
                break;
               
            case 'UnApprove_PEstimate':
                helper.unapproveJobProEst(component, event, helper, selectPEstId);
                break;
        }
    }
   
})