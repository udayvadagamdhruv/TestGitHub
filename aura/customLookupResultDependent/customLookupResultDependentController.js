({
	DepselectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getDepSelectRecord = component.get("v.DepoRecord");
       console.log('=====getDepSelectRecord======'+getDepSelectRecord);
       console.log('=====getSelectRecord======'+getDepSelectRecord.Id);

      var compEvent = component.getEvent("DepoSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"DeprecordByEvent" : getDepSelectRecord });  
    // fire the event  
         compEvent.fire();
       
    },
     
})