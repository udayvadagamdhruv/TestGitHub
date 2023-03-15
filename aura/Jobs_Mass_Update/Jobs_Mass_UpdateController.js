({
	doInIt : function(component, event, helper) {
        
        component.set('v.columns', [
            {label: 'Job#', fieldName: 'Job_Auto_Number__c', type: 'text',sortable: true,initialWidth:150},
            {label: 'JobName', fieldName: 'Name', type: 'text',sortable: true}
        ]);
        helper.getFiltersandCustomSetting(component, event, helper);
        helper.getTotalActiveJobRecords(component, event, helper);
        helper.FetchMassUpdateJobRecords(component, event, helper,0);  
        helper.ShowProductionEstimate(component, event);
	},
    
    loadMoreData : function(component, event, helper) {
       console.log('loadmore---');
        console.log('active rows length---'+component.get("v.totalAcitveJobRows"));
        console.log('data length---'+component.get('v.data').length);
        if(component.get("v.totalAcitveJobRows") !=component.get('v.data').length){
            event.getSource().set("v.isLoading", true);  
              component.set('v.loadMoreStatus', 'Loading...');
            console.log('====Data lenght==='+component.get('v.data').length);
            helper.FetchMassUpdateJobRecords(component, event, helper, component.get('v.data').length);
           // event.getSource().set("v.isLoading", false);
        }
        else{
            event.getSource().set("v.isLoading", false);
            component.set('v.enableInfiniteLoading', false);
            component.set('v.loadMoreStatus', 'No more data to load');
        }
    },
    
    
     // Client-side controller called by the onsort event handler
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
     updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        
        cmp.set('v.selectedRowsCount', selectedRows.length);
        cmp.set('v.Selected_Jobs', selectedRows);
        console.log('==========='+typeof(selectedRows));
    },
    
    NoAllApprovePE : function (component, event, helper) {
        component.set("v.isApproveAllPE",false);
        component.get('v.overlayPanelForPE').then(
            function (modal) {
                modal.close();
            }
        );
        helper.MarkCompleteJobsApproveConfirmationTasks(component, event, helper);
    },
    YesAllApprovePE : function (component, event, helper) {
         component.set("v.isApproveAllPE",true);
         component.get('v.overlayPanelForPE').then(
            function (modal) {
                modal.close();
            }
        );
       helper.MarkCompleteJobsApproveConfirmationTasks(component, event, helper);  
    },
    NoAllTaskDone :  function (component, event, helper) {
        component.set("v.isMarkDoneAllTasks",false);
        component.get('v.overlayPanelForTask').then(
            function (modal) {
                modal.close();
            }
        );
        helper.MarkFinalCompleteJobs(component, event, helper);
    },
     YesAllTaskDone : function(component,event,helper) {
        component.set("v.isMarkDoneAllTasks",true);
        component.get('v.overlayPanelForTask').then(
            function (modal) {
                modal.close();
            }
        );
          helper.MarkFinalCompleteJobs(component, event, helper);
    },
    markCompletehandler : function (component, event, helper) {
        var selectJobs=component.get('v.Selected_Jobs');
        var showPE=component.get("v.CSdata.Active__c");        
        console.log('====showPE====='+showPE);
        if(selectJobs.length>0){
            if(showPE){
              helper.MarkCompleteJobsApproveConfirmation(component, event, helper,showPE);  
            }
            else{
                 helper.MarkCompleteJobsApproveConfirmationTasks(component, event, helper); 
             //helper.MarkFinalCompleteJobs(component, event, helper);  
            }
            
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"info",
                "message": "Please select at least one Job"
            });
            toastEvent.fire();   
        }
        
    },
    
    cancelnaviagtion  : function (component, event, helper) {
         var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Job__c',
                actionName: 'home'
            }
        };
        navService.navigate(pageReference);
    },
    
    
    resetFilters : function (component, event, helper) {
        helper.resetFiltersHelper(component, event, helper);
    },
    
    doFilter : function(component, event, helper) {
        component.set("v.data",[]);
        component.set("v.selectedRowsCount",0);
        component.set("v.Selected_Jobs",[]);
          helper.filerJobRefecth(component, event, helper);
    }
})