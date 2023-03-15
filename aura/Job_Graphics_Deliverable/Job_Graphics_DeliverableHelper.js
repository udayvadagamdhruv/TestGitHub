({
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Graphics_Deliverables__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                // console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction( Objaction );   
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Graphics_Deliverables__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
        });
        
        $A.enqueueAction(action1);
    },
    
    
    getDataTableRespone : function(component, event) {
        var recId = component.get("v.recordId");
        var rowActions11=[{'label': 'Edit',   'iconName': 'utility:edit',  'name': 'Edit_GD'},
                          {'label': 'Delete', 'iconName': 'utility:delete', 'name': 'Delete_GD'},
                          {'label': 'Duplicate','iconName': 'action:clone', 'name': 'Duplicate_GD'}];
        var action = component.get("c.getDataTableDetails");
        action.setParams({
            objApi : 'Graphics_Deliverables__c',
            fieldSetName : 'Job_List_GD',
            JobId : recId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var rowact = {type: 'action', typeAttributes: {rowActions: rowActions11}};
                
                // console.log('::::::::::::: Reuslttttttttttt :::::::::::::'+JSON.stringify(lstoflabels.push(rowact)));
                console.log('::::::::::::: SUCCESS :::::::::::::'+JSON.stringify(response.getReturnValue().lstOfFieldLabels));
                console.log('::::::::::::: SUCCESS Records:::::::::::::'+JSON.stringify(response.getReturnValue().lstOfSObjs));
               
                var mapWithGdData=[];
                var lstoflabels=response.getReturnValue().lstOfFieldLabels;
                var lstofvalues=response.getReturnValue().lstOfSObjs;
                var str;
                var Notes;
                for(var i=0;i<lstofvalues.length;i++){
                    var mapWithData=[];
                    for(var k=0;k<lstoflabels.length;k++){
                        if(lstofvalues[i].Graphics_Note__c!=null ||  lstofvalues[i].Graphics_Note__c!=undefined){
                            str = lstofvalues[i].Graphics_Note__c.toString();
                            Notes=  str.replace(/<[^>]*>/g, '');
                            lstofvalues[i].Graphics_Note__c = Notes; 
                        }
                        if(lstofvalues[i][lstoflabels[k].fieldName]==null || lstofvalues[i][lstoflabels[k].fieldName]==undefined){
                            
                            mapWithData.push({
                                key:lstoflabels[k].label,
                                value:'',
                                api:lstoflabels[k].fieldName,
                                id:lstofvalues[i].Id
                            });
                        }
                        else{
                            mapWithData.push({
                                key:lstoflabels[k].label,
                                value:lstofvalues[i][lstoflabels[k].fieldName],
                                api:lstoflabels[k].fieldName,
                                id:lstofvalues[i].Id
                            });
                        }
                    }
                    mapWithGdData.push({
                        key:'key',
                        value:mapWithData
                    }
                                       );
                    
                }
               console.log('-mapWithGdData---'+mapWithGdData);
                component.set('v.mapWithGDData',mapWithGdData);
                
                var DummyLstofLabels=[];
                DummyLstofLabels.push(rowact);
                for (var i = 0; i < lstoflabels.length; i++) {
                    var row = lstoflabels[i];
                    console.log('>>>>>>GD Fields>>>>>>'+JSON.stringify(row));
                    row={label:row.label, fieldName: row.fieldName, type: row.type, sortable:"true",initialWidth:200};
                    if(row.fieldName=='Deliverable_Date__c' || row.fieldName=='Graphics_Type__c'){
                        row={label:row.label, fieldName: row.fieldName, type: row.type, editable:"true",initialWidth:200, sortable:"true"};
                    }  
                    if(row.fieldName=='Start_Time__c'){
                        row={label:row.label, fieldName: row.fieldName, type: 'date', sortable:"true",initialWidth:200,typeAttributes: {  hour: '2-digit',  minute: '2-digit',  second: '2-digit', timeZone:'UTC'}};
                    }
                     if(row.fieldName=='End_Time__c'){
                                                                                                                                        row={label:row.label, fieldName: row.fieldName, type: 'date', sortable:"true",initialWidth:200,typeAttributes: {  hour: '2-digit',  minute: '2-digit',  second: '2-digit', timeZone:'UTC'}};
                    }
                    if(row.fieldName=='Name'){
                        row={label:row.label, fieldName: 'nameLink', type: 'url', sortable:"true",initialWidth:200, typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}};
                    }
                    if(row.fieldName=='Job__c'){
                        row={label:row.label, fieldName: 'JobLink', type: 'url', sortable:"true", initialWidth:200,typeAttributes: { label: { fieldName: 'Job__c' }, target: '_self' ,tooltip:{ fieldName: 'Job__c' }}};
                    }
                    if(row.fieldName=='CreatedById'){
                        row={label:row.label, fieldName: 'CreatedLink', type: 'url', sortable:"true",initialWidth:200, typeAttributes: { label: { fieldName: 'CreatedById' }, target: '_self' ,tooltip:{ fieldName: 'CreatedById' }}};
                    }
                    
                    DummyLstofLabels.push(row);
                }
                console.log('>>>>List of Labels>>>>>>>>'+JSON.stringify(DummyLstofLabels));
                
                var rows=response.getReturnValue().lstOfSObjs;
                for (var i = 0; i < rows.length; i++) {
                    var rowSobj = rows[i];
                    console.log('>>>>>>rowSobj >>>>>>'+JSON.stringify(rowSobj));
                    if(rowSobj.Name){
                        rowSobj.Name=rowSobj.Name;
                        rowSobj.nameLink='/'+rowSobj.Id;
                    }
                    if(rowSobj.Graphics_Note__c){
                        var str = rowSobj.Graphics_Note__c.toString();
                        var Notes =  str.replace(/<[^>]*>/g, '');
                        rowSobj.Graphics_Note__c = Notes;
                    }
                    if(rowSobj.Job__c){
                        rowSobj.Job__c=rowSobj.Job__r.Name;
                        rowSobj.JobLink='/'+rowSobj.Job__r.Id;
                    }
                    if(rowSobj.CreatedById){
                        rowSobj.CreatedById=rowSobj.CreatedBy.Name;
                        rowSobj.CreatedLink='/'+rowSobj.CreatedBy.Id;
                    }
                    
                }
                
               // DummyLstofLabels.push(rowact);
                component.set("v.columnsHeader",DummyLstofLabels);
                
                component.set("v.lstOfRecords",  rows);  
                
            }else if (state === 'ERROR'){
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                
            }
        });
         
         var GDAccess = component.get("c.getisAccessable");
         GDAccess.setCallback(this, function(response) {
             if (response.getState() === "SUCCESS") {
                 console.log('GD Accessable'+response.getReturnValue());
                 component.set("v.GDAccessable",response.getReturnValue());
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
         
        $A.enqueueAction(GDAccess);
        $A.enqueueAction(action);
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_GD'
        };
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_GD'
        };
        var dupAction = {
            'label': 'Duplicate',
            'iconName': 'utility:clone',
            'name': 'Duplicate_GD'
        };
        actions.push(editAction,deleteAction,dupAction);
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
        var editedRecords =  component.find("GDDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateGD");
        action.setParams({
            'editGDList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Records Updated"
                    });
                    
                    // helper.reloadDataTable();
                    helper.getDataTableRespone(component, event);
                    component.find("GDDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
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
        var data = cmp.get("v.lstOfRecords");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.lstOfRecords", data);
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
    
    FetchFieldsfromFS:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Graphics_Deliverables__c",
            fieldsetname : "Graphics_Deliverables_Fieldset"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue()); //getting all api names in the field set
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
    
    
    deleteJobGD: function(component, event, helper,selectGdId){
        var DeleteGD=component.get("c.DeleteGD");
         if(selectGdId!=null || selectGdId!=undefined){
            DeleteGD.setParams({
                GDId :selectGdId
            });
            
        }     
        else{
            var row = event.getParam('row');
            console.log('===Delete GD Id=='+row.Id);     
            DeleteGD.setParams({
                GDId :row.Id 
            });
        }
       
        
        DeleteGD.setCallback(this, function(DeleteGDres){
            var delresult = DeleteGDres.getReturnValue();
            console.log('===delresult=='+JSON.stringify(delresult));
            if( DeleteGDres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.getDataTableRespone(component, event);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    });
                    ToastMsg.fire();
                }
                else{
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":delresult[0]
                    });
                    ToastMsg.fire();
                    
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DeleteGDres.getError()[0].message);
                var errors = DeleteGDres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
            
        });
        $A.enqueueAction(DeleteGD);  
    },
    
    duplicateJobGD: function(component, event, helper,selectGdId){
        var DupGD=component.get("c.duplicateGD");
        if(selectGdId!=null || selectGdId!=undefined){
            DupGD.setParams({
                GDId :selectGdId
            });
            
        }     
        else{
            var row = event.getParam('row');
            console.log('===GD Id=='+row.Id);     
            DupGD.setParams({
                GDId :row.Id
            }); 
        }
        DupGD.setCallback(this, function(DupGDres){
            var dupstate = DupGDres.getState();
            console.log('===dupstate=='+dupstate);
            if(dupstate === "SUCCESS"){
                if(DupGDres.getReturnValue() == 'OK')
                {
                    helper.getDataTableRespone(component, event);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Record Duplicated Successfully.'
                    });
                    ToastMsg.fire();
                }
                else
                {
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":DupGDres.getReturnValue()
                    });
                    ToastMsg.fire();
                    
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DupGDres.getError()[0].message);
                var errors = DupGDres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(DupGD);  
    }
    
})