({	
    getFieldLabels: function(component, event, helper) {
       
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Vendor_Contact__c'
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
                    {label: tableHeader.Vendor_Contact__c.Name.label, fieldName: 'VenConLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeader.Vendor_Contact__c.Active__c.label, fieldName: 'Active__c', sortable: true, type: 'boolean'},
                    {label: tableHeader.Vendor_Contact__c.Phone_2__c.label, fieldName: 'Phone_2__c',sortable: true, type: 'phone'},
                    {label: tableHeader.Vendor_Contact__c.Phone_1__c.label, fieldName: 'Phone_1__c', sortable: true, type: 'phone'},
                    {label: tableHeader.Vendor_Contact__c.Email__c.label, fieldName: 'Email__c',sortable: true, type: 'email'}
                    
                ]);  
                
                
            }else {
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
    },
    
    
    fetchVenCon : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Vendor ID>>>>>>>>>>>>'+recId);
		var VenConRec = component.get("c.vendorContacts");
        VenConRec.setParams({
            recordId : recId 
        });
        VenConRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>> Rowsssss >>>>>>>>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.VenConLink = '/'+row.Id; 
                   /* console.log('>>>>>>>First_Name__c>>>>>>>>>>>'+row.First_Name__c);
                    console.log('>>>>>>>Last_Name__c>>>>>>>>>>>'+row.Last_Name__c);
                    row.Name = row.First_Name__c+' '+row.Last_Name__c; 
                    console.log('>>>>>>>Name>>>>>>>>>>>'+row.Name);*/
                    if (row.Vendor__c) row.Vendor = row.Vendor__r.Name;
                }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Contact has '+errors[0].message
                }); 
            }
        });
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Vendor_Contact__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
        });
        
        $A.enqueueAction(action1);

		$A.enqueueAction(VenConRec);
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_VenCon'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_VenCon'
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
        if(fieldName=='VenConLink'){
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
    
    CreateVenConRecord:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Vendor_Contact__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
        });
       
        $A.enqueueAction(action);
    },
    
    
     getRoles: function(component, event, helper){
         var RolesAction = component.get("c.getRole");
         RolesAction.setCallback(this, function(Roleresponse) {
            console.log("=====Roles List====", Roleresponse.getReturnValue());
            var Rol=Roleresponse.getReturnValue();
            var Roles=[];
            if(Roleresponse.getState() === "SUCCESS"){
                console.log("=====Roles List IF enter====");
                for (var key in Rol) {
                    Roles.push({
                        key: key,
                        value: Rol[key]
                    });
                }
                component.set("v.roles", Roles); 
                //console.log("=====Roles List IF enter====");
            } 
             else {
                 console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                 var errors = response1.getError();
                 helper.showToast({
                     "title": "Error!!",
                     "type": "error",
                     "message":'Roles has '+ errors[0].message
                 }); 
             }
        });
        $A.enqueueAction(RolesAction);
    },
    
    deleteVenCon: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete Ven Con Id=='+row.Id);     
        var DeleteVenCon=component.get("c.DeleteVenCon");
        DeleteVenCon.setParams({VenId :row.Id });
        DeleteVenCon.setCallback(this, function(DeleteVenConres){
            var delstate = DeleteVenConres.getState();
            if(delstate === "SUCCESS"){
                if(DeleteVenConres.getReturnValue() == "OK"){
                    helper.fetchVenCon(component, event, helper);
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
                        "message":DeleteVenConres.getReturnValue()
                    });
                    ToastMsg.fire();
                    
                }
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
        $A.enqueueAction(DeleteVenCon);  
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