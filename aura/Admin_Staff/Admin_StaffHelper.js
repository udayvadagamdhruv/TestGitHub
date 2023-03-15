({
	fetchUserRec : function(component, event, helper) {
        
		var UserRec = component.get("c.getUsers");
       
        UserRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
               var rows=response.getReturnValue();
                console.log('>>>>>>User Records >>>>>>'+JSON.stringify(rows));
                 for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                     if(row.Name){
                         
                         
                         var compDefinition = { "componentDef" : "c:User_Detail", 
                                               "attributes" :{
                                                   "recordId" :row.Id, 
                                               } 
                                              }; 
                         // Base64 encode the compDefinition JS object 
                         var encodedCompDef = btoa(JSON.stringify(compDefinition)); 
                         row.UserLink = '/one/one.app#'+encodedCompDef; 
                     }
                    if(row.UserRoleId){
                        row.UserRoleId=row.UserRole.Name;
                    }
                    
                }
                component.set("v.Userdata",rows);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
            
        });
		 $A.enqueueAction(UserRec);
    },
    
    UsersortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.Userdata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName='UserLink'){
            data.sort(this.sortBy('Name', reverse))
        }else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.Userdata", data);
    },
    
    fetchStaffRec : function(component, event, helper) {
        
		var StaffRec = component.get("c.getStaffs");
       
        StaffRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
               var rows=response.getReturnValue();
                console.log('>>>>>>Staff Records >>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                    row.StaffLink = '/'+row.Id;    
                    if(row.Name){
                        row.Name=row.Name;
                    }
                }
                component.set("v.Staffdata",rows);
            }
        });
		 $A.enqueueAction(StaffRec);
    },
    
    
    StaffsortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.Staffdata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        console.log('fieldName--'+fieldName);
        if(fieldName=='StaffLink'){
            data.sort(this.sortBy('Name', reverse))
        }
        else {
             data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.Staffdata", data);
    },
    
     /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    sortBy: function (field, reverse, primer) {
        console.log('==sortBy=primer==='+primer);
         console.log('==sortBy=field==='+field);
         console.log('==sortBy=reverse==='+reverse);
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
     getProfile: function(component, event, helper){
        var ProfileAct = component.get("c.getProfile");
        ProfileAct.setCallback(this, function(response1) {
            console.log("=====Profile List====", response1.getReturnValue());
            var Pro=response1.getReturnValue();
            var Profiles=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in Pro) {
                    Profiles.push({
                        key: key,
                        value: Pro[key]
                    });
                }
                component.set("v.ProfileRec", Profiles); 
            } 
        });
        $A.enqueueAction(ProfileAct);
    },
    
    getRoles: function(component, event, helper){
        var RolesAct = component.get("c.getSURoles");
        RolesAct.setCallback(this, function(response1) {
            console.log("=====Roles List====", response1.getReturnValue());
            var Rol=response1.getReturnValue();
            var Roles=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in Rol) {
                    Roles.push({
                        key: key,
                        value: Rol[key]
                    });
                }
                component.set("v.RolesRec", Roles); 
            } 
        });
        $A.enqueueAction(RolesAct);
    },
    
   
})