({
    //Intial aura method load
    loadCalendar : function(component, event, helper) {
        console.log('>>>>>>>>>>>> 2. Intial aura method load>>>>>>>>>>>>');
        var n = Date.now();
        var dateval="calendar_"+n;        
        console.log('--dateval---'+dateval);
        component.set("v.dateval",dateval);
        
        helper.fetchCalenderEvents(component, event, helper);
    },
    
    // Campaign Calendar selected aura method load
    loadCalforcampaginsevents : function(component, event, helper) {
        console.log('>>>>>>>>>>>> 2. Campaign Calendar selected aura method load>>>>>>>>>>>>');
        var dynid= component.get('v.dateval');
        $('#'+dynid).fullCalendar('removeEvents');
        helper.fetchCampCalenderEvents(component, event, helper);
        
    },
    
    // Job Calendar selected aura method load
    loadCalforjobsevents : function(component, event, helper) { 
        console.log('>>>>>>>>>>>> 2. Job Calendar selected aura method load>>>>>>>>>>>>');
        var dynid= component.get('v.dateval');
        $('#'+dynid).fullCalendar('removeEvents');
        helper.fetchjobEvents(component, event, helper);
        
    },
    
    // Task Calendar selected aura method load
    loadCalfortasksevents: function(component, event, helper) {
		console.log('>>>>>>>>>>>> 2. Task Calendar selected aura method load>>>>>>>>>>>>');        
        var dynid= component.get('v.dateval');
        $('#'+dynid).fullCalendar('removeEvents');
        helper.fetchtskCalenderEvents(component, event, helper);
        
    },
    
})