({
	
     getFieldLabels: function(component, event, helper) {
       
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Vendor_GL_Code__c'
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
                    {label: tableHeader.Vendor_GL_Code__c.Name.label, fieldName: 'Name', sortable: true, type: 'text' },
                    {label: tableHeader.Vendor_GL_Code__c.GL_Code__c.label, fieldName: 'VenGlCLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'GLC' }, target: '_self', tooltip :{ fieldName: 'GLC' }} }
                    
                ]); 
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor GL_Code has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
    fetchVenGlCode : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Vendor ID>>>>>>>>>>>>'+recId);
		var VenGlCRec = component.get("c.vendorGlcode");
        VenGlCRec.setParams({
            recordId : recId 
        });
        VenGlCRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>> Rowsssss >>>>>>>>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.VenGlCLink = '/'+row.GL_Code__c; 
                    if (row.GL_Code__c) row.GLC = row.GL_Code__r.Name;
                }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor GL_Code has '+errors[0].message
                }); 
            }
        });
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Vendor_GL_Code__c"
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
                    "message": 'Vendor GL_Code has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);

		$A.enqueueAction(VenGlCRec);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_VenGLc'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_VenGLc'
        };
        
        actions.push(editAction,deleteAction);
        
         // simulate a trip to the server
         setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
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
        if(fieldName=='VenGlCLink'){
            data.sort(this.sortBy('GLC', reverse))
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
    
    
    getGLC: function(component, event, helper){
        var GLCAction = component.get("c.getGLCodes");
        GLCAction.setCallback(this, function(GLCresponse) {
            console.log("=====GLCode List====", GLCresponse.getReturnValue());
            var GL=GLCresponse.getReturnValue();
            var GLCode=[];
            if(GLCresponse.getState() === "SUCCESS"){
                for (var key in GL) {
                    GLCode.push({
                        key: key,
                        value: GL[key]
                    });
                }
                component.set("v.Glcode", GLCode); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor GL_Code has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(GLCAction);
    },
    
    deleteVenGlcode: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete Ven Con Id=='+row.Id);     
        var DeleteVenGl=component.get("c.DeleteVenGlcode");
        DeleteVenGl.setParams({VenGlcId :row.Id });
        DeleteVenGl.setCallback(this, function(DeleteVenGlres){
            var delstate = DeleteVenGlres.getState();
            if(delstate === "SUCCESS"){
                if(DeleteVenGlres.getReturnValue() == "OK"){
                    helper.fetchVenGlCode(component, event, helper);
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
                        "message":DeleteVenGlres.getReturnValue()
                    });
                    ToastMsg.fire();
                    
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DeleteVenGlres.getError()[0].message);
                var errors = DeleteVenGlres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor GL_Code has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(DeleteVenGl);  
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
    }
   
    
})