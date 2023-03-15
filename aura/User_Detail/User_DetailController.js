({
    
    doInit : function(component, event, helper) {
        helper.getProfile(component, event, helper);
        helper.getRoles(component, event, helper);
    },
    EditUser: function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('>>>>>>RecID>>>>>>>>'+recId);
        component.set("v.isUserOpen", true);
        
    }, 
    
    doCancel: function(component, helper) {
        component.set("v.isUserOpen", false);
    },
    
    Userload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.recordId");
        console.log('===Recordid after==='+recId); 
       // helper.getProfile(component, event, helper);
      //  helper.getRoles(component, event, helper);
      
        if(recId!=null){
            console.log('===Recordid 33333 after==='+recId);    
            var Userfields = event.getParam("recordUi");
          // console.log('>>>User Fileds>>>>>>>>>>'+JSON.stringify(Userfields));
          
                component.find("UserProfileId").set("v.value",component.get("v.simpleRecord.ProfileId"));
           
          
               component.find("URoleId").set("v.value",component.get("v.simpleRecord.UserRoleId"));
           
         
        }
    },
    
    
      UserOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Userfields = event.getParam("fields"); 
        var Pro=component.find("UserProfileId");
        var Profile=Pro.get("v.value");
        console.log('===Profile==='+JSON.stringify(Profile));
        
        var Rol=component.find("URoleId");
        var Role=Rol.get("v.value");
        console.log('===Role==='+JSON.stringify(Role));
        
        var FName=component.find("UserFName");
        var SFName=FName.get("v.value");
        console.log('===First Name==='+JSON.stringify(SFName));
        
        var LName=component.find("UserLName");
        var SLName=LName.get("v.value");
        console.log('===Last Name==='+JSON.stringify(SLName));
        
        var SEmail=component.find("UserEmailfields");
        var StaffEmail=SEmail.get("v.value");
        console.log('===Email==='+JSON.stringify(StaffEmail));
        
        var SUName=component.find("UserNamefield");
        var StaffUserName=SUName.get("v.value");
        console.log('===UserName==='+JSON.stringify(StaffUserName));
        
        //event.preventDefault(); // Prevent default submit
        
        var Usertypee = component.find("UserTypefields");
        var Usertype = Usertypee.get("v.value");
        var IsActivee = component.find("UserActivefields");
        var IsActive =  IsActivee.get("v.value");
        
        if(Usertype=='Licensed User' && IsActive==false) 
        {
            var ToastMsgUT=$A.get("e.force:showToast");
            ToastMsgUT.setParams({
                "title":"Info",
                "type": "error",
                "message":"Please change the User Type to Unlicensed Staff."
            });   
            ToastMsgUT.fire();
            event.preventDefault(); 
        }
       
          
       /* if(Usertype=='Unlicensed Staff') 
       {
            Userfields["IsActive"]=false;
        }
       */
        else if(SFName==null || SFName=='')
        {
            var ToastMsgFN=$A.get("e.force:showToast");
            ToastMsgFN.setParams({
                "title":"First Name",
                "type": "error",
                "message":"First Name must have at least three characters."
            });   
            ToastMsgFN.fire();
            event.preventDefault(); 
        }
        else if(SFName.length < 3)
        {
            var ToastMsg1=$A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title":"First Name",
                "type": "error",
                "message":"First Name must have at least three characters."
            });   
            ToastMsg1.fire();
            event.preventDefault(); 
        }
            else if(SLName==null || SLName=='')
            {
                var ToastMsgLN=$A.get("e.force:showToast");
                ToastMsgLN.setParams({
                    "title":"Last Name",
                    "type": "error",
                    "message":"Please enter the Last Name"
                });   
                ToastMsgLN.fire();
                event.preventDefault(); 
            }
                else if(StaffEmail==null || StaffEmail=='')
                {
                    var ToastMsgEmail=$A.get("e.force:showToast");
                    ToastMsgEmail.setParams({
                        "title":"Email",
                        "type": "error",
                        "message":"Please enter the Email"
                    });   
                    ToastMsgEmail.fire();
                    event.preventDefault(); 
                }
                    else if(StaffUserName==null || StaffUserName=='')
                    {
                        var ToastMsgUN=$A.get("e.force:showToast");
                        ToastMsgUN.setParams({
                            "title":"User Name",
                            "type": "error",
                            "message":"Please enter the User Name"
                        });   
                        ToastMsgUN.fire();
                        event.preventDefault(); 
                    }
        
                        else if(Profile==null || Profile=='' || Profile=='--None--')
                        {
                            var ToastMsg=$A.get("e.force:showToast");
                            ToastMsg.setParams({
                                "title":"Profile",
                                "type": "error",
                                "message":"You must select a Profile."
                            });   
                            ToastMsg.fire();
                            event.preventDefault(); 
                        }
                            else if(Role==null || Role=='' || Role=='--None--')
                            {
                                var ToastMsg1=$A.get("e.force:showToast");
                                ToastMsg1.setParams({
                                    "title":"Role",
                                    "type": "error",
                                    "message":"You must select a Role."
                                });   
                                ToastMsg1.fire();
                                event.preventDefault(); 
                            }
        
                                else
                                {
                                    if(Usertype=='Unlicensed Staff') 
                                    {
                                        Userfields["IsActive"]=false;
                                    }
                                    
                                    var FName=component.find("UserFName").get("v.value");
                                    var LName=component.find("UserLName").get("v.value");
                                    var alias=FName.substring(0,3)+''+LName.substring(0,1);
                                    console.log('>>>>>>Alias>>>>>>>>>>'+alias);
                                     Userfields["Id"]=component.get("v.recordId");
                                    Userfields["Name"]=FName+' '+LName;
                                    Userfields["ProfileId"]=component.find("UserProfileId").get("v.value");
                                    console.log('===Profile==='+component.find("UserProfileId").get("v.value"));
                                    Userfields["UserRoleId"]=component.find("URoleId").get("v.value");
                                    console.log('===Role==='+component.find("URoleId").get("v.value"));
                                    Userfields["alias"]=alias;
                                    
                                    component.find("UserEditform").submit(Userfields);
                                    console.log('===form Userfields==='+JSON.stringify(Userfields));
                                    
                                    console.log('===form Userfields==='+JSON.stringify(Userfields));
                                    var userinfo=JSON.stringify(Userfields);
                                    
                                    var UserRec = component.get("c.UpdateUsers");
                                    UserRec.setParams({
                                        userinfostr:userinfo,
                                        oldUsername : component.get("v.simpleRecord.Username")
                                    });
                                    
                                    UserRec.setCallback(this,function(response) {
                                        var state = response.getState();
                                        if (state === "SUCCESS") {
                                            if(response.getReturnValue() === 'true'){
                                               /* helper.showToast({
                                                    "type": "success",
                                                    "message": " Record Updated Successfully"
                                                });*/
                                               
                                            } else{ 
                                                helper.showToast({
                                                    "title": "Error!!",
                                                    "type": "error",
                                                    "message": response.getReturnValue()
                                                });
                                                
                                            }      
                                        }
                                    });
                                    $A.enqueueAction(UserRec);
                                    
                                }
    },
    
    UserRecordSuccess: function(component, event, helper) 
    { 
        var resultsToast = $A.get("e.force:showToast");
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
       /* var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Admin_Staff"
        });*/
        
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was updated."
        });
        component.set("v.isUserOpen", false);
       // evt.fire();
        resultsToast.fire();
        
    },
    
    
    
    ResetPassword: function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('==Reset Password==='+recId);
        var RpUser = component.get("c.resetpassword");
        RpUser.setParams({
            recordId : recId 
        });
        RpUser.setCallback(this,function(response) {
            var state = response.getState();
            console.log('==Reset Password==='+response.getState());
            if (state === "SUCCESS") {
                console.log('==Reset Password==='+response.getState());
                if(response.getReturnValue() === 'OK'){
                    helper.showToast({
                        "title": "Reset Password",
                        "type": "success",
                        "message": "Reset Password Successfully"
                    });
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
                   /* var navEvt = $A.get("e.force:navigateToComponent");
                    navEvt.setParams({
                        componentDef : "c:Admin_Staff"
                    });
                    navEvt.fire();*/
                } else if(response.getReturnValue() === 'User is Inactive'){
                    helper.showToast({
                        "title": "Error",
                        "type": "error",
                        "message": "User is Inactive"
                    });
                } else{ 
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
            }
        });
        $A.enqueueAction(RpUser);
    },
    
    
    Deactivate: function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('==Deactivate recId==='+recId);
        var DeactUser = component.get("c.deactivateUser");
        DeactUser.setParams({
            recordId : recId 
        });
        DeactUser.setCallback(this,function(response) {
            var state = response.getState();
            console.log('==Deactivate user==='+response.getState());
            if (state === "SUCCESS") {
                console.log('==Deactivate user==='+response.getState());
                if(response.getReturnValue() === 'OK'){
                    helper.showToast({
                        "title": "Record Deactivated",
                        "type": "success",
                        "message": " Record Deactivated Successfully"
                    });
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
                    /*
                    var navEvt = $A.get("e.force:navigateToComponent");
                    navEvt.setParams({
                        componentDef : "c:Admin_Staff"
                    });
                    navEvt.fire();*/
                } else if(response.getReturnValue() === 'ChangeUSerType'){
                    helper.showToast({
                        "title": "Error",
                        "type": "error",
                        "message": "Please change the User Type to Unlicensed Staff."
                    });
                } else{ 
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
            }
        });
        $A.enqueueAction(DeactUser);
    }
})