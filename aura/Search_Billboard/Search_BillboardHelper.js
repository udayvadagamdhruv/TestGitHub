({
    fetchBBRecords : function(component, event, helper,offSetCount) {
        console.log('=======offSetCount======'+offSetCount);
        var BBAction= component.get("c.getBB");
        BBAction.setParams({
           intOffSet: offSetCount
        });
        BBAction.setCallback(this, function(response){ 
            console.log('=======dddd'+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('====rows===='+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.BBLink = '/'+row.Id;
                    if(row.Client_Name__c!=null ){
                        row.ClientLink='/'+row.Client_Name__r.Id;
                        row.ClientName=row.Client_Name__r.Name;  
                    }
                    if(row.BB_Vendor__c!=null){
                        row.VenLink='/'+row.BB_Vendor__r.Id;
                        row.VenName=row.BB_Vendor__r.Name;  
                    }
                }
                var currentData=component.get('v.data'); 
                
                console.log('===currentData==='+currentData);
                component.set("v.data", currentData.concat(rows));
                //console.log('===currentData concat==='+currentData.concat(rows));
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Billboard Search: '+errors[0].message
                }); 
            }
            event.getSource().set("v.isLoading", false);
        }); 
        $A.enqueueAction(BBAction);
    },
    
    getTotalBBRecords :function(component, event, helper){
      var totalRec=component.get("c.getTotalNoOfBB");
        totalRec.setCallback(this, function (res) {
            if (res.getState() === "SUCCESS") {
                component.set("v.totalRows",res.getReturnValue());
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Billboard Search: '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(totalRec);
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    }
})