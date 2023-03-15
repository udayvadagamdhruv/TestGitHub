({
    getFieldLabels: function(component, event, helper) {
        
           var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Production_Estimate_Temp_Line_Items__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue())));
                
                var tableHeader=component.get('v.ObjectType');
                console.log('>>>Field Name Dynamically >>>>>>>>>>>>>'+tableHeader);
                component.set('v.columns', [
                    
                    {label: tableHeader.Production_Estimate_Temp_Line_Items__c.Name.label, fieldName: 'ProEstLink',  type: 'url', sortable: true,  typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeader.Production_Estimate_Temp_Line_Items__c.Calc_Unit__c.label, fieldName: 'Calc_Unit__c', sortable: true, type: 'text'},
                    {label: tableHeader.Production_Estimate_Temp_Line_Items__c.Material_Item__c.label, fieldName: 'MI',sortable: true, type: 'text'},
                    {label: tableHeader.Production_Estimate_Temp_Line_Items__c.Sort_Order__c.label, fieldName: 'Sort_Order__c', sortable: true,  type: 'number',editable:'true',cellAttributes:{ alignment: 'left'}},
                    {type: 'action', typeAttributes: {rowActions: rowActions}}
                ]);  
                
                
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
     getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_ProEstimate',
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_ProEstimate',
        };
      
        actions.push(editAction,deleteAction);
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    }, 
    
    fetchProEstimatesLI : function(component, event, helper) {
        console.log('====Pro Estaimate Temp Records===='+component.get("v.recordId"));             
        var PEAction=component.get("c.getPELIRecords");
        PEAction.setParams({
            recordId:component.get("v.recordId")
        });
        PEAction.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                console.log('====PE LI Records===='+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if(row.Name)row.ProEstLink='/'+row.Id;
                    if(row.Material_Item__c)row.MI=row.Material_Item__r.Name;
                }
                console.log('====PE LI Records===='+JSON.stringify(rows));
                component.set("v.data",rows);
            }
              else if (res.getState()=== "ERROR") {
                var errors = res.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
        });
        
        $A.enqueueAction(PEAction);
    },
    
    fetchFieldsetforProEstimate:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Production_Estimate_Temp_Line_Items__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field sets for the ProEstimate===="+ response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
        });
        
        var LabelAction = component.get("c.geLabelforObject");
        LabelAction.setParams({
            sObjName : "Production_Estimate_Temp_Line_Items__c"
        });
        LabelAction.setCallback(this, function(response) {
            console.log("=====Label for the ProEstimate===="+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.ProEstObjLabel", response.getReturnValue()); 
            }
        });
        
        $A.enqueueAction(action); 
        $A.enqueueAction(LabelAction);
        
    },
    
    
     /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("PELIDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updatePELI");
        action.setParams({
            'editPELIList' : editedRecords
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
                    helper.fetchProEstimatesLI(component, event, helper);
                    component.find("PELIDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                   
                }      
            }
            else {
                var errors = response.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
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
        if(fieldName=='ProEstLink'){
         data.sort(this.sortBy('Name', reverse))   
        }else{
        data.sort(this.sortBy(fieldName, reverse))
        }
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
    
    
    getMaterialItems :function(component, event, helper,CalUnit){
        //var CalUnit=component.find("CalUnitFieldId").get("v.value");
        //
        console.log("========CalUnit===="+CalUnit);
            var miaction = component.get("c.getMatereialItems");
            miaction.setParams({
                CalUnit :CalUnit 
            });
            miaction.setCallback(this, function(res) {
                console.log("=====Materail Items records===="+ res.getReturnValue());
                if(res.getState() === "SUCCESS"){
                    component.set("v.MItem_Records", res.getReturnValue()); 
                } 
            });
            $A.enqueueAction(miaction);  
    },
    
    getGLDepartment: function(component, event, helper){
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(res) {
            console.log("=====GLD List===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                component.set("v.GL_DepartmentRecords", res.getReturnValue()); 
            } 
        });
        $A.enqueueAction(action1);
    },
    
     getGLCode: function(component, event, helper){
        var GLDId=component.find("GLDSelectId").get('v.value');
        console.log('===GLDId==='+GLDId);
        var actionCC = component.get("c.getGLCodes");
        actionCC.setParams({
            GLDName :GLDId 
        });
        actionCC.setCallback(this, function(res){
            console.log("===List of GLC===" + JSON.stringify(res.getReturnValue()));
            if(res.getState() === "SUCCESS"){
                component.set("v.GL_CodeRecords",res.getReturnValue()); 
            } 
        }); 
        $A.enqueueAction(actionCC);  
    },
    
    getVendor:  function(component, event, helper){
        var GLCId=component.find("GLCodeSelectId").get('v.value');
        console.log('===Department==='+JSON.stringify(component.find("GLDSelectId").get('v.value')));
        console.log('===GLCId==='+JSON.stringify(GLCId));
        var actionVen = component.get("c.getVendors");
        actionVen.setParams({
            GLCName :GLCId 
        });
        actionVen.setCallback(this, function(res){
            console.log("===List of Vendors===" + JSON.stringify(res.getReturnValue()));
            if(res.getState() === "SUCCESS"){
                component.set("v.VendorRecords", res.getReturnValue()); 
            } 
        }); 
        $A.enqueueAction(actionVen);  
    }, 
    
    
    deleteProEstLI :function(component, event, helper){
        var row=event.getParam("row");
        var delAction=component.get("c.deleteProEst");
        delAction.setParams({
            ProEstID:row.Id
        });
        delAction.setCallback(this,function(res){
            var delreslut=res.getReturnValue();
            console.log("========Delete Result=========="+JSON.stringify(delreslut));
            if(res.getState()==="SUCCESS"){
                if(delreslut[0]=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record Deleted Successfully."
                    });
                    helper.fetchProEstimatesLI(component, event, helper);
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":delreslut[1]
                    });  
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type":"error",
                    "message":delreslut[1]
                });    
            }
        });
          $A.enqueueAction(delAction);
    }
    
})