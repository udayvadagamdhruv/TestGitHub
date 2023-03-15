({
    doInit : function(component, event, helper) {
         helper.getTotalNumberOfRecords(component);
         helper.getFieldLabels(component, event, helper); 
        helper.fetchCConJobs(component, event, helper);
       
              
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    handleLoadMoreRec: function (component, event, helper) {
        console.log('>>>>>>>>> Load More >>>>>>>>>>>>');
        event.getSource().set("v.isLoading", true);
        console.log('>>>>>>>>> Total No.of rowsssss >>>>>>>>>>>>'+component.get('v.totalNumberOfRows'));
        console.log('>>>>>>>>>Data Length>>>>>>>>>>>>'+component.get('v.data').length);
        component.set('v.loadMoreStatus', 'Loading....');
        if (component.get('v.data').length != component.get('v.totalNumberOfRows')) {
            console.log('>>>>>>>>> After If >>>>>>>>>>>>');
            helper.getMoreRec(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
                console.log('>>>>>>>>>After If Data>>>>>>>>>>>>'+JSON.stringify(data));
               console.log('>>>>>>>>>After If Data Length>>>>>>>>>>>>'+data.length);
                if (component.get('v.data').length == component.get('v.totalNumberOfRows')) {
                    component.set('v.enableInfiniteLoading', false);
                    component.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = component.get('v.data');
                    var newData = currentData.concat(data);
                    for (var i = 0; i < newData.length; i++) {
                        var row = newData[i]
                        row.JobLink = '/'+row.Id;
                        row.Name = row.Name;                       
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
    }

    
})