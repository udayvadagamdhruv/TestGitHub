({
 doinit : function(component, event, helper) 
     {
 			component.set('v.columns', [
            {label: 'Material Item Name', fieldName: 'Name', type: 'text'},
            {label: 'Calc Unit', fieldName: 'Calc_Unit__c', type: 'text'},
            {label: 'Qty On Hand', fieldName: 'Qty_On_Hand__c', type: 'text'},
            {label: 'Category', fieldName: 'Category__c', type: 'text'}
         ]);
            
          
         
         var Milist = component.get("c.vendorMI");
         Milist.setParams
         ({
             recordid: component.get("v.recordId")
         });
        
         Milist.setCallback(this, function(res) 
                           {
                               component.set("v.MIList", res.getReturnValue());
                           });
         $A.enqueueAction(Milist);
 }
})