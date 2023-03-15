({
    handleClick : function(component, event, helper) {
        component.set("v.iseditMode",true);
    },
    handlesubmit :function(component, event, helper) {
        component.set("v.isLoading",true); 
    },
    
    handleCancel :function(component, event, helper) {
          component.set("v.iseditMode",false);
    },
    
    handleSuccess :function(component, event, helper) {
        component.set("v.iseditMode",false);
        component.set("v.isLoading",false);
    }
})