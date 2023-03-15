({
	doInIt : function(component, event, helper) {
         helper.getTotalJobRecords(component, event, helper);
        
         var rowActions =[
            {label: 'Edit',name: 'Edit_Job',iconName: 'utility:edit'}, 
            {label: 'Delete',name: 'Delete_Job',iconName: 'utility:delete'}];
        
        component.set('v.columns', [
            {label: 'Job#', fieldName: 'Job_Auto_Number__c', type: 'text',sortable: true},
            {label: 'Name', fieldName: 'JobLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip:{ fieldName: 'Name' } } },
            {label: 'Status', fieldName: 'Status__c', type: 'text',sortable: true},
            {label: 'Job Description', fieldName: 'Job_Description__c', type: 'text',sortable: true},
            {label: 'Client', fieldName: 'ClientLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'ClientName' }, target: '_self', tooltip:{ fieldName: 'ClientName' } } },
            {label: 'Campign', fieldName: 'CampLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'CampName' }, target: '_self', tooltip:{ fieldName: 'CampName' } } },
            {label: 'Start Date', fieldName: 'Start_Date__c', type: 'date-local',sortable: true,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Start Date' }},
            {label: 'Due Date', fieldName: 'Due_Date__c', type: 'date-local',sortable: true,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Due Date' }},
            {label: 'Completion Date', fieldName: 'Completion_Date__c', type: 'date-local',sortable: true,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date'}},
            {type: 'action', typeAttributes: {rowActions: rowActions }}  
            	
        ]);
        
        
        helper.fetchJobRecords(component, event, helper, 0);
       
      //helper.fetchJobRecords(component, event, helper); 
	},
    
    loadMoreData : function(component, event, helper) {
        if(component.get("v.totalRows") !=component.get('v.data').length){
            event.getSource().set("v.isLoading", true);        
            component.set('v.loadMoreStatus', 'Loading...');
            console.log('====Data lenght==='+component.get('v.data').length);
            helper.fetchJobRecords(component, event, helper, component.get('v.data').length);
        }
        else{
            event.getSource().set("v.isLoading", false);
            component.set('v.enableInfiniteLoading', false);
            component.set('v.loadMoreStatus', 'No more data to load');
        }
    },
    
     navigateToJobSearchResult : function(component, event, helper) {
        window.open('/one/one.app#/alohaRedirect/apex/Job_Search_Result_InPDF','_blank'); 
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
    
    navigateToMyComponent : function(component, event, helper) {
       var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Job__c',
                actionName: 'new'
            }
        };
        navService.navigate(pageReference);
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
    
    
    handleSearchRowActions: function(component, event, helper) {
        // DeleteTask  ActiveTask CompleteTask tskid
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit_Job':
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:Job_New_Edit_Cmp",
                        componentAttributes: {
                            sObjectName : "Job__c",
                            recordId :row.Id
                        }
                    });
                    evt.fire();
                break;
                
            case 'Delete_Job':
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:Job_Delete",
                    componentAttributes: {
                         sObjectName : "Job__c",
                        recordId :row.Id
                    }
                });
                evt.fire(); 
                
        }
    },
    
    
    doSearch : function(component, event, helper) {
        //alert();
       var Job_Name=component.find("Job_Name").get("v.value");
       var Client=component.find("Client").get("v.value");
       var Campaign=component.find("Campaign").get("v.value");
       var Status=component.find("Status").get("v.value"); 
       var Job_Description=component.find("Job_Description").get("v.value");
       var Start_Date1=component.find("Start_Date1").get("v.value");
       var Start_Date2=component.find("Start_Date2").get("v.value");
       var Due_Date1=component.find("Due_Date1").get("v.value");
       var Due_Date2=component.find("Due_Date2").get("v.value");
       var Completion_Date1=component.find("Completion_Date1").get("v.value");
       var Completion_Date2=component.find("Completion_Date2").get("v.value");
        
        console.log('====='+(Job_Name!='')+'==='+(Status!='')+'===='+(Client!='')+'==='+Campaign+'==='+Job_Description+'==SD1='+(Start_Date1!=null)+'==DD2='+(Start_Date2!='')+'==='+Due_Date1+'==='+Due_Date2+'==='+Completion_Date1+'==='+Completion_Date2+'===');
     
        if(Job_Name!='' || Status!='' || Client!='' || Campaign!='' || Job_Description!='' || Start_Date1!='' || Start_Date2!='' || Due_Date1!='' || Due_Date2!='' || Completion_Date1!='' || Completion_Date2!='')
        {
            console.log('====Yes filter condition===');
            component.set('v.enableInfiniteLoading', false);
        }
        else{
            console.log('====No filter condition===');
            component.set('v.enableInfiniteLoading', true);
             helper.fetchJobRecords(component, event, helper, 0);
        }
       //runSearch(String JN,String CN,String CampN,String ST,String JD,String SD1,String SD2,String DD1,String DD2,String CD1,String CD2) 
         
        var JobsAction= component.get("c.runSearch");
        JobsAction.setParams({
            JN:Job_Name,
            CN:Client,
            CampN:Campaign,
            ST:Status,
            JD:Job_Description,
            SD1:Start_Date1,
            SD2:Start_Date2,
            DD1:Due_Date1,
            DD2:Due_Date2,
            CD1:Completion_Date1,
            CD2:Completion_Date2
            
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
                component.set("v.data",rows);
            }  
        }); 
        
         $A.enqueueAction(JobsAction);
       
       
    },
    
   
    
})