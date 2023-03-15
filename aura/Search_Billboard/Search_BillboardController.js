({
    doInIt : function(component, event, helper) {
        helper.getTotalBBRecords(component, event, helper);  
        var rowActions =[
            {label: 'Edit',name: 'Edit_BB',iconName: 'utility:edit'}, 
            {label: 'Delete',name: 'Delete_BB',iconName: 'utility:delete'}];
        
        component.set('v.columns', [
            {label: 'BB #', fieldName: 'BBLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip:{ fieldName: 'Name' } } },
            {label: 'Client Name', fieldName: 'ClientName', type: 'text', sortable: true },
            {label: 'BB Vendor', fieldName: 'VenName', type: 'text', sortable: true },
            {label: 'Location', fieldName: 'Location__c', type: 'text', sortable: true },
            {label: 'Expiration Date', fieldName: 'Expiration_Date__c', type: 'date-local',sortable: true,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Expiration Date' }},
            {type: 'action', typeAttributes: {rowActions: rowActions }}  
        ]);
        
        helper.fetchBBRecords(component, event, helper, 0);  
    },
    
     loadMoreData : function(component, event, helper) {
        if(component.get("v.totalRows") !=component.get('v.data').length){
            event.getSource().set("v.isLoading", true);        
            component.set('v.loadMoreStatus', 'Loading...');
            console.log('====Data lenght==='+component.get('v.data').length);
            helper.fetchBBRecords(component, event, helper, component.get('v.data').length);
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
    
    navigateToMyComponent : function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Billboard__c',
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
                objectApiName: 'Billboard__c',
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
            case 'Edit_BB':
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:BillBoardTab",
                    componentAttributes: {
                        sObjectName : "Billboard__c",
                        recordId :row.Id
                    }
                });
                evt.fire();
                break;
                
            case 'Delete_BB':
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:BillBoard_Delete",
                    componentAttributes: {
                        sObjectName : "Billboard__c",
                        recordId :row.Id
                    }
                });
                evt.fire(); 
                
        }
    },
    
    
    doSearch : function(component, event, helper) {
        //alert();
        var BB=component.find("BB#").get("v.value");
        var Client=component.find("Client").get("v.value");
        var ClientCode=component.find("ClientCode").get("v.value");
        var BBVendor=component.find("BBVendor").get("v.value"); 
        var Location=component.find("Location").get("v.value");
        var ExpirationDate1=component.find("ExpirationDate1").get("v.value");
        var ExpirationDate2=component.find("ExpirationDate2").get("v.value");
       
        
        console.log('====='+BB+'====='+Client+'==='+ClientCode+'==='+BBVendor+'==='+Location+'==='+ExpirationDate1+'==='+ExpirationDate2+'===');
        
        if(BB!='' || Client!='' || ClientCode!='' || BBVendor!='' || Location!='' || ExpirationDate1!='' || ExpirationDate2!='')
        {
            console.log('====Yes filter condition===');
            component.set('v.enableInfiniteLoading', false);
        }
        else{
            console.log('====No filter condition===');
            component.set('v.enableInfiniteLoading', true);
            helper.fetchBBRecords(component, event, helper, 0);  
        }
        
        //runSearch(String BB,String CLI,String CLICode,String BBV,String LOC,String ED1,String ED2) 
        
        var BBAction= component.get("c.runSearch");
        BBAction.setParams({
            BB:BB,
            CLI:Client,
            CLICode:ClientCode,
            BBV:BBVendor,
            LOC:Location,
            ED1:ExpirationDate1,
            ED2:ExpirationDate2,
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
                component.set("v.data",rows);
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
        $A.enqueueAction(BBAction);
    },
    
    
    
})