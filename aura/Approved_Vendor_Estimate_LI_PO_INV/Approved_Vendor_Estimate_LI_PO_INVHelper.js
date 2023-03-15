({
    fetchCustomSettingData : function(component, event, helper) {   
        var CSettingAction = component.get("c.showProductionEstimate");
        CSettingAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('========ShowPE========='+response.getReturnValue());
                component.set("v.ShowProductionEstimate",response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(CSettingAction); 
    },       
    
    fetchApprovedEstLI : function(component, event, helper) {
        
        var recId = component.get("v.JobId");
        var vendorId = component.get("v.VendorId");
        console.log('========recId=========='+recId);
        console.log('========VendorId=========='+vendorId);
        var ApprovedEstLI = component.get("c.getApprovedEstLI");
        ApprovedEstLI.setParams({
            VendorName : vendorId,
            recordId : recId 
        });
        ApprovedEstLI.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('========vendor record values======'+JSON.stringify(response.getReturnValue()));
                //   component.set("v.data",response.getReturnValue()); 
                var showPE=component.get("v.ShowProductionEstimate");
                console.log('========showPE=========='+showPE);
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.GL_Code__c) row.GLCName=row.GL_Code__r.Name;
                    if(showPE){
                        if(row.Total_Cost__c)row.TotalCost=row.Total_Cost__c;
                    }else{
                        if(row.Total_Amount__c)row.TotalCost=row.Total_Amount__c;
                    }
                    
                }
                
                console.log("========finalized rows========"+JSON.stringify(rows));
                component.set("v.data",rows);
                if(rows.length==0)
                    component.set("v.datalenght",true);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(ApprovedEstLI);
    },
     /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
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