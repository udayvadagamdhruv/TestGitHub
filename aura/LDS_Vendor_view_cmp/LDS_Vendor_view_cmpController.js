({
	doInit : function(component, event, helper) {  
        var actions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Delete', name: 'delete' }
        ]
        component.set('v.columns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Active', fieldName: 'Active__c', type: 'boolean' },
            { label: 'Mobile Phone', fieldName: 'Phone_1__c', type: 'text' },
            { label: 'Office Phone', fieldName: 'Phone_2__c', type: 'text' },
            { label: 'Email', fieldName: 'Email__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
        
 		var recId = component.get("v.recordId");
        var action = component.get("c.vendorviewcm1");
   	    action.setParams({
            recordId : recId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("list of vendor contacts records" + response.getReturnValue());
             
            if(state === "SUCCESS"){
                component.set('v.data', response.getReturnValue());
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
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'show_details':
                alert('Showing Details: ');
                break;
            case 'delete':
               // helper.removeBook(cmp, row)
                break;
        }
    }
})