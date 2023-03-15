({
    doinit: function (cmp, event, helper) {
      //  alert('hiii');
        var recId = cmp.get("v.recordId");
        console.log('>>>>>>>>>Client ID>>>>>>>>>>>>'+recId);
      //  alert('>>>>>>>>>'+recId);
        var CLOC = cmp.get("c.ClientLoc");
      //  alert('>>>>eeeee>>>>>'+recId);
        CLOC.setParams({
            recordId : recId 
        });
        CLOC.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
              //  alert('>>>Latt>>>>>>'+rows.Latitude__c);
              //  alert('>>>Lannn>>>>>>'+rows.Longitude__c);
                cmp.set('v.mapMarkers', [
                    {
                        location: {
                            'Latitude': rows.Latitude__c,
                            'Longitude': rows.Longitude__c
                        },
                        icon: 'Utility:checkin',
                     //   title: 'Saint-Tropez'
                    }
                ]);
               // cmp.set('v.markersTitle', 'Côte d\'Azur');
                cmp.set('v.zoomLevel', 4);
              //  cmp.set("v.ShowMap", true);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Map has '+errors[0].message
                }); 
            }
            
        });
        
        var MapAccess = cmp.get("c.getisAccessable");
        MapAccess.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('Map Accessable'+response.getReturnValue());
                cmp.set("v.ShowMap",response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Map has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(MapAccess);
        
        $A.enqueueAction(CLOC);
    }    
    
})