({
    myAction : function(component, event, helper) {
        var action=component.get("c.getJobs");
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS')
            {
                component.set("v.Jobs",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        component.set('v.columns', [
            {label: '#Job', fieldName: 'Job_Auto_Number__c', type: 'text'},
            {label: 'Job Name', fieldName: 'Name', type: 'text'},
            {label: 'Completion Date', fieldName: 'Completion_Date__c', type: 'Date'},
            {label: 'Schedule Type', fieldName: 'Schedule_Calc__c', type: 'text'}
        ]);
    },
    viewRecord : function(component,event,helper) {
        var selectedRows = event.getParam('selectedRows');
        console.log('the selected rows are'+JSON.stringify(selectedRows));
        // alert('The selected records '+JSON.stringify(selectedRows));
        //  alert('The selected records ids'+event.getParam('id'));
        component.set("v.selectedjobrecords",selectedRows);
    },
    select : function(component,event,helper){
        var action=component.get("c.createclientinvoices");
        var records = component.get("v.selectedjobrecords");
        //alert('The records '+records);
        action.setParams({
            selectedjobs:records
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                var c=response.getReturnValue(); 
            }
        }); $A.enqueueAction(action);
    }
})