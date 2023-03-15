({
    doInit : function(component, event, helper) {
        console.log('>>>>>>>>>>>Do INIT>>>>>>>>>>>>>>>>>>>>');
        var action = component.get("c.getObjLabels");
        action.setCallback(this, function(response) {
            console.log('====response======'+JSON.stringify(response.getReturnValue()));
            var ObjState = response.getState();
            if (ObjState === "SUCCESS") {
                var result=response.getReturnValue();
                /*var objMap=[];
                for(var key in result){
                    objMap.push({key: key, value: result[key]});
                }*/
                component.set("v.objLabels",result); 
            }
            
        });
        $A.enqueueAction(action);
    },
    
    GLDep : function(component, event, helper) {
        var Sobj='GL_Department__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    Mediatype : function(component, event, helper) {
        var Sobj='Media_Type__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    Role : function(component, event, helper) {
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'Admin_Role',
            }         
        };
        component.set("v.pageReference", pageReference);
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Admin_Role",
        });
        evt.fire();*/
    },
    
    AppSchTemp : function(component, event, helper) {
        var Sobj='Approval_Schedule_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    GLCode : function(component, event, helper) {
        var Sobj='GL_Code__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    SchTemp : function(component, event, helper) {
        var Sobj='Schedule_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    Staff : function(component, event, helper) {
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'Admin_Staff',
            }         
        };
        component.set("v.pageReference", pageReference);
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Admin_Staff",
        });
        evt.fire();*/
    },
    
    CreativeBrief : function(component, event, helper) {
        var Sobj='Specification_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    ProductionSpec : function(component, event, helper) {
        var Sobj='Production_Spec_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    Holiday : function(component, event, helper) {
        var Sobj='Holiday__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    ProductionEst : function(component, event, helper) {
        var Sobj='Production_Estimate_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    InvAllTemp : function(component, event, helper) {
        var Sobj='Invoice_Allocation_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    CampTemp : function(component, event, helper) {
        var Sobj='Campaign_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
    TagTemp : function(component, event, helper) {
        var Sobj='Tag_Template__c';
        helper.FetchObjPrefix(component, event, Sobj);
    },
    
})