({
	 getFieldLabels: function(component, event, helper) {
       
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Client_Contact__c'
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
                    {label: tableHeader.Client_Contact__c.Name.label, fieldName: 'CConLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeader.Client_Contact__c.Active__c.label, fieldName: 'Active__c', sortable: true, type: 'boolean'},
                    {label: tableHeader.Client_Contact__c.UserName__c.label, fieldName: 'UserName__c',sortable: true, type: 'text'},
                    {label: tableHeader.Client_Contact__c.Email__c.label, fieldName: 'Email__c',sortable: true, type: 'email'},
                    {label: tableHeader.Client_Contact__c.Department__c.label, fieldName: 'Department__c', sortable: true, type: 'text'},
                    {label: tableHeader.Client_Contact__c.Mobile_Phone__c.label, fieldName: 'Mobile_Phone__c',sortable: true, type: 'phone'},
                    {label: tableHeader.Client_Contact__c.Salesforce_User__c.label, fieldName: 'Salesforce_User__c',sortable: true, type: 'boolean'}
                    
                ]);  
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Contact has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    fetchCCon : function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Client ID>>>>>>>>>>>>'+recId);
		var CConRec = component.get("c.ClientContacts");
        CConRec.setParams({
            recordId : recId 
        });
        CConRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>> Rowsssss >>>>>>>>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.CConLink = '/'+row.Id; 
                   /* console.log('>>>>>>>First_Name__c>>>>>>>>>>>'+row.First_Name__c);
                    console.log('>>>>>>>Last_Name__c>>>>>>>>>>>'+row.Last_Name__c);
                    row.Name = row.First_Name__c+' '+row.Last_Name__c; 
                    console.log('>>>>>>>Name>>>>>>>>>>>'+row.Name);*/
                    if (row.Client__c) row.Client = row.Client__r.Name;
                }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Contact has '+errors[0].message
                }); 
            }
        });
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Client_Contact__c"
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
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Contact has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);

		$A.enqueueAction(CConRec);
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_CCon'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_CCon'
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
        if(fieldName=='CConLink'){
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
    
    CreateCConRecord:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Client_Contact__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Contact has '+errors[0].message
                }); 
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
                for (var key in Rol) {
                    Roles.push({
                        key: key,
                        value: Rol[key]
                    });
                }
                component.set("v.roles", Roles); 
            }
             else {
                 console.log('>>>>>> Error >>>>>>>>>>',Roleresponse.getError()[0].message);
                 var errors = Roleresponse.getError();
                 this.showToast({
                     "title": "Error!!",
                     "type": "error",
                     "message": 'Client Contact has '+errors[0].message
                 }); 
             }
        });
        $A.enqueueAction(RolesAction);
    },
    
    deleteCCon: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete Client Con Id=='+row.Id);     
        var DeleteCCon=component.get("c.DeleteCCon");
        DeleteCCon.setParams({CConId :row.Id });
        DeleteCCon.setCallback(this, function(DeleteCConres){
            var delstate = DeleteCConres.getState();
            if(delstate === "SUCCESS"){
                if(DeleteCConres.getReturnValue() == "OK"){
                    helper.fetchCCon(component, event, helper);
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
                        "message":DeleteCConres.getReturnValue()
                    });
                    ToastMsg.fire();
                    
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DeleteCConres.getError()[0].message);
                var errors = DeleteCConres.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(DeleteCCon);  
    },
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
   
    
})