({
    doInit : function(component, event, helper) {
        var statusDefault=component.get('v.selectValue');     
        helper.fetchJobRec(component, event, helper,statusDefault);
        helper.fetchChatterFilesRec(component, event, helper);
        
        component.set('v.Jobcolumns', [
            {label: 'Job#', fieldName: 'Job_Auto_Number__c',sortable: true, type: 'text'},
            {label: 'Job Name', fieldName: 'Name', sortable: true, type: 'text'}
        ]);  
        
        component.set('v.ChatterFilescolumns', [
            {label: 'Title', fieldName: 'Title',sortable: true, type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate', sortable: true, type: 'date-local' ,cellAttributes: { class: { fieldName: 'CreatedDate' }, iconName: 'utility:event', iconAlternativeText:'Created Date'}}
        ]);  
    },
    
    handleSelect : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        console.log('>>Sleeee>>>>>>>>>>>>'+JSON.stringify(selectedRows));
        component.set('v.selectedRowsCount', selectedRows.length);
        
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        component.set("v.selectedJobs", setRows);
        console.log('>>Selected Jobs >>>>>>>>>>>>'+JSON.stringify(setRows));
        // helper.UnfollowSelectedJobRec(component, event, selectedRows);
    },
    
    UnfollowJobs : function(component, event, helper) {
        var selectedRows = component.get("v.selectedJobs");
        var selectStatusUnfollow=component.find('StatusField').get('v.value');
        console.log('selectStatusUnfollow----'+selectStatusUnfollow);
        console.log('>>unfollow Recccc>>>>>>>>>>>>'+selectedRows.length);
        console.log('>>unfollow Recccc>>>>>>>>>>>>'+JSON.stringify(selectedRows));
        if(selectedRows.length>0){
            helper.UnfollowSelectedJobRec(component, event, selectedRows, helper,selectStatusUnfollow);
            
        }
        else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Please select atleast one job'
            });
        }
    },
    
    handleSelectCF : function(component, event, helper) {
        var selectedCFRows = event.getParam('selectedRows'); 
        console.log('>>Select CF >>>>>>>>>>>>'+JSON.stringify(selectedCFRows));
        component.set('v.selectedCFRowsCount', selectedCFRows.length);
        
        var setRows = [];
        for(var i = 0; i < selectedCFRows.length; i++) {
            setRows.push(selectedCFRows[i]);
        }
        component.set("v.selectedCF", setRows);
        console.log('>>Selected CF >>>>>>>>>>>>'+JSON.stringify(setRows));
    },
    
    UnfollowCF : function(component, event, helper) {
        var selectedCFRows = component.get("v.selectedCF");
        console.log('>>unfollow CF Recccc>>>>>>>>>>>>'+JSON.stringify(selectedCFRows));
        helper.UnfollowSelectedCFRec(component, event, selectedCFRows, helper);
    },
    
    
    JobupdateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.JobsortedBy", fieldName);
        cmp.set("v.JobsortedDirection", sortDirection);
        helper.JobsortData(cmp, fieldName, sortDirection);
    },
    
    CFupdateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.ChatterFilessortedBy", fieldName);
        cmp.set("v.ChatterFilessortedDirection", sortDirection);
        helper.CFsortData(cmp, fieldName, sortDirection);
    },
    
    StatusChange : function (cmp, event, helper) {
        var selectStatus=cmp.find('StatusField').get('v.value');
        cmp.set('v.selectValue',selectStatus);
        console.log('selectStatus----'+selectStatus);
        if(selectStatus=='Cancelled'){
              helper.fetchJobRec(cmp, event, helper,'Cancelled');
        }
        else if(selectStatus=='On Hold'){
             helper.fetchJobRec(cmp, event, helper,'On Hold');
        }
            else{
                 helper.fetchJobRec(cmp, event, helper,'Completed');
            }
    }
    
})