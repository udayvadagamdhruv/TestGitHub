({
    display : function(component, event, helper) {
        helper.toggleHelper(component, event);
       // component.set("v.text","<p><b>Assign team members to specific jobs:</b></p><p><br></p><ul><li>Click the <b>Add/Edit </b>team button to add or remove team members to the Job Team.</li><li>Use the <i>Resource Workload Chart</i> to see each team members load, filtered by Role.</li><li>Both Licensed Staff and Unlicensed Staff can be assigned to job teams.</li><li>Team members are automatically assigned to tasks on the schedule based on their role. The roles is defined on the schedule template. </li></ul><p><br></p>");
    },
    
    displayOut : function(component, event, helper) {
        helper.toggleHelper(component, event);      
    }
})