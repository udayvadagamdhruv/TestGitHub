({
	doInit : function(component, event, helper) {
         var checkPEpermisson=component.get("c.getPOPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[0]")){
                    helper.fetchJobPO(component, event, helper);
                    helper.CreatePORecord(component, event, helper);
                    helper.InvoiceFromPOFields(component, event, helper); 
                    helper.getVendor(component, event, helper);
                    helper.getStaff(component, event, helper);
                }               
            }
        });
        $A.enqueueAction(checkPEpermisson);   
        
       
      
        //helper.getTotalAmount(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
        
        component.set('v.PoLicolumns', [
            {label: 'Line Item', fieldName: 'LineName', type: 'text'},
            {label: 'Amount', fieldName: 'Calc_Amnt', type: 'currency',cellAttributes: {alignment: 'left' }},
            {label: 'Quantity', fieldName: 'Qunatity', type: 'number',cellAttributes: {alignment: 'left' }},

         ]);
            
         helper.getFieldLabels(component, event, helper);
            
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Log_Inv':
                if(component.get("v.isAccess[5]")){
                component.set("v.InvPOrecordId", row.Id);
                helper.PoLineItemsFromPo(component, event, helper);
                setTimeout($A.getCallback(function () {
                component.set("v.isLogInvOpen", true);
                }),200);
                }else{
                helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Invoice has insufficient access to create'
                }); 
                
                }
                break;
            
            case 'Edit_PO':
                if(component.get("v.isAccess[2]")){
                component.set("v.isPOOpen", true);
                component.set('v.PORecordid',row.Id);
                } else{
                helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Purchase order Item has insufficient access to edit'
                }); 
                }            
                break;
                
            case 'Delete_PO':
                helper.deleteJobPO(component, event, helper);
                break;
            
             case 'Print_PO':
                window.open('/one/one.app#/alohaRedirect/apex/POReportWithESIs?id='+row.Id,'_blank'); 
                break;
                
        }
    },
    
    updateSelectedTextPOLI: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
         cmp.set('v.Selected_POLI', selectedRows);   
        cmp.set('v.PoLiselectedRowsCount', selectedRows.length);
    },
    
    
    VendorChange:function(component, event, helper) {
        var vendorId=component.find("VendorId").get("v.value");
        if(vendorId!=null && vendorId!=''){
           component.set("v.VendorIdApp",vendorId);
           component.find("AVELID").vendorchangefiremethod(vendorId);  
         }
        helper.getVendorCon(component, event, helper,'');
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    POCreate:function (component, event, helper) {
            if(component.get("v.isAccess[1]")){
            component.set("v.isPOOpen", true);
            helper.getVendor(component, event, helper);
            component.find("AVELID").vendorchangefiremethod(null); 
            } else{
            helper.showToast({
            "title": "Error!!",
            "type": "error",
            "message": 'Purchase order has insufficient access to create'
            }); 
        }
      
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isPOOpen", false);
        component.set('v.PORecordid', null);
        component.find("AVELID").vendorchangefiremethod(null);     
    },
    
    closeModelForLogInvoice :function(component, event, helper) {
       component.set("v.isLogInvOpen", false); 
    },
    
    handleselectedRecord :function(component, event, helper) {
        var slecteESLI=event.getParam("ApprovedItems");
        console.log('=====selected Estimate Record==='+slecteESLI);
        component.set("v.Selected_ESTLI",slecteESLI);
        
    },
    
    jobPOOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var POfields = event.getParam("fields");
        console.log('========'+component.get("v.jobrecordId"));
        POfields["Job__c"]=component.get("v.jobrecordId");
        console.log('===OnSubmit====='+component.get("v.jobrecordId"));
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('JobPOField').reduce(function(validFields, inputCmp) {   
             if(inputCmp.get("v.fieldName") == "Issue_Date__c" ){
                var POIssueDate = inputCmp.get("v.value");
                if (POIssueDate == null || POIssueDate == '') 
                    missField1 = "Issue Date";
            } 
            
            
                else if(inputCmp.get("v.fieldName") == "Due_Date__c"){
                    var DueDate = inputCmp.get("v.value"); 
                    if (DueDate == null || DueDate == '') 
                        missField2 = "Due Date";
                }
        }, true);
       
        var ToastMsg2 = $A.get("e.force:showToast");
        ToastMsg2.setParams({
            "title": missField1,
            "type": "error",
            "message": missField1 + " Field is required."
            
        }); 
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": missField2,
            "type": "error",
            "message": missField2 + " Field is required."
        }); 
       
        if(component.get('v.PORecordid')==null || component.get('v.PORecordid')=='undefined'){ 
            if((component.find("VendorId").get("v.value")=='null' || component.find("VendorId").get("v.value")=='')){
                var ToastMsg5=$A.get("e.force:showToast");    
                ToastMsg5.setParams({
                    "title":"Vendor",
                    "type": "error",
                    "message":"Vendor Field is required."
                    
                });   
                ToastMsg5.fire();
                event.preventDefault();   
            }
        } 
      if (missField1 == "Issue Date"){
            ToastMsg2.fire();
            event.preventDefault();
        }
        else if(missField2 == "Due Date"){
                ToastMsg1.fire();
                event.preventDefault();
        }
        else{
            if(component.get('v.PORecordid')==null || component.get('v.PORecordid')=='undefined'){
                POfields["Vendor__c"]=component.find("VendorId").get("v.value");
                console.log('===Ven==='+component.find("VendorId").get("v.value"));
            }
            
            POfields["Vendor_Contact__c"]=component.find("VenConId").get("v.value");
            POfields["Approved_By_Staff__c"]=component.find("StaffID").get("v.value");
            component.find("JobPOEditform").submit(POfields);
        }
    },
    
    
    onPORecordSuccess: function(component, event, helper){ 
        var POId=component.get("v.PORecordid");
         var newPoId=event.getParam("response").id;
        var msg;
        if(POId=='undefined' || POId==null ){
            if(component.get("v.Selected_ESTLI")!=null && component.get("v.Selected_ESTLI")!=''){
                 console.log('====selected rows it going to insert the Estimate or Production Estimate');
                helper.selectedEstLI_PELI(component, event, helper,newPoId);
            }
            msg='Successfully Inserted Job PO Record';
        }
        else{
            msg='Successfully Updated Job PO Record';
        }
        console.log('===record Success==='+POId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "type": "success",
            "message":msg
        });
         ToastMsg11.fire();
       setTimeout($A.getCallback(function() {
       component.set("v.isPOOpen", false); 
       component.set("v.PORecordid",null);
       helper.fetchJobPO(component, event, helper); 
       }),1000);
    },
    
    jobPOload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.PORecordid");
        console.log('===Recordid after==='+recId);           
        if(recId!=null){
            var POfilds = event.getParam("recordUi");
            //helper.fetchJobPO(component, event, helper); 
            //helper.getVendor(component, event, helper);
            helper.getVendorCon(component, event, helper,POfilds.record.fields.Vendor__c.value);
            //helper.getStaff(component, event, helper);
              component.set("v.PORecordDetails",POfilds.record.fields);
            console.log('>>>>>>>>>>>POfilds  22222>>>>>>>>>>>>>'+JSON.stringify(POfilds.record.fields));
             console.log('>>>>>>>>>>>POfilds 22222>>>>>>>>>>>>>'+JSON.stringify(POfilds.record.fields.Vendor__r.value.fields.Name.value));
            
            
            setTimeout($A.getCallback(function() {
                component.find("VenConId").set("v.value",POfilds.record.fields.Vendor_Contact__c.value);
                console.log('==Vendor_Contact__c Onload Id=='+component.find("VenConId").get("v.value"));
            }), 500);
            
           // setTimeout($A.getCallback(function() {
                component.find("StaffID").set("v.value",POfilds.record.fields.Approved_By_Staff__c.value);
                console.log('==Approved_By_Staff__c Onload Id=='+component.find("StaffID").get("v.value"));
           // }), 500);
        }
    },
    
    
    InvFromPOOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Invfields = event.getParam("fields");
        console.log('====Job Id===='+component.get("v.jobrecordId"));
        console.log('===PO Id====='+component.get("v.POsimpleRecord.Id"));
        console.log('====Vendor Id===='+component.get("v.POsimpleRecord.Vendor__c"));
      

        Invfields["Job__c"]=component.get("v.jobrecordId");
        Invfields["Vendor__c"]=component.get("v.POsimpleRecord.Vendor__c");
        Invfields["Purchase_Order__c"]=component.get("v.POsimpleRecord.Id");
        
        if(component.get("v.OrgBasedCon")){
            console.log('===Picklist 3===='+component.get("v.POsimpleRecord.Dummy_Picklist_3__c"));
            console.log('====Picklist 2==='+component.get("v.POsimpleRecord.Dummy_Picklist_2__c"));
             console.log('===Picklist 1===='+component.get("v.POsimpleRecord.Dummy_Picklist_1__c"));
            Invfields["Dummy_Text_1__c"]=component.get("v.POsimpleRecord.Dummy_Picklist_3__c");
            Invfields["Dummy_Text_2__c"]=component.get("v.POsimpleRecord.Dummy_Picklist_2__c"); 
            Invfields["Dummy_Text_3__c"]=component.get("v.POsimpleRecord.Dummy_Picklist_1__c");
        }
        
        var missField = "";
        var missField1 = "";
        var reduceReutrn = component.find('InvPOField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var InvName = inputCmp.get("v.value");
                if (InvName == null || InvName == '') 
                    missField = "Invoice Number";
            } 
            
             else if(inputCmp.get("v.fieldName") == "Date_Received__c"){
                    var RecevedDate = inputCmp.get("v.value"); 
                    if (RecevedDate == null || RecevedDate == '') 
                        missField1 = "Date Received";
                }
      
       }, true);
       
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": missField1,
            "type": "error",
            "message": missField1 + " Field is required."
        }); 
        
       if (missField =="Invoice Number"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(missField1 == "Date Received"){
                ToastMsg1.fire();
                event.preventDefault();
        }
            else{
                var POId=component.get("v.POsimpleRecord.Id");
                if(component.get("v.Selected_POLI")!=null && component.get("v.Selected_POLI")!=''){
                    var Liaction=component.get("c.SavePoLineItemsSubmit");
                    
                    Liaction.setParams({
                        selectedRec : component.get("v.Selected_POLI"),
                        poid:POId
                    });
                    
                    Liaction.setCallback(this, function(res) {
                        if (res.getState() === "SUCCESS") {
                            if(res.getReturnValue()=="OK"){
                                console.log('====Ok response==='+res.getReturnValue());
                               component.find("LogInvFromPoForm").submit(Invfields);  
                            }
                            else{
                             console.log('====fale  response==='+res.getReturnValue());               
                              event.preventDefault();
                                var ToastMsg111 = $A.get("e.force:showToast");
                                ToastMsg111.setParams({
                                    "type": "error",
                                    "message":res.getReturnValue()
                                }); 
                                ToastMsg111.fire();
                            }
                        }
                    });
                    $A.enqueueAction(Liaction);   
                }
                
                else{
                   console.log('====Invfields=='+JSON.stringify(Invfields));  
                  component.find("LogInvFromPoForm").submit(Invfields);    
                }
           }
  
    },
    
    InvFromPOOnsucess : function(component, event, helper) {
        var InvId=event.getParam("response").id;
        var poid=component.get("v.POsimpleRecord.Id");
        if(component.get("v.Selected_POLI")!=null && component.get("v.Selected_POLI")!=''){
            helper.saveRecordsInvfromPO(component,component.get("v.Selected_POLI"),InvId,poid);
        }
        
        var appEvent=$A.get("e.c:UpdateRecordsforChanges");
        appEvent.fire();
        
         helper.fetchJobPO(component, event, helper);
       component.set("v.InvPOrecordId", null);
       component.set("v.isLogInvOpen", false);
        var ToastMsg111 = $A.get("e.force:showToast");
        ToastMsg111.setParams({
            "type": "success",
            "message":"Invoice Created Successfully From Purchase Order."
        }); 
        ToastMsg111.fire();
        
    },
    
    
})