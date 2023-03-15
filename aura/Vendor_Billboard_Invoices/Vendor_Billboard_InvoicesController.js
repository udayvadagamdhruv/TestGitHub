({
    doInit : function(component, event, helper) {
        helper.fetchVBBI(component);
        helper.getTotalNumberOfRecords(component);
        helper.getFieldLabels(component, event, helper);
    },
    
    
    handleLoadMoreRec: function (component, event, helper) {
        console.log('>>>>>>>>> Load More >>>>>>>>>>>>');
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');
        if (component.get('v.data').length != component.get('v.totalNumberOfRows')) {
            helper.getMoreRec(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
                if (component.get('v.data').length == component.get('v.totalNumberOfRows')) {
                    component.set('v.enableInfiniteLoading', false);
                    component.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = component.get('v.data');
                    var newData = currentData.concat(data);
                    for (var i = 0; i < newData.length; i++) {
                        var row = newData[i];
                        row.BBILink = '/'+row.Name; 
                        row.BBIName = row.Name;
                        
                        row.BBLink = '/'+row.Billboard__c; 
                        row.BBName = row.Billboard__r.Name;
                    }
                    component.set('v.data', newData);
                    component.set('v.loadMoreStatus', 'Please scroll down to load more data');
                }
                event.getSource().set("v.isLoading", false);
            }));
        }
        else{
            component.set('v.enableInfiniteLoading', false);
            component.set('v.loadMoreStatus', 'No more data to load');
         //   event.getSource().set("v.isLoading", false);
        }
    },
    
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    
})