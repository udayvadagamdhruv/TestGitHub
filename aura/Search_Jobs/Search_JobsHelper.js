({
    fetchJobRecords : function(component, event, helper,offSetCount) {
       console.log('=======offSetCount======'+offSetCount);
        var JobsAction= component.get("c.getJobs");
        JobsAction.setParams({
           intOffSet: offSetCount
        });
        JobsAction.setCallback(this, function(response){ 
            console.log('=======dddd'+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('====rows===='+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.JobLink = '/'+row.Id;
                    if(row.JS_Client__r!=null ){
                        row.ClientLink='/'+row.JS_Client__r.Id;
                        row.ClientName=row.JS_Client__r.Name;  
                    }
                    if(row.Campaign__r!=null){
                        row.CampLink='/'+row.Campaign__r.Id;
                        row.CampName=row.Campaign__r.Name;  
                    }
                }
                var currentData=component.get('v.data'); 
                
                console.log('===currentData==='+currentData);
                component.set("v.data", currentData.concat(rows));
                //console.log('===currentData concat==='+currentData.concat(rows));
            } 
             event.getSource().set("v.isLoading", false);
            
        }); 
        
        
        var saction=component.get("c.getStatusList");
        saction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.statusList",response.getReturnValue());
            } 
        });
        
        $A.enqueueAction(saction);
        $A.enqueueAction(JobsAction);
    },
    
    getTotalJobRecords :function(component, event, helper){
    
      var totalRec=component.get("c.getTotalNoOfJobs");
        totalRec.setCallback(this, function (res) {
            if (res.getState() === "SUCCESS") {
                component.set("v.totalRows",res.getReturnValue());
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
    }
})