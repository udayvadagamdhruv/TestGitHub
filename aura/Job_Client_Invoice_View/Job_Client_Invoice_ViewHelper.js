({
    
    getFieldLabels: function(component, event, helper) {
        
        var rowActions = helper.getRowActions.bind(this, component);
        var CLInvLIrowActions = helper.getCLInvLIRowActions.bind(this, component);
        var Objaction = component.get( "c.FetchObjectType" );
        Objaction.setParams({
            ObjNames : ['Client_Invoice__c','Invoice_Allocation_Line_Item__c','Client_Invoice_Line_Item__c']
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
                    {label: tableHeader.Invoice_Allocation_Line_Item__c.Client_Name__c.label, fieldName: 'ClientLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'ClientName' }, target: '_self' } },
                    {label: tableHeader.Invoice_Allocation_Line_Item__c.Allocation_Qty__c.label, fieldName: 'Allocation_Qty__c', editable:'true',sortable: true, type: 'number'},
                    {label: tableHeader.Invoice_Allocation_Line_Item__c.Allocation_Amount__c.label, fieldName: 'Allocation_Amount__c',sortable: true, type: 'currency'}
                   
                ]);  
                
                
                var Dcolumns =[
                    {type: 'action', typeAttributes: {rowActions: CLInvLIrowActions}},
                    {label: 'Line Item', fieldName: 'EstLILink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'EstName' }, target: '_self' , tooltip:{ fieldName: 'EstName' }}},
                    {label: tableHeader.Client_Invoice_Line_Item__c.GL_Code__c.label, fieldName: 'GL_CodeLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'GL_CodeName' }, target: '_self' , tooltip:{ fieldName: 'GL_CodeName' }}},
                    {label: tableHeader.Client_Invoice_Line_Item__c.GL_Code_No__c.label, fieldName: 'GL_Code_No__c',sortable: true, type: 'number',cellAttributes: {alignment: 'left' }},
                    {label: tableHeader.Client_Invoice_Line_Item__c.Unit_Type__c.label, fieldName: 'Unit_Type__c',sortable: true, type: 'text'},
                    {label: tableHeader.Client_Invoice_Line_Item__c.Equipment_Type__c.label, fieldName: 'Equipment_Type__c',sortable: true, type: 'text'},
                    {label: tableHeader.Client_Invoice_Line_Item__c.Quantity__c.label, fieldName: 'Quantity__c',editable:'true',sortable: true, type: 'number',cellAttributes: {alignment: 'left' }},
                    {label: tableHeader.Client_Invoice_Line_Item__c.Billable_Amount__c.label, fieldName: 'Billable_Amount__c',editable:'true',sortable: true, type: 'currency',cellAttributes: {alignment: 'left' }},
                    {label: tableHeader.Client_Invoice_Line_Item__c.Tax__c.label, fieldName: 'Tax__c',editable:'true',sortable: true, type: 'boolean'}
                    
                ];
                setTimeout($A.getCallback(function() {
                    var showPE=component.get("v.ShowProductionEstimate");
                    console.log('========showPE=========='+showPE);
                    if(showPE){
                        var newcol=Dcolumns.slice(0, 3).concat(Dcolumns.slice(3 + 1, Dcolumns.length))
                        console.log('========newcol=========='+newcol);
                        component.set('v.CLINVColumns',newcol);
                    }
                    else{
                        var newcol=Dcolumns.slice(0, 4).concat(Dcolumns.slice(4 + 1, Dcolumns.length))
                        console.log('========newcol=========='+JSON.stringify(newcol));
                        component.set('v.CLINVColumns',newcol);
                    }
                }),500);
                
                //Display table to Add Estimate/Production Estimate in Client Invoice Line Items 
                var columns = [
                    {label: 'Name', fieldName: 'Name',sortable: true, type: 'text'},
                    {label: 'GL Description', fieldName: 'GL_CodeName', sortable: true, type: 'text'},
                    {label: 'Unit Type', fieldName: 'Unit_Type__c',sortable: true, type: 'text'},
                    {label: 'Equipment Type', fieldName: 'Equipment_Type__c',sortable: true, type: 'text'},
                    {label: 'Quantity', fieldName: 'Quantity__c',sortable: true, type: 'number',cellAttributes: {alignment: 'left' }},
                    {label: 'Total Cost', fieldName: 'TotalCost',sortable: true, type: 'currency',cellAttributes: {alignment: 'left' }}
                ];
                setTimeout($A.getCallback(function() {
                    var showPE=component.get("v.ShowProductionEstimate");
                    console.log('========showPE=========='+showPE);
                    if(showPE){
                        var newcol=columns.slice(0, 2).concat(columns.slice(2 + 1, columns.length))
                        component.set('v.AddCLINVColumns',newcol);
                    }
                    else{
                        var newcol=columns.slice(0, 3).concat(columns.slice(3 + 1, columns.length))
                        component.set('v.AddCLINVColumns',newcol);
                    }
                }),500);
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    fetchInvALI : function(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc) {
        
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
        
        /********************************** Fetch Invoice Allocation Records ***********************************/
        if(ClientInvLIAllocAcc==true){
            var InvALIRec = component.get("c.getInvALIrecords");
            InvALIRec.setParams({
                recordId : recId 
            });
            InvALIRec.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    
                    var rows=response.getReturnValue();
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                        if(row.Client_Name__c){
                            row.ClientLink='/'+row.Client_Name__c;
                            row.ClientName=row.Client_Name__r.Name;
                        }
                        
                    }
                    component.set("v.data",rows);
                    
                }
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                    var errors = response.getError();
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Invoice Allocation Line Item has '+errors[0].message
                    }); 
                }
            });
            
            /************************************ Sum and Quantity of Invoice Allocation Items **************************************/  
            var sumAction = component.get("c.getSumCash");
            sumAction.setParams({
                CLIid : recId 
            });
            sumAction.setCallback(this, function(res) {
                if (res.getState() === "SUCCESS") {
                    component.set("v.SumCash",res.getReturnValue());
                }
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',res.getError());
                    var errors = res.getError();
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Error in Calculating Sum of amount in Invoice Allocation Line Items'
                    }); 
                }
            });
            
            var QuantyAction = component.get("c.getSumQuant");
            QuantyAction.setParams({
                CLIid : recId 
            });
            QuantyAction.setCallback(this, function(res) {
                if (res.getState() === "SUCCESS") {
                    component.set("v.SumQuant",res.getReturnValue());
                }
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',res.getError());
                    var errors = res.getError();
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Error in Calculating Sum of Qty in Invoice Allocation Line Items'
                    }); 
                }
            });
            
            $A.enqueueAction(sumAction);
            $A.enqueueAction(QuantyAction);
            $A.enqueueAction(InvALIRec);
            
            
        }
        
        /*************** Fetch Estimate/Production Estimates records in Add LineItems button in Invoice Line Item section ********/
        if(ClientInvLIAcc==true){
            var AddCLInvLIRec = component.get("c.getAddEstLIinCLInvLI");
            AddCLInvLIRec.setParams({
                recordId : recId 
            });
            AddCLInvLIRec.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    try{
                        var rows=response.getReturnValue();
                        console.log('==Inv LI rows==='+JSON.stringify(rows));
                        for (var i = 0; i < rows.length; i++) {	
                            var row = rows[i];
                            var ShowPE=component.get("v.ShowProductionEstimate");
                            console.log('>>>>>ShowPE>>>>>>>>'+ShowPE);
                            if(ShowPE){
                                row.TotalCost=row.Total_Cost__c;
                                // row.UnitType=row.Equipment_Type__c;
                            }else{
                                row.TotalCost=row.Total_Amount__c;
                                // row.UnitType=row.Unit_Type__c;
                            }
                            if(row.GL_Code__c){
                                row.GL_CodeName=row.GL_Code__r.Name;
                            }
                        }
                        component.set("v.AddCLINVLIdata",rows);
                    }
                    catch (e) {
                        // Handle error
                        console.error(e);
                        var errors = response.getError();
                        helper.showToast({
                            "title": "Error!!",
                            "type": "error",
                            "message": e.message
                            
                        }); 
                    }
                    
                }
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                    var errors = response.getError();
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": errors[0].message
                    }); 
                }
            });
            
            
            /********************************** Fetch Client Invoice Line Item records *******************************************/
            var CLInvLIRec = component.get("c.getClientInvLI");
            CLInvLIRec.setParams({
                recordId : recId 
            });
            CLInvLIRec.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var rows=response.getReturnValue();
                        var val=Object.values(rows);
                        console.log('>>>>CLInvLIRec>>>>>>>>'+JSON.stringify(Object.values(rows)));
                        for (var i = 0; i < val.length; i++) {
                            var ShowPE=component.get("v.ShowProductionEstimate");
                            console.log('>>>>>ShowPE>>>>>>>>'+ShowPE);
                            var row = rows[i];
                            console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                            if(ShowPE){
                                if(row.Production_Estimate__c){
                                    console.log('>>>>>>With PE Name>>>>>>');
                                    row.EstLILink='/'+row.Production_Estimate__c;
                                    row.EstName=row.Production_Estimate__r.Name;
                                }
                            }
                            else
                            {
                                if(row.Estimate_Line_Item__c){
                                    row.EstLILink='/'+row.Estimate_Line_Item__c;
                                    row.EstName=row.Estimate_Line_Item__r.Name;
                                }
                            }
                            if(row.GL_Code__c){
                                row.GL_CodeLink='/'+row.GL_Code__c;
                                row.GL_CodeName=row.GL_Code__r.Name;
                            }
                            
                        }
                        console.log('>>>>>rows CLINVLI>>>>>'+JSON.stringify(rows));
                        component.set("v.CLINVLIdata",Object.values(rows));
                    }
                   
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                    var errors = response.getError();
                    helper.showToast({
                        "title": "CliError!!!!!",
                        "type": "error",
                        "message": 'Client Invoice Line Items has'+errors[0].message
                    }); 
                }
            });
            $A.enqueueAction(AddCLInvLIRec);
            $A.enqueueAction(CLInvLIRec);
        }
        
        
        
        
        
    },
    
    ShowProductionEstimate :function(component, event){
        var showPEAction = component.get("c.showProductionEstimate");
        showPEAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var isShowPE=response.getReturnValue();
                
                component.set("v.ShowProductionEstimate",isShowPE);
                console.log('>>>>Showwww PEEEEE >>>>>>>>>>'+component.get("v.ShowProductionEstimate"));
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(showPEAction);                          
    },
    
    /****************************** Row Actions of Invoice Allocation Section *******************************/
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_InvALI'
        };
        
        actions.push(deleteAction);
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    /****************************** Row Actions of Client Invoice Line Item Section *******************************/
    getCLInvLIRowActions: function (component, row, doneCallback) {
        var actions = [];
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_CLInvLI'
        };
        
        actions.push(deleteAction);
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
    /************************** Save the Invoice Allocation Section Table **********************************/
    
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("InvALIDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateInvALI");
        action.setParams({
            'editInvALIList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Invoice Allocation Line Item Records Updated"
                    });
                    
                    // helper.reloadDataTable();
                    var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
                    var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
                    helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
                    
                    component.find("InvALIDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
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
    
    /************************** Save the Invoice Line Items Section Table **********************************/
    
    CLInvLIsaveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("CLInvLIDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateCLInvLI");
        action.setParams({
            'editCLInvLIList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Client Invoice Line Item Records Updated"
                    });
                    
                    helper.reloadDataTable();
                    var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
                    var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
                    helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
                    component.find("CLInvLIDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Invoice Line Items has'+ errors[0].message
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
    
    /************************** Sort the Invoice Allocation Section Table Data **********************************/
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='ClientLink'){
          data.sort(this.sortBy('ClientName', reverse))  
        }else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.data", data);
    },
    
    /************************** Sort the Invoice Line Item Section Table Data **********************************/
    
    CLInvLIsortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.CLINVLIdata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='EstLILink'){
           data.sort(this.sortBy('EstName', reverse)) 
        }else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.CLINVLIdata", data);
    },
    
    /************************** Sort the Add button Invoice Line Item Section Table Data **********************************/
    
    AddCLInvLIsortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.AddCLINVLIdata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.AddCLINVLIdata", data);
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
    
    /*  CreateInvALIRecord:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Invoice_Allocation_Line_Item__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
        });
        
        $A.enqueueAction(action);
    },*/
    
    getInvALITemp: function(component, event, helper){
        var action1 = component.get("c.getInvAllocationTemplates");
        action1.setCallback(this, function(response1) {
            console.log("=====Invoice Allocation Temp====", response1.getReturnValue());
            var InvALI=response1.getReturnValue();
            var InvALITemp=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in InvALI) {
                    InvALITemp.push({
                        key: key,
                        value: InvALI[key]
                    });
                }
                component.set("v.InvALITempRecords", InvALITemp); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError());
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Invoice Allocation Template has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    
    getClient: function(component, event, helper){
        var action1 = component.get("c.getClients");
        action1.setCallback(this, function(response1) {
            console.log("=====Client List====", response1.getReturnValue());
            var Cli=response1.getReturnValue();
            var clients=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in Cli) {
                    clients.push({
                        key: key,
                        value: Cli[key]
                    });
                }
                component.set("v.ClientRecords", clients); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError());
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    
    /**************************************** Delete the Client Invoice Line Items *************************************/
    
    deleteCLInvLI: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete CLI Id=='+row.Id);     
        var DeleteCLInvLI=component.get("c.deleteCLInvLI");
        DeleteCLInvLI.setParams({CLIid :row.Id });
        DeleteCLInvLI.setCallback(this, function(DeleteCLInvLIres){
            var delstate = DeleteCLInvLIres.getState();
            console.log('===delstate=='+delstate);
            if(delstate === "SUCCESS"){
                var delSuc=DeleteCLInvLIres.getReturnValue();
                if(delSuc==='OK'){
                var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
                var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
                helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
                
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "type": "success",
                    "message":'Record Deleted Successfully.'
                });
                ToastMsg.fire();
                helper.reloadDataTable();
            }
                else
                {
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":DeleteCLInvLIres.getReturnValue()
                    });
                    ToastMsg.fire();
                } 
            }
            else {
               console.log('>>>>>> Error >>>>>>>>>>',DeleteCLInvLIres.getError());
               var errors = DeleteCLInvLIres.getError();
               helper.showToast({
                   "title": "Error!!",
                   "type": "error",
                   "message": errors[0].message
               });
           }
        });
        $A.enqueueAction(DeleteCLInvLI);  
    },
    
    /**************************************** Delete the Client Invoice Allocation Items *************************************/
    
    deleteInvALI: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete CLI Id=='+row.Id);     
        var DeleteInvALITemp=component.get("c.deleteIALI");
        DeleteInvALITemp.setParams({CLIid :row.Id });
        DeleteInvALITemp.setCallback(this, function(DeleteInvALIres){
            var delstate = DeleteInvALIres.getState();
            console.log('===delstate=='+delstate);
            if(delstate === "SUCCESS"){
                var delSuc=DeleteInvALIres.getReturnValue();
                if(delSuc==='OK'){
                    var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
                    var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
                    helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
                    
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    });
                    ToastMsg.fire();
                }
                else
                {
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":DeleteInvALIres.getReturnValue()
                    });
                    ToastMsg.fire();
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DeleteInvALIres.getError());
                var errors = DeleteInvALIres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
            }
        });
        $A.enqueueAction(DeleteInvALITemp);  
    },
    
    /********************* Selected the Estimate/Production estimate and Save the record *************************************/
    
    selectedEstLI_PELI: function(component, event, helper){
        var newCLIId=component.get("v.recordId");
        var CLI=component.get('v.Selected_ESTLI');
        if((newCLIId!=null || newCLIId!='') && (newCLIId!=null || newCLIId!='')){
            var Est_PEAction = component.get("c.insertEstLI_PELI");
            Est_PEAction.setParams({
                CLInvRecId : newCLIId,
                selRecords : CLI });
            
            Est_PEAction.setCallback(this, function(Est_PEActionRes){
                var Est_PEActionstate = Est_PEActionRes.getState();
                console.log("===insert Est_PE state from Detail page===" + Est_PEActionRes.getReturnValue());
                var resp= Est_PEActionRes.getReturnValue();
                if(Est_PEActionstate === "SUCCESS"){
                    if(resp==='OK')
                    {
                        console.log('=====scucesffully inserted Est and PE the records from the Detail page===');
                        var ToastMsg5=$A.get("e.force:showToast");    
                        ToastMsg5.setParams({
                            "type": "success",
                            "message": CLI.length +" line Items added to this Order."
                        });   
                        ToastMsg5.fire();
                        var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
                        var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
                        helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
                        
                        component.set('v.selectedRowsCount', null);
                        component.set("v.Selected_ESTLI",null);   
                        component.set("v.isaddClick",false);  
                    }
                    else
                    {
                        helper.showToast({
                            "title": "Error!!",
                            "type": "error",
                            "message": resp
                        }); 
                    }
                }
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',Est_PEActionRes.getError());
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