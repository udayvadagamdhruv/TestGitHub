({
    fetchJobRec : function(component, event, helper,status) {
        var JobRec = component.get("c.getJobRec");
        console.log('---status-helper-'+status);
        JobRec.setParams({
            status:status
        });
        JobRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>Job Records >>>>>>'+JSON.stringify(rows));
                component.set("v.Jobdata",rows);
            }
        });
        $A.enqueueAction(JobRec);
    },
    
    
    UnfollowSelectedJobRec : function(component, event, selectedRows, helper,selectStatusUnfollow) {
        
        console.log('>>Selected Jobs helper>>>>>>>>>>>>'+JSON.stringify(selectedRows));
        var UnfollowSelJobRec = component.get("c.UnfollowSelectedJobs");
        UnfollowSelJobRec.setParams({
            selRecords : selectedRows
        }); 
        
        UnfollowSelJobRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('>>Selected Jobs helper1>>>>>>>>>>>>'+JSON.stringify(response.getState()));
                if(response.getReturnValue() === 'true'){
                    console.log('>>Selected Jobs helper2>>>>>>>>>>>>'+JSON.stringify(response.getReturnValue()));
                    helper.showToast({
                        "title": "Unfollow Job",
                        "type": "success",
                        "message": "Successfully unfollow the selected job."
                    });
                   
                    helper.fetchJobRec(component, event, helper,selectStatusUnfollow);
                }else{ //if  got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                }
            }
            else if (response.getReturnValue() === "ERROR") {
                var errors = response.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
        });
        $A.enqueueAction(UnfollowSelJobRec);
    },

    fetchChatterFilesRec : function(component, event, helper) {
        var ChatterFilesRec = component.get("c.getChatterFilesRec");
        ChatterFilesRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>Chatter File Records >>>>>>'+JSON.stringify(rows));
                component.set("v.ChatterFilesdata",rows);
            }
        });
        $A.enqueueAction(ChatterFilesRec);
    },
    
    UnfollowSelectedCFRec : function(component, event, selectedCFRows, helper) {
        
        console.log('>>Selected CF helper>>>>>>>>>>>>'+JSON.stringify(selectedCFRows));
        var UnfollowSelCFRec = component.get("c.UnfollowSelectedCF");
        UnfollowSelCFRec.setParams({
            selRecords : selectedCFRows
        }); 
        
        UnfollowSelCFRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('>>Selected Files helper1>>>>>>>>>>>>'+JSON.stringify(response.getState()));
                if(response.getReturnValue() === 'true'){
                    console.log('>>Selected Files helper2>>>>>>>>>>>>'+JSON.stringify(response.getReturnValue()));
                    helper.showToast({
                        "title": "Unfollow Files",
                        "type": "success",
                        "message": "Successfully unfollow the selected Files."
                    });
                    
                    helper.fetchChatterFilesRec(component, event, helper);
                }else{ //if  got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                }
            }
            else if (response.getReturnValue() === "ERROR") {
                var errors = response.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
        });
        $A.enqueueAction(UnfollowSelCFRec);
    },
    
    
    
    JobsortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.Jobdata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.Jobdata", data);
    },
    CFsortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.ChatterFilesdata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.ChatterFilesdata", data);
    },
    
    /* * Show toast with provided params * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    sortBy: function (field, reverse, primer) {
        console.log('==sortBy=primer==='+primer);
        console.log('==sortBy=field==='+field);
        console.log('==sortBy=reverse==='+reverse);
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
})