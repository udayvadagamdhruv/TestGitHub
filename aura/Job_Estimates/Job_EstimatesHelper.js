({
    getFieldLabels: function(component, event, helper) {
        console.log('>>>>>> getFieldLabels Method >>>>>>>>');
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Estimate_Line_Items__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                var tableHeader=component.get('v.ObjectType');
                console.log('>>>Field Name Dynamically >>>>>>>>>>>>>'+tableHeader);
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeader.Estimate_Line_Items__c.Name.label, fieldName: 'EstLink', sortable: true, type: 'url',initialWidth:200, typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeader.Estimate_Line_Items__c.Vendor__c.label, fieldName: 'Vendor', sortable: true,initialWidth:200, type: 'text'},
                    {label: tableHeader.Estimate_Line_Items__c.Unit_Type__c.label, fieldName: 'Unit_Type__c',sortable: true,initialWidth:100, type: 'text'},
                    {label: tableHeader.Estimate_Line_Items__c.Quantity__c.label, fieldName: 'Quantity__c', editable:'true', sortable: true,initialWidth:100, type: 'number',  cellAttributes: {class: { fieldName: 'EsimateInlineEdit'}, alignment: 'left' } },
                    {label: tableHeader.Estimate_Line_Items__c.Amount__c.label, fieldName: 'Amount__c', editable:'true', sortable: true, type: 'currency',initialWidth:180, cellAttributes: {class: { fieldName: 'EsimateInlineEdit'}, alignment: 'left' } },
                    {label: tableHeader.Estimate_Line_Items__c.Total_Amount__c.label, fieldName: 'Total_Amount__c',sortable: true, type: 'currency',initialWidth:180, cellAttributes: {alignment: 'left' } },
                    {label: tableHeader.Estimate_Line_Items__c.Approved__c.label, fieldName: 'Approved__c', sortable: true, type: 'boolean',initialWidth:100},
                    {label: tableHeader.Estimate_Line_Items__c.PO_Created__c.label, fieldName: 'PO_Created__c', sortable: true, type: 'boolean',initialWidth:100}
                    
                ]);  
                
                var labels = {'Quantity':tableHeader.Estimate_Line_Items__c.Quantity__c.label,
                              'TotalCost':tableHeader.Estimate_Line_Items__c.Total_Amount__c.label
                             };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels------'+JSON.stringify(labels));
                
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
        $A.enqueueAction( Objaction );   
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Estimate_Line_Items__c"
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
        
        $A.enqueueAction(action1);
    },
    
    fetchJobEst : function(component, event, helper) {
        console.log('>>>>>> fetchJobEst Method Enter >>>>>>>>>>');
        var recId = component.get("v.jobrecordId");
        var EstimateRec = component.get("c.getEstimateRecords");
        EstimateRec.setParams({
            recordId : recId 
        });
        EstimateRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.EstLink = '/'+row.Id;    
                    if (row.Vendor__c) row.Vendor = row.Vendor__r.Name;
                    if(row.PO_Created__c == false && row.Approved__c == false && row.Restrict__c == false){
                        row.EsimateInlineEdit='EstimateEditable';   
                    }
                    else{
                        row.EsimateInlineEdit='EstimateNonEditable';  
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
        
        
        var sumAction = component.get("c.getTotalAmountForSections");
        sumAction.setParams({
            ObjectName : "Est",
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
                    "message": 'Estimate has'+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(EstimateRec);
        $A.enqueueAction(sumAction);
        console.log('>>>>>> fetchJobEst Method Endss >>>>>>>>>>');
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        console.log('>>>>>> getRowActions Method >>>>>>>>');
        var actions = [{'label': 'Duplicate',
                        'iconName': 'action:clone',
                        'name': 'Dup_Estimate'}];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_Estimate'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_Estimate'
        };
        var approveAction = {
            'label': 'Approve',
            'iconName': 'action:approval',
            'name': 'Approve_Estimate'
        };
        
        var unApproveAction = {
            'label': 'Unapprove',
            'iconName': 'utility:close',
            'name': 'UnApprove_Estimate'
        };
        
        console.log('===row approve=='+row['Approved__c']);
        console.log('===row approve=='+row.Approved__c);
        console.log('===row Restrict=='+row['Restrict__c']);
        console.log('===row Restrict=='+row.Restrict__c);
        
        if (row['Approved__c'] || row['Restrict__c']) {
            editAction['disabled']= 'true';
            deleteAction['disabled'] = 'true';
            if(row['Approved__c']){
                approveAction['disabled'] ='true';
                if(row['PO_Created__c']==true){
                    unApproveAction['disabled'] = 'true';
                }
            }
            else{
                unApproveAction['disabled'] = 'true';
            }
        }
        else {
            unApproveAction['disabled'] = 'true';
        }
        actions.push(editAction,deleteAction,approveAction,unApproveAction);
        
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
        console.log('>>>>>> saveDataTable Method >>>>>>>>');
        var editedRecords =  component.find("EstimateDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateEst");
        action.setParams({
            'editedEstList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Estimate Records Updated"
                    });
                    
                    // helper.reloadDataTable();
                    helper.fetchJobEst(component, event, helper);
                    component.find("EstimateDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Estimate has'+response.getReturnValue()
                    });
                    
                }      
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Estimate has'+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Show toast with provided params
     * */
    showToast : function(params){
        console.log('>>>>>> showToast Method >>>>>>>>');
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
        //$A.get('e.force:refreshView').fire();
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
    
    CreateEstRecord:  function(component, event, helper){
        console.log('>>>>>> CreateEstRecord Method >>>>>>>>');
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Estimate_Line_Items__c"
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
                    "message": 'Estimate has'+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getGLDepartment: function(component, event, helper){
        console.log('>>>>>> getGLDepartment Method >>>>>>>>');
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(response1) {
            console.log("=====GLD List====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var GLD=response1.getReturnValue();
                component.set("v.GL_DepartmentRecords", GLD); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Estimate has'+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    getGLCode: function(component, event, helper, GLCodeVal, VendorVal){
        console.log("===getGLCode Method Enter===");
        var GLDId=component.find("GLDSelectId").get('v.value');
        console.log('===GLDId==='+GLDId);
        var actionCC = component.get("c.getGLCodes");
        
        actionCC.setParams({
            GLDName :GLDId 
        });
        actionCC.setCallback(this, function(responseCC){
            var stateCC = responseCC.getState();
            console.log("===List of GLC===" + JSON.stringify(responseCC.getReturnValue()));
            if(stateCC === "SUCCESS"){
                var CC=responseCC.getReturnValue();
                component.set("v.GL_CodeRecords", CC); 
                if((GLCodeVal!=null || GLCodeVal!=undefined) && (VendorVal!=null || VendorVal !=undefined)){
                    this.getVendor(component, event,helper, GLCodeVal, VendorVal);
                }
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseCC.getError()[0].message);
                var errors = responseCC.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Estimate has'+errors[0].message
                }); 
            }
            console.log('>>>>>> getGLCode Method Endss >>>>>>>>>>');
            
        }); 
        $A.enqueueAction(actionCC);  
        
    },
    
    getVendor:  function(component, event, helper, GLCodeVal, VendorVal){
        console.log("===getVendor Method Enter===");
        var GLCId=GLCodeVal; //component.find("GLCodeSelectId").get('v.value');
        //console.log('===Department==='+JSON.stringify(component.find("GLDSelectId").get('v.value')));
        console.log('===GLCId==='+GLCId);
        var actionVen = component.get("c.getVendors");
        actionVen.setParams({
            GLCName :GLCId 
        });
        actionVen.setCallback(this, function(responseVen){
            var stateVen = responseVen.getState();
            console.log("===List of Vendors===" + JSON.stringify(responseVen.getReturnValue()));
            if(stateVen === "SUCCESS"){
                var Ven=responseVen.getReturnValue();
                component.set("v.VendorRecords", Ven); 
                setTimeout($A.getCallback(function() {
                    console.log('>>>>>> getVendor GLCodeVal >>>>>>>>'+GLCodeVal);
                    console.log('>>>>>> getVendor VendorVal >>>>>>>>'+VendorVal);
                    if((GLCodeVal!=null || GLCodeVal!=undefined) && (VendorVal!=null || VendorVal !=undefined)){
                        component.find("GLCodeSelectId").set("v.value",GLCodeVal);
                        component.find("VendorId").set("v.value",VendorVal);
                    }
                }), 200);
                
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVen.getError()[0].message);
                var errors = responseVen.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Estimate has'+errors[0].message
                }); 
            }
            console.log('>>>>>> getVendor Method Endss >>>>>>>>>>');
        }); 
        
        var actionAmount = component.get("c.getamount");
        actionAmount.setParams({
            GLCName :GLCId 
        });
        actionAmount.setCallback(this, function(responseAmt){
            var stateAmt = responseAmt.getState();
            console.log("===Amount===" + responseAmt.getReturnValue());
            if(stateAmt === "SUCCESS"){
                component.set("v.Amount", responseAmt.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVen.getError()[0].message);
                var errors = responseVen.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Estimate has'+errors[0].message
                }); 
            }
            console.log('>>>>>> getVendor1 Method Endss >>>>>>>>>>');
            
        }); 
        $A.enqueueAction(actionAmount);  
        $A.enqueueAction(actionVen);  
        
    },
    
    deleteJobEst: function(component, event, helper,selectEstId){
        console.log('>>>>>> deleteJobEst Method >>>>>>>>');
        var DeleteEst=component.get("c.deleteEst");
        if(selectEstId!=null || selectEstId!=undefined){
            DeleteEst.setParams({
                estRecId :selectEstId
            });
        }
        else{
            var row = event.getParam('row');
            DeleteEst.setParams({
                estRecId :row.Id
            });
            console.log('===Delete Est Id=='+row.Id);
        }  
        
        DeleteEst.setCallback(this, function(DeleteEstres){
            var delresult=DeleteEstres.getReturnValue();
            if(DeleteEstres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record deleted Successfully."
                    });
                    helper.fetchJobEst(component, event, helper);   
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Estimate has'+delresult[1]
                    });
                }
            }          
        });
        $A.enqueueAction(DeleteEst);  
    },
    
    duplicateJobEst: function(component, event, helper, selectEstId){
        console.log('>>>>>> duplicateJobEst Method >>>>>>>>');
        var DuplicateEst=component.get("c.duplicateEtimate");
        if(selectEstId!=null || selectEstId!=undefined){
            DuplicateEst.setParams({
                estRecId :selectEstId
            });
        }
        else{
            var row = event.getParam('row');
            DuplicateEst.setParams({
                estRecId :row.Id
            });
            console.log('===Dup Est Id=='+row.Id);
        }  
        
        DuplicateEst.setCallback(this, function(DupEstres){
            var DupEststate = DupEstres.getState();
            if(DupEststate === "SUCCESS"){
                if(DupEstres.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record duplicated Successfully."
                    });
                    helper.fetchJobEst(component, event, helper);
                }
                else if(DupEstres.getReturnValue()=='Error, Estimate Line Item has insufficient access to create'){
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Estimate has'+DupEstres.getReturnValue()
                    });  
                }
                    else{
                        helper.showToast({
                            "title":"Error!!",
                            "type":"error",
                            "message":'Estimate has'+DupEstres.getReturnValue()
                        }); 
                    }
            }           
        });
        $A.enqueueAction(DuplicateEst);  
    },
    
    approveJobEst: function(component, event, helper, selectEstId){
        console.log('>>>>>> approveJobEst Method >>>>>>>>');
        var ApproveEst=component.get("c.approveEstimate");
        if(selectEstId!=null || selectEstId!=undefined){
            ApproveEst.setParams({
                estRecId :selectEstId
            });
        }
        else{
            var row = event.getParam('row');
            ApproveEst.setParams({
                estRecId :row.Id
            });
            console.log('===App Est Id==='+row.Id);
        }  
        
        ApproveEst.setCallback(this, function(AppEstres){
            var ApproveEststate = AppEstres.getState();
            if(ApproveEststate === "SUCCESS"){
                if(AppEstres.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record approved Successfully."
                    });
                    helper.fetchJobEst(component, event, helper);
                    helper.reloadDataTable();
                }
                else if(AppEstres.getReturnValue()=='Error'){
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message": 'Estimate Line Item has insufficient access to Edit/Update'
                    });  
                }
                    else{
                        helper.showToast({
                            "title":"Error!!",
                            "type":"error",
                            "message": 'Estimate has'+AppEstres.getReturnValue()
                        });  
                    }
            }           
        });
        $A.enqueueAction(ApproveEst);  
    },
    
    unapproveJobEst: function(component, event, helper, selectEstId){
        console.log('>>>>>> unapproveJobEst Method >>>>>>>>');
        var unApproveEst=component.get("c.unapproveEstimate");
        if(selectEstId!=null || selectEstId!=undefined){
            unApproveEst.setParams({
                estRecId :selectEstId
            });
        }
        else{
            var row = event.getParam('row');
            unApproveEst.setParams({
                estRecId :row.Id
            });
            console.log('===unApp Est Id==='+row.Id);
        } 
        
        unApproveEst.setCallback(this, function(unAppEstres){
            var unApproveEststate = unAppEstres.getState();
            if(unApproveEststate === "SUCCESS"){
                if(unAppEstres.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record Unapproved Successfully."
                    });
                    helper.fetchJobEst(component, event, helper);
                    helper.reloadDataTable();
                }
                else if(unAppEstres.getReturnValue()=='Error'){
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Estimate Line Item has Insufficient access to Edit/Update'
                    });  
                }else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Estimate has'+unAppEstres.getReturnValue()
                    }); 
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type":"error",
                    "message":'Estimate has'+unAppEstres.getReturnValue()
                });  
            }
        });
        $A.enqueueAction(unApproveEst);  
    },
    
    
})