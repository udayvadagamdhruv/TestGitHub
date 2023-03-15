({
    doInit : function(component, event, helper) {
       
        helper.fetchVBB(component,event,'Active;Active-Batch');
        helper.getTotalNumberOfRecords(component,event,'Active;Active-Batch');
		helper.getFieldLabels(component, event, helper);
       
        var inputSelects = component.find("inputSelects");        
        for(var i = 0; i < inputSelects.length; i++){
            inputSelects[i].set("v.value",true);
        }
        
        var pickaction = component.get("c.fetchPicklistvalues");
        pickaction.setCallback(this, function(pickRes) {
            var picstate = pickRes.getState();
            if (picstate === "SUCCESS") {
                component.set("v.statusPicklist", pickRes.getReturnValue());
            }
        });
        $A.enqueueAction(pickaction);      
       
    },
    
    StatusChange: function(component, event, helper) {
        var cmo = component.find("pickBB");
        var selectd = cmo.get("v.value");
        console.log("====selectd==" +selectd );
        helper.fetchVBB(component,event,selectd);
        helper.getTotalNumberOfRecords(component,event,selectd);
    },  
   
    
     handleLoadMoreRec: function (component, event, helper) {
        console.log('>>>>>>>>>Handle Load More >>>>>>>>>>>>');
        event.getSource().set("v.isLoading", true);
        var cmo = component.find("pickBB");
        var selectd = cmo.get("v.value");
        console.log("====selectd==" +selectd );
        component.set('v.loadMoreStatus', 'Loading....');
         console.log('>>>>>>>>>>> Total Number of Rows >>>>>>>'+component.get('v.totalNumberOfRows'));
        if (component.get('v.data').length != component.get('v.totalNumberOfRows')) {
            helper.getMoreRec(component, component.get('v.rowsToLoad'),selectd).then($A.getCallback(function (data) {
                if (component.get('v.data').length == component.get('v.totalNumberOfRows')) {
                    component.set('v.enableInfiniteLoading', false);
                    component.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = component.get('v.data');
                    var newData = currentData.concat(data);
                    for (var i = 0; i < newData.length; i++) {
                        var row = newData[i];
                         row.BBLink = '/'+row.Id; 
                        row.Name = row.Name;
                        
                        row.ClientLink = '/'+row.Client_Name__c; 
                        row.Client = row.Client_Name__r.Name;
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
    }
    
})