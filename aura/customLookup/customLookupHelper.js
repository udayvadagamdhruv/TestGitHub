({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        // set param to method  
        action.setParams({ 
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ParentFilter': component.get("v.ParentFilter"),
            'ParentSortBy' : component.get("v.ParentSortBy")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            console.log('======parent Records state==='+response.getState());
            console.log('======parent Records state==='+response.getReturnValue());
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    
    getObjectLables: function (component,event,helper){
        var ObjAPIName=component.get("v.objectAPIName");
        var DObjeAPIName=component.get("v.DepobjectAPIName");
        //alert('ObjAPIName=== '+ObjAPIName +'and' + '' + '' +'DObjeAPIName=== '+DObjeAPIName );
        
        var action = component.get("c.getcustomLookUpObjectLables");
        action.setParams({
            ObjAPIName : ObjAPIName,
            DObjeAPIName : DObjeAPIName
        });
        action.setCallback(this, function(res){
            if(res.getState()=="SUCCESS"){
                
                var result=res.getReturnValue();
                
                console.log('=======LooKup Object Lables==========='+JSON.stringify(result));
                // component.set("v.label", result[0]);
                if(result.length>1){
                    // component.set("v.Depelabel", result[1]);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getDependetRecords :function (component,event,selectedParentRecordId,getInputkeyWord){
        
        var action = component.get("c.getDependetRecords");
        // set param to method  
        action.setParams({
            'depsearchKeyWord' :getInputkeyWord,
            'ParentRecId' : selectedParentRecordId,
            'ObjectName' : component.get("v.DepobjectAPIName"),
            'RelationShipName' : component.get("v.RelationShipName"),
            'ChildFilter': component.get("v.ChildFilter"),
            'ChildSortBy': component.get("v.ChildSortBy")
            
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            console.log('====contact record state===='+response.getState());
            console.log('====contact record values===='+JSON.stringify(response.getReturnValue()));
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.DepMessage", 'No Result Found...');
                } else {
                    component.set("v.DepMessage", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfDepenRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    
    
    helperDepClear : function(component,event,helper){
        var pillTarget = component.find("Deplookup-pill");
        var lookUpTarget = component.find("DeplookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.DepSearchKeyWord",null);
        component.set("v.listOfDepenRecords", null );
        component.set("v.DepenselectedRecord", {} );  
    }
})