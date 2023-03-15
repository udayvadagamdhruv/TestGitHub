({
    
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Tag__c'
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
            sObjName :  "Tag__c"
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
    
    getTagTemp: function(component, event, helper){
        var action1 = component.get("c.getTagTemplates");
        action1.setCallback(this, function(response1) {
            console.log("=====Tag Temp====", response1.getReturnValue());
            var Tag=response1.getReturnValue();
            var TagTemp=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in Tag) {
                    TagTemp.push({
                        key: key,
                        value: Tag[key]
                    });
                }
                component.set("v.TagTempRecords", TagTemp); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        var TagAccess = component.get("c.getisAccessable");
        TagAccess.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('Tag Accessable'+response.getReturnValue());
                component.set("v.TagAccessable",response.getReturnValue());
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
        $A.enqueueAction(TagAccess);
        $A.enqueueAction(action1);
    },
    
    getDataTableRespone : function(component, event) {
        var recId = component.get("v.recordId");
        var rowActions11=[{'label': 'Edit',   'iconName': 'utility:edit',  'name': 'Edit_Tag'},
                          {'label': 'Delete', 'iconName': 'utility:delete', 'name': 'Delete_Tag'},
                          {'label': 'Duplicate','iconName': 'action:clone', 'name': 'Duplicate_Tag'}];
        var action = component.get("c.getDataTableDetails");
        action.setParams({
            objApi : 'Tag__c',
            fieldSetName : 'TagsFieldsets',
            JobId : recId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var rowact = {type: 'action', typeAttributes: {rowActions: rowActions11}};
                // console.log('::::::::::::: Reuslttttttttttt :::::::::::::'+JSON.stringify(lstoflabels.push(rowact)));
                console.log('success===== '+response.getReturnValue().lstOfFieldLabels+'lenght==== '+response.getReturnValue().lstOfFieldLabels.length);
                console.log('::::::::::::: SUCCESS :::::::::::::'+JSON.stringify(response.getReturnValue().lstOfFieldLabels));
                console.log('success   2===== '+response.getReturnValue().lstOfSObjs+'length===== '+response.getReturnValue().lstOfSObjs.length);
                console.log('::::::::::::: SUCCESS Records:::::::::::::'+JSON.stringify(response.getReturnValue().lstOfSObjs));
                var mapWithTagData=[];
                var lstoflabels=response.getReturnValue().lstOfFieldLabels;
                var lstofvalues=response.getReturnValue().lstOfSObjs;
                for(var i=0;i<lstofvalues.length;i++){
                    var mapWithData=[];
                    for(var k=0;k<lstoflabels.length;k++){
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
                             console.log('mapWithData  is =========== '+JSON.stringify(mapWithData));
                        }
                    }
                      console.log('mapWithData   1=========== '+mapWithData+'\n');
                      console.log('mapWithData   2=========== '+JSON.stringify(mapWithData)+'\n');
                    mapWithTagData.push({
                        key:'key',
                        value:mapWithData
                    } );
                }
                console.log('mapWithTagData  1=========== '+mapWithTagData+'\n');
             console.log('mapWithTagData  2=========== '+JSON.stringify(mapWithTagData)+'\n');
                component.set('v.mapWithTagData',mapWithTagData);
                var DummyLstofLabels=[];
                DummyLstofLabels.push(rowact);
                for (var i = 0; i < lstoflabels.length; i++) {
                    var row = lstoflabels[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                    row={label:row.label, fieldName: row.fieldName, type: row.type, editable:"true", sortable:"true",initialWidth:200};
                    /* if(row.fieldName=='Tag_Due_Date__c'){
                        row={label:row.label, fieldName: row.fieldName, type: 'date-local', editable:"true", sortable:"true"};
                    }  */  
                    if(row.fieldName=='Name'){
                        row={label:row.label, fieldName: 'nameLink', type: 'url', sortable:"true",initialWidth:200, typeAttributes: { label: { fieldName:'Name'}, target: '_self' ,tooltip:{ fieldName: 'Name' }}};
                    }
                    if(row.fieldName=='Job__c'){
                        row={label:row.label, fieldName: 'JobLink', type: 'url', sortable:"true", initialWidth:200,typeAttributes: { label: { fieldName:'Job__c'}, target: '_self' ,tooltip:{ fieldName: 'Job__c' }}};
                    }
                    if(row.fieldName=='CreatedById'){
                        row={label:row.label, fieldName: 'CreatedLink', type: 'url', sortable:"true",initialWidth:200, typeAttributes: { label: { fieldName:'CreatedById'}, target: '_self',tooltip:{ fieldName: 'CreatedById' }}};
                    }
                    DummyLstofLabels.push(row);
                }
                console.log('>>>>List of Labels>>>>>>>>'+JSON.stringify(DummyLstofLabels));
                component.set("v.MobileTagLabels",  DummyLstofLabels); 
                var rows=response.getReturnValue().lstOfSObjs;
                for (var i = 0; i < rows.length; i++) {
                    var rowSobj = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                    if(rowSobj.Name){
                        rowSobj.Name=rowSobj.Name;
                        rowSobj.nameLink='/'+rowSobj.Id;
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
                component.set("v.columnsHeader",DummyLstofLabels);
                console.log('::::::::::::: columnsHeader Labels :::::::::::::'+JSON.stringify(DummyLstofLabels));
                console.log('::::::::::::: lstOfRecords :::::::::::::'+JSON.stringify(rows));
                component.set("v.lstOfRecords",  rows); 
            }else if (state === 'ERROR'){
                console.log('::::::::::::: ERROR :::::::::::::');
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("TagDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateTag");
        action.setParams({
            'editTagList' : editedRecords
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
                    component.find("TagDataTable").set("v.draftValues", null);
                    
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
            sObjName : "Tag__c",
            fieldsetname : "TagsFieldsets"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    deleteJobTag: function(component, event, helper,selectTagId){
        var DeleteTag=component.get("c.DeleteTag");
        if(selectTagId!=null || selectTagId!=undefined){
            DeleteTag.setParams({
                TagId :selectTagId
            });
            
        }     
        else{
            var row = event.getParam('row');
            console.log('===Delete Tag Id=='+row.Id);
            DeleteTag.setParams({
                TagId :row.Id 
            });
        }
        DeleteTag.setCallback(this, function(DeleteTagres){
            var delresult = DeleteTagres.getReturnValue();
            console.log('===delresult=='+JSON.stringify(delresult));
            if(DeleteTagres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.getDataTableRespone(component, event);
                    var ToastMsg1 = $A.get("e.force:showToast");
                    ToastMsg1.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    });
                    ToastMsg1.fire();
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
            else
            {
                console.log('>>>>>> Error >>>>>>>>>>',DeleteTagres.getError()[0].message);
                var errors = DeleteTagres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
                
            }
            
        });
        $A.enqueueAction(DeleteTag);  
    },
    
    duplicateJobTag: function(component, event, helper,selectTagId){
        var DupTag=component.get("c.duplicateTag");
        if(selectTagId!=null || selectTagId!=undefined){
            DupTag.setParams({
                TagId :selectTagId
            }); 
        }
        else{
            var row = event.getParam('row');
            console.log('===Tag Id=='+row.Id);  
            DupTag.setParams({
                TagId :row.Id
            });
        }
        
        DupTag.setCallback(this, function(DupTagres){
            var dupstate = DupTagres.getState();
            console.log('===dupstate=='+dupstate);
            console.log('===nnn dupstate=='+JSON.stringify(DupTagres.getReturnValue()));
            if(dupstate === "SUCCESS"){
                
                if(DupTagres.getReturnValue()==='OK')
                {
                    console.log('===dupstate=='+JSON.stringify(DupTagres.getReturnValue()));
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
                        "message":response.getReturnValue()
                    });
                    ToastMsg.fire();
                }
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(DupTag);  
    }
})