({
    doInit : function(component, event, helper) {
        
        helper.fetchUserRec(component, event, helper);
        helper.fetchStaffRec(component, event, helper);
        helper.getProfile(component, event, helper);
        helper.getRoles(component, event, helper);
        
        component.set('v.Usercolumns', [
            {label: 'Full Name', fieldName: 'UserLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}},
            {label: 'Email', fieldName: 'Email', sortable: true, type: 'email'},
            {label: 'Username', fieldName: 'Username',sortable: true, type: 'text'},
            {label: 'Role', fieldName: 'UserRoleId', sortable: true, type: 'text'}
        ]);  
        
        component.set('v.Staffcolumns', [
            {label: 'Staff Name', fieldName: 'StaffLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}},
            {label: 'Email', fieldName: 'Email__c', sortable: true, type: 'email'},
            {label: 'Username', fieldName: 'Username__c',sortable: true, type: 'text'},
            {label: 'Role', fieldName: 'Role__c', sortable: true, type: 'text'}
        ]);  
    },
    
    UserupdateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.UsersortedBy", fieldName);
        cmp.set("v.UsersortedDirection", sortDirection);
        helper.UsersortData(cmp, fieldName, sortDirection);
    },
    
    StaffupdateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.StaffsortedBy", fieldName);
        cmp.set("v.StaffsortedDirection", sortDirection);
        helper.StaffsortData(cmp, fieldName, sortDirection);
    },
    
    UesrCreate:function (component, event, helper) {
        component.set("v.isUserOpen", true);
        helper.getProfile(component, event, helper);
        helper.getRoles(component, event, helper);
    },
    
    UsercloseModel: function(component, event, helper) {
        component.set("v.isUserOpen", false);
        component.set('v.UserRecordid', null);
    },
    
    StaffCreate:function (component, event, helper) {
        component.set("v.isStaffOpen", true);
    },
    
    StaffcloseModel: function(component, event, helper) {
        component.set("v.isStaffOpen", false);
        component.set('v.StaffRecordid', null);
    },
    
    
    UserOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        
        var Pro=component.find("UserProfileId");
        var Profile=Pro.get("v.value");
        console.log('===Profile==='+JSON.stringify(Profile));
        
        var Rol=component.find("URoleId");
        var Role=Rol.get("v.value");
        console.log('===Role==='+JSON.stringify(Role));
        
        var FName=component.find("UserFName");
        var UFName=FName.get("v.value");
        console.log('===Role==='+JSON.stringify(Role));
        
        event.preventDefault(); // Prevent default submit
        
        if(Profile==null || Profile=='' || Profile=='--None--')
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
            else if(UFName==null || UFName=='')
            {
                var ToastMsgUF=$A.get("e.force:showToast");
                ToastMsgUF.setParams({
                    "title":"First Name",
                    "type": "error",
                    "message":"First Name must have at least three characters."
                });   
                ToastMsgUF.fire();
                event.preventDefault(); 
            }
        
                else if(UFName.length < 3)
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
                    else
                    {
                        var Userfields = event.getParam("fields");
                        
                        var FName=component.find("UserFName").get("v.value");
                        var LName=component.find("UserLName").get("v.value");
                        var alias=FName.substring(0,3)+''+LName.substring(0,1);
                        console.log('>>>>>>Alias>>>>>>>>>>'+alias);
                        
                        Userfields["FirstName"]=FName;
                        Userfields["LastName"]=LName;
                        Userfields["Email"]=component.find("UserEmailfields").get("v.value");
                        Userfields["Username"]=component.find("UserNamefield").get("v.value");
                        Userfields["communitynickname"]=LName;
                        Userfields["TimeZoneSidKey"] = 'America/Los_Angeles';
                        Userfields["LocaleSidKey"] = 'en_GB';
                        Userfields["LanguageLocaleKey"] = 'en_US'; 
                        Userfields["EmailEncodingKey"] = 'ISO-8859-1';
                        Userfields["ProfileId"]=component.find("UserProfileId").get("v.value");
                        console.log('===Profile==='+component.find("UserProfileId").get("v.value"));
                        Userfields["UserRoleId"]=component.find("URoleId").get("v.value");
                        console.log('===Role==='+component.find("URoleId").get("v.value"));
                        Userfields["alias"]=alias;
                        component.find("UserEditform").submit(Userfields);
                        console.log('===form Userfields==='+JSON.stringify(Userfields));
                        var userinfo=JSON.stringify(Userfields);
                        
                        var UserRec = component.get("c.InsertUsers");
                        UserRec.setParams({
                            userinfostr:userinfo
                        });
                        
                        UserRec.setCallback(this,function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                if(response.getReturnValue() === 'true'){
                                    helper.showToast({
                                        "title": "Record Created",
                                        "type": "success",
                                        "message": " Record Created Successfully"
                                    });
                                    helper.fetchUserRec(component, event, helper);
                                    component.set('v.UserRecordid',null);
                                    component.set("v.isUserOpen", false);
                                } else{ 
                                    helper.showToast({
                                        "title": "Error!!",
                                        "type": "error",
                                        "message": response.getReturnValue()
                                    });
                                    
                                }      
                            }
                            else {
                                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                                var errors = response.getError();
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message": errors[0].message
                                });
                                toastEvent.fire ();
                            }
                        });
                        $A.enqueueAction(UserRec);
                        
                    }
    },
    
    UserRecordSuccess: function(component, event, helper) { 
        console.log('>>>>Rec Success>>>>>');
        var UserId=component.get('v.UserRecordid');
        var msg;
        if(UserId=='undefined' || UserId==null ){
            msg='Successfully Inserted Record';
        }
        else{
            msg='Successfully Updated Record';
        }
        console.log('===record Success==='+UserId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        setTimeout($A.getCallback(function () {
            component.set('v.UserRecordid',null);
            component.set("v.isUserOpen", false);
            helper.fetchUserRec(component, event, helper);
        }), 2000);
        ToastMsg11.fire();
    },
    
    
    
    StaffOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        
        var Pro=component.find("StaffProfileId");
        var Profile=Pro.get("v.value");
        console.log('===Profile==='+JSON.stringify(Profile));
        
        var Rol=component.find("staffRoleId");
        var Role=Rol.get("v.value");
        console.log('===Role==='+JSON.stringify(Role));
        
        var FName=component.find("StaffFName");
        var SFName=FName.get("v.value");
        console.log('===First Name==='+JSON.stringify(SFName));
        
        var LName=component.find("StaffLName");
        var SLName=LName.get("v.value");
        console.log('===Last Name==='+JSON.stringify(SLName));
        
        var SEmail=component.find("StaffEmail");
        var StaffEmail=SEmail.get("v.value");
        console.log('===Email==='+JSON.stringify(StaffEmail));
        
        var SUName=component.find("StaffUName");
        var StaffUserName=SUName.get("v.value");
        console.log('===UserName==='+JSON.stringify(StaffUserName));
        
        event.preventDefault(); // Prevent default submit
        
        
        if(SFName==null || SFName=='')
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
                                    
                                    var Stafffields = event.getParam("fields");
                                    var FName=component.find("StaffFName").get("v.value");
                                    var LName=component.find("StaffLName").get("v.value");
                                    var alias=FName.substring(0,3)+''+LName.substring(0,1);
                                    console.log('>>>>>>Alias>>>>>>>>>>'+alias);
                                    Stafffields["Name"]=FName+' '+LName;
                                    Stafffields["Profile__c"]=component.find("StaffProfileId").get("v.value");
                                    console.log('===Profile==='+component.find("StaffProfileId").get("v.value"));
                                    Stafffields["Role__c"]=component.find("staffRoleId").get("v.value");
                                    console.log('===Role==='+component.find("staffRoleId").get("v.value"));
                                    Stafffields["Alias__c"]=alias;
                                    
                                    component.find("StaffEditform").submit(Stafffields);
                                    console.log('===form Stafffields==='+JSON.stringify(Stafffields));
                                }
    },
    
    StaffRecordSuccess: function(component, event, helper) { 
        console.log('>>>>Rec Success>>>>>');
        var StaffId=component.get('v.StaffRecordid');
        var msg;
        if(StaffId=='undefined' || StaffId==null ){
            msg='Successfully Inserted Record';
        }
        else{
            msg='Successfully Updated Record';
        }
        console.log('===record Success==='+StaffId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        setTimeout($A.getCallback(function () {
            component.set('v.StaffRecordid',null);
            component.set("v.isStaffOpen", false);
            helper.fetchStaffRec(component, event, helper);
        }), 2000);
        ToastMsg11.fire();
    },
    
    
})