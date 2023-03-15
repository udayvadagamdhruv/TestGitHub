({
    getFieldLabels: function(component, event, helper) {
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Purchase_Order__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                var tableHeaders=JSON.parse(response.getReturnValue());
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeaders.Purchase_Order__c.Name.label, fieldName: 'POLink', sortable: true, type: 'url',initialWidth:180, typeAttributes: { label: { fieldName: 'Name' }, target: '_self',tooltip:{ fieldName: 'Name' } } },
                    {label: tableHeaders.Purchase_Order__c.Invoice_Created__c.label, fieldName: 'Invoice_Created__c',initialWidth:200,sortable: true, type: 'text'},
                    {label: tableHeaders.Purchase_Order__c.Vendor__c.label, fieldName: 'Vendor__c', sortable: true, type: 'text',initialWidth:200},
                    {label: tableHeaders.Purchase_Order__c.Issue_Date__c.label, fieldName: 'Issue_Date__c', editable:'true',initialWidth:200, sortable: true, type: 'date-local' , cellAttributes: { class: {fieldName: 'POInlineEdit'}, iconName: 'utility:event', iconAlternativeText: tableHeaders.Purchase_Order__c.Issue_Date__c.label} },
                    {label: tableHeaders.Purchase_Order__c.Due_Date__c.label, fieldName: 'Due_Date__c', editable:'true',initialWidth:200, sortable: true, type: 'date-local' , cellAttributes: { class: {fieldName: 'POInlineEdit'}, iconName: 'utility:event', iconAlternativeText:tableHeaders.Purchase_Order__c.Due_Date__c.label} },
                    {label: tableHeaders.Purchase_Order__c.Status__c.label, fieldName: 'Status__c',sortable: true, type: 'text',initialWidth:150 },
                    {label: tableHeaders.Purchase_Order__c.Total_Amount__c.label, fieldName: 'Total_Amount__c', sortable: true,initialWidth:200 ,type: 'currency', cellAttributes: {alignment: 'left' } }
                    
                ]);
                var labels = {
                    'Name':tableHeaders.Purchase_Order__c.Name.label,
                    'InvoiceCreated': tableHeaders.Purchase_Order__c.Invoice_Created__c.label,
                    'Vendor':tableHeaders.Purchase_Order__c.Vendor__c.label,
                    'IssueDate': tableHeaders.Purchase_Order__c.Issue_Date__c.label,
                    'DueDate':tableHeaders.Purchase_Order__c.Due_Date__c.label,
                    'Status':tableHeaders.Purchase_Order__c.Status__c.label,
                    'Amount': tableHeaders.Purchase_Order__c.Total_Amount__c.label
                };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));
                
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Purchase_Order__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction( Objaction );   
        $A.enqueueAction(action1);
        
    },
    
    fetchJobPO : function(component, event, helper) {
        
        var recId = component.get("v.jobrecordId");
        var PORec = component.get("c.getPORecords");
        PORec.setParams({
            recordId : recId 
        });
        PORec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.POLink = '/'+row.Id;    
                    if (row.Vendor__c) row.Vendor__c = row.Vendor__r.Name;
                    
                    if(row.Status__c=='Sent'){
                        row.POInlineEdit='PONonEditable';  
                    }
                    else{
                        row.POInlineEdit='POEditable';   
                    }   
                    
                }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        var OrgAction = component.get("c.OrganizationIdsBasedOnpages");
        OrgAction.setParams({
            Page : "InvoiceFromPo" 
        });
        OrgAction.setCallback(this, function(Orgresponse) {
            if (Orgresponse.getState() === "SUCCESS") {
                console.log('========Org settings==='+Orgresponse.getReturnValue());
                component.set("v.OrgBasedCon",Orgresponse.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',Orgresponse.getError()[0].message);
                var errors = Orgresponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        
        var sumAction = component.get("c.getTotalAmountForSections");
        sumAction.setParams({
            ObjectName : "PO",
            Jobid:component.get("v.jobrecordId")
        });
        sumAction.setCallback(this, function(res) {
            if (res.getState() === "SUCCESS") {
                component.set("v.TotalAmount",res.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        var ShowProEst = component.get("c.showProductionEstimate");
        ShowProEst.setCallback(this, function(ShowPEres) {
            if (ShowPEres.getState() === "SUCCESS") {
                component.set("v.showProductionEstimate",ShowPEres.getReturnValue());
                console.log('======Show PE in the doint=='+component.get("v.showProductionEstimate"));
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',ShowPEres.getError()[0].message);
                var errors = ShowPEres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        
        $A.enqueueAction(ShowProEst);
        $A.enqueueAction(PORec);
        $A.enqueueAction(sumAction);
        $A.enqueueAction(OrgAction);
        
    },
    
    
    PoLineItemsFromPo : function (component, event, helper) {
        var ShowPE=component.get("v.showProductionEstimate");
        console.log('=====ShowPE====='+ShowPE);
        var PoLiAction = component.get("c.PoLineItemsFromPo");
        PoLiAction.setParams({
            poid : event.getParam('row').Id
        });
        PoLiAction.setCallback(this, function(POLIresponse) {
            if (POLIresponse.getState() === "SUCCESS") {
                console.log('=====PoItems==='+POLIresponse.getReturnValue());
                console.log('=====PoItems==='+JSON.stringify(POLIresponse.getReturnValue()));
                
                var rows=POLIresponse.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('==row ='+row);
                    console.log('==Amount='+row.Calc_amnt);
                    row.Calc_Amnt=row.Calc_amnt;
                    if(ShowPE){
                        row.LineName=row.e.Production_Estimate__r.Name;
                        row.Qunatity=row.e.Quantity_production__c;    
                    }
                    else{
                        row.LineName=row.e.Estimate_Line_Item__r.Name;
                        row.Qunatity=row.e.Quantity__c; 
                    }
                }
                component.set("v.PoLidata",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',POLIresponse.getError()[0].message);
                var errors = POLIresponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(PoLiAction);  
    },
    
    saveRecordsInvfromPO : function(component,selectedRecords,InvoiceId,Porderid){
        var SaveAction = component.get("c.SavePoLineItems");
        SaveAction.setParams({
            selectedRec : selectedRecords,
            InvId:InvoiceId,
            poid:Porderid
        });
        
        SaveAction.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS") {
                if(res.getReturnValue()=="OK"){
                    var ToastMsg111 = $A.get("e.force:showToast");
                    ToastMsg111.setParams({
                        "type": "success",
                        "message":'Successully PO Line Items Inserted as Invoice Line Items'
                    }); 
                    ToastMsg111.fire();
                    
                    //var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                    // appEvent.fire();
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(SaveAction);  
        
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var LogInvAction = {
            'label': 'Log Invoice',
            'iconName': 'utility:Add',
            'name': 'Log_Inv',
            'disabled': (row.Invoice_Created__c == 'Created' || row.Status__c == 'Open' || row.Status__c == 'Cancelled' || row.Status__c == 'Pending' || row.Status__c == null)
        };
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_PO'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_PO'
        };
        
        var printAction = {
            'label': 'Print',
            'iconName': 'utility:print',
            'name': 'Print_PO'
        };
        
        if(row.Invoice_Created__c!='No'){
            deleteAction['disabled']=true;
            editAction['disabled']=true;
        }
        
        actions.push(LogInvAction,editAction,deleteAction,printAction);
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("PODataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updatePO");
        action.setParams({
            'editedPOList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" PO Records Updated"
                    });
                    
                    // helper.reloadDataTable();
                    helper.fetchJobPO(component, event, helper);
                    component.find("PODataTable").set("v.draftValues", null);
                    
                } else if(response.getReturnValue() ==='Error'){
                     helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Purchase order has insufficient access to eidit/update.'
                    });
                }
                else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                    var err_array =  response.getReturnValue().split(';');
                    component.set('v.errors', {
                        rows: {
                            b: {
                                title: 'We found errors.',
                                messages: [
                                    err_array[0],
                                    err_array[1].split(',')[1]
                                ],
                                fieldNames: ['Issue_Date__c', 'Due_Date__c']
                            }
                        },
                        table: {
                            title: 'Your entry cannot be saved. Fix the errors and try again.',
                            messages: [
                                err_array[0],
                                err_array[1].split(',')[1]
                            ]
                        }
                    });
                    
                    
                }      
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
    reloadDataTable : function(){
        console.log('==========reloadData Table======');
        var refreshEvent = $A.get("e.force:refreshView");
        $A.get('e.force:refreshView').fire();
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        console.log('==sortBy=primer==='+primer);
        console.log('==sortBy=field==='+field);
        console.log('==sortBy=reverse==='+reverse);
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    CreatePORecord:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Purchase_Order__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    InvoiceFromPOFields :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Invoice__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set for Invoice====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.Invfieldset",response.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    
    getVendor:  function(component, event, helper){
        var recId = component.get("v.jobrecordId");
        var actionVen = component.get("c.getPOVendors");
        actionVen.setParams({
            recordId : recId 
        });
        actionVen.setCallback(this, function(responseVen){
            var stateVen = responseVen.getState();
            console.log("===List of Approved Estimate Vendors===" + responseVen.getReturnValue());
            console.log("===List of Approved Estimate Vendors===" + JSON.stringify(responseVen.getReturnValue()));
            var Ven=responseVen.getReturnValue();
            var Venlist=[];
            if(stateVen === "SUCCESS"){
                for (var key in Ven) {
                    Venlist.push({
                        key: key,
                        value: Ven[key]
                    });
                }
                component.set("v.VendorRecords", Venlist); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVen.getError()[0].message);
                var errors = responseVen.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVen);  
    },
    
    getVendorCon:  function(component, event, helper,ParentId){
        var VenId;
        if(ParentId==null || ParentId=='' ){
            VenId=component.find("VendorId").get('v.value');
            console.log('====new button get contact=='+VenId);
        }
        else{
            
            VenId=ParentId;
            console.log('====edit vendoer button button=='+VenId);
        }
        
        
        console.log('===VenId==='+VenId);
        var actionVenCon = component.get("c.getVendorContact");
        actionVenCon.setParams({
            VendorName :VenId 
        });
        
        actionVenCon.setCallback(this, function(responseVenCon){
            var stateVenCon = responseVenCon.getState();
            console.log("===List of Vendors Contact===" + responseVenCon.getReturnValue());
            //var VenCon=responseVenCon.getReturnValue();
            //var VenConlist=[];
            if(stateVenCon === "SUCCESS"){
                /* for (var key in VenCon) {
                    VenConlist.push({
                        key: key,
                        value: VenCon[key]
                    });
                  }*/
                component.set("v.VendorConRecords",responseVenCon.getReturnValue()); 
                
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVenCon.getError()[0].message);
                var errors = responseVenCon.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVenCon);  
    },
    
    getStaff:  function(component, event, helper){
        var actionStaff = component.get("c.getStaffs");
        actionStaff.setCallback(this, function(responseStaff){
            var stateStaff = responseStaff.getState();
            console.log("===List of Staff===" + responseStaff.getReturnValue());
            if(stateStaff === "SUCCESS"){
                component.set("v.StaffRecords",responseStaff.getReturnValue()); 
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',responseStaff.getError()[0].message);
                var errors = responseStaff.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionStaff);  
    },
    
    deleteJobPO: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete PO Id for the Section=='+row.Id);     
        var DeletePO=component.get("c.deletePO");
        DeletePO.setParams({PORecId :row.Id });
        DeletePO.setCallback(this, function(DeletePO){
            var delresult= DeletePO.getReturnValue();
            console.log('======delresult======'+JSON.stringify(delresult));
            if(DeletePO.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    var ToastMsg111 = $A.get("e.force:showToast");
                    ToastMsg111.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    }); 
                    ToastMsg111.fire();
                    
                    helper.fetchJobPO(component, event, helper);
                    var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                    appEvent.fire();
                }
                else{
                    var ToastMsg111 = $A.get("e.force:showToast");
                    ToastMsg111.setParams({
                        "title" :"Error!!",
                        "type": "error",
                        "message":delresult[1]
                    }); 
                    ToastMsg111.fire();
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DeletePO.getError()[0].message);
                var errors = DeletePO.getError();               
                var ToastMsg111 = $A.get("e.force:showToast");
                ToastMsg111.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
                ToastMsg111.fire();
            }
         
        });
        $A.enqueueAction(DeletePO);  
    },
    
    selectedEstLI_PELI: function(component, event, helper,newPOId){
        var POLI=component.get('v.Selected_ESTLI');
        if((newPOId!=null || newPOId!='') && (POLI!=null || POLI!='')){
            var Est_PEAction = component.get("c.insertEstLI_PELI");
            Est_PEAction.setParams({
                PORecId : newPOId,
                selRecords : POLI });
            
            Est_PEAction.setCallback(this, function(Est_PEActionRes){
                var Est_PEActionstate = Est_PEActionRes.getState();
                console.log("===insert Est_PE state===" + Est_PEActionRes.getReturnValue());
                if(Est_PEActionstate === "SUCCESS"){
                    console.log('=====scucesffully inserted Est and PE the records===');
                    component.set("v.Selected_ESTLI",null);  
                    helper.fetchJobPO(component, event, helper);
                    
                    var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                    appEvent.fire();
                    
                } 
                
                else {
                console.log('>>>>>> Error >>>>>>>>>>',Est_PEActionRes.getError()[0].message);
                var errors = Est_PEActionRes.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
            }); 
            $A.enqueueAction(Est_PEAction);  
        }
        
    }
})