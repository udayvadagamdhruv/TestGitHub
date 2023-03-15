({
    myAction : function(component, event, helper) {
        helper.getTotalNumberOfrecords(component);
        component.set('v.columns', [
            {label: '#Job', fieldName: 'Job_Auto_Number__c', type: 'text'},
            {label: 'Job Name', fieldName: 'Name', type: 'text'},
            {label: 'Completion Date', fieldName: 'Completion_Date__c', type: 'Date'},
            {label: 'Schedule Type', fieldName: 'Schedule_Calc__c', type: 'text'}
        ]);
        var action=component.get("c.getJobs");
        action.setParams({
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS')
            {
                var df=response.getReturnValue();
                component.set("v.Jobs",df);
                component.set("v.currentCount", component.get("v.initialRows"));
            }
        });$A.enqueueAction(action);
        
    },
    viewRecord : function(component,event,helper) {
        var selectedRows = event.getParam('selectedRows');
        console.log('the selected rows are'+JSON.stringify(selectedRows));
        // alert('The selected records '+JSON.stringify(selectedRows));
        //  alert('The selected records ids'+event.getParam('id'));
        component.set("v.selectedjobrecords",selectedRows);
    },
    handleLoadMoreRecords: function(component,event,helper){
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');    
        helper.getMoreRecords(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
            if (component.get('v.Jobs').length == component.get('v.totalNumberOfRows')) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
            } else {
                var currentData = component.get('v.Jobs');
                var newData = currentData.concat(data);
                component.set('v.Jobs', newData);
                component.set('v.loadMoreStatus', 'Please scroll down to load more data');
            }
            event.getSource().set("v.isLoading", false);
        }));
    },
    
    select : function(component,event,helper){
        var action=component.get("c.createclientinvoices");
        var records = component.get("v.selectedjobrecords");
        //alert('The records '+records);
        action.setParams({
            selectedjobs:component.get("v.selectedjobrecords")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                var c=response.getReturnValue(); 
            }
        }); $A.enqueueAction(action);
    }
})