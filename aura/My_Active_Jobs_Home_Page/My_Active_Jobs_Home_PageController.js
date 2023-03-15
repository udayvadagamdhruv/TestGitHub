({
    doInit: function(component, event, helper) {
        helper.fetchFieldLabels(component, event, helper);
        helper.Jobrecordsfetch(component,event,'Active');
        var pickaction = component.get("c.fetchPicklistvalues");
        pickaction.setCallback(this, function(pickRes) {
            var picstate = pickRes.getState();
            console.log('>>>>>>>>>>>Job status picstate>>>>>>>>>>>>>>>'+picstate);
            console.log('>>>>>>>>>>>Job status Picklist>>>>>>>>>>>>>>>'+pickRes.getReturnValue());
            if (picstate === "SUCCESS") {
                component.set("v.statusPicklist", pickRes.getReturnValue());
            }
        });
        $A.enqueueAction(pickaction);
    },
            
    updateColumnSorting: function (cmp, event, helper) {
            var fieldName = event.getParam('fieldName');
        console.log('----fieldName--'+fieldName);
            var sortDirection = event.getParam('sortDirection');
         console.log('----sortDirection--'+sortDirection);
            // assign the latest attribute with the sorted column fieldName and sorted direction
            cmp.set("v.sortedBy", fieldName);
            cmp.set("v.sortedDirection", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection);
    },
            
    StatusChange: function(component, event, helper) {
            var cmo = component.find("pickJob");
            var selectd = cmo.get("v.value");
            console.log("====selectd==" +selectd );
            helper.Jobrecordsfetch(component,event,selectd);
   },           
            
            
})