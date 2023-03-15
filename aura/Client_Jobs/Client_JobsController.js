({
    doInit : function(component, event, helper) {
        helper.fetchCJ(component,event,'Active');
        helper.getTotalNumberOfRecords(component,event,'Active');
        var pickaction = component.get("c.fetchPicklistvalues");
        pickaction.setCallback(this, function(pickRes) {
            var picstate = pickRes.getState();
            console.log('>>>>>>>>>>>Job status picstate>>>>>>>>>>>>>>>'+picstate);
            console.log('>>>>>>>>>>>Job status Picklist>>>>>>>>>>>>>>>'+pickRes.getReturnValue());
            if (picstate === "SUCCESS") {
                component.set("v.statusPicklist", pickRes.getReturnValue());
            }
            else {
                    console.log('>>>>>> Error >>>>>>>>>>',pickRes.getError()[0].message);
                    var errors = pickRes.getError();
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Client Jobs has '+errors[0].message
                    }); 
                }
        });
        $A.enqueueAction(pickaction);
        
        helper.getFieldLabels(component, event, helper);
    },
    
    
    handleLoadMoreRec: function (component, event, helper) {
      console.log('>>>>>>>>> Load More >>>>>>>>>>>>');
        event.getSource().set("v.isLoading", false);
        var cmo = component.find("pickJob");
        var selectd = cmo.get("v.value");
        console.log("====selectd==" +selectd );
        component.set('v.loadMoreStatus', 'Loading....');
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
                        row.JobLink = '/'+row.Id; 
                        row.JobLinkName = '/'+row.Id; 
                        row.Job = row.Name;
                        
                        row.JobLink = '/'+row.Id; 
                        row.JobNO = row.Job_Auto_Number__c;
                        if(row.JS_Client_Contact__r!=null)
                        {    
                            row.ClientContact = row.JS_Client_Contact__r.Name;
                        }
                        else
                        {
                            row.ClientContact = '';
                        }
                        
                    }
                    console.log('>>>>>>>>>>Handle Load More Rec>>>>>>>>>>>>>'+JSON.stringify(newData));
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
    
    StatusChange: function(component, event, helper) {
        var cmo = component.find("pickJob");
        var selectd = cmo.get("v.value");
        console.log("====selectd==" +selectd );
        component.set('v.enableInfiniteLoading', true);
        helper.fetchCJ(component,event,selectd);
        helper.getTotalNumberOfRecords(component,event,selectd);
       // helper.onLoadMore(component, event, helper);
    }  
    
    
})