({
	getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Purchase_Order__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    getFieldsforObject : function(component, sObj){
        
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : sObj
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("list of fiels name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.fieldSet", response.getReturnValue());
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName : sObj
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
    },
      getVendor:  function(component, event, helper){
        var recId = component.get("v.jobrecordId");
        var actionVen = component.get("c.getPOVendors");
        actionVen.setParams({
            recordId : recId 
        });
        actionVen.setCallback(this, function(responseVen){
            var stateVen = responseVen.getState();
            console.log("===List of Approved Estimate Vendors===" + responseVen.getReturnValue());
            console.log("===List of Approved Estimate Vendors===" + JSON.stringify(responseVen.getReturnValue()));
            var Ven=responseVen.getReturnValue();
            var Venlist=[];
            if(stateVen === "SUCCESS"){
                for (var key in Ven) {
                    Venlist.push({
                        key: key,
                        value: Ven[key]
                    });
                }
                component.set("v.VendorRecords", Venlist); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVen.getError()[0].message);
                var errors = responseVen.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVen);  
    },
    
    getVendorCon:  function(component, event, helper,ParentId){
        var VenId;
        if(ParentId==null || ParentId=='' ){
            VenId=component.find("VendorId").get('v.value');
            console.log('====new button get contact=='+VenId);
        }
        else{
           
            VenId=ParentId;
             console.log('====edit vendoer button button=='+VenId);
        }
        
        
        console.log('===VenId==='+VenId);
        var actionVenCon = component.get("c.getVendorContact");
        actionVenCon.setParams({
            VendorName :VenId 
        });
        
        actionVenCon.setCallback(this, function(responseVenCon){
            var stateVenCon = responseVenCon.getState();
            console.log("===List of Vendors Contact===" + responseVenCon.getReturnValue());
            //var VenCon=responseVenCon.getReturnValue();
            //var VenConlist=[];
            if(stateVenCon === "SUCCESS"){
               /* for (var key in VenCon) {
                    VenConlist.push({
                        key: key,
                        value: VenCon[key]
                    });
                  }*/
                component.set("v.VendorConRecords",responseVenCon.getReturnValue()); 
                
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVenCon.getError()[0].message);
                var errors = responseVenCon.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVenCon);  
    },
    
     getStaff:  function(component, event, helper){
        var actionStaff = component.get("c.getStaffs");
        actionStaff.setCallback(this, function(responseStaff){
            var stateStaff = responseStaff.getState();
            console.log("===List of Staff===" + responseStaff.getReturnValue());
            if(stateStaff === "SUCCESS"){
                component.set("v.StaffRecords",responseStaff.getReturnValue()); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseStaff.getError()[0].message);
                var errors = responseStaff.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionStaff);  
    }
})