({
   selectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
       console.log('=====getSelectRecord======'+getSelectRecord);
              console.log('=====getSelectRecord======'+getSelectRecord.Id);

    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"recordByEvent" : getSelectRecord });  
    // fire the event  
         compEvent.fire();
       
       
       //var appEvent = $A.get("e.c:dependentappEvent");
        var ParEvent= component.getEvent("ParentChangedEvent");
       // Optional: set some data for the event (also known as event shape)
       // A parameter’s name must match the name attribute
       // of one of the event’s <aura:attribute> tags
       ParEvent.setParams({ "ParentRecordId" : getSelectRecord.Id });
       ParEvent.fire();
       
    },
    
   
})