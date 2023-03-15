({
    doInIt : function(component,event,helper){
        helper.getObjectLables(component,event,helper);
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        //alert('onfocus clicked');
        //the below when we click input box then all records will appear.
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){ 
      component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
                //the below when we click input box and for search results.
       // alert('keypresscontroller');
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,helper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} ); 
        component.set("v.ParentRecId",null); 
        helper.helperDepClear(component,event,helper);
        
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('============='+JSON.stringify(selectedAccountGetFromEvent));
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
    
    Deponfocus : function(component,event,helper){
        $A.util.addClass(component.find("depmySpinner"), "slds-show");
        var forOpen = component.find("DepsearchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        var ParentId=component.get("v.ParentRecId");
        helper.getDependetRecords(component,event,ParentId,getInputkeyWord);
    },
    
    Deponblur : function(component,event,helper){ 
        component.set("v.listOfDepenRecords", null );
        var forclose = component.find("DepsearchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    DepkeyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.DepSearchKeyWord");
        var ParentId=component.get("v.ParentRecId");
        console.log('The parent rcd id '+ParentId);
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("DepsearchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.getDependetRecords(component,event,ParentId,getInputkeyWord);
        }
        else{  
            component.set("v.listOfDepenRecords", null ); 
            var forclose = component.find("DepsearchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    Depclear :function(component,event,helper){
       
        helper.helperDepClear(component,event,helper);
    },
    
    // This function call when the end User Select any record from the result list.   
    DephandleComponeSntEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedDepRecordwithEvent = event.getParam("DeprecordByEvent");
        console.log('========selectedDepRecordwithEvent======='+selectedDepRecordwithEvent);
        component.set("v.DepenselectedRecord" , selectedDepRecordwithEvent); 
        
        var forclose = component.find("Deplookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("DepsearchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("DeplookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
    
    
    
    
    getDependentRecords :function(component, event, helper) {
        var IsDependent=component.get("v.IsDependent");
        if(IsDependent){
            var selectedParentRecordId = event.getParam("ParentRecordId");
            component.set("v.ParentRecId", selectedParentRecordId); 
            var getInputkeyWord = '';
            console.log('=======getting App event ParentId==='+selectedParentRecordId);
            helper.getDependetRecords(component,event,selectedParentRecordId,getInputkeyWord);
        }
    },
    
    PopulateLookupvalues : function(component, event, helper){
        var fireWithEdit=event.getParam('arguments');
        console.log('The fireWithEdit '+fireWithEdit);
        if(fireWithEdit)
        {
            var PObj=fireWithEdit.ParentObject;
            console.log('==Parent Object child======'+PObj);
            
            var CObj=fireWithEdit.ChildObject;
            console.log('==Parent Child======'+CObj); 
            
            var boolval = Object.keys(CObj).length === 0 && CObj.constructor === Object;
           // alert(boolval + '' +Object.values(CObj));
            
            component.set("v.selectedRecord" ,PObj);
            component.set("v.ParentRecId", PObj.Id); 
            
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
            
            var IsDependent=component.get("v.IsDependent"); 
            if(IsDependent && !boolval){
                window.setTimeout(
                    $A.getCallback(function() {    
                        component.set("v.DepenselectedRecord" , CObj); 
                        
                        var forclose = component.find("Deplookup-pill");
                        $A.util.addClass(forclose, 'slds-show');
                        $A.util.removeClass(forclose, 'slds-hide');
                        
                        var forclose = component.find("DepsearchRes");
                        $A.util.addClass(forclose, 'slds-is-close');
                        $A.util.removeClass(forclose, 'slds-is-open');
                        
                        var lookUpTarget = component.find("DeplookupField");
                        $A.util.addClass(lookUpTarget, 'slds-hide');
                        $A.util.removeClass(lookUpTarget, 'slds-show');   
                    }), 1000
                );  
         
            }
            else if(IsDependent && boolval)
            {
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
        }  
    },
    
})